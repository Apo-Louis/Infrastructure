output "vpc_id" {
  description = "ID du VPC"
  value       = module.vpc_and_subnets.vpc_id
}

output "private_subnets" {
  description = "Liste des IDs des sous-réseaux privés"
  value       = module.vpc_and_subnets.private_subnets
}

output "public_subnets" {
  description = "Liste des IDs des sous-réseaux publics"
  value       = module.vpc_and_subnets.public_subnets
}

#output "public_route_table_ids" {
#  description = "List of IDs of public route tables"
#  value       = module.vpc_and_subnets.public_route_table_ids
#}

#output "private_route_table_ids" {
#  description = "List of IDs of private route tables"
#  value       = module.vpc_and_subnets.private_route_table_ids
#}

#output "nat_ids" {
#  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
#  value       = module.vpc_and_subnets.nat_ids
#}

#output "nat_public_ips" {
#  description = "List of public Elastic IPs created for AWS NAT Gateway"
#  value       = module.vpc_and_subnets.nat_public_ips
#}

#output "natgw_ids" {
#  description = "List of NAT Gateway IDs"
#  value       = module.vpc_and_subnets.natgw_ids
#}

#output "igw_id" {
#  description = "The ID of the Internet Gateway"
#  value       = module.vpc_and_subnets.igw_id
#}
