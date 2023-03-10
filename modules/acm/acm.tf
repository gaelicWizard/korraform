/* Certificate Management
 */
resource "aws_acm_certificate" "KorraCert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "KorraLoad" {
  zone_id = var.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = aws_lb.KorraLoad.dns_name
    zone_id                = aws_lb.KorraLoad.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "KorraCert" {
  for_each = {
    for dvo in aws_acm_certificate.KorraCert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.dns.zone_id
}

resource "aws_acm_certificate_validation" "KorraCert" {
  certificate_arn         = aws_acm_certificate.KorraCert.arn
  validation_record_fqdns = [for record in aws_route53_record.KorraCert : record.fqdn]
}
