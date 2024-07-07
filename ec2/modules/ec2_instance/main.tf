resource "aws_instance" "default" {
  count = var.create ? 1 : 0

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  tags  = var.tags

  subnet_id      = var.subnet_id
}

resource "aws_lb_target_group_attachment" "default" {
  count            = length(var.target_group_arns)
  target_group_arn = var.target_group_arns[count.index]
  target_id        = aws_instance.default[0].id
}
