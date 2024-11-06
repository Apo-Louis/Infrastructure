output "ingress_name" {
    description = "Ingres class name to use for in helm/manifest ingress configuration"
    value = helm_release.nginx-ingress-controller-chart.name
}
