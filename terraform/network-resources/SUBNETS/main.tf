resource "aws_subnet" "public_A" {
  vpc_id = var.vpc_id
  availability_zone = var.AZ_a
  cidr_block = "10.50.10.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_A_subnet"
  }
}

resource "aws_subnet" "public_B" {
  vpc_id = var.vpc_id
  availability_zone = var.AZ_b
  cidr_block = "10.50.20.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_B_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "WebApp-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table_association" "public_A_association" {
  subnet_id = aws_subnet.public_A.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_B_association" {
  subnet_id = aws_subnet.public_B.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "nat_eip_A" {
  domain = "vpc"
}

resource "aws_eip" "nat_eip_B" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway_A" {
  allocation_id = aws_eip.nat_eip_A.id
  subnet_id = aws_subnet.public_A.id
  tags = {
    Name = "PrivateSubnetA_NAT"  
 }
}

resource "aws_nat_gateway" "nat_gateway_B" {
  allocation_id = aws_eip.nat_eip_B.id
  subnet_id = aws_subnet.public_B.id
  tags = {
    Name = "PrivateSubnetB_NAT"  
 }
}

resource "aws_subnet" "private_A" {
  vpc_id = var.vpc_id
  cidr_block = "10.50.80.0/24"
  availability_zone = var.AZ_a
  tags = {
    Name = "private_A_subnet"
  }
}

resource "aws_subnet" "private_B" {
  vpc_id = var.vpc_id
  cidr_block = "10.50.90.0/24"
  availability_zone = var.AZ_b
  tags = {
    Name = "private_B_subnet"
  }
}

resource "aws_route_table_association" "private_A_association" {
  subnet_id = aws_subnet.private_A.id
  route_table_id = aws_route_table.private_A_route_table.id
}

resource "aws_route_table_association" "private_B_association" {
  subnet_id = aws_subnet.private_B.id
  route_table_id = aws_route_table.private_B_route_table.id
}

resource "aws_route_table" "private_A_route_table" {
  vpc_id  = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_A.id
  }
  tags = {
    Name = "Private-Route-Table-A"
  }
}

resource "aws_route_table" "private_B_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_B.id
  }
  tags = {
    Name = "Private-Route-Table-B"
  }
}
