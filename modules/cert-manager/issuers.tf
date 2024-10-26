resource "kubernetes_manifest" "letsencrypt_prod" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = var.issuer_name
    }
    spec = {
      acme = {
        server                 = "https://acme-v02.api.letsencrypt.org/directory"
        email                  = var.email
        privateKeySecretRef    = {
            name = var.issuer_name
        }
        solvers = [
          {
            dns01 = {
              webhook = {
                  groupName = "ovh_dns"
                  solverName = "ovh"
                  config = {
                      endpoint = "ovh-eu"
                      applicationKey = var.ovh_application_key
                      applicationSecretRef = {
                          name = kubernetes_secret.ovh_credentials.metadata[0].name
                          key  = "applicationSecret"
                  }
                }
              }
            }
          }
        ]
      }
    }
  }
}
