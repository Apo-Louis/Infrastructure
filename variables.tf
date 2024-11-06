variable "region" {
  description = "Nom de la région"
  type        = string
}

variable "azs" {
  description = "liste des AZs"
  type        = list(string)
}

variable "tags" {
  description = "Map des tags assignés à toutes les ressources"
  type        = map(string)
}

variable "environment" {
  description = "environnement"
  type        = string
}

# module vpc_and_subnets
variable "vpc_name" {
  description = "Nom du VPC a créer"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR du vpc"
  type        = string
}

variable "public_subnets_cidr" {
  description = "liste des CIDR sous-réseaux public"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "liste des CIDR sous-réseaux privés"
  type        = list(string)
}
###################################
# module eks
###################################

variable "eks_cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}

variable "k8s_version" {
  description = "kubernetes version"
  type        = string
  default     = "1.31"
}

variable "kubeconfig_path" {
  description = "Chemin de destination du fichier kubeconfig associé au cluster EKS"
  type        = string
}


# distinction des cluster de test
# définir la variable d'environement TF_VAR_cluster_prefix
variable "cluster_prefix" {
  description = "Préfix ajouté devant les noms des ressources créé afin d'éviter les homonymes"
  type        = string
  default     = ""
}

locals {
  environment_settings = {
    prod = {
      instance_type = ["t5.large"]
      capacity_type = "ON_DEMAND"
      disk_size     = 50
      min_size      = 4
      max_size      = 8
      desired_size  = 4
    }
    staging = {
      instance_type = ["t3.large"]
      capacity_type = "SPOT"
      disk_size     = 20
      min_size      = 2
      max_size      = 4
      desired_size  = 2
    }
    dev = {
      instance_type = ["t3.medium"]
      capacity_type = "SPOT"
      disk_size     = 20
      min_size      = 1
      max_size      = 2
      desired_size  = 1
    }
  }

  workers_config = [
    {
      name           = "${var.environment}-worker"
      instance_types = local.environment_settings[var.environment].instance_type
      capacity_type  = local.environment_settings[var.environment].capacity_type
      disk_size      = local.environment_settings[var.environment].disk_size
      min_size       = local.environment_settings[var.environment].min_size
      max_size       = local.environment_settings[var.environment].max_size
      desired_size   = local.environment_settings[var.environment].desired_size
    }
  ]
}

###################################
# module velero
###################################

variable "bucket_name_velero" {
  description = "Nom du bucket S3 pour les backup"
  type        = string
}


###################################
# module cert-manager
###################################

variable "ovh_application_key" {
  description = "OVH Application key "
  type        = string
  sensitive = true
}

variable "ovh_application_secret" {
  description = "OVH Application secret"
  type        = string
  sensitive = true
}

variable "ovh_consumer_key" {
  description = "OVH Consumer key"
  type        = string
  sensitive = true
}

variable "email" {
  description = "Email for letsencrypt"
  type        = string
}

###################################
# module argo-cd
###################################

# Variables pour Harbor
variable "harbor_url" {
  description = "The URL of the Harbor registry"
  type        = string
}

variable "harbor_username" {
  description = "Username for the Harbor robot"
  type        = string
  sensitive   = true
}

variable "harbor_password" {
  description = "Password for the Harbor robot"
  type        = string
  sensitive   = true
}

variable "robot_email" {
  description = "Email associated with the Harbor robot"
  type        = string
  default     = ""  # Optionnel
}

# Variables pour ArgoCD
variable "argo_hostname" {
  description = "The hostname that will be used by the Ingress resource for routing traffic."
  type        = string
}

variable "argo_ingress_class_name" {
  description = "The name of the IngressClass resource to use for this ingress controller."
  type        = string
}

variable "cluster_issuer_name" {
  description = "The name of the Cert-Manager issuer to use for generating certificates."
  type        = string
}

variable "environment_namespace" {
  description = "The namespace where the environment is deployed. (dev, staging, prod)"
  type        = string
}

variable "job_name" {
  description = "Name of the job to be created."
  type        = string
}

# Variables pour WordPress
variable "wp_github_repo" {
  description = "The GitHub repository for the WordPress plugins and themes."
  type        = string
}

variable "wp_github_branch" {
  description = "The branch of the GitHub repository to use for WordPress content."
  type        = string
  default     = "main"
}

variable "wp_github_token" {
  description = "GitHub personal access token with read permissions for the repository."
  type        = string
}

variable "wp_ingress_class_name" {
  description = "The name of the IngressClass to use for the WordPress ingress."
  type        = string
}

variable "wp_hostname" {
  description = "The hostname for the WordPress ingress."
  type        = string
}

# Variables pour la base de données
variable "db_host" {
  description = "The host for the db database."
  type        = string
  default     = "mariadb"
}

variable "db_root_password" {
  description = "The root password for the db database."
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "The username for the db database user."
  type        = string
}

variable "db_password" {
  description = "The password for the db database user."
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the db database to create."
  type        = string
}
