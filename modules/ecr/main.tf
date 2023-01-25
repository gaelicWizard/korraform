resource "aws_ecr_repository" "KorraRepo" {
  name = var.project_name
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}
