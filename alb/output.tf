output "default_target_group_arn" {
  value = try(aws_lb_target_group.this[0].arn,null)
}