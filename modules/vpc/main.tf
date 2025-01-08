data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name] 
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]

  tags = {
    Name = "Public-Subnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = data.aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "Private-Subnet-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "IGW-1"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.main.id

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


output "vpc_cidr" {
  value = data.aws_vpc.main.cidr_block
}
