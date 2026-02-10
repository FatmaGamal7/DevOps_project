output "nlb_arn" {
  value = aws_lb.nlb.arn
}

output "nlb_dns_name" {
  value = aws_lb.nlb.dns_name
}

output "listener_id" {
  value = aws_lb_listener.nlb_listener.id
}

output "listener_arn" {
  value = aws_lb_listener.nlb_listener.arn
}

output "nlb_tg_arn" {
  value = aws_lb_target_group.nlb_tg.arn
}
