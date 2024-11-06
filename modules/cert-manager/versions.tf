# configuration de terraform
terraform {
    
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"  # Correct source
      version = "1.14.0"
    }
  }
}