output "role_arn" {
  value = aws_iam_role.Korraline.arn
}

output "bucket_name" {
  value = aws_s3_bucket.Korraline.arn
}