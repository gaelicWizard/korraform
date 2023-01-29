# VPC with subnets and gateway

resource "aws_vpc" "Korra" {
  cidr_block = "${var.network_prefix}${var.network_suffix}"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_internet_gateway" "Appa" {
  vpc_id = aws_vpc.Korra.id

  tags = {
    Name = "${var.name}-internet-gateway"
  }
}

resource "aws_subnet" "nations" {
  vpc_id     = aws_vpc.Korra.id
  count      = length(data.aws_availability_zones.Zonai.names)
  cidr_block = "${var.network_prefix}.${16 * count.index}${var.subnet_dot_zero}/${var.subnet_mask}"

  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.Zonai.names[count.index]
  /*name                    = data.aws_availability_zones.Zonai.names[count.index]/**/
}

resource "aws_route_table" "nation" {
  vpc_id = aws_vpc.Korra.id

  tags = {
    Name = "${var.name}-route-table"
  }
}

resource "aws_route" "seasons" {
  route_table_id         = aws_route_table.nation.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Appa.id
}

resource "aws_route_table_association" "element" {
  count          = length(aws_subnet.nations)
  route_table_id = aws_route_table.nation.id
  subnet_id      = element(aws_subnet.nations.*.id, count.index)
}

data "aws_availability_zones" "Zonai" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
