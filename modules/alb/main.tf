resource "helm_release" "alb" {
    name = "alb"
    repository = "https://aws.github.io/eks-charts"
    chart = "aws-load-balancer-controller"
    namespace = "kube-system"
    version = "1.9.1"

    set {
        name = "clusterName"
        value = var.cluster_name
    }

    set {
        name = "serviceAccount.create"
        value = false
    }

    set {
        name = "serviceAccount.name"
        value = kubernetes_service_account.alb_service_account.metadata[0].name
    }
}