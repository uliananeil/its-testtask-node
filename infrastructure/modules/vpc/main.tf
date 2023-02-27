data "aws_availability_zones" "alive" {
  state = "available"
}

locals {
  az_amount = length(data.aws_availability_zones.alive.names)
}

//----VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-main-vpc"
  }
}

//----Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-igw"
  }
}

//----Private Subnets
resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.main.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = data.aws_availability_zones.alive.names[count.index % local.az_amount]

  tags = {
    "Name"                                      = "${var.project}-private-subnet-${count.index}"
    "kubernetes.io/role/internal-elb"           = "1"
    //"kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

//----Public Subnets
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.main.id
  count = length(var.public_subnets)
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = data.aws_availability_zones.alive.names[count.index % local.az_amount]
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "${var.project}-public-subnet-${count.index}"
    "kubernetes.io/role/elb"                    = "1"
    //"kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}


//----Elastic IP
resource "aws_eip" "nat_ip" {
  vpc = true

  tags = {
    Name = "${var.project}-nat-ip"
  }
}

//----Network Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "${var.project}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

//----Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project}-private-route-table"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project}-public-route-table"
  }
}

//----Route Table Assosiation
resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}