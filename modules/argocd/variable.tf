
variable "domain_name" {
    description = "Domain used for the ingress setup"
    type = string
}

variable "eks_endpoint" {
    description = "Endpoint of the EKS cluster"
    type = string
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
  description = "URL du dépôt WordPress"
  default = "Apo-Louis/wordpress-charts"
}

variable "wordpress_repo" {
  type        = string
  description = "URL du dépôt WordPress"
  default = "Apo-Louis/wordpress"
}




variable "wordpress_repo_token" {
    type = string
    description = "Token generate from GitHub"
    sensitive = true
}
variable "wordpress_branch" {
  type        = string
  description = "Branche du dépôt WordPress à utiliser"
  default = "main"
}

# Variables MariaDB
variable "storage_class" {
  type        = string
  description = "Classe de stockage à utiliser"
  default = "default"
}

variable "mariadb_root_password" {
  type        = string
  description = "Mot de passe root MariaDB"
  sensitive   = true
}

variable "database_name" {
  type        = string
  description = "Nom de la base de données WordPress"
  default = "wordpressdb"
}

variable "database_username" {
  type        = string
  description = "Nom d'utilisateur de la base de données"
  default = "wordpress"
}

variable "database_password" {
  type        = string
  description = "Mot de passe de la base de données"
  sensitive   = true
  default = "password"
}

variable "mariadb_volume_size" {
  type        = string
  description = "Taille du volume MariaDB"
  default = "10Gi"
}

# Variables WordPress
variable "wordpress_site_title" {
  type        = string
  description = "Titre du site WordPress"
  default = "Fil Rouge Project Wordpress"
  }

variable "wordpress_admin_user" {
  type        = string
  description = "Nom d'utilisateur administrateur WordPress"
  default = "admin"
}

variable "wordpress_admin_password" {
  type        = string
  description = "Mot de passe administrateur WordPress"
  sensitive   = true
  default = "password"
}

variable "wordpress_admin_email" {
  type        = string
  description = "Email de l'administrateur WordPress"
  default = "admin@example.com"
}

variable "docker_image" {
  type        = string
  description = "Repository de l'image Docker WordPress"
  default = "apoolouis8/wordpress"
}

variable "docker_tag" {
  type        = string
  description = "Tag de l'image Docker WordPress"
  default = "prod-1.0.0"
}


# Variables Ingress
variable "ingress_class" {
  type        = string
  description = "Classe d'ingress à utiliser"
  default = "nginx"
}

variable "cluster_issuer" {
  type        = string
  description = "Nom du cluster-issuer cert-manager"
  default = "letsencrypt"
}

variable "wordpress_hostname" {
  type        = string
  description = "Nom d'hôte pour WordPress"
  default = "filrouge-wp.apoland.net"
}


variable "wordpress_tls_secret_name" {
  type        = string
  description = "Nom du secret TLS pour WordPress"
  default = "wp-tls"
}


### External IP for Nginx Ingress
variable "external_ip" {
  type        = string
  description = "External IP or Hostname from the Nginx Ingress"
}
