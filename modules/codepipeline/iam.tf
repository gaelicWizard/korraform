resource "aws_iam_role" "Korraline" {
  name               = "${var.project_name}Pipeline"
  assume_role_policy = data.aws_iam_policy_document.Korraline.json
}

data "template_file" "Korraline" {
  template = file("${path.module}/iam.json")
  vars = {
    ACCOUNT_ID         = data.aws_caller_identity.default.account_id
    CODEBUILD_ARN      = var.codebuild_arn
    AWS_DEFAULT_REGION = var.region
    S3_BUCKET          = aws_s3_bucket.Korraline.arn
  }
}

data "aws_iam_policy_document" "Korraline" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"] /*, "codebuild.amazonaws.com"]/**/
    }
  }

  /*statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.default.account_id}:root"]
    }
		}/**/
}


resource "aws_iam_role_policy" "Korraline" {
  name = "${var.project_name}Pipeline"
  role = aws_iam_role.Korraline.id

  policy = data.template_file.Korraline.rendered
}


data "aws_caller_identity" "default" {}
