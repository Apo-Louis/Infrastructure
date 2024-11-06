output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks_cluster.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks_cluster.cluster_endpoint
}

output "cluster_name" {
  description = "Nom du cluster EKS"
  value       = module.eks_cluster.cluster_name
}

output "cluster_id" {
  description = "Identifiant du cluster EKS"
  value       = module.eks_cluster.cluster_id
}

output "cluster_version" {
  description = "Version du cluster EKS"
  value       = module.eks_cluster.cluster_version
}

output "oidc_provider_url" {
  description = "URL du openid connect provider"
  value       = module.eks_cluster.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  description = "ARN du openid connect provider"
  value       = module.eks_cluster.oidc_provider_arn
}


output "kubeconfig" {
    description = "kubeconfig path needed for other modules after generated"
    value = var.kubeconfig_path
}
