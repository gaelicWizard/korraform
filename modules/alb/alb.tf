/* Elastic Load Balancer
 * - Allow access to containers from the internet, over HTTPS
 */
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

  tags = {
    Name = "allow-https-sg"
  }
}

resource "aws_lb" "LoadBalancer" {
  name               = local.project
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.LoadBalancer.id}"]
  subnets            = var.subnets

  tags = {
    Name = "example"
  }
}

resource "aws_lb_target_group" "LoadBalancer" {
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

resource "aws_lb_listener" "LoadBalancer" {
  load_balancer_arn = aws_lb.LoadBalancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate
  /*ssl_policy        = "ELBSecurityPolicy-2016-08"/**/

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
    path_pattern {
      values = ["/*"]
    }
  }
}
