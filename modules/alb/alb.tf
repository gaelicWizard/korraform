/* Elastic Load Balancer
 * - Allow access to containers from the internet, over HTTP(S)
 */
resource "aws_security_group" "KorraLoad" {
  # see https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-update-security-groups.html
  name   = "allow-${local.project}"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 0 # client-side port doesn't matter
    protocol    = "tcp"
    to_port     = local.listener_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-https-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "KorraLoad" {
  name               = local.project
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.KorraLoad.id}"]
  subnets            = var.subnets

  tags = {
    #Name = "example"
  }
}

resource "aws_lb_target_group" "KorraLoad" {
  count = length(local.target_groups)

  name = "${local.project}-${element(local.target_groups, count.index)}"

  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "ip"

  health_check {
    path     = "/"
    port     = "traffic-port"
    protocol = "HTTP"
  }
}

/*resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = var.target_id
  alb_target_group_arn   = aws_lb_target_group.external-elb.arn
  }/**/

resource "aws_lb_listener" "KorraLoad" {
  load_balancer_arn = aws_lb.KorraLoad.arn
  port              = local.listener_port
  protocol          = local.listener_protocol
  /*certificate_arn   = var.certificate/**/
  /*ssl_policy        = "ELBSecurityPolicy-2016-08"/**/

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.KorraLoad.*.arn[0]
  }
}

resource "aws_lb_listener_rule" "KorraLoad" {
  listener_arn = aws_lb_listener.KorraLoad.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.KorraLoad.*.arn[0]
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
