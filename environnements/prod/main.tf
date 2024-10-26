###### ----- VPC ----- ######

resource "aws_eip" "nat" {
  count = 1
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = var.vpc_name
    cidr = var.vpc_cidr

    azs             = var.availability_zones

    private_subnets = var.private_subnets
    public_subnets  = var.public_subnets
    database_subnets = var.database_subnets

    enable_nat_gateway = true
    single_nat_gateway = true
    one_nat_gateway_per_az = false

    reuse_nat_ips       = true
    external_nat_ip_ids = "${aws_eip.nat.*.id}"

    tags = {
        Terraform = "true"
        Environment = "dev"
  }
}

###### -------------------------------------------------------------------- ######

###### ----- EKS ----- ######

module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 20.0"

    cluster_name    = "my-cluster"
    cluster_version = "1.31"

    cluster_endpoint_public_access  = true
    cluster_endpoint_private_access = false

    # Filter ip access from internet
    #cluster_endpoint_public_access_cidrs = ["203.0.113.5/32"]

    cluster_addons = {
        coredns                = {}
        eks-pod-identity-agent = {}
        kube-proxy             = {}
        vpc-cni                = {}
        aws-ebs-csi-driver     = {}
    }

    vpc_id                   = module.vpc.vpc_id
    subnet_ids               = module.vpc.private_subnets
    control_plane_subnet_ids = module.vpc.private_subnets


    eks_managed_node_group_defaults = {
        instance_types = ["m6i.large", "m5.large"]
    }

    eks_managed_node_groups = {
        example = {
        instance_types = ["t3.medium"] # <-- J'ai dù baisser en gamme car je pense que sur le compte de service on à des limitations.
        
        min_size     = 2
        max_size     = 5
        desired_size = 2
        }
    }

    enable_cluster_creator_admin_permissions = true

    tags = {
        Environment = "prod"
        Terraform   = "true"
    }
    }
###### -------------------------------------------------------------------- ######


###### ----- CERT-MANAGER ----- ######

module "cert-manager" {
    source = "../../cert-manager"
    
    ovh_application_key = var.ovh_application_key
    ovh_application_secret = var.ovh_application_secret
    ovh_consumer_key = var.ovh_consumer_key

}

###### -------------------------------------------------------------------- ######


###### ----- ARGO-CD ----- ######

module "argo-cd" {
    source = "../../modules/argocd"
}

###### -------------------------------------------------------------------- ######


###### ----- ALB ----- ######

module "alb" {
    source = "../../alb"

    cluster_name = module.eks.cluster_name
    region = var.aws_region
    vpc_id = module.vpc.vpc_id
}

###### -------------------------------------------------------------------- ######
