/* IAM role for CodePipeline to:
 * - Retrieve source from CodeStar connection,
 * - Pass artifacts to/from CodeBuild & CodeDeploy,
 * - Trigger CodeBuild,
 * - Trigger CodeDeploy,
 *
 * https://aws.amazon.com/blogs/devops/complete-ci-cd-with-aws-codecommit-aws-codebuild-aws-codedeploy-and-aws-codepipeline/

 */
resource "aws_iam_role" "Korraline" {
  name               = "${var.project_name}Pipeline"
  assume_role_policy = data.aws_iam_policy_document.Korraline.json
  /*managed_policy_arns = [
      "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess",
      "arn:aws:iam::aws:policy/AWSCodeDeployDeployerAccess"
      ]/**/
}

data "template_file" "Korraline" {
  template = file("${path.module}/iam.json")
  vars = {
    ACCOUNT_ID         = data.aws_caller_identity.default.account_id
    CODEBUILD_ARN      = var.codebuild_arn
    CODEDEPLOY_ARN     = var.codedeploy_arn
    CODESTAR_ARN       = var.codestar_arn
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
