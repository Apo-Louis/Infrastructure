variable "namespace" {
    description = "The namespace where to deploy sealed-secrets controller."
    type = string
    default = "kube-system"
}
