# VPC with subnets and gateway

resource "aws_vpc" "Korra" {
  cidr_block = local.subnets."${var.region}-air"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "Appa" {
  vpc_id = "${aws_vpc.Korra.id}"

  tags = {
    Name = "main-internet-gateway"
  }
}

resource "aws_subnet" "nations" {
  count      = "${length(local.subnets)}"
  cidr_block = "${element(values(local.subnets), count.index)}"
  vpc_id     = "${aws_vpc.Korra.id}"

  map_public_ip_on_launch = true
  availability_zone       = "${element(keys(local.subnets), count.index)}"

  tags = {
    Name = "${element(keys(local.subnets), count.index)}"
  }
}

resource "aws_route_table" "nations" {
  vpc_id = "${aws_vpc.Korra.id}"

  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route" "seasons" {
  route_table_id         = "${aws_route_table.nations.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.Appa.id}"
}

resource "aws_route_table_association" "elements" {
  count          = "${length(local.subnets)}"
  route_table_id = "${aws_route_table.nations.id}"
  subnet_id      = "${element(aws_subnet.nations.*.id, count.index)}"
}
