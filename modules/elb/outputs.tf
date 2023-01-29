output "group_arns" {
  value = aws_lb_target_group.LoadBalancer.*.arn
}

output "group_names" {
  value = aws_lb_target_group.LoadBalancer.*.name
}

output "listener" {
  value = aws_lb_listener.LoadBalancer.arn
}
