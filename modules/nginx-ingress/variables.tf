variable "crds_version" {
    description = "The version of the nginx ingress controller to install."
    type        = string
    default     = "v3.7.0"
}

variable "chart_version" {
    description = "The version of the helm chart for the nginx ingress controller."
    type        = string
    default     = "1.4.0"
}