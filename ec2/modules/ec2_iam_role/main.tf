data "local_file" "assume_role_path" {
  count    = var.create ? 1 : 0
  filename = var.assume_role_path
}

data "template_file" "policy" {
  count    = var.create ? 1 : 0
  template = file(var.policy_path)
  vars = {
    account_id = var.account_id
  }
}
locals {
  policy_boundary = var.role_name_boundary != "" ? "arn:aws:iam::${var.account_id}:policy/${var.role_name_boundary}" : ""
}
############ IAM ROLE EC2 / Policy #############
resource "aws_iam_role" "ec2_role" {
  count                = var.create ? 1 : 0
  name                 = var.role_name_ec2
  assume_role_policy   = try(data.local_file.assume_role_path[0].content, null)
  permissions_boundary = local.policy_boundary
  managed_policy_arns  = var.managed_policy_arns
}
resource "aws_iam_policy" "policy" {
  count       = var.create ? 1 : 0
  name        = var.policy_name_ec2
  description = var.policy_description
  policy      = can(data.template_file.policy[0].rendered) ? data.template_file.policy[0].rendered : null
}
resource "aws_iam_policy_attachment" "attach_policy_role" {
  count      = var.create ? 1 : 0
  name       = "${var.policy_name_ec2}-attachment"
  roles      = [aws_iam_role.ec2_role[0].name]
  policy_arn = aws_iam_policy.policy[0].arn
}
resource "aws_iam_instance_profile" "instance_profile" {
  count = var.create ? 1 : 0
  name  = var.role_name_ec2
  role  = aws_iam_role.ec2_role[0].name
}
