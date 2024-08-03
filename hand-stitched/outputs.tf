output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_cidr_blocks" {
  description = "The CIDR blocks for all private subnets of the VPC"
  value       = values(aws_subnet.private)[*].cidr_block
}

output "public_subnet_cidr_blocks" {
  description = "The CIDR blocks for all public subnets of the VPC"
  value       = values(aws_subnet.public)[*].cidr_block
}

output "nat_gateway_public_ip_address" {
  description = "The public IP address of the NAT gateway"
  value       = aws_nat_gateway.public.public_ip
}
