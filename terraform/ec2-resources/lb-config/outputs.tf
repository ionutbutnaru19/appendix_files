output "target_group_id" {
  value = aws_lb_target_group.target_group.arn
}

output "dns_name" {
  value = aws_lb.public_load_balancer.dns_name
}
