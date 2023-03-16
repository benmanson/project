###############
#     VPC
###############

resource "aws_vpc" "project-vpc" {
    cidr_block = "10.0.0.0/16"

    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "project-vpc"
    }
}

###############
#   SUBNETS
###############

resource "aws_subnet" "project-public-subnet-1" {
    vpc_id = aws_vpc.project-vpc.id

    cidr_block = cidrsubnet(aws_vpc.project-vpc.cidr_block, 8, 1)
    availability_zone = var.availability_zones[0]

    map_public_ip_on_launch = true

    tags = {
        Name = "project-subnet-public-${var.availability_zones[0]}"
    }
}

resource "aws_subnet" "project-public-subnet-2" {
    vpc_id = aws_vpc.project-vpc.id

    cidr_block = cidrsubnet(aws_vpc.project-vpc.cidr_block, 8, 3)
    availability_zone = var.availability_zones[1]

    map_public_ip_on_launch = true

    tags = {
        Name = "project-subnet-public-${var.availability_zones[1]}"
    }
}

resource "aws_subnet" "project-private-subnet-1" {
    vpc_id = aws_vpc.project-vpc.id

    cidr_block = cidrsubnet(aws_vpc.project-vpc.cidr_block, 8, 2)
    availability_zone = var.availability_zones[0]

    map_public_ip_on_launch = false

    tags = {
        Name = "project-subnet-private-${var.availability_zones[0]}"
    }
}

resource "aws_subnet" "project-private-subnet-2" {
    vpc_id = aws_vpc.project-vpc.id

    cidr_block = cidrsubnet(aws_vpc.project-vpc.cidr_block, 8, 4)
    availability_zone = var.availability_zones[1]

    map_public_ip_on_launch = false

    tags = {
        Name = "project-subnet-private-${var.availability_zones[1]}"
    }
}

###############
# ROUTE TABLES
###############

resource "aws_route_table" "project-public-rtb" {
    vpc_id = aws_vpc.project-vpc.id

    tags = {
        Name = "project-rtb-public"
    }
}

resource "aws_route_table_association" "project-public-subnet-1-association" {
  subnet_id = aws_subnet.project-public-subnet-1.id
  route_table_id = aws_route_table.project-public-rtb.id
}

resource "aws_route_table_association" "project-public-subnet-2-association" {
  subnet_id = aws_subnet.project-public-subnet-2.id
  route_table_id = aws_route_table.project-public-rtb.id
}

resource "aws_route_table" "project-private-rtb" {
    vpc_id = aws_vpc.project-vpc.id

    tags = {
        Name = "project-rtb-private"
    }
}

resource "aws_route_table_association" "project-private-subnet-1-association" {
  subnet_id = aws_subnet.project-private-subnet-1.id
  route_table_id = aws_route_table.project-private-rtb.id
}

resource "aws_route_table_association" "project-private-subnet-2-association" {
  subnet_id = aws_subnet.project-private-subnet-2.id
  route_table_id = aws_route_table.project-private-rtb.id
}
