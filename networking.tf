resource "aws_vpc" "eks_vpc" {
    cidr_block = var.cidr_block
    # enable_dns_support = true
    # enable_dns_hostnames = true
    tags = {
        Name = "eks-vpc"
    }
}

resource "aws_subnet" "public_subnet1" {
    vpc_id = aws_vpc.eks_vpc.id
    cidr_block =  "10.0.1.0/24"
    availability_zone = var.availability_zone1
    map_public_ip_on_launch = true
    tags = {
      name = "eks-public-subnet1"
    }
}
resource "aws_subnet" "public_subnet2" {
    vpc_id = aws_vpc.eks_vpc.id
    cidr_block =  "10.0.2.0/24"
    availability_zone = var.availability_zone2
    map_public_ip_on_launch = true
    tags = {
      name = "eks-public-subnet2"
    }
}
resource "aws_subnet" "private_subnet1" {
    vpc_id = aws_vpc.eks_vpc.id
    cidr_block =  "10.0.3.0/24"
    availability_zone = var.availability_zone1
    tags = {
      name = "eks-private-subnet1"
    }
}
resource "aws_subnet" "private_subnet2" {
    vpc_id = aws_vpc.eks_vpc.id
    cidr_block =  "10.0.4.0/24"
    availability_zone = var.availability_zone2
    tags = {
      name = "eks-private-subnet2"
    }
}

resource "aws_internet_gateway" "eks_igw" {
    vpc_id = aws_vpc.eks_vpc.id
    tags = {
        name = "eks-igw"
    }
}

# -------------public route table and Association----------------

resource "aws_route_table" "eks_public_route_table" {
    vpc_id = aws_vpc.eks_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.eks_igw.id
    }
    tags = {
      name = "eks-public-route-table"
    }
}

resource "aws_route_table_association" "eks_public_subnet1_association" {
    subnet_id = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.eks_public_route_table.id
  
}
resource "aws_route_table_association" "eks_public_subnet2_association" {
    subnet_id = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.eks_public_route_table.id
}

resource "aws_eip" "eks_nat_eip" {
    depends_on = [ aws_internet_gateway.eks_igw ]
    vpc = true
}



# ----------private route table and Association----------------

resource "aws_nat_gateway" "eks_nat_gateway" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public_subnet2
    depends_on    = [aws_internet_gateway.eks_igw]
}

resource "aws_route_table" "eks_private_route_table" {
    vpc_id = aws_vpc.eks_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.eks_nat_gateway.id
    }
    tags = {
      name = "eks-private-route-table"
    }
}
resource "aws_route_table_association" "eks_private_subnet1_association1" {
    subnet_id = aws_subnet.private_subnet1.id
    route_table_id = aws_route_table.eks_private_route_table.id
}
resource "aws_route_table_association" "eks_private_subnet1_association2" {
    subnet_id = aws_subnet.private_subnet2.id
    route_table_id = aws_route_table.eks_private_route_table.id
}



# ---------------Eks module networking ----------------