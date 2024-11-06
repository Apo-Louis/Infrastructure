resource "helm_release" "nginx-ingress-controller-chart" {
  name             = "nginx-ingress-controller"
  namespace        = var.namespace
  create_namespace = true

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  version    = var.chart_version

  # https://kubernetes.github.io/ingress-nginx/deploy/#aws
  # Idle timeout value for TCP flows is 350 seconds and cannot be modified.
  # For this reason, you need to ensure the keepalive_timeout value is configured less than 350 seconds to work as expected.
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


