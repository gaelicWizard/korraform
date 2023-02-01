output "group_arns" {
  value = aws_lb_target_group.KorraLoad.*.arn
}

output "group_names" {
  value = aws_lb_target_group.KorraLoad.*.name
}

output "listener" {
  value = aws_lb_listener.KorraLoad.arn
}

output "dns_name" {
  value = aws_lb.KorraLoad.dns_name
}

output "zone_id" {
  value = aws_lb.KorraLoad.zone_id
}
