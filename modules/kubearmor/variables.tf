variable "namespace" {
  description = "Name of the namespace for kubearmor"
  type        = string
}


variable "app_namespace" {
  description = "Namespace of the prod/staging/dev environment"
  type        = string
}
