# --- lb/outputs.tf ---

output "lb_target_group_arn" {
  value = aws_lb_target_group.lb_target_group.arn
}

output "lb_url" {
  value = aws_lb.frontend_alb.dns_name
}