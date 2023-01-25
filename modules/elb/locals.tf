/*
 */
locals {
  project    = var.project_name
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  target_groups = [
    "green",
    "blue",
  ]
}

