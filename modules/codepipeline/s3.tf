resource "aws_s3_bucket" "Korraline" {
  bucket        = "${var.project_name}Pipeline"
  force_destroy = true
}
