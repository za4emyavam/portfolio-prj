resource "aws_vpc" "portfolio_vpc" {
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = {
    Name    = "portfolio-vpc"
    Project = "portfolio"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.portfolio_vpc.id
  tags = {
    Name    = "portfolio-igw"
    Project = "portfolio"
  }
}

resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = aws_vpc.portfolio_vpc.id
  tags = {
    Name    = "portfolio-eigw-ipv6"
    Project = "portfolio"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.portfolio_vpc.id
  cidr_block        = "10.0.1.0/24"
  ipv6_cidr_block   = cidrsubnet(aws_vpc.portfolio_vpc.ipv6_cidr_block, 8, 1)
  availability_zone = "eu-central-1a"

  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags = {
    Name    = "portfolio-public-a"
    Project = "portfolio"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.portfolio_vpc.id
  cidr_block        = "10.0.2.0/24"
  ipv6_cidr_block   = cidrsubnet(aws_vpc.portfolio_vpc.ipv6_cidr_block, 8, 2)
  availability_zone = "eu-central-1b"

  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags = {
    Name    = "portfolio-public-b"
    Project = "portfolio"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.portfolio_vpc.id
  cidr_block        = "10.0.10.0/24"
  ipv6_cidr_block   = cidrsubnet(aws_vpc.portfolio_vpc.ipv6_cidr_block, 8, 10)
  availability_zone = "eu-central-1a"

  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  tags = {
    Name    = "portfolio-private-a"
    Project = "portfolio"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.portfolio_vpc.id
  cidr_block        = "10.0.11.0/24"
  ipv6_cidr_block   = cidrsubnet(aws_vpc.portfolio_vpc.ipv6_cidr_block, 8, 11)
  availability_zone = "eu-central-1b"

  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  tags = {
    Name    = "portfolio-private-b"
    Project = "portfolio"
  }
}


resource "aws_route_table" "publc_rt" {
  vpc_id = aws_vpc.portfolio_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "portfolio-public-rt"
    Project = "portfolio"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.portfolio_vpc.id

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_egress_only_internet_gateway.eigw.id
  }

  tags = {
    Name    = "portfolio-private-rt"
    Project = "portfolio"
  }
}

resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.publc_rt.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.publc_rt.id
}

resource "aws_route_table_association" "private_a_assoc" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_b_assoc" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt.id
}
