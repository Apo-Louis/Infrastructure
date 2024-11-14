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
      version = "~> 2.13.0"
    }
    ovh = {
        source = "ovh/ovh"
        version = "1.0.0"
    }
  }
}
