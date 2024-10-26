# création du role pour velero
resource "aws_iam_role" "velero_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# policy pour le bucket S3
data "aws_iam_policy_document" "cluster_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.velero_role.arn]
    }

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name_velero}",
      "arn:aws:s3:::${var.bucket_name_velero}/*"
    ]
  }
}

# création du bucket S3
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.1"
  bucket  = var.bucket_name_velero
  acl     = "private"
  # permet de supprimer le contenu du S3 avec le terraform destroy
  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  attach_policy = true
  policy        = data.aws_iam_policy_document.cluster_bucket_policy.json

  attach_deny_insecure_transport_policy = false

  versioning = {
    enabled = true
  }
}


# we are using irsa module for defining all access to roles and later this role
# will be assumed by "velero" service account in k8s cluster
# https://github.com/terraform-aws-modules/terraform-aws-iam/blob/master/examples/iam-role-for-service-accounts-eks/main.tf
module "velero_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.39.0"

  role_name             = "${var.eks_cluster_name}-velero-role"
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

# Déploiement de Velero avec Helm
resource "helm_release" "velero" {
  name       = "velero"
  namespace  = "velero"
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  version    = "2.30.1"  # Remplacez par la version souhaitée

  create_namespace = true

  set {
    name  = "configuration.provider"
    value = "aws"
  }

  set {
    name  = "configuration.backupStorageLocation.name"
    value = "default"
  }

  set {
    name  = "configuration.backupStorageLocation.bucket"
    value = var.bucket_name_velero
  }

  set {
    name  = "configuration.backupStorageLocation.config.region"
    value = var.region
  }

  set {
    name  = "configuration.volumeSnapshotLocation.name"
    value = "default"
  }

  set {
    name  = "configuration.volumeSnapshotLocation.config.region"
    value = var.region
  }

  set {
    name  = "serviceAccount.server.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.velero_irsa_role.role_arn
  }

  depends_on = [module.velero_irsa_role, module.s3_bucket]
}
