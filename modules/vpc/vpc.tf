# VPC with subnets and gateway

resource "aws_vpc" "Korra" {
  cidr_block = "${element(values(var.subnets), 0)}"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_internet_gateway" "Appa" {
  vpc_id = "${aws_vpc.Korra.id}"

  tags = {
    Name = "${var.name}-internet-gateway"
  }
}

resource "aws_subnet" "nation" {
  count      = "${length(var.subnets)}"
  cidr_block = "${element(values(var.subnets), count.index)}"
  vpc_id     = "${aws_vpc.Korra.id}"

  map_public_ip_on_launch = true
  availability_zone       = "${element(keys(var.subnets), count.index)}"

  tags = {
    Name = "${element(keys(var.subnets), count.index)}"
  }
}

resource "aws_route_table" "nation" {
  vpc_id = "${aws_vpc.Korra.id}"

  tags = {
    Name = "${var.name}-route-table"
  }
}

resource "aws_route" "seasons" {
  route_table_id         = "${aws_route_table.nation.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.Appa.id}"
}

resource "aws_route_table_association" "element" {
  count          = "${length(var.subnets)}"
  route_table_id = "${aws_route_table.nation.id}"
  subnet_id      = "${element(aws_subnet.nation.*.id, count.index)}"
}
