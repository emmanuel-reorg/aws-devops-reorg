resource "aws_vpc" "reorg" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "reorg_vpc"
  }
}
resource "aws_internet_gateway" "cv_igw" {
  vpc_id = aws_vpc.reorg.id
  tags = {
    Name = "reorg_igw"
  }
}

resource "aws_subnet" "subnet-1a" {
  vpc_id                  = aws_vpc.reorg.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "subnet-1a"
  }
}

resource "aws_subnet" "subnet-1b" {
  vpc_id                  = aws_vpc.reorg.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "subnet-1b"
  }
}

# Create a Route Table for the VPC
resource "aws_route_table" "reorg_rt" {
  vpc_id = aws_vpc.reorg.id
  tags = {
    Name = "reorg_rt"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.reorg_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cv_igw.id
}

# Associate the Route Table with Subnet-1a
resource "aws_route_table_association" "subnet_1a_association" {
  subnet_id      = aws_subnet.subnet-1a.id
  route_table_id = aws_route_table.reorg_rt.id
}

# Associate the Route Table with Subnet-1b
resource "aws_route_table_association" "subnet_1b_association" {
  subnet_id      = aws_subnet.subnet-1b.id
  route_table_id = aws_route_table.reorg_rt.id
}

data "aws_route_table" "main" {
  vpc_id = aws_vpc.reorg.id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}
