/* Elastic Container Service
 * - Run containers provided from CodeDeploy using the standard task definition.
 */
resource "aws_cloudwatch_log_group" "Korrapod" {
  name = var.project_name
}

module "container_definition" {
  source = "cloudposse/ecs-container-definition/aws"
  #  version = "0.13.0"
  /*  for_each = var.containers

  container_name  = each.key
  container_image = "${var.repository_url}/${each.key}:latest"
/**/
  container_name  = "Example"
  container_image = "${var.repository_url}/Example:latest"

  port_mappings = [
    {
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }
  ]

  /*log_configuration = {
    awslogs-region        = var.region
    awslogs-group         = var.project_name
    awslogs-stream-prefix = each.key
  }/**/
}

resource "aws_ecs_cluster" "Korrapod" {
  name = var.project_name
}

resource "aws_ecs_task_definition" "Korrapod" {
  family                   = var.project_name
  container_definitions    = jsonencode([module.container_definition.json_map_object])
  execution_role_arn       = aws_iam_role.Korrapod.arn
  task_role_arn            = aws_iam_role.KorraTask.arn
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_security_group" "Korrapod" {
  name   = "${var.project_name}pod"
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

resource "aws_ecs_service" "Korrapod" {
  name            = var.project_name
  task_definition = aws_ecs_task_definition.Korrapod.id
  cluster         = aws_ecs_cluster.Korrapod.arn

  load_balancer {
    target_group_arn = var.target_groups[0]
    container_name   = "Example" #var.containers[0].key #module.container_definition[0].container_name
    container_port   = 80
  }

  launch_type   = "FARGATE"
  desired_count = var.instances

  network_configuration {
    subnets         = var.subnets
    security_groups = ["${aws_security_group.Korrapod.id}"]

    assign_public_ip = true
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    ignore_changes = [
      desired_count,  # ignore any changes to that count caused externally (e.g., Application Autoscaling).
      task_definition # ignore changes to task definition, which is managed by CodeDeploy
    ]
  }

  /* To prevent a race condition during service deletion, make sure to set depends_on to the related aws_iam_role_policy; otherwise, the policy may be destroyed too soon and the ECS service will then get stuck in the DRAINING state.*/
  depends_on = [
    aws_iam_role.Korrapod,
    var.listener
  ]
}
