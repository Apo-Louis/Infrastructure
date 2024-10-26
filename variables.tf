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
  default     = "1.29"
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
