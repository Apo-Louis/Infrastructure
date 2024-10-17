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
}