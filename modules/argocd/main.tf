resource "kubernetes_secret" "docker_credentials" {
  metadata {
    name = "docker-creds"
    namespace = var.environment_namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          username = var.docker_username
          password = var.docker_password
          email    = var.docker_email
          auth     = base64encode("${var.docker_username}:${var.docker_password}")
        }
      }
    })
  }
}

resource "helm_release" "argocd" {
  name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.6.10"

  namespace        = "argocd"
  create_namespace = true

  values = [
    templatefile("${path.module}/template/argocd_values.yaml", {
      argo_hostname  = var.argo_hostname
      ingress_class  = var.ingress_class
      cluster_issuer = var.cluster_issuer
    }),
    templatefile("${path.module}/template/repository_values.yaml", {
      wordpress_repo       = var.wordpress_repo
      wordpress_repo_token = var.wordpress_repo_token
    })
  ]
}


resource "kubectl_manifest" "wordpress" {
  yaml_body = templatefile("${path.module}/application_manifest.yaml", {
    app_name           = "wordpress"
    namespace          = var.argo_namespace
    chart_repo_url     = "${var.harbor_url}/wordpress"
    chart_revision     = "HEAD"
    chart_name         = "wordpress"
    destination_server = var.destination_server
    app_namespace      = var.environment_namespace
    values_file = templatefile("${path.module}/template/wordpress_values.yaml.tpl", {
      wordpress_repo   = var.wordpress_repo
      wordpress_branch = var.wordpress_branch
      wordpress_token  = var.wordpress_token

      storage_class = var.storage_class

      mariadb_root_password = var.mariadb_root_password
      database_name         = var.database_name
      database_username     = var.database_username

      mariadb_volume_size = var.mariadb_volume_size

      docker_image = var.docker_image
      docker_tag   = var.docker_tag

      docker_image_pull_secrets = var.docker_image_pull_secrets # <-- Docker Registry Name added into the cluster

      ingress_class = var.ingress_class

      wordpress_hostname = var.wordpress_hostname

      wordpress_tls_secret_name = var.wordpress_tls_secret_name
    })
  })
}
