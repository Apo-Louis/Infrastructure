#=============================================================================#
#=============================================================================#
#=========== Service account for the cluster-autoscaler
#=============================================================================#
#=============================================================================#
module "autoscaler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.39.0"

  role_name                        = "${var.eks_cluster_name}-cluster-autoscaler-role"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [var.eks_cluster_name]

  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }

  tags = var.tags
}


