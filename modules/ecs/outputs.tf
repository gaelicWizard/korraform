output "tasks" {
  value = jsonencode([module.container_definition.json_map_encoded_list])
}

output "execution_role" {
  value = aws_iam_role.Korrapod.arn
}

output "task_role" {
  value = aws_iam_role.KorraTask.arn
}

output "arn" {
  value = aws_ecs_service.Korrapod.id
}

output "service_name" {
  value = aws_ecs_service.Korrapod.name
}

output "cluster_name" {
  value = aws_ecs_cluster.Korrapod.name
}
