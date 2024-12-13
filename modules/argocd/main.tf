#=============================================================================#
#=============================================================================#
#=========== Docker hub Credential Secret
#=============================================================================#
#=============================================================================#
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
  depends_on = [helm_release.argocd]
}

#=============================================================================#
#=============================================================================#
#============ ArgoCD Helm Deployment
#=============================================================================#
#=============================================================================#
#------- https://artifacthub.io/packages/helm/argo/argo-cd
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
  ]
  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt(var.argo_admin_password) # Le mot de passe doit être hashé en bcrypt
    }
}

#=============================================================================#
#=============================================================================#
#============= Create ArgoCD repository for Wordpress
#============= via a kubernetes manifest
#=============================================================================#
#=============================================================================#
resource "kubectl_manifest" "wordpress_chart_repo" {
  yaml_body = templatefile("${path.module}/template/repository_values.yaml", {
    name      = "wordpress-repo-secret"
    namespace = var.argo_namespace
    repo_url  = "https://github.com/${var.wordpress_chart_repo}"

    repo_password = var.wordpress_repo_token
  })
  depends_on = [helm_release.argocd]
}


#=============================================================================#
#============== Deployer ArgoCD application for wordpress with
#============== application_manifest template
#=============================================================================#
resource "kubectl_manifest" "wordpress" {
  yaml_body = templatefile("${path.module}/template/application_manifest.yaml", {
    app_name           = "wordpress"
    argo_namespace     = var.argo_namespace
    repo_url           = "https://github.com/${var.wordpress_chart_repo}"
    chart_revision     = "HEAD"
    path               = "chart/"
    destination_server = var.destination_server
    app_namespace      = var.environment_namespace
    values_file = templatefile("${path.module}/template/wordpress_values.yaml.tpl", {
      wordpress_repo       = var.wordpress_repo
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

      docker_image_pull_secrets = kubernetes_secret.docker_hub_auth.metadata[0].name

      ingress_class = var.ingress_class

      wordpress_hostname = "${var.wordpress_hostname}.${var.domain_name}"
      cluster_issuer     = var.cluster_issuer

      wordpress_tls_secret_name = var.wordpress_tls_secret_name
    })
  })
  depends_on = [helm_release.argocd, kubernetes_secret.docker_hub_auth]
}

#=============================================================================#
#============== ArgoCD DNS Record
#=============================================================================#
resource "ovh_domain_zone_record" "argocd-dns" {
  zone      = var.domain_name
  subdomain = var.argo_hostname
  fieldtype = "CNAME"
  ttl       = 60
  target    = "${var.external_ip}." # <-- Make sure to add the point (.) or ovh will add at the and of the endpoint the dns name
}


#=============================================================================#
#============== ArgoCD DNS Record
#=============================================================================#
resource "ovh_domain_zone_record" "wordpress-dns" {
  zone      = var.domain_name
  subdomain = var.wordpress_hostname
  fieldtype = "CNAME"
  ttl       = 60
  target    = "${var.external_ip}."
}

