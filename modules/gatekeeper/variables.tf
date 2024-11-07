variable "allowed_repo_list" {
    description = "list of repo allowed into the application namspace (dev, prod, staging)"
    type = list(string)
    default = [
        "harbor.apoland.net/", # <-- prod repo
        "apoolouis8/" # <-- dev / staging repo
    ]
}

variable "app_namespace" {
    description = "namespace of the application"
    type = string
}


variable "contraints_url_list" {
    description = "A list of contraints from the officel gatekeeper library"
    type = list(string)
    default = [
        "https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/general/allowedrepos/template.yaml",
        "https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/general/block-nodeport-services/template.yaml"
    ]
}
