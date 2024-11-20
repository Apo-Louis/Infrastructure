
variable "domain_name" {
  description = "Domain used for the ingress setup"
  type        = string
}

variable "eks_endpoint" {
  description = "Endpoint of the EKS cluster"
  type        = string
}

variable "docker_username" {
  description = "Docker username for private registry"
  type        = string
  sensitive   = true
}

variable "docker_password" {
  description = "Docker password for private registry"
  type        = string
  sensitive   = true
}

variable "docker_email" {
  description = "Docker email for private registry"
  type        = string
  sensitive   = true
}

variable "argo_hostname" {
  description = "The hostname that will be used by the Ingress resource for routing traffic."
  type        = string
}

variable "argo_namespace" {
  description = "The namespace in which to deploy the ingress controller."
  type        = string
  default     = "argocd"
}

variable "argo_admin_password" {
  description = "ArgoCD admin password"
  type        = string
}

variable "destination_server" {
  description = "The destination server to which Argo CD will connect."
  type        = string
  default     = "https://kubernetes.default.svc"
}

variable "environment_namespace" {
  description = "The namespace where the environment is deployed. (dev, staging, prod)"
  type        = string
}

# Variables Github
variable "wordpress_chart_repo" {
  type        = string
  description = "Wordpress Chart name"
  default     = "Apo-Louis/wordpress-charts"
}

variable "wordpress_repo" {
  type        = string
  description = "Wordpress source code repo"
  default     = "Apo-Louis/wordpress"
}

variable "wordpress_repo_token" {
  type        = string
  description = "Token generate from GitHub"
  sensitive   = true
}

# Variables MariaDB
variable "storage_class" {
  type        = string
  description = "Storage Class Name for persistent volumes"
  default     = "default"
}

variable "mariadb_root_password" {
  type        = string
  description = "Mariadb root password"
  sensitive   = true
}

variable "database_name" {
  type        = string
  description = "Wordpress database name"
  default     = "wordpressdb"
}

variable "database_username" {
  type        = string
  description = "Wordpres database username"
  default     = "wordpress"
}

variable "database_password" {
  type        = string
  description = "Wordpress database password"
  sensitive   = true
  default     = "password"
}

variable "mariadb_volume_size" {
  type        = string
  description = "Mariadb PVC volume size"
  default     = "10Gi"
}

# Variables WordPress
variable "wordpress_site_title" {
  type        = string
  description = "Wordpress Site Title"
  default     = "Fil Rouge Project Wordpress"
}

variable "wordpress_admin_user" {
  type        = string
  description = "Wordpress admin username"
  default     = "admin"
}

variable "wordpress_admin_password" {
  type        = string
  description = "Wordpress admin password"
  sensitive   = true
  default     = "password"
}

variable "wordpress_admin_email" {
  type        = string
  description = "Wordpress admin email"
  default     = "admin@example.com"
}

# Variables Ingress
variable "ingress_class" {
  type        = string
  description = "IngressClass name"
  default     = "nginx"
}

variable "cluster_issuer" {
  type        = string
  description = "Cluster issuer name"
  default     = "letsencrypt"
}

variable "wordpress_hostname" {
  type        = string
  description = "Wordpress hostname"
  default     = "filrouge-wp"
}


variable "wordpress_tls_secret_name" {
  type        = string
  description = "TLS secret name"
  default     = "wp-tls"
}

### External IP for Nginx Ingress
variable "external_ip" {
  type        = string
  description = "External IP or Hostname from the Nginx Ingress"
}
