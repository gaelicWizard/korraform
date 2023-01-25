resource "aws_s3_bucket" "Korraline" {
  bucket        = lower("${var.project_name}Pipeline")
  force_destroy = true
}
