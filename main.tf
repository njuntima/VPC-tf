# VPC
resource "aws_vpc" "new_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"


  tags = {
    Name = "tf-vpc"
  }
}


# subnets 

  # east 1a
resource "aws_subnet" "public_subnets" {
  count = 2
  vpc_id = aws_vpc.new_vpc.id

  cidr_block = var.public_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "public-subnet-tf-${count.index}"
  }
}

resource "aws_subnet" "private_subnets" {
  count = 2
  vpc_id = aws_vpc.new_vpc.id

  cidr_block = var.private_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-subnet-tf-${count.index}"
  }
}


# igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.new_vpc.id

  tags = {
    Name = "igw-tf"
  }
}

# route tables
resource "aws_route_table" "public_route_table" {
   vpc_id = aws_vpc.new_vpc.id 


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "public-route-table-tf"
  }
}


resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.new_vpc.id 


# done automatically if local by AWS
#   route {
#     cidr_block = "10.0.0.0/16"
#   }

  tags = {
    Name = "private-route-table-tf"
  }
}


# link route tables
resource "aws_route_table_association" "public_associations" {
  count = 2
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_associations" {
  count = 2
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}


# s3 endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.new_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  route_table_ids = [ aws_route_table.private_route_table.id ]
  tags = {
    Name = "vpc-s3-endpoint-tf"
  }
}
