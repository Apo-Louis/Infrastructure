

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
    namespace = "cert-manager"
  }

  data = {
    applicationKey   = var.ovh_application_key
    applicationSecret = var.ovh_application_secret
    consumerKey      = var.ovh_consumer_key
  }

  type = "Opaque"
  depends_on = [ helm_release.cert-manager ]
}

# ClusterIssuer avec la dépendance explicite sur le secret et cert-manager
# resource "kubernetes_manifest" "cluster_issuer" {
#   manifest = {
#     apiVersion = "cert-manager.io/v1"
#     kind       = "ClusterIssuer"
#     metadata = {
#       name = var.issuer_name
#     }
#     spec = {
#       acme = {
#         server              = "https://acme-v02.api.letsencrypt.org/directory"
#         email               = var.email
#         privateKeySecretRef = {
#           name = var.issuer_name
#         }
#         solvers = [
#           {
#             dns01 = {
#               webhook = {
#                 groupName = "ovh_dns"
#                 solverName = "ovh"
#                 config = {
#                   endpoint          = "ovh-eu"
#                   applicationKey    = var.ovh_application_key
#                   applicationSecretRef = {
#                     name = kubernetes_secret.ovh_credentials.metadata[0].name
#                     key  = "applicationSecret"
#                   }
#                 }
#               }
#             }
#           }
#         ]
#       }
#     }
#   }
# }


resource "kubectl_manifest" "cluster_issuer" {
  yaml_body = <<-YAML
  apiVersion: cert-manager.io/v1
  kind: ClusterIssuer
  metadata:
    name: ${var.issuer_name}
  spec:
    acme:
      server: https://acme-v02.api.letsencrypt.org/directory
      email: ${var.email}
      privateKeySecretRef:
        name: ${var.issuer_name}
      solvers:
        - dns01:
            webhook:
              groupName: ovh_dns
              solverName: ovh
              config:
                endpoint: ovh-eu
                applicationKey: ${var.ovh_application_key}
                applicationSecretRef:
                  name: ${kubernetes_secret.ovh_credentials.metadata[0].name}
                  key: applicationSecret
  YAML
  depends_on = [ helm_release.cert-manager ]
}
