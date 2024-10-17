data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "oidc_provider" {
  url = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "alb_controller" {
  name = var.alb_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.oidc_provider.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${data.aws_iam_openid_connect_provider.oidc_provider.url}:sub" = "system:serviceaccount:kube-system:${var.alb_service_account_name}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "alb_controller_policy" {
  name        = "alb-controller-policy"
  description = "Policy for ALB ingress controller"

  policy = file("${path.module}/alb-policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_policy_attachment" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}
resource "kubernetes_service_account" "alb_service_account" {
  metadata {
    name      = var.alb_service_account_name
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
    }
  }
}
