/* Elastic Container Registry
 */
resource "aws_ecr_repository" "KorraRepo" {
  name = lower(var.project_name)
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}
