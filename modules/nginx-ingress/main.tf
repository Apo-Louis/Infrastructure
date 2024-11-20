#=============================================================================#
#=============================================================================#
#=========== Deploy Nginx Ingress Controller with HELM
#=============================================================================#
#=============================================================================#
resource "helm_release" "nginx-ingress-controller-chart" {
  name             = "nginx-ingress-controller"
  namespace        = var.namespace
  create_namespace = true

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  version    = var.chart_version

  timeout = 600

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "replicaCount"
    value = var.replica_count
  }
}

#=============================================================================#
#=========== Data request for the ingress external ip (or hostname)
#=============================================================================#
data "kubernetes_service" "nginx-ingress-controller" {
    metadata {
        name = helm_release.nginx-ingress-controller-chart.name
        namespace = helm_release.nginx-ingress-controller-chart.namespace
    }
}


