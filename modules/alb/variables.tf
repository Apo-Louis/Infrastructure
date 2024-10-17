variable "region" {
    description = "AWS region of the VPC"
    type = string
}

variable "vpc_id" {
    description = "ID of the existing VPC where resources will be created"
    type = string
}

variable "cluster_name" {
    description = "The name of the cluster."
    type = string
}

variable "alb_service_account_name" {
    description = "The service account name for the ALB."
    type = string
    default = "aws-load-balancer-controller"
}

variable "alb_iam_role_name" {
  default     = "AmazonEKSLoadBalancerControllerRole"
  description = "Nom du rôle IAM pour le ALB Controller"
}