output "groups" {
  value = aws_lb_target_group.LoadBalancer.*.arn
}

output "listener" {
  value = aws_lb_listener.LoadBalancer.arn
}
