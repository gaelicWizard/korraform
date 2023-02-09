/*
 */
locals {
  project = var.project_name
  vpc_id  = var.vpc_id

  listener_port     = 80     #443
  listener_protocol = "HTTP" #"HTTPS"

  target_groups = [
    "green",
    "blue",
  ]
}
