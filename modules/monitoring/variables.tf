variable "namespace" {
    description = "Namespace of the monitoring stack"
    type = string
    default = "prometheus"
}

variable "storage_class" {
    description = "Storage Class for the persistence of prom / grafana data"
    type = string
}

variable "argocd_namespace" {
    description = "Namespace of ArgoCD"
    type = string
    default = "argocd"
}

variable "nginx_ingress_namespace" {
    description = "Ingress nameqpace"
    type = string
    default = "nginx"
}

variable "nginx_ingress_name" {
    description = "Ingress name"
    type = string
}

variable "mariadb_username" {
    description = "mariaDB username needed for the exporter"
    type = string
}

variable "mariadb_password" {
    description = "mariaDB password needed for the exporter"
    type = string
}
