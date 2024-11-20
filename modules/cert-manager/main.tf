#=============================================================================#
#=============================================================================#
#=========== Cert Manager Deployment with HELM
#=============================================================================#
#=============================================================================#
resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  version          = "1.16.1"
  create_namespace = true

  set {
    name  = "crds.enabled"
    value = true
  }
}

#=============================================================================#
#=============================================================================#
#=========== Create ovh_credentials secret needed for the clusterIssuer
#=============================================================================#
#=============================================================================#
resource "kubernetes_secret" "ovh_credentials" {
  metadata {
    name      = "ovh-credentials"
    namespace = helm_release.cert-manager.namespace
  }

  data = {
    applicationKey    = var.ovh_application_key
    applicationSecret = var.ovh_application_secret
    consumerKey       = var.ovh_consumer_key
  }

  type       = "Opaque"
  depends_on = [helm_release.cert-manager]
}


#=============================================================================#
#=============================================================================#
#=========== OVH Webhook needed to record DNS
#=========== for applications deployed in the cluster
#=============================================================================#
#=============================================================================#
resource "helm_release" "cert-manager-webhook-ovh" {
  name       = "cert-manager-webhook-ovh"
  repository = "https://aureq.github.io/cert-manager-webhook-ovh"
  chart      = "cert-manager-webhook-ovh"
  namespace  = "cert-manager"
  version    = "v0.7.0"

  set {
    name  = "configVersion"
    value = "0.0.1"
  }

    values = [ templatefile("${path.module}/templates/ovh-issuer.yaml", {
        ovh_group_name = var.ovh_group_name
        namespace = helm_release.cert-manager.namespace
        prod_issuer_name = var.prod_issuer_name
        staging_issuer_name = var.staging_issuer_name
        email = var.email
        ovh_credentials_name = kubernetes_secret.ovh_credentials.metadata[0].name
    })
    ]

  depends_on = [
    helm_release.cert-manager,
    kubernetes_secret.ovh_credentials
  ]
}
