#=============================================================================#
#=============================================================================#
#=========== Create kubernetes cluster with EKS module
#=============================================================================#
#=============================================================================#
module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy            = {}
    vpc-cni               = {}
    aws-efs-csi-driver = {
      service_account_role_arn = aws_iam_role.efs_csi.arn
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.worker_subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  eks_managed_node_groups = {
    for node_group in var.workers_config : node_group.name => {
      instance_types = node_group.instance_types
      capacity_type  = node_group.capacity_type
      disk_size      = node_group.disk_size
      desired_size   = node_group.desired_size
      max_size       = node_group.max_size
      min_size       = node_group.min_size
      name           = node_group.name
      tags = {
        "kubernetes.io/cluster/${var.cluster_name}"     = "owned"
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "true"
      }
    }
  }

  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions
  tags = var.tags
}

#=============================================================================#
#=========== IAM Role for EFS CSI Driver
#=============================================================================#
resource "aws_iam_role" "efs_csi" {
  name = "${var.cluster_name}-efs-csi-controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = module.eks_cluster.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${module.eks_cluster.oidc_provider}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa",
            "${module.eks_cluster.oidc_provider}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

#=============================================================================#
#=========== Attach AWS managed policy for EFS CSI Driver
#=============================================================================#
resource "aws_iam_role_policy_attachment" "efs_csi_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.efs_csi.name
}

#=============================================================================#
#=========== Create EFS File System
#=============================================================================#
resource "aws_efs_file_system" "eks" {
  creation_token = "${var.cluster_name}-efs"
  encrypted      = true
  tags = {
    Name = "${var.cluster_name}-efs"
  }
}

#=============================================================================#
#=========== Create mount targets in each subnet
#=============================================================================#
resource "aws_efs_mount_target" "eks" {
  count           = length(var.worker_subnet_ids)
  file_system_id  = aws_efs_file_system.eks.id
  subnet_id       = var.worker_subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}

#=============================================================================#
#=========== Security group for EFS
#=============================================================================#
resource "aws_security_group" "efs" {
  name        = "${var.cluster_name}-efs"
  description = "Security group for EFS mount targets"
  vpc_id      = var.vpc_id

  ingress {
    description = "NFS from EKS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.worker_subnet_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-efs-sg"
    }
  )
}

#=============================================================================#
#=========== Create StorageClass using kubernetes provider
#=============================================================================#
resource "kubernetes_storage_class" "efs" {
  metadata {
    name = "efs-sc"
  }

  storage_provisioner = "efs.csi.aws.com"
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.eks.id
    directoryPerms   = "700"
  }
  volume_binding_mode = "WaitForFirstConsumer"
  reclaim_policy     = "Delete"

  depends_on = [
    module.eks_cluster
  ]
}
#=============================================================================#
#=========== IAM Role for EFS CSI Driver
#=============================================================================#
# Update kubeconfig
resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --alias ${var.cluster_name} --kubeconfig ${var.kubeconfig_path}"
  }
  depends_on = [module.eks_cluster]
}
