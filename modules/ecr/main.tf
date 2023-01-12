resource "aws_ecr_repository" "project_ecr_repo" {
  name = var.ecr_name
#  scan_on_push = true
  force_delete = true
}
