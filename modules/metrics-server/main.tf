#=============================================================================#
#=============================================================================#
#=========== Deploy Metrics Server with Helm
#=============================================================================#
#=============================================================================#
resource "helm_release" "metrics-server" {
  name             = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  namespace        = "kube-system"
  version          = "3.12.2"
  create_namespace = true
}


