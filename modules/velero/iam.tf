data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "oasis_velero_policy" {
  name        = "oasis-velero-policy"
  description = "Une politique pour les opérations EC2 et S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:DeleteObject",
          "s3:DeleteObjectAcl",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]
        Resource = [
          "arn:aws:s3:::${module.aws_s3_bucket.s3_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${module.aws_s3_bucket.s3_bucket_arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "oasis_velero_role" {
  name        = "oasis-velero-role"
  description = "Un rôle pour les opérations EC2 et S3"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        },
        {
          "Effect" : "Allow",
          "Principal" : {
            Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.openid_connect_provider_uri}"
          },
          "Action" : "sts:AssumeRoleWithWebIdentity",
          "Condition" : {
            "StringEquals" : {
              "${local.openid_connect_provider_uri}:sub" = "system:serviceaccount:velero-server"
              "${local.openid_connect_provider_uri}:aud" = "sts.amazonaws.com"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "oasis_velero_policy_attachment" {
  role       = aws_iam_role.oasis_velero_role.name
  policy_arn = aws_iam_policy.oasis_velero_policy.arn
}
