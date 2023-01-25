resource "aws_s3_bucket" "KorraPipe" {
  bucket        = "${var.project_name}Pipeline"
  force_destroy = true
}
