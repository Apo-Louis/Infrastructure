module "eks_cluster" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 20.0"

    cluster_name    = var.cluster_name
    cluster_version = var.cluster_version

    cluster_endpoint_public_access  = var.cluster_endpoint_public_access
    cluster_endpoint_private_access = var.cluster_endpoint_private_access

    # Filter ip access from internet
    #cluster_endpoint_public_access_cidrs = ["203.0.113.5/32"]

    cluster_addons = {
        coredns                = {}
        eks-pod-identity-agent = {}
        kube-proxy             = {}
        vpc-cni                = {}
        aws-ebs-csi-driver     = {}
    }

    vpc_id                   = var.vpc_id
    subnet_ids               = var.worker_subnet_ids
    control_plane_subnet_ids = var.control_plane_subnet_ids


    eks_managed_node_groups = {
        for node_group in var.workers_config : node_group.name => {
            instance_types = node_group.instance_types
            capacity_type  = node_group.capacity_type
            disk_size      = node_group.disk_size
            desired_size   = node_group.desired_size
            max_size       = node_group.max_size
            min_size       = node_group.min_size
            name           = node_group.name

            tags = {
                "kubernetes.io/cluster/${var.cluster_name}" = "owned"
                "k8s.io/cluster-autoscaler/enabled"             = "true"
                "k8s.io/cluster-autoscaler/${var.cluster_name}" = "true"
            }
        }
    }

    enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

    tags = var.tags
}


resource "null_resource" "kubeconfig" {
    provisioner "local-exec" {
        command = "aws eks update-kubeconfig --name ${var.cluster_name} --alias ${var.cluster_name} --kubeconfig ${var.kubeconfig_path}"
    }

    depends_on = [module.eks_cluster]
}
