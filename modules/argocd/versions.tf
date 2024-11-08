# configuration de terraform
terraform {

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.18.0"
    }
    local = {
      source  = "hashicorp/local-exec"
      version = "2.3.0"
    }
  }
}
