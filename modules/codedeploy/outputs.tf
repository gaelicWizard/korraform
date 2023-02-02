output "app" {
  value = aws_codedeploy_app.Korraploy.name
}

output "group" {
  value = aws_codedeploy_deployment_group.Korraploy.deployment_group_name
}

output "arns" {
  value = [
    aws_codedeploy_deployment_group.Korraploy.arn,
    aws_codedeploy_app.Korraploy.arn
  ]
}
