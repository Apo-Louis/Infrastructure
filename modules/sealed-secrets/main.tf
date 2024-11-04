resource "helm_release" "sealed-secrets" {
    name       = "sealed-secrets"
    repository = "https://bitnami-labs.github.io/sealed-secrets"
    chart      = "sealed-secrets"
    namespace  = var.namespace
    version    = "2.16.1"
}

# Voir pour ajouter le secret nécessaire pour