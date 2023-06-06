# Create VPC
resource "aws_vpc" "henryvpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    name = "testvpc"
  }
}

# Create Subnet
resource "aws_subnet" "publicsubnet" {
  vpc_id     = aws_vpc.henryvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "test public subnet 1"
  }
}

resource "aws_subnet" "publicsubnet2" {
  vpc_id     = aws_vpc.henryvpc.id
  cidr_block = "10.0.30.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "test public subnet 2"
  }
}

resource "aws_subnet" "privatesubnet3" {
  vpc_id     = aws_vpc.henryvpc.id
  cidr_block = "10.0.50.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "test private subnet database tier"
  }
}

resource "aws_subnet" "privatesubnet4" {
  vpc_id     = aws_vpc.henryvpc.id
  cidr_block = "10.0.144.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private subnet database tier"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "publicig" {
  vpc_id = aws_vpc.henryvpc.id

  tags = {
    Name = "test"
  }
}

# Create Route Table
resource "aws_route_table" "routeigw" {
  vpc_id = aws_vpc.henryvpc.id 

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.publicig.id
  }

  tags = {
    Name = "testroutetable"
  }
}

# Associate public Subnet with Route Table in az1
resource "aws_route_table_association" "publicsubnet_asst" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.routeigw.id
}

# Associate public Subnet with Route Table in az2
resource "aws_route_table_association" "publicsubnet2_asst" {
  subnet_id      = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.routeigw.id
}
