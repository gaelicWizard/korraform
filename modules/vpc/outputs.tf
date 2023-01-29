output "vpc_id" {
  value = aws_vpc.Korra.id
}

output "subnets" {
  value = aws_subnet.nations.*.id
}
