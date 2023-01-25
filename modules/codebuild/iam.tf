/* Create the role for CodeBuild to access the source code and store the build result.
 */

data "local_file" "KorraBuild" {
  filename = "${path.module}/iam.json"
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
  assume_role_policy    = data.aws_iam_policy_document.KorraBuild.json
  description           = "Allows CodeBuild to call AWS services on your behalf."
  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  ]
  max_session_duration = 3600
  name                 = "KorraBuild"

}

resource "aws_iam_role_policy" "KorraBuild" {
  role   = aws_iam_role.KorraBuild.name
  policy = replace(replace(data.local_file.KorraBuild.content, "ACCOUNT_ID", "${data.aws_caller_identity.default.account_id}"), "CODEBUILD_NAME", var.image_name)
}
