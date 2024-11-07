variables "allowed_repo_list" {
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
