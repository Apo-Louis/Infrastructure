# configuration de terraform
terraform {
  # backend "s3" {
  #   bucket = "ff14-raidplanner-terraform-state"
  #   key    = "global/terraform-state/cluster/terraform.tfstate"
  #   region = "eu-west-3"

  #   dynamodb_table = "ff14-raidplanner-terraform-locks"
  #   encrypt        = true
  # }

  required_version = ">=1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
