variable "harbor_url" {
  description = "The URL of the Harbor registry"
  type        = string
}

variable "harbor_username" {
  description = "Username for the Harbor robot"
  type        = string
  sensitive   = true
}

variable "harbor_password" {
  description = "Password for the Harbor robot"
  type        = string
  sensitive   = true
}

variable "robot_email" {
  description = "Email associated with the Harbor robot"
  type        = string
  default     = "" # Optionnel
}




variable "argo_hostname" {
  description = "The hostname that will be used by the Ingress resource for routing traffic."
  type        = string
}

variable "argo_ingress_class_name" {
  description = "The name of the IngressClass resource to use for this ingress controller."
  type        = string
}

variable "argo_namespace" {
  description = "The namespace in which to deploy the ingress controller."
  type        = string
  default     = "argocd"
}

variable "cluster_issuer_name" {
  description = "The name of the Cert-Manager issuer to use for generating certificates."
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

variable "job_name" {
  description = "Name of the job to be created."
  type        = string
  default     = "pre-sync-job"
}


######### Wordpress

variable "wp_github_repo" {
  description = "The GitHub repository for the WordPress plugins and themes."
  type        = string
}

variable "wp_github_branch" {
  description = "The branch of the GitHub repository to use for WordPress content."
  type        = string
  default     = "main"
}

variable "wp_github_token" {
  description = "GitHub personal access token with read permissions for the repository."
  type        = string
}

variable "wp_ingress_enabled" {
  description = "Enable or disable Ingress for WordPress."
  type        = bool
  default     = true
}

variable "wp_ingress_class_name" {
  description = "The name of the IngressClass to use for the WordPress ingress."
  type        = string
}

variable "wp_hostname" {
  description = "The hostname for the WordPress ingress."
  type        = string
}

variable "wp_pvc_size" {
  description = "The size of the PersistentVolumeClaim for WordPress data."
  type        = string
  default     = "10Gi"
}


# Pour db_host recuperer directement à partir de la resources application crée pour mariadb (name)


######### db

variable "db_host" {
  description = "The host for the db database."
  type        = string
  default     = "mariadb"
}

variable "db_root_password" {
  description = "The root password for the db database."
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "The username for the db database user."
  type        = string
}

variable "db_password" {
  description = "The password for the db database user."
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the db database to create."
  type        = string
}

variable "db_pvc_size" {
    description = "The size of the PersistentVolumeClaim for database"
    type = string
    default = "50Gi"
}
# <--- Terminé les variables après avoir refait le chart helm de mariadb

##### EFS StorageClass Needed for wp-content & mariadb

variable "storage_class" {
    description = "EFS StorageClass Needed for wp-content & mariadb"
    type = string
}
