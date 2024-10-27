output "kubeconfig_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "Nom du cluster EKS"
  value       = module.eks.cluster_name
}

output "eks_cluster_id" {
  description = "Identifiant du cluster EKS"
  value       = module.eks.cluster_id
}

output "eks_cluster_version" {
  description = "Version du cluster EKS"
  value       = module.eks.cluster_version
}

output "eks_oidc_provider_url" {
  description = "URL du openid connect provider"
  value       = module.eks.cluster_oidc_issuer_url
}

output "eks_oidc_provider_arn" {
  description = "ARN du openid connect provider"
  value       = module.eks.oidc_provider_arn
}
