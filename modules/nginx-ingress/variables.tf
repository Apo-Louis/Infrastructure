variable "crds_version" {
    description = "The version of the nginx ingress controller to install."
    type        = string
    default     = "v3.7.0"
}

variable "kubeconfig_path" {
    description = "Path to the kubeconfig file."
    type        = string
}



variable "namespace" {
  description = "Nom du namespace pour déployer le chart"
  type        = string
  default     = "nginx-ingress-controller"
}

# https://bitnami.com/stack/nginx-ingress-controller/helm
variable "chart_version" {
  description = "version du chart Bitnami package for NGINX Ingress Controller à installer"
  type        = string
  default     = "11.5.2"
}

variable "replica_count" {
  description = "Number of replica pods to create"
  type        = number
  default     = 1
}

