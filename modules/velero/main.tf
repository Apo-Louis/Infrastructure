#=============================================================================#
#=============================================================================#
#=========== IAM Policy for Velero role
#=============================================================================#
#=============================================================================#
resource "aws_iam_role_policy" "velero_policy" {
  name = "velero-main-policy"
  role = module.velero_irsa_role.iam_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]
        Resource = [
          module.s3_bucket.s3_bucket_arn,
          "${module.s3_bucket.s3_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeVolumes",
          "ec2:DescribeSnapshots",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot"
        ]
        Resource = "*"
      }
    ]
  })
}

#=============================================================================#
#=============================================================================#
#=========== Create s3 bucket for velero with module
#=============================================================================#
#=============================================================================#
# Module S3 bucket avec configuration mise à jour
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.1"

  bucket = var.bucket_name_velero
  acl    = null  # Désactivé car nous utilisons la propriété des objets

  # Activation de la propriété des objets
  control_object_ownership = true
  object_ownership        = "BucketOwnerPreferred"

  # Permettre la suppression du bucket non vide
  force_destroy = true

  # Versioning
  versioning = {
    enabled = true
  }

  # Autoriser le chiffrement par défaut
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

#=============================================================================#
#=========== s3 bucket policy
#=============================================================================#
resource "aws_s3_bucket_policy" "velero" {
  bucket = module.s3_bucket.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VeleroAccess"
        Effect = "Allow"
        Principal = {
          AWS = module.velero_irsa_role.iam_role_arn
        }
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]
        Resource = [
          module.s3_bucket.s3_bucket_arn,
          "${module.s3_bucket.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

#=============================================================================#
#=========== IRSA module for velero
#=============================================================================#
module "velero_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.39.0"

  role_name = "${var.eks_cluster_name}-velero-role"

  attach_velero_policy  = true
  velero_s3_bucket_arns = [module.s3_bucket.s3_bucket_arn]

  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["velero:velero"]
    }
  }

  tags = var.tags
}

#=============================================================================#
#=============================================================================#
#=========== IAM Policy for Velero role
#=============================================================================#
#=============================================================================#
resource "local_file" "velero_values_yaml" {
  filename = "${path.module}/generated_values.yaml"
  content = templatefile("${path.module}/values.yaml.tpl", {
    bucket_name_velero       = var.bucket_name_velero,
    region                   = var.region,
    backup_schedule          = var.backup_schedule,
    backup_ttl               = var.backup_ttl,
    velero_plugin_image      = var.velero_plugin_image,
    plugin_image_pull_policy = var.plugin_image_pull_policy,
    velero_irsa_role_arn     = module.velero_irsa_role.iam_role_arn
  })
}

#=============================================================================#
#=============================================================================#
#=========== Deploy Velero with HELM
#=============================================================================#
#=============================================================================#
resource "helm_release" "velero" {
  name       = "velero"
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  namespace  = "velero"

  create_namespace = true

  values = [local_file.velero_values_yaml.content]

  depends_on = [local_file.velero_values_yaml, module.velero_irsa_role]
}

