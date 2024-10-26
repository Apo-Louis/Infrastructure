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
