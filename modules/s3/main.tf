resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "codepipeline-korraform"
  force_destroy = true
}
