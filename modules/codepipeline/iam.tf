resource "aws_iam_role" "KorraPipe" {
  name               = "${var.project_name}Pipeline"
  assume_role_policy = data.aws_iam_policy_document.KorraPipe.json
}

data "template_file" "KorraPipe" {
  template = file("${path.module}/iam.json")
  vars = {
    ACCOUNT_ID         = data.aws_caller_identity.default.account_id
    CODEBUILD_NAME     = var.project_name
    AWS_DEFAULT_REGION = var.region
  }
}

data "aws_iam_policy_document" "KorraPipe" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com", "codebuild.amazonaws.com", "cloudformation.amazonaws.com", "lambda.amazonaws.com"]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.default.account_id}:root"]
    }
  }
}


resource "aws_iam_role_policy" "KorraPipe" {
  name = "${var.project_name}Pipeline"
  role = aws_iam_role.KorraPipe.id

  policy = data.template_file.KorraPipe.rendered
}


data "aws_caller_identity" "default" {}
