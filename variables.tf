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
      instance_type = ["t3.large"]
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
      min_size      = 2
      max_size      = 3
      desired_size  = 2
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


variable "docker_username" {
  description = "Docker username for private registry"
  type        = string
  sensitive   = true
}

variable "docker_password" {
  description = "Docker password for private registry"
  type        = string
  sensitive   = true
}

variable "docker_email" {
  description = "Docker email for private registry"
  type        = string
  sensitive   = true
}



variable "argo_hostname" {
  description = "The hostname that will be used by the Ingress resource for routing traffic."
  type        = string
}

variable "argo_namespace" {
  description = "The namespace in which to deploy the ingress controller."
  type        = string
  default     = "argocd"
}

variable "cluster_issuer" {
  description = "The name of the Cert-Manager issuer to use for generating certificates."
  type        = string
}



variable "destination_server" {
  description = "The destination server to which Argo CD will connect."
  type        = string
  default     = "https://kubernetes.default.svc"
}

variable "environment_namespace" {
  description = "The namespace where the environment is deployed. (dev, staging, prod)"
  type        = string
}




variable "wordpress_repo" {
  type        = string
  description = "URL du dépôt WordPress"
  default = "Apo-Louis/wordpress"
}

variable "wordpress_repo_token" {
    type = string
    description = "Token generate from GitHub"
    sensitive = true
}
variable "wordpress_branch" {
  type        = string
  description = "Branche du dépôt WordPress à utiliser"
  default = "main"
}

variable "storage_class" {
  type        = string
  description = "Classe de stockage à utiliser"
  default = "default"
}

variable "mariadb_root_password" {
  type        = string
  description = "Mot de passe root MariaDB"
  sensitive   = true
}

variable "database_name" {
  type        = string
  description = "Nom de la base de données WordPress"
  default = "wordpressdb"
}

variable "database_username" {
  type        = string
  description = "Nom d'utilisateur de la base de données"
  default = "wordpress"
}

variable "database_password" {
  type        = string
  description = "Mot de passe de la base de données"
  sensitive   = true
  default = "password"
}

variable "wordpress_hostname" {
  type        = string
  description = "Nom d'hôte pour WordPress"
  default = "filrouge-wp.apoland.net"
}

# Variables WordPress
variable "wordpress_site_title" {
  type        = string
  description = "Titre du site WordPress"
  default = "Fil Rouge Project Wordpress"
}

variable "wordpress_admin_user" {
  type        = string
  description = "Nom d'utilisateur administrateur WordPress"
  default = "admin"
}

variable "wordpress_admin_password" {
  type        = string
  description = "Mot de passe administrateur WordPress"
  sensitive   = true
  default = "password"
}

variable "wordpress_admin_email" {
  type        = string
  description = "Email de l'administrateur WordPress"
  default = "admin@example.com"
}

# Import from Terraform Registry Configuration
 variable "docker_image_pull_secrets" {
  type        = string
  description = "Secrets pour pull l'image Docker"
}