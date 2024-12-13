variable "ovh_application_key" {
  description = "OVH Application Key"
  sensitive   = true
}

variable "ovh_application_secret" {
  description = "OVH Application Secret"
  sensitive   = true
}

variable "ovh_consumer_key" {
  description = "OVH Consumer Key"
  sensitive   = true
}

variable "namespace" {
  description = "Namespace for the resources"
  default     = "cert-manager"
  type        = string
}

variable "prod_issuer_name" {
  description = "Prod issuer name"
  type        = string
    default = "letsencrypt-prod"
}

variable "staging_issuer_name" {
  description = "Staging issuer name"
  type        = string
  default = "letsencrypt-staging"
}

variable "email" {
  description = "Email for the Let's Encrypt account"
  default     = "apoo.louis.8@gmail.com"
  type        = string
}

## OVH ISSUER ##
variable "ovh_group_name" {
  description = "Unique group name for the ovh ClusterIssuer"
  type        = string
  default     = "acme.apoland.net"
}

