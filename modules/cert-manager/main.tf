resource "helm_release" "cert-manager" {
    name = "cert-manager"
    repository = "https://charts.jetstack.io"
    chart = "cert-manager"
    namespace = "cert-manager"
    version = "1.16.1"

    create_namespace = true

    set {
        name = "crds.enabled"
        value = true
    }
}