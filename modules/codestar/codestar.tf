resource "aws_codestarconnections_connection" "KorraHub" {
  name          = var.project_name
  provider_type = "GitHub"
}
