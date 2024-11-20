output "vpc_id" {
  description = "VPC id"
  value       = module.vpc_and_subnets.vpc_id
}

output "private_subnets" {
  description = "Private subnets ids"
  value       = module.vpc_and_subnets.private_subnets
}

output "public_subnets" {
  description = "Public subnets ids"
  value       = module.vpc_and_subnets.public_subnets
}
