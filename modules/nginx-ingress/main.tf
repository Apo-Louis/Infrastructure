resource "kubernetes_manifest" "nginx_crds" {
  manifest = yamldecode(
    filebase64(
      "https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/${var.crds_version}/deploy/crds.yaml"
    )
  )
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  chart      = "oci://ghcr.io/nginxinc/charts/nginx-ingress"
  version    = var.chart_version
  namespace  = "nginx-ingress"

  values = [
    file("nginx-values.yaml")
  ]

  create_namespace = true
}
