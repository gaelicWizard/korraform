# Elastic Container Service
data "aws_ecr_repository" "ECS" {
  name = "${local.project}/${var.name}"
}

resource "aws_cloudwatch_log_group" "ECS" {
  name = var.project
}

module "container_definition" {
  source = "cloudposse/ecs-container-definition/aws"
  #  version = "0.13.0"

  container_name  = var.name
  container_image = "${data.aws_ecr_repository.this.repository_url}:latest"

  port_mappings = [
    {
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    },
  ]

  log_configuration = {
    awslogs-region        = var.region
    awslogs-group         = var.project
    awslogs-stream-prefix = local.name
  }
}

resource "aws_ecs_cluster" "ECS" {
  name = local.project
}

data "aws_iam_policy_document" "ECS" {
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

data "aws_iam_policy_document" "execution_role" {
  statement {
    sid    = "AllowECRPull"
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]

    resources = ["${data.aws_ecr_repository.ECS.arn}"]
  }

  statement {
    sid    = "AllowECRAuth"
    effect = "Allow"

    actions = ["ecr:GetAuthorizationToken"]

    resources = ["*"]
  }

  statement {
    sid    = "AllowLogging"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "task_role" {
  statement {
    sid    = "AllowDescribeCluster"
    effect = "Allow"

    actions = ["ecs:DescribeClusters"]

    resources = ["${aws_ecs_cluster.ECS.arn}"]
  }
}

resource "aws_iam_role" "execution_role" {
  name               = "ecs-example-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_by_ecs.json
}

resource "aws_iam_role_policy" "execution_role" {
  role   = aws_iam_role.execution_role.name
  policy = data.aws_iam_policy_document.execution_role.json
}

resource "aws_iam_role" "task_role" {
  name               = "ecs-example-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_by_ecs.json
}

resource "aws_iam_role_policy" "task_role" {
  role   = aws_iam_role.task_role.name
  policy = data.aws_iam_policy_document.task_role.json
}

resource "aws_ecs_task_definition" "this" {
  family                   = "green-blue-ecs-example"
  container_definitions    = module.container_definition.json_map_encoded_list
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  network_mode             = "awsvpc"
  cpu                      = "0.25 vcpu"
  memory                   = "0.5 gb"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_security_group" "ECS" {
  name   = "allow-ecs-traffic"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "ECS" {
  name            = local.project
  task_definition = aws_ecs_task_definition.this.id
  cluster         = aws_ecs_cluster.ECS.arn

  load_balancer {
    target_group_arn = var.target_group
    container_name   = var.name
    container_port   = 80
  }

  launch_type   = "FARGATE"
  desired_count = var.count

  network_configuration {
    subnets         = ["${var.subnets}"]
    security_groups = ["${aws_security_group.ECS.id}"]

    assign_public_ip = true
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
}
