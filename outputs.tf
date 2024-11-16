# output "region" {
#   description = "Région de déploiement"
#   value       = var.region
# }

# # eks module
# output "eks_cluster_name" {
#   description = "Nom du cluster EKS"
#   value       = module.eks.eks_cluster_name
# }

# output "eks_cluster_id" {
#   description = "Identifiant du cluster EKS"
#   value       = module.eks.eks_cluster_id
# }

# output "eks_cluster_version" {
#   description = "Version du cluster EKS"
#   value       = module.eks.eks_cluster_version
# }

# output "kubeconfig_certificate_authority_data" {
#   description = "Base64 encoded certificate data required to communicate with the cluster"
#   value       = module.eks.kubeconfig_certificate_authority_data
# }

# output "eks_cluster_endpoint" {
#   description = "Endpoint for your Kubernetes API server"
#   value       = module.eks.eks_cluster_endpoint
# }

# output "eks_oidc_provider_arn" {
#   description = "ARN du openid connect provider"
#   value       = module.eks.eks_cluster_endpoint
# }

# # module velero
# output "velero_s3_bucket_arn" {
#   description = "Région de déploiement"
#   value       = module.velero.velero_s3_bucket_arn
# }

# output "velero_s3_bucket_id" {
#   description = "Identifiant du bucket S3 pour Velero"
#   value       = module.velero.velero_s3_bucket_id
# }

# output "velero_s3_bucket_domain_name" {
#   description = "Nom de domaine du bucket S3 pour Velero"
#   value       = module.velero.velero_s3_bucket_domain_name
# }

# output "velero_iam_role_arn" {
#   description = "ARN du role pour le service account de Velero"
#   value       = module.velero.velero_iam_role_arn
# }

# output "velero_iam_role_name" {
#   description = "Nom du role IAM pour le service account Velero"
#   value       = module.velero.velero_iam_role_name
# }

# # module autoscaler
# output "autoscaler_iam_role_arn" {
#   description = "ARN du role pour le service account de cluster-autoscaler"
#   value       = module.autoscaler.autoscaler_iam_role_arn
# }

# output "autoscaler_iam_role_name" {
#   description = "Nom du role IAM pour l'autoscaler"
#   value       = module.autoscaler.autoscaler_iam_role_name
# }



output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}


output "ingress_ip" {
    value = module.nginx-ingress.external_ip
}
