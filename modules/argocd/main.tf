resource "kubernetes_secret" "docker_hub_auth" {
  metadata {
    name      = "docker-hub-auth"
    namespace = var.environment_namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          auth = base64encode("${var.docker_username}:${var.docker_password}")
        }
      }
    })
  }
    depends_on = [ helm_release.argocd ]
}

# Add admin configuration password to not add
resource "helm_release" "argocd" {
  name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.6.10"

  namespace        = "argocd"
  create_namespace = true

  values = [
    templatefile("${path.module}/template/argocd_values.yaml", {
      argo_hostname  = "${var.argo_hostname}.${var.domain_name}"
      ingress_class  = var.ingress_class
      cluster_issuer = var.cluster_issuer
    }),
    # templatefile("${path.module}/template/repository_values.yaml", {
    #   wordpress_repo       = "https://github.com${var.wordpress_repo}"
    #   wordpress_repo_token = var.wordpress_repo_token
    # })
  ]
}


resource "kubectl_manifest" "wordpress_repo" {
    yaml_body = templatefile("${path.module}/template/repository_values.yaml", {
        name = "wordpress-repo-secret"
        namespace = var.argo_namespace
        repo_url = "https://github.com/${var.wordpress_repo}"

        repo_password = var.wordpress_repo_token
    })
    }




resource "kubectl_manifest" "wordpress" {
  yaml_body = templatefile("${path.module}/template/application_manifest.yaml", {
    app_name           = "wordpress"
    argo_namespace     = var.argo_namespace
    repo_url           = "https://github.com/${var.wordpress_repo}"
    chart_revision     = "HEAD"
    path               = "helm-chart/"
    destination_server = var.destination_server
    app_namespace      = var.environment_namespace
    values_file = templatefile("${path.module}/template/wordpress_values.yaml.tpl", {
      wordpress_repo       = var.wordpress_repo
      wordpress_branch     = var.wordpress_branch
      wordpress_repo_token = var.wordpress_repo_token


      wordpress_site_title     = var.wordpress_site_title
      wordpress_admin_user     = var.wordpress_admin_user
      wordpress_admin_password = var.wordpress_admin_password
      wordpress_admin_email    = var.wordpress_admin_email

      storage_class = var.storage_class

      mariadb_root_password = var.mariadb_root_password
      database_name         = var.database_name
      database_username     = var.database_username
      database_password     = var.database_password

      mariadb_volume_size = var.mariadb_volume_size

      # docker_image = var.docker_image
      # docker_tag   = var.docker_tag

      docker_image_pull_secrets = kubernetes_secret.docker_hub_auth.metadata[0].name

      ingress_class = var.ingress_class

      wordpress_hostname = "${var.wordpress_hostname}.${var.domain_name}"
      cluster_issuer     = var.cluster_issuer

      wordpress_tls_secret_name = var.wordpress_tls_secret_name


    })

  })
  depends_on = [helm_release.argocd, kubernetes_secret.docker_hub_auth]
}

resource "ovh_domain_zone_record" "argocd-dns" {
  zone      = var.domain_name
  subdomain = var.argo_hostname
  fieldtype = "CNAME"
  ttl       = 60
  target    = var.external_ip
}


resource "ovh_domain_zone_record" "wordpress-dns" {
  zone      = var.domain_name
  subdomain = var.wordpress_hostname
  fieldtype = "CNAME"
  ttl       = 60
  target    = var.external_ip
}



