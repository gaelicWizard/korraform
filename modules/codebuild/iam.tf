/* Create the role for CodeBuild to access the source code and store the build result.
 */

data "local_file" "policy" {
  filename = "${path.module}/iam.json"
}

resource "aws_iam_role" "codebuildrole" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "codebuild.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  description           = "Allows CodeBuild to call AWS services on your behalf."
  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  ]
  max_session_duration = 3600
  name                 = "CodeBuildRole"

}

resource "aws_iam_role_policy" "example" {
  role   = aws_iam_role.codebuildrole.name
  policy = replace(replace(data.local_file.policy.content, "ACCOUNT_ID", "${data.aws_caller_identity.default.account_id}"), "CODEBUILD_NAME", var.codebuild_image_name)
}
