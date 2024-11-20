#=============================================================================#
#=============================================================================#
#=========== Create AWS resources with VPC module
#=============================================================================#
#=============================================================================#
module "vpc_and_subnets" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"

  name = "${var.vpc_name}-${var.environment}"

  azs = var.azs

  cidr = var.vpc_cidr

  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr


  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  create_igw = var.create_igw

  tags                = var.tags
  vpc_tags            = var.additional_vpc_tags
  public_subnet_tags  = var.additional_public_subnet_tags
  private_subnet_tags = var.additional_private_subnet_tags
}
