resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Main-VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]

  tags = {
    Name = "Public-Subnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "Private-Subnet-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Internet-Gateway"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  # Route internet-bound traffic to IGW
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_rt_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


data "aws_vpc" "peer_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.peer_vpc_name] # Specify the Name tag of the peer VPC
  }
}

# Fetch Peer Route Table Dynamically
data "aws_route_table" "peer_route_table" {
  vpc_id = data.aws_vpc.peer_vpc.id
filter {
    name   = "association.main"
    values = ["true"]
  }
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id      = aws_vpc.main.id
  peer_vpc_id = data.aws_vpc.peer_vpc.id

  auto_accept = true

  tags = {
    Name = "VPC-Peering-Main-To-Peer"
  }
}

# Main VPC Route Table Update
resource "aws_route" "main_to_peer_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = data.aws_vpc.peer_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# Peer VPC Route Table Update
resource "aws_route" "peer_to_main_route" {
  route_table_id         = data.aws_route_table.peer_route_table.id
  destination_cidr_block = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}
