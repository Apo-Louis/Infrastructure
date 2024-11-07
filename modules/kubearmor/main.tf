resource "helm_release" "kubearmor_chart" {
  repository = "https://kubearmor.github.io/charts"
  chart      = "kubearmor"
  version    = "1.4.3"

  name = "kubearmor"

    namespace = var.namespace

}


locals {
    manifest_files = fileset("${path.module}/policies", "*.yaml")
}


# Deploy all policies from policies directory and apply it to the application namespace
resource "kubectl_manifest" "deploy_policies" {
    for_each = { for file in local.manifest_files : file => file }
    yaml_body = templatefile(each.value, {
        app_namespace = var.app_namespace
        })


}
