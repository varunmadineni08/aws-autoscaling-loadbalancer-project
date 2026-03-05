provider "aws" {
  region=var.region
}


resource "aws_vpc" "ag_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name="ag_vpc"
  }
}

resource "aws_internet_gateway" "ag_igw" {
  vpc_id = aws_vpc.ag_vpc.id
  tags = {
    Name="ag_igw"
  }
}

resource "aws_subnet" "ag_subnet_1" {
  vpc_id = aws_vpc.ag_vpc.id
  cidr_block = var.pub_subnet_1_cidr
  availability_zone = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name="subnet_1"
  }
}

resource "aws_subnet" "ag_subnet_2" {
  vpc_id = aws_vpc.ag_vpc.id
  cidr_block = var.pub_subnet_2_cidr
  availability_zone = var.az_2
  map_public_ip_on_launch = true

  tags = {
    Name="subnet_2"
  }

}


resource "aws_route_table" "ag_rt" {
  vpc_id = aws_vpc.ag_vpc.id
  tags = {
    Name="ag_route"
  }
}

resource "aws_route" "internet_access" {
  route_table_id = aws_route_table.ag_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ag_igw.id
}

resource "aws_route_table_association" "route_table_association_1" {
  route_table_id = aws_route_table.ag_rt.id
  subnet_id = aws_subnet.ag_subnet_1.id
}

resource "aws_route_table_association" "route_table_association_2" {
  route_table_id = aws_route_table.ag_rt.id
  subnet_id = aws_subnet.ag_subnet_2.id
}

















































