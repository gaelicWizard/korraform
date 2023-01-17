# Elastic Load Balancer
locals {
  project    = var.project_name
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  target_groups = [
    "green",
    "blue",
  ]
}

resource "aws_security_group" "LoadBalancer" {
  name   = "allow-${local.project}"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 443
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

  tags {
    Name = "allow-https-sg"
  }
}

resource "aws_lb" "LoadBalancer" {
  name               = local.project
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.LoadBalancer.id}"]
  subnets            = ["${local.subnet_ids}"]

  tags {
    Name = "example"
  }
}

resource "aws_lb_target_group" "LoadBalancer" {
  count = length(local.target_groups)

  name = "${local.project}-${element(local.target_groups, count.index)}"

  port        = 443
  protocol    = "HTTPS"
  vpc_id      = local.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
    port = 443
  }
}

resource "aws_lb_listener" "LoadBalancer" {
  load_balancer_arn = aws_lb.LoadBalancer.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.LoadBalancer.*.arn[0]
  }
}

resource "aws_lb_listener_rule" "LoadBalancer" {
  listener_arn = aws_lb_listener.LoadBalancer.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.LoadBalancer.*.arn[0]
  }

  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}