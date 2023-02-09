/* IAM role for CodeBuild to:
 * - access source from CodePipeline,
 * - push image to ECR,
 * - return to CodePipeline.
 *
 * https://aws.amazon.com/blogs/devops/complete-ci-cd-with-aws-codecommit-aws-codebuild-aws-codedeploy-and-aws-codepipeline/
 * https://github.com/aws-samples/cicd-with-aws-code-suite/tree/master/policies
 */

resource "aws_iam_role" "KorraBuild" {
  name               = "${var.project_name}Build"
  assume_role_policy = data.aws_iam_policy_document.KorraBuild.json
  description        = "Allows CodeBuild to call AWS services on your behalf."
  /*managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  ]/**/
}

data "template_file" "KorraBuild" {
  template = file("${path.module}/iam.json")
  vars = {
    ACCOUNT_ID         = data.aws_caller_identity.default.account_id
    CODEBUILD_NAME     = var.project_name
    CODESTAR_ARN       = var.codestar_connection
    AWS_DEFAULT_REGION = var.region
    S3_BUCKET          = var.bucket
    ECR_ARN            = var.ecr_arn
    ECS_ARN            = var.ecs_arn
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

resource "aws_iam_role_policy" "KorraBuild" {
  name   = "${var.project_name}Build"
  role   = aws_iam_role.KorraBuild.name
  policy = data.template_file.KorraBuild.rendered
}
