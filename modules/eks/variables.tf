variable "environment" {
  description = "environment"
  type        = string
}

variable "eks_cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}

variable "k8s_version" {
  description = "kubernetes version"
  type        = string
  default     = "1.29"
}

variable "control_plane_subnet_ids" {
  description = "IDs des sous-réseaux ou le cluster EKS doit être créé"
  type        = list(string)
}

variable "eks_node_groups_subnet_ids" {
  description = "IDs des sous-réseaux où des groupes de noeuds EKS doivent être créés"
  type        = list(string)
}

variable "workers_config" {
  description = "Configuration des noeuds"
  type = list(object({
    name           = string
    instance_types = list(string)
    capacity_type  = string
    disk_size      = number
    desired_size   = number
    min_size       = number
    max_size       = number
    #update_config = object({
    #  max_unavailable = number
    #})
  }))
  default = [
    {
      name = "t3-medium-spot"
      # il faut mettre une plus grosse instance pour avoir assez d'adress IP
      # minimum : 4 CPU et 10 Go de RAM
      instance_types = ["t3.medium"]
      # ON_DEMAND, SPOT
      capacity_type = "SPOT"
      disk_size     = 20
      min_size      = 0
      max_size      = 4
      desired_size  = 1
    },
  ]
}

variable "tags" {
  description = "Map des tags associé à toutes les ressources"
  type        = map(string)
  default     = {}
}

variable "kubeconfig_path" {
  description = "Chemin de destination du fichier kubeconfig associé au cluster EKS"
  type        = string
}

# distinction des cluster de test
variable "cluster_prefix" {
  description = "Préfix ajouté devant les noms des ressources créé afin d'éviter les homonymes"
  type        = string
}