resource "aws_lb" "nlb" {
  name               = "${var.name}-${var.env}"
  internal           = var.scheme == "internal" ? true : false
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Environment = var.env
    Name        = "${var.name}-${var.env}"
  }
}



resource "aws_lb_target_group" "nlb_tg" {
  name        = "nlb-tg-${var.env}"
  port        = var.node_port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"   
    health_check {
    port     = "30080"
    protocol = "TCP"
    interval = 10
    timeout  = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}



