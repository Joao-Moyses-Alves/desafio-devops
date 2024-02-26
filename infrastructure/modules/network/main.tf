resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name                                = "${var.name}-vpc"
    "kubernetes_io_cluster_${var.name}" = "owned"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name                                = "${var.name}-igw"
    "kubernetes_io_cluster_${var.name}" = "owned"
  }
}

resource "aws_subnet" "public" {
  count                   = var.create_public_subnet ? length(var.availability_zones) : 0
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cidr, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                = "${var.name}-Public${count.index + 1}"
    "kubernetes_io_cluster_${var.name}" = "owned"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/role/elb"            = "1"
  }
}

resource "aws_subnet" "private" {
  count             = var.create_private_subnets ? length(var.availability_zones) : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, 8, 100 + count.index)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name                                = "${var.name}-Private-${var.availability_zones[count.index]}"
    "kubernetes_io_cluster_${var.name}" = "owned"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/role/elb"            = "1"
  }
}

resource "aws_eip" "nat_gateway" {
  count  = var.create_nat_gateway ? length(var.availability_zones) : 0
  domain = "vpc"

  tags = {
    Name                                = "${var.name}-eip-ngw${var.availability_zones[count.index]}"
    "kubernetes_io_cluster_${var.name}" = "owned"
  }
}

resource "aws_nat_gateway" "ngw" {
  count             = var.create_nat_gateway ? length(var.availability_zones) : 0
  allocation_id     = aws_eip.nat_gateway[count.index].id
  subnet_id         = var.create_nat_gateway ? aws_subnet.public[count.index].id : null
  connectivity_type = "public"

  tags = {
    Name                                = "${var.name}-ngw${var.availability_zones[count.index]}"
    "kubernetes_io_cluster_${var.name}" = "owned"
  }
}

resource "aws_route_table" "private" {
  count  = var.create_route_tables ? length(var.availability_zones) : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.create_route_tables ? aws_nat_gateway.ngw[count.index].id : null
  }

  tags = {
    Name                                = "${var.name}-private-route-table-${var.availability_zones[count.index]}"
    "kubernetes_io_cluster_${var.name}" = "owned"
  }
}

resource "aws_route_table" "public" {
  count  = var.create_route_tables ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.create_internet_gateway ? aws_internet_gateway.gw.id : null
  }

  tags = {
    Name                                = "${var.name}-public-route-table"
    "kubernetes_io_cluster_${var.name}" = "owned"
  }
}

resource "aws_route_table_association" "pvt" {
  count          = var.create_route_tables ? length(var.availability_zones) : 0
  subnet_id      = var.create_route_tables ? element(concat(aws_subnet.private.*.id), count.index) : null
  route_table_id = var.create_route_tables ? aws_route_table.private[count.index].id : null
}

resource "aws_route_table_association" "pub" {
  count          = var.create_route_tables ? length(var.availability_zones) : 0
  subnet_id      = var.create_route_tables ? element(concat(aws_subnet.public.*.id), count.index) : null
  route_table_id = var.create_route_tables ? aws_route_table.public[0].id : null
}

output "subnet_id_pub1a" {
  value = var.create_public_subnet ? aws_subnet.public[0].id : null
}

output "subnet_id_pub1b" {
  value = var.create_public_subnet && length(aws_subnet.public) > 1 ? aws_subnet.public[1].id : null
}

output "vpc_id" {
  value = aws_vpc.main.id
}
