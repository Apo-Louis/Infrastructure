# vpc module : creation vpc, subnets, NATs, IGW
module "vpc_and_subnets" {
  # invoke public vpc module
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"

  # nom du VPC
  name = "${var.vpc_name}-${var.environment}"

  # zones de disponibilité
  azs = var.azs

  # vpc cidr
  cidr = var.vpc_cidr

  # création des sous-réseaux public et privé
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr


  # création des nat gateways
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  # enable dns hostnames and support
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  # création de l'Internet Gateway
  create_igw = var.create_igw

  # tags
  tags                = var.tags
  vpc_tags            = var.additional_vpc_tags
  public_subnet_tags  = var.additional_public_subnet_tags
  private_subnet_tags = var.additional_private_subnet_tags
}
