data "aws_route53_zone" "dns" {
  name         = var.zone_name
  private_zone = false
}
