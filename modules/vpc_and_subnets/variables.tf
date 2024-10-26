variable "azs" {
  description = "liste des AZs"
  type        = list(string)
}

variable "vpc_name" {
  description = "Nom du VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR du vpc"
  type        = string
}

variable "public_subnets_cidr" {
  description = "liste des CIDR sous-réseaux public"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "liste des CIDR sous-réseaux privés"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "doit être à 'true' si on veut provisioner un NAT Gateway pour chaque sous-réseau privé"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "doit être à 'true' si on veut provisionner un NAT gateway partagé entre tout les sous-réseaux privés"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "doit être à 'true' si on veux un seul NAT Gateway par az"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Doit être à 'true' pour activé le DNS hostnames sur le VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "create_igw" {
  description = "Doit être à 'true' pour create un IGW pour les sous-réseaux publics et les routes associées pour les connecter"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map des tags associé à toutes les ressources"
  type        = map(string)
  default     = {}
}

variable "additional_public_subnet_tags" {
  description = "Tags additionnel pour les public subnets"
  type        = map(string)
  default     = {}
}

variable "additional_private_subnet_tags" {
  description = "Tags additionnel pour les private subnets"
  type        = map(string)
  default     = {}
}

variable "additional_vpc_tags" {
  description = "Tags additionnel pour le VPC"
  type        = map(string)
  default     = {}
}

