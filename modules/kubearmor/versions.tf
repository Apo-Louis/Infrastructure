# configuration de terraform
terraform {

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16.1"
    }
  }
}