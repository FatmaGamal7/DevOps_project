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

# NLB listener example (TCP 80)
variable "listener_port" {
  type    = number
  default = 80
}

resource "aws_lb_target_group" "nlb_tg" {
  name        = "nlb-tg-${var.env}"
  port        = var.listener_port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"   
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


