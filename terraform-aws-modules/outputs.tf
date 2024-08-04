output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_cidr_blocks" {
  description = "The CIDR blocks for all private subnets of the VPC"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnet_cidr_blocks" {
  description = "The CIDR blocks for all public subnets of the VPC"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "nat_gateway_public_ip_address" {
  description = "The public IP address of the NAT gateway"
  value       = module.vpc.nat_public_ips
}
