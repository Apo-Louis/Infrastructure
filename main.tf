#=============================================================================#
#=============================================================================#
#=========== Create AWS resources with VPC module
#=============================================================================#
#=============================================================================#
module "vpc_and_subnets" {
  source               = "./modules/vpc_and_subnets"
  environment          = var.environment
  azs                  = var.azs
  vpc_name             = "${var.cluster_prefix}${var.vpc_name}"
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  tags                 = var.tags
  additional_public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_prefix}${var.eks_cluster_name}-${var.environment}" = "owned"
    "kubernetes.io/role/elb"                                                                = "1"
  }
  additional_private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_prefix}${var.eks_cluster_name}-${var.environment}" = "owned"
    "kubernetes.io/role/internal-elb"                                                       = "1"
  }
}

#=============================================================================#
#=============================================================================#
#=========== Create kubernetes cluster with EKS module
#=============================================================================#
#=============================================================================#
module "eks" {
  source                   = "./modules/eks"
  vpc_id                   = module.vpc_and_subnets.vpc_id
  cluster_name             = "${var.cluster_prefix}${var.eks_cluster_name}-${var.environment}"
  cluster_version          = var.k8s_version
  worker_subnet_ids        = module.vpc_and_subnets.private_subnets
  worker_subnet_cidr       = var.private_subnets_cidr
  control_plane_subnet_ids = concat(module.vpc_and_subnets.public_subnets, module.vpc_and_subnets.private_subnets)
  tags                     = var.tags
  kubeconfig_path          = var.kubeconfig_path
  workers_config           = local.workers_config
}

#=============================================================================#
#=============================================================================#
#=========== Deploy Metrics Server with Helm
#=============================================================================#
#=============================================================================#
module "metrics-server" {
    source = "./modules/metrics-server"
    depends_on = [ module.eks ]
}

#=============================================================================#
#=========== Create namespace with kubectl manifest
#=============================================================================#
resource "kubectl_manifest" "environment_namespace" {

  yaml_body  = <<YAML
    apiVersion: v1
    kind: Namespace
    metadata:
        name: ${var.environment_namespace}
    YAML
  depends_on = [module.eks]
}

#=============================================================================#
#=============================================================================#
#=========== Service account for the cluster-autoscaler
#=============================================================================#
#=============================================================================#
module "autoscaler" {
  source                = "./modules/autoscaler"
  eks_cluster_name      = "${var.cluster_prefix}${var.eks_cluster_name}"
  eks_oidc_provider_arn = module.eks.oidc_provider_arn
  tags                  = var.tags
}

#=============================================================================#
#=============================================================================#
#=========== Deploy Velero with HELM
#=============================================================================#
#=============================================================================#
module "velero" {
  source                = "./modules/velero"
  region                = var.region
  bucket_name_velero    = "${var.cluster_prefix}${var.bucket_name_velero}"
  eks_cluster_name      = "${var.cluster_prefix}${var.eks_cluster_name}"
  eks_oidc_provider_arn = module.eks.oidc_provider_arn
  tags                  = var.tags
  depends_on            = [module.eks]
}

#=============================================================================#
#=============================================================================#
#=========== Deploy Nginx Ingress Controller with HELM
#=============================================================================#
#=============================================================================#
module "nginx-ingress" {
  source          = "./modules/nginx-ingress"
  kubeconfig_path = var.kubeconfig_path
  depends_on      = [module.eks]
}

#=============================================================================#
#=============================================================================#
#=========== Cert Manager Deployment with HELM
#=============================================================================#
#=============================================================================#
module "cert-manager" {
  source                 = "./modules/cert-manager"
  ovh_application_key    = var.ovh_application_key
  ovh_application_secret = var.ovh_application_secret
  ovh_consumer_key       = var.ovh_consumer_key
  email                  = var.email
  depends_on             = [module.eks, module.vpc_and_subnets]
}

#=============================================================================#
#=============================================================================#
#=========== ArgoCD Deployment with HELM
#=========== Wordpress application deployment with HELM
#=============================================================================#
#=============================================================================#
module "argocd" {
  source = "./modules/argocd"

  docker_username = var.docker_username
  docker_password = var.docker_password
  docker_email    = var.docker_email

  domain_name  = var.domain_name
  eks_endpoint = replace(module.eks.cluster_endpoint, "https://", "")

  argo_hostname         = var.argo_hostname
  argo_admin_password   = var.argo_admin_password
  cluster_issuer        = var.environment == "prod" ? module.cert-manager.prod_issuer_name : module.cert-manager.staging_issuer_name
  environment_namespace = var.environment

  wordpress_repo = var.wordpress_repo
  wordpress_chart_repo       = var.wordpress_chart_repo
  wordpress_repo_token = var.wordpress_repo_token

  storage_class         = module.eks.efs_storage_class
  mariadb_root_password = var.mariadb_root_password
  database_name         = var.database_name
  database_username     = var.database_username
  database_password     = var.database_password

  wordpress_hostname = var.wordpress_hostname

  wordpress_site_title     = var.wordpress_site_title
  wordpress_admin_user     = var.wordpress_admin_user
  wordpress_admin_password = var.wordpress_admin_password
  wordpress_admin_email    = var.wordpress_admin_email

  # ingress_class = module.nginx-ingress.ingress_name
  ingress_class = "nginx"
  external_ip   = module.nginx-ingress.external_ip

  depends_on = [module.eks, module.nginx-ingress, module.cert-manager, kubectl_manifest.environment_namespace]
}


#=============================================================================#
#=============================================================================#
#=========== GateKeeper Deployment with HELM
#=============================================================================#
#=============================================================================#
module "gatekeeper" {
  source        = "./modules/gatekeeper"
  app_namespace = var.environment_namespace

  depends_on = [module.eks, kubectl_manifest.environment_namespace]
}


#=============================================================================#
#=============================================================================#
#=========== KubeArmor Deployment with HELM
#=============================================================================#
#=============================================================================#
module "kubearmor" {
  source = "./modules/kubearmor"

  app_namespace = var.environment_namespace

  depends_on = [module.eks, kubectl_manifest.environment_namespace]
}
