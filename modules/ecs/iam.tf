/*
 */
data "aws_iam_policy_document" "Korrapod" {
  statement {
    sid     = "AllowAssumeByEcsTasks"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "KorraTask" {
  statement {
    sid    = "AllowDescribeCluster"
    effect = "Allow"

    actions = ["ecs:DescribeClusters"]

    resources = ["${aws_ecs_cluster.Korrapod.arn}"]
  }

  statement {
    sid    = "AllowECRAuth"
    effect = "Allow"

    actions = ["ecr:GetAuthorizationToken"]

    resources = ["*"]
  }

  statement {
    sid    = "AllowECR"
    effect = "Allow"

    actions = [
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    resources = [var.ecr_arn]
  }
}

resource "aws_iam_role" "Korrapod" {
  name                = "${var.project_name}pod"
  assume_role_policy  = data.aws_iam_policy_document.Korrapod.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"] #["arn:aws:iam::aws:policy/AmazonECSTaskExecutionRolePolicy"]
}

resource "aws_iam_role" "KorraTask" {
  name               = "${var.project_name}Task"
  assume_role_policy = data.aws_iam_policy_document.Korrapod.json
}

resource "aws_iam_role_policy" "KorraTask" {
  role   = aws_iam_role.KorraTask.name
  policy = data.aws_iam_policy_document.KorraTask.json
}

