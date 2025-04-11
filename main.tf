#vpc

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc-${var.project_name}"
  }
}

#subnets

resource "aws_subnet" "pub-subnets" {
  count                   = length(local.selected_azs)
  vpc_id                  = aws_vpc.my-vpc.id
  availability_zone       = local.selected_azs[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${var.project_name}-${count.index}"
  }
}

resource "aws_subnet" "pvt-subnets" {
  count                   = length(local.selected_azs)
  vpc_id                  = aws_vpc.my-vpc.id
  availability_zone       = local.selected_azs[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + length(local.selected_azs))
  map_public_ip_on_launch = true
  tags = {
    Name = "private-subnet-${var.project_name}-${count.index}"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "igw-${var.project_name}"
  }
}

resource "aws_eip" "eip-2" {

}

resource "aws_nat_gateway" "my-nat" {
  allocation_id = aws_eip.eip-2.id
  subnet_id     = aws_subnet.pub-subnets[1].id
  tags = {
    Name = "nat-gateway-${var.project_name}"
  }

}

#routetables

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    gateway_id = aws_internet_gateway.my-igw.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "public-rt-${var.project_name}"
  }
}



resource "aws_route_table" "pvt-rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    gateway_id = aws_nat_gateway.my-nat.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "private-rt-${var.project_name}"
  }
}

#subnet association

resource "aws_route_table_association" "pub-asso" {
  count          = length(aws_subnet.pub-subnets)
  subnet_id      = aws_subnet.pub-subnets[count.index].id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table_association" "pvt-asso" {
  count          = length(aws_subnet.pvt-subnets)
  subnet_id      = aws_subnet.pvt-subnets[count.index].id
  route_table_id = aws_route_table.pvt-rt.id
}