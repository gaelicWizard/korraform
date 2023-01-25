/* Create the role for CodeBuild to access the source code and store the build result.
 */

data "template_file" "KorraBuild" {
  template = file("${path.module}/iam.json")
  vars = {
    ACCOUNT_ID         = data.aws_caller_identity.default.account_id
    CODEBUILD_NAME     = var.project_name
    AWS_DEFAULT_REGION = var.region
    S3_BUCKET          = var.bucket
    ECR_ARN            = var.ecr_arn
  }
}

data "aws_iam_policy_document" "KorraBuild" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "KorraBuild" {
  name               = "${var.project_name}Build"
  assume_role_policy = data.aws_iam_policy_document.KorraBuild.json
  description        = "Allows CodeBuild to call AWS services on your behalf."
  /*managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  ]/**/
}

resource "aws_iam_role_policy" "KorraBuild" {
  name   = "${var.project_name}Build"
  role   = aws_iam_role.KorraBuild.name
  policy = data.template_file.KorraBuild.rendered
}
