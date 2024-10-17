terraform {
  required_providers {
    aws = {
       source  = "hashicorp/aws"
       version = "~> 5.0"
     }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key # <-- Use export TF_VAR_* to set these variables
  secret_key = var.aws_secret_key # <-- Use export TF_VAR_* to set these variables
}


provider "kubernetes" {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command = "aws"
    }
  }

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command = "aws"
    }
  }

} 
## harbor registery
  # registry {
  #   url = ""
  #   username = ""
  #   password = ""
  # }

