output "kubeconfig_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = base64decode(aws_eks_cluster.eks-cluster.certificate_authority[0].data)
}

output "eks_cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = aws_eks_cluster.eks-cluster.endpoint
}

output "eks_cluster_name" {
  description = "Nom du cluster EKS"
  value       = aws_eks_cluster.eks-cluster.name
}

output "eks_cluster_id" {
  description = "Identifiant du cluster EKS"
  value       = aws_eks_cluster.eks-cluster.id
}

output "eks_cluster_version" {
  description = "Version du cluster EKS"
  value       = aws_eks_cluster.eks-cluster.version
}

output "eks_oidc_provider_url" {
  description = "URL du openid connect provider"
  value       = aws_iam_openid_connect_provider.eks-openid-connect.url
}

output "eks_oidc_provider_arn" {
  description = "ARN du openid connect provider"
  value       = aws_iam_openid_connect_provider.eks-openid-connect.arn
}
