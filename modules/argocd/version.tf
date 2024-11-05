terraform {
  required_version = ">=1.7"

    required_providers {
      helm = {
        source  = "hashicorp/helm"
        version = "2.9.0"
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