### Official library :
## https://open-policy-agent.github.io/gatekeeper-library/website/

resource "helm_release" "gatekeeper" {
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper"
  version    = "3.17.1"
  name       = "gatekeeper"

    namespace = "gatekeeper-system"
  create_namespace = true
}

data "http" "contraints" {
  for_each = toset(var.contraints_url_list)

  url = each.value
}



# Deploy all policies from policies directory and apply it to the application namespace
resource "kubectl_manifest" "deploy_contraints" {
  for_each = data.http.contraints

  yaml_body = data.http.contraints[each.key].response_body

  depends_on = [helm_release.gatekeeper]
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
    namespace  = var.app_namespace
    repos_list = join("\n      ", [for repo in var.allowed_repo_list : "- ${repo}"]) # Ajout de 6 espaces pour l'indentation correcte

    depends_on = [helm_release.gatekeeper]
  })
}
