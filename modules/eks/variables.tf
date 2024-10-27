variable "cluster_name" {
    description = "The name of the cluster."
    type        = string
    default     = "eks-cluster"
}

variable "cluster_version" {
    description = "The Kubernetes version to use for the EKS cluster."
    type        = string
    default     = "1.31"
}

variable "cluster_endpoint_public_access" {
    description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
    type        = bool
    default     = true
}

variable "cluster_endpoint_private_access" {
    description = "Indicates whether or not the Amazon EKS private api server endpoint is enabled."
    type        = bool
    default     = false
}

variable "cluster_addons" {
    description = "Map of Kubernetes add-ons to enable."
    type        = map(any)
    default     = {
        coredns                = {}
        eks-pod-identity-agent = {}
        kube-proxy             = {}
        vpc-cni                = {}
        aws-ebs-csi-driver     = {}
    }
}

variable "vpc_id" {
    description = "The ID of the VPC where the EKS cluster will be created."
    type        = string
}

variable "worker_subnet_ids" {
    description = "A list of subnet IDs where the worker nodes will be placed."
    type        = list(string)
}

variable "control_plane_subnet_ids" {
    description = "A list of subnet IDs for the control plane."
    type        = list(string)
}

variable "workers_config" {
    description = "Configuration for worker nodes."
    type        = list(object({
        name           = string
        instance_types = list(string)
        capacity_type  = string
        disk_size      = number
        desired_size   = number
        min_size       = number
        max_size       = number
    }))
    default = [
        {
        name = "t3-medium-spot"
        # il faut mettre une plus grosse instance pour avoir assez d'adress IP
        # minimum : 4 CPU et 10 Go de RAM
        instance_types = ["t3.medium"]
        # ON_DEMAND, SPOT
        capacity_type = "SPOT"
        disk_size     = 20
        min_size      = 0
        max_size      = 4
        desired_size  = 1
        },
    ]
}

variable "enable_cluster_creator_admin_permissions" {
    description = "Enable cluster creator admin permissions."
    type        = bool
    default     = true
}

variable "tags" {
    description = "A map of tags to add to all resources created by this module."
    type        = map(string)
    default     = {}
}

variable "kubeconfig_path" {
    description = "Path where the kubeconfig file will be saved."
    type        = string
}