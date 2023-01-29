output "tasks" {
  value = jsonencode([module.container_definition.json_map_encoded_list])
}
