##################################
##### CONTROL PLANE
##################################
# création du Role IAM de cluster Amazon EKs
# source : https://docs.aws.amazon.com/fr_fr/eks/latest/userguide/service_IAM_role.html
resource "aws_iam_role" "EKSClusterRole" {
  name = "${var.cluster_prefix}EKSClusterRole-${var.eks_cluster_name}-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  tags = var.tags
}


# This policy provides Kubernetes the permissions it requires to manage resources on your behalf.
# Kubernetes requires Ec2:CreateTags permissions to place identifying information on EC2 resources including but not limited to Instances, Security Groups, and Elastic Network Interfaces.
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.EKSClusterRole.name
}


# création du cluster EKS
resource "aws_eks_cluster" "eks-cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.EKSClusterRole.arn
  version  = var.k8s_version

  vpc_config {
    subnet_ids = var.control_plane_subnet_ids
  }

  #enabled_cluster_log_types = [
  #  "api",
  #  "audit",
  #  "authenticator",
  #  "controllermanager",
  #  "scheduler"
  #]

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
  ]

  # génération du fichier kubeconfig associé au cluster
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.eks_cluster_name} --alias ${var.eks_cluster_name} --kubeconfig ${var.kubeconfig_path}"
  }
}


##################################
##### NODES
##################################
# création du role IAM pour les noeud Amazon EKS
# source : https://docs.aws.amazon.com/fr_fr/eks/latest/userguide/create-node-role.html
resource "aws_iam_role" "EKSNodeGroupRole" {
  name = "${var.cluster_prefix}EKSNodeGroupRole-${var.eks_cluster_name}-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = var.tags
}


# This policy allows Amazon EKS worker nodes to connect to Amazon EKS Clusters
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.EKSNodeGroupRole.name
}


# Provides read-only access to Amazon EC2 Container Registry repositories.
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.EKSNodeGroupRole.name
}


# This policy provides the Amazon VPC CNI Plugin (amazon-vpc-cni-k8s) the permissions it requires to modify the IP address configuration on your EKS worker nodes. 
# This permission set allows the CNI to list, describe, and modify Elastic Network Interfaces on your behalf
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.EKSNodeGroupRole.name
}


# Configuration des worker node de type EC2
resource "aws_eks_node_group" "worker-node-ec2" {
  for_each        = { for node_group in var.workers_config : node_group.name => node_group }
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = each.value.name
  node_role_arn   = aws_iam_role.EKSNodeGroupRole.arn
  subnet_ids      = var.eks_node_groups_subnet_ids

  scaling_config {
    desired_size = try(each.value.desired_size, 1)
    max_size     = try(each.value.max_size, 2)
    min_size     = try(each.value.min_size, 1)
  }

  #ami_type       = each.value.ami_type
  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type
  disk_size      = each.value.disk_size

  update_config {
    max_unavailable = 1
  }

  # ajout du tag pour gestion via cluster-autoscaler
  tags = merge(var.tags, { "k8s.io/cluster-autoscaler/enabled" = true, "k8s.io/cluster-autoscaler/${var.eks_cluster_name}" = "owned" })

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  ]
}


##################################
##### OIDC
##################################
# certificat avec OIDC
data "tls_certificate" "eks-tls-certificat" {
  url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}


resource "aws_iam_openid_connect_provider" "eks-openid-connect" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks-tls-certificat.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}


##################################
##### ADDON EBS CSI driver
# cet add on est un pré requis pour le fonctionnement de Velero (backup)
# source : https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/
##################################
# policy pour le EBS CSI Driver
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}


# création du Role associé à l'add on
module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.38.0"

  create_role                   = true
  role_name                     = "${var.cluster_prefix}EKSEBSCSIRole-${var.eks_cluster_name}-${var.environment}"
  provider_url                  = replace(data.tls_certificate.eks-tls-certificat.url, "https://", "")
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}


# installation de l'add on
resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = var.eks_cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.29.1-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags                     = var.tags
}

