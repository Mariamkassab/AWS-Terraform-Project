output "lb_target_group_arn_pub" {
  value = aws_lb_target_group.lb_tg[0].arn
}

output "lb_target_group_arn_pri" {
  value = aws_lb_target_group.lb_tg[1].arn
}

output "pri_lb_dns" {
  value = aws_lb.lb_creation[1].dns_name
}