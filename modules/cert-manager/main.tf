

# Création de la release Helm de cert-manager
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


# Création du secret OVH avant l'issuer
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



# Fusionné le Cluster Issuer avec le helm ovh
resource "helm_release" "cert-manager-webhook-ovh" {
  name       = "cert-manager-webhook-ovh"
  repository = "https://aureq.github.io/cert-manager-webhook-ovh"
  chart      = "cert-manager-webhook-ovh"
  namespace  = "cert-manager"
  version    = "v0.7.0" # Vérifiez la dernière version disponible

  set {
    name  = "groupName"
    value = "ovh-dns" # Doit correspondre au groupName dans votre ClusterIssuer
  }

  set {
    name  = "configVersion"
    value = "0.0.1"
  }

    values = [ templatefile("${path.module}/templates/ovh-issuer.yaml", {
        ovh_group_name = var.ovh_group_name
        namespace = helm_release.cert-manager.namespace
        issuer_name = var.issuer_name
        email = var.email
        ovh_credentials_name = kubernetes_secret.ovh_credentials.metadata[0].name
    })
    ]

  depends_on = [
    helm_release.cert-manager,
    kubernetes_secret.ovh_credentials
  ]
}

# resource "kubectl_manifest" "cluster_issuer" {
#   yaml_body  = <<-YAML
#   apiVersion: cert-manager.io/v1
#   kind: ClusterIssuer
#   metadata:
#     name: ${var.issuer_name}
#   spec:
#     acme:
#       server: https://acme-v02.api.letsencrypt.org/directory
#       email: ${var.email}
#       privateKeySecretRef:
#         name: ${var.issuer_name}
#       solvers:
#         - dns01:
#             webhook:
#               groupName: ovh-dns
#               solverName: ovh
#               config:
#                 endpoint: ovh-eu
#                 applicationKey: ${var.ovh_application_key}
#                 applicationSecretRef:
#                   name: ${kubernetes_secret.ovh_credentials.metadata[0].name}
#                   key: applicationSecret
#   YAML
#   depends_on = [helm_release.cert-manager]
# }
