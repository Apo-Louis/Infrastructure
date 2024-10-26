output "autoscaler_iam_role_name" {
  description = "Nom du role IAM pour l'autoscaler"
  value       = module.autoscaler_irsa_role.iam_role_name
}

output "autoscaler_iam_role_arn" {
  description = "ARN du role pour le service account de Cluster-autoscaler"
  value       = module.autoscaler_irsa_role.iam_role_arn
}

