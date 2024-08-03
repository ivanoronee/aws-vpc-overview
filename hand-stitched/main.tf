# Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cir_block
  instance_tenancy     = "default"
  enable_dns_hostnames = false

  tags = merge(
    { "Name" = var.vpc_name },
    local.resource_tags,
  )
}

####################################################################################################
# Configure the public subnets                                                                     #
####################################################################################################

# Create the public subnets
resource "aws_subnet" "public" {
  for_each          = local.public_subnets_cidr_az_mapping
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.key
  availability_zone = each.value

  tags = merge(
    { Name = "${var.vpc_name}-public-${each.value}" },
    local.resource_tags
  )
}

# Create a route table for the public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = "${var.vpc_name}-public" },
    local.resource_tags
  )
}

# Associate all public subnets with the public route table
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Create an internet gateway for the public subnets
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = "${var.vpc_name}-igw" },
    local.resource_tags
  )
}

# Add a route to the internet gateway in the public route table
resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = local.public_internet_cidr
  gateway_id             = aws_internet_gateway.main.id
}

####################################################################################################
# Configure the private subnets                                                                    #
####################################################################################################

# Create the private subnets
resource "aws_subnet" "private" {
  for_each          = local.private_subnets_cidr_az_mapping
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.key
  availability_zone = each.value

  tags = merge(
    { Name = "${var.vpc_name}-private-${each.value}" },
    local.resource_tags
  )
}

# Create a route table for the private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = "${var.vpc_name}-private" },
    local.resource_tags
  )
}

# Associate all private subnets with the private route table
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

##### Configure internet access for the private subnets #####

# Provision an Elastic IP address for use by the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    { Name = "${var.vpc_name}-natgw-${local.nat_gateway_az}" },
    local.resource_tags
  )
  depends_on = [aws_internet_gateway.main]
}

# Create public NAT gateway
resource "aws_nat_gateway" "public" {
  allocation_id = aws_eip.nat.id
  subnet_id     = local.nat_gateway_subnet["id"]

  tags = merge(
    { Name = "${var.vpc_name}-public-nat-${local.nat_gateway_az}" },
    local.resource_tags
  )
  depends_on = [aws_internet_gateway.main]
}

# Add a route to NAT gateway in the private subnets' route table
resource "aws_route" "nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = local.public_internet_cidr
  nat_gateway_id         = aws_nat_gateway.public.id
}

####################################################################################################

data "aws_availability_zones" "available" {}

locals {
  vpc_cir_block        = "172.16.0.0/16"
  nat_gateway_subnet   = aws_subnet.public[element(keys(local.public_subnets_cidr_az_mapping), 0)]
  nat_gateway_az       = local.nat_gateway_subnet["availability_zone"]
  public_internet_cidr = "0.0.0.0/0"

  availability_zones             = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets_cidr_az_mapping = {
    "172.16.10.0/24" = local.availability_zones[0],
    "172.16.20.0/24" = local.availability_zones[1],
    "172.16.30.0/24" = local.availability_zones[2]
  }

  private_subnets_cidr_az_mapping = {
    "172.16.40.0/24" = local.availability_zones[0],
    "172.16.50.0/24" = local.availability_zones[1],
    "172.16.60.0/24" = local.availability_zones[2]
  }

  resource_tags = {
    "ManagedBy" : "Terraform"
  }
}
