variable "namespace" {
  description = "Namespace of the monitoring stack"
  type        = string
  default     = "prometheus"
}

variable "storage_class" {
  description = "Storage Class for the persistence of prom / grafana data"
  type        = string
}

variable "argocd_namespace" {
  description = "Namespace of ArgoCD"
  type        = string
  default     = "argocd"
}

variable "nginx_ingress_namespace" {
  description = "Ingress nameqpace"
  type        = string
  default     = "nginx"
}

variable "nginx_ingress_name" {
  description = "Ingress name"
  type        = string
}

variable "mariadb_username" {
  description = "mariaDB username needed for the exporter"
  type        = string
}

variable "mariadb_password" {
  description = "mariaDB password needed for the exporter"
  type        = string
}




variable "smtp_username" {
  type        = string
  description = "SMTP authentication username"
  sensitive   = true
  default     = "apo"
}

variable "smtp_password" {
  type        = string
  description = "SMTP authentication password"
  sensitive   = true
  default     = "apo"
}

variable "smtp_host" {
  type        = string
  description = "SMTP server host"
  default     = "smtp.gmail.com:587"
}

variable "smtp_from" {
  type        = string
  description = "Email address for sending alerts"
  default     = "alimoviee@gmail.come"
}

variable "smtp_to" {
  type        = string
  description = "Email address for receiving alerts"
  default     = "alimoviee@gmail.com"
}
