/* CodeStar Connection from GitHub.
 */
resource "aws_codestarconnections_connection" "KorraStar" {
  name          = var.project_name
  provider_type = var.connection_type
  lifecycle {
    create_before_destroy = true
  }
}
