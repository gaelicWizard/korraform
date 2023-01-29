/*
 */
locals {
  project = var.project_name
  vpc_id  = var.vpc_id

  target_groups = [
    "green",
    "blue",
  ]
}

