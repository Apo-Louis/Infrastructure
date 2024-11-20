#=============================================================================#
#=============================================================================#
#=========== kubearmor deployment with helm
#=============================================================================#
#=============================================================================#
#------ https://docs.kubearmor.io/kubearmor
resource "helm_release" "kubearmor_chart" {
  repository = "https://kubearmor.github.io/charts"
  chart      = "kubearmor"
  version    = "1.4.3"

  name = "kubearmor"

  namespace        = var.namespace
  create_namespace = true

}


locals {
  manifest_files = [
    for file in fileset("${path.module}/policies",
    "*.yaml") : "${path.module}/policies/${file}"
  ]
}

#=============================================================================#
#=============================================================================#
#=========== Deploy all policies from the policies directory
#=========== apply it to the application namespace
#=============================================================================#
#=============================================================================#
resource "kubectl_manifest" "deploy_policies" {
  for_each = { for file in local.manifest_files : file => file }
  yaml_body = templatefile(each.value, {
    app_namespace = var.app_namespace
  })

  depends_on = [helm_release.kubearmor_chart]

}

