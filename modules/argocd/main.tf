
resource "helm_release" "my_argo_cd" {
  name    = "argo-cd"
  chart   = "argo-cd"
  version = "7.6.10"

  repository = "https://argoproj.github.io/argo-helm"

  namespace        = "argocd"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}

resource "kubernetes_manifest" "harbor_repo" {
  manifest = templatefile("${path.module}/harbor_repo.yaml", {
    namespace = var.argo_namespace
    url       = var.harbor_url
    password  = var.harbor_password
    username  = var.harbor_username
  })
  depends_on = [helm_release.my_argo_cd]

}

resource "local_file" "mariadb_values" {
  filename = "${path.module}/mariadb_values.yaml"
  content = templatefile("${path.module}/mariadb_values.yaml.tpl", {
    db_host          = var.db_host
    db_user          = var.db_user
    db_password      = var.db_password
    db_name          = var.db_name
    db_root_password = var.db_root_password
  })
}

# Loop pour wordpress & mariadb
resource "local_file" "wordpress_values" {
  filename = "${path.module}/wordpress_values.yaml"
  content = templatefile("${path.module}/wordpress_values.yaml.tpl", {
    github_repo   = var.wp_github_repo
    github_branch = var.wp_github_branch
    github_token  = var.wp_github_token

    ingress_enabled     = var.wp_ingress_enabled
    ingress_class_name  = var.wp_ingress_class_name
    cluster_issuer_name = var.cluster_issuer_name
    hostname            = var.wp_hostname

    db_host     = var.db_host
    db_user     = var.db_user
    db_password = var.db_password
    db_name     = var.db_name

    pvc_size      = var.wp_pvc_size
    storage_class = var.wp_storage_class
  })
}

resource "kubernetes_manifest" "wordpress" {
  manifest = templatefile("${path.module}/application_manifest.yaml", {
    app_name           = "wordpress"
    namespace          = var.argo_namespace
    chart_repo_url     = "${var.harbor_url}/wordpress"
    chart_revision     = "HEAD"
    chart_name         = "wordpress"
    values_file        = local_file.wordpress_values.filename
    destination_server = var.destination_server
    app_namespace      = var.environment_namespace
    # presync_job_name = var.job_name
  })
}

