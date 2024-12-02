output "ingress_name" {
    description = "Ingres class name to use for in helm/manifest ingress configuration"
    value = helm_release.nginx-ingress-controller-chart.name
}

output "external_ip" {
    description = "The external ip configured for the load balancer nginx ingress"
    value = data.kubernetes_service.nginx-ingress-controller.status.0.load_balancer.0.ingress.0.hostname
}

output "ingress_namespace" {
    description = "Ingress namespace to use for helm/manifests"
    value = helm_release.nginx-ingress-controller-chart.namespace
}
