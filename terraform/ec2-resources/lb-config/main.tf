resource "aws_lb" "public_load_balancer" {
  name = var.lb_name
  load_balancer_type = "application"
  subnets = var.subnets
  security_groups = var.security_groups
}


resource "aws_lb_target_group" "target_group" {
  name = "TargetGroup"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"

  health_check {
    enabled = true
    interval = 30
    path = "/"
    port = 80
    protocol = "HTTP"
    unhealthy_threshold = 5
    healthy_threshold = 2
    timeout = 5
  }
  depends_on = [aws_lb.public_load_balancer]
}

resource "aws_lb_listener" "webapp_listener" {
  load_balancer_arn = aws_lb.public_load_balancer.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
