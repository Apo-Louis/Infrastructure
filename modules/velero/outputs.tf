output "velero_s3_bucket_arn" {
  description = "ARN du bucket S3 pour Velero"
  value       = module.s3_bucket.s3_bucket_arn
}

output "velero_s3_bucket_id" {
  description = "Identifiant du bucket S3 pour Velero"
  value       = module.s3_bucket.s3_bucket_id
}

output "velero_s3_bucket_domain_name" {
  description = "Nom de domaine du bucket S3 pour Velero"
  value       = module.s3_bucket.s3_bucket_bucket_domain_name
}

output "velero_iam_role_arn" {
  description = "ARN du role pour le service account de Velero"
  value       = module.velero_irsa_role.iam_role_arn
}

output "velero_iam_role_name" {
  description = "Nom du role pour le service account de Velero"
  value       = module.velero_irsa_role.iam_role_name
}
