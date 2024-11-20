output "argocd_url" {
    description = "Url of Argocd"
    value = "https://${var.argo_hostname}.${var.domain_name}"
}

output "wordpress_url" {
    description = "Url of Argocd"
    value = "https://${var.wordpress_hostname}.${var.domain_name}"
}
