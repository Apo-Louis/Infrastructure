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

variable "ansible_vars_file_path" {
  description = "Chemin de destination du fichier contenant les variables pour ansible"
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

# module eks
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

# module velero
variable "bucket_name_velero" {
  description = "Nom du bucket S3 pour les backup"
  type        = string
}

# distinction des cluster de test
# définir la variable d'environement TF_VAR_cluster_prefix
variable "cluster_prefix" {
  description = "Préfix ajouté devant les noms des ressources créé afin d'éviter les homonymes"
  type        = string
  default     = ""
}


# Revoir pour la rendre plus DRY
locals {
  workers_config = var.environment == "prod" ? [
    {
      name           = "t3-medium-spot"
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      disk_size      = 20
      min_size       = 1
      max_size       = 5
      desired_size   = 3
    },
    # ON_DEMAND Type for production environment
    # {
    #   name           = "m5.large"
    #   instance_types = ["m5.large"]
    #   capacity_type  = "ON_DEMAND"
    #   disk_size      = 50
    #   min_size       = 2
    #   max_size       = 6
    #   desired_size   = 4
    # }
  ] : var.environment == "stage" ? [
    {
      name           = "t3-small-spot"
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      disk_size      = 20
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  ] : [
    {
      name           = "t3-micro"
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      disk_size      = 10
      min_size       = 2
      max_size       = 4
      desired_size   = 2
    }
  ]
}