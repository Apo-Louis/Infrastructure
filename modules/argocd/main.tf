resource "helm_release" "my_argo_cd" {
    name       = "argo-cd"
    chart      = "argo-cd"
    version    = "7.6.10"
    
    repository = "https://argoproj.github.io/argo-helm"

    namespace  = "argocd"
    create_namespace = true

    values = [
      file("${path.module}/values.yaml")
    ]
}