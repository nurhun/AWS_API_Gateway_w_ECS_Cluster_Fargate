# --- lb/alb.tf ---

resource "aws_lb" "frontend_alb" {
  name                       = "front"
  load_balancer_type         = "application"
  internal                   = "false"
  ip_address_type            = "ipv4"
  enable_deletion_protection = "false"
  enable_http2               = "true"
  idle_timeout               = "60"
  security_groups            = [var.sg_id]

  subnets = var.subnets_ids
}


resource "aws_lb_target_group" "lb_target_group" {
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = "10"
    unhealthy_threshold = "2"
  }

  ip_address_type               = "ipv4"
  load_balancing_algorithm_type = "round_robin"
  name                          = "group"
  port                          = "80"
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  slow_start                    = "0"

}


resource "aws_lb_listener" "lb_listeners" {
  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = "80"
  protocol          = "HTTP"
}
