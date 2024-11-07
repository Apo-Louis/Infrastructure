resource "helm_release" "gatekeeper" {
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper/gatekeeper"
  version    = "3.17.1"
  name       = "gatekeeper"

  create_namespace = true
}



locals {
  contraints_files = fileset("${path.module}/contraints", "*.yaml")
}



# Deploy all policies from policies directory and apply it to the application namespace
resource "kubectl_manifest" "deploy_contraints" {
  for_each  = { for file in local.contraints_files : file => file }
  yaml_body = templatefile(each.value)
}

# NePort policies if Prod Infrastructure
resource "kubectl_manifest" "nodeport_policy" {
  count = var.app_namespace == "prod" ? 1 : 0

  yaml_body = templatefile("${path.module}/policies/block-nodeport.yaml", {
        app_namespace = var.app_namespace
    })
}


# Autorized repos to application namespace
resource "kubectl_manifest" "allowed_repos" {
  yaml_body = templatefile("${path.module}/policies/allows-repos.yaml", {
        namespace = var.app_namespace
        allowed_repo_list = var.allowed_repo_list
    })
}
