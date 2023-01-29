/* IAM role for CodeDeploy
 * 
 * https://docs.aws.amazon.com/AmazonECS/latest/developerguide/codedeploy_IAM_role.html
 */
resource "aws_iam_role" "Korraploy" {
  name               = "${var.projectname}ploy"
  assume_role_policy = data.aws_iam_policy_document.AssumeKorraploy.json
  /*managed_policy_arns = [
      "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
      ]/**/
}

data "aws_iam_policy_document" "AssumeKorraploy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "Korraploy" {
  statement {
    sid    = "AllowLoadBalancingAndECSModifications"
    effect = "Allow"

    actions = [
      "ecs:CreateTaskSet",
      "ecs:DeleteTaskSet",
      "ecs:DescribeServices",
      "ecs:UpdateServicePrimaryTaskSet",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyRule",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowS3"
    effect = "Allow"

    actions = ["s3:GetObject"]

    resources = ["${var.s3_bucket}/*"]
  }

  statement {
    sid    = "AllowPassRole"
    effect = "Allow"

    actions = ["iam:PassRole"]

    resources = [
      "${aws_iam_role.execution_role.arn}",
      "${aws_iam_role.task_role.arn}",
    ]
  }
}

resource "aws_iam_role_policy" "Korraploy" {
  role   = aws_iam_role.Korraploy.name
  policy = data.aws_iam_policy_document.Korraploy.json
}
