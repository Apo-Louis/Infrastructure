region = "eu-west-3"
azs    = ["eu-west-3a", "eu-west-3b"]
tags = {
  Environnement = "staging"
  Projet        = "Wordpress"
  terraform     = "true"
}
environment = "prod"

# module vpc_and_subnets
vpc_name             = "vpc-wordpress"
vpc_cidr             = "10.0.0.0/16"
public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidr = ["10.0.101.0/24", "10.0.102.0/24"]

# module eks
eks_cluster_name = "eks-wordpress"
kubeconfig_path  = "outputs/eks_kubeconfig"
# cluster_prefix         = "prod"
# module velero
bucket_name_velero = "wordpress-velero-backup-bucket"

# module cert-manager
ovh_consumer_key       = XXX
ovh_application_key    = XXX
ovh_application_secret = XXX
email                  = "alimoviee@gmail.com"

# Configuration for ArgoCD
docker_username = "apoolouis8"
docker_password = XXX
docker_email    = "apoo.louis.8@gmail.com"

domain_name           = "apoland.net"
argo_hostname         = "eks-argocd" # Hostname for ArgoCD Ingress routing (e.g., "argocd")
argo_admin_password = "argo_password"
environment_namespace = "prod"    # Namespace of the deployed environment (e.g., "dev", "staging", "prod")

# Configuration for WordPress
wordpress_chart_repo = "Apo-Louis/wordpress-charts" # GitHub repository URL for WordPress plugins and themes (e.g., "https://github.com/username/wordpress-content")
wordpress_repo       = "Apo-Louis/wordpress"        # GitHub repository URL for WordPress plugins and themes (e.g., "https://github.com/username/wordpress-content")
wordpress_branch     = "main"                        # GitHub branch for WordPress content, default is "main"
wordpress_repo_token = XXX

mariadb_root_password = "password"

database_name     = "wordpress"
database_username = "wordpress"
database_password = "password"

wordpress_hostname = "eks-wordpress"

wordpress_site_title     = "Eks Test"
wordpress_admin_user     = "admin"
wordpress_admin_password = "password"
wordpress_admin_email    = "apoo.louis.8@gmail.com"
