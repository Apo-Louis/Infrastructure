variable "bucket_name_velero" {
  description = "Nom du S3 bucket pour les backups"
  type        = string
}

variable "eks_cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}

variable "eks_oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  type        = string
}

variable "tags" {
  description = "Map des tags associé à toutes les ressources"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "Region AWS"
  type        = string
}


variable "backup_schedule" {
  type        = string
  description = "Planification du backup, par exemple '0 0 * * *' pour un backup quotidien"
  default     = "0 0 * * *"
}

variable "backup_ttl" {
  type        = string
  description = "Durée de rétention des backups, par exemple '240h' pour 10 jours"
  default     = "240h"
}

variable "velero_plugin_image" {
  type        = string
  description = "Image Docker pour le plugin Velero AWS"
  default     = "velero/velero-plugin-for-aws:v1.10.0"
}

variable "plugin_image_pull_policy" {
  type        = string
  description = "Politique de pull de l'image pour le plugin Velero"
  default     = "IfNotPresent"
}
# variable "included_namespaces" {
#   type        = list(string)
#   description = "Namespaces à inclure dans le backup. Liste vide signifie tous les namespaces"
#   default     = []
# }

# variable "excluded_namespace_resources" {
#   type        = list(string)
#   description = "Ressources de namespace à exclure du backup"
#   default     = []
# }

# variable "excluded_cluster_resources" {
#   type        = list(string)
#   description = "Ressources de cluster à exclure du backup"
#   default     = []
# }

