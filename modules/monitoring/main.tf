#=============================================================================#
#=============================================================================#
#=========== Prometheus Grafana stack helm deployment
#=============================================================================#
#=============================================================================#
resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "prometheus"
  version          = "66.3.0"
  create_namespace = true

  #
  # set {
  #   name  = "server.presistentVolume.enabled"
  #   value = false
  # }

  values = [
    file("${path.module}/dashboards/dashboards.yaml")
  ]

  wait          = true
  wait_for_jobs = true
}


# Need to improve with variables
data "kubernetes_service" "mariadb_service" {
  metadata {
    name      = "wordpress-mariadb"
    namespace = "staging"
  }
}


output "service_spec" {
  value = data.kubernetes_service.mariadb_service.spec
}

# On garde le data source pour les variables
locals {
  template_vars = {
    namespace               = var.namespace
    kube_release            = helm_release.prometheus.name
    nginx_ingress_namespace = var.nginx_ingress_namespace
    nginx_ingress_name      = var.nginx_ingress_name
    data_source_name = base64encode(
      join("", [
        "${var.mariadb_username}:",
        "${var.mariadb_password}@(",
        "wordpress-mariadb:3306/",
        ")"
      ])
    )
  }
}

# On utilise fileset pour les fichiers yaml
resource "kubectl_manifest" "deploy_exporter" {
  for_each = fileset("${path.module}/templates", "*.yaml")
  yaml_body = templatefile(
    "${path.module}/templates/${each.value}",
    local.template_vars
  )
  depends_on = [helm_release.prometheus]
}

