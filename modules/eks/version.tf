# configuration de terraform
terraform {

  required_version = ">=1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
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
