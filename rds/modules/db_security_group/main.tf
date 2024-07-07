resource "aws_security_group" "this" {
  count = var.create ? 1 : 0

  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, try(length(var.security_group_name) > 0) ? { Name = var.security_group_name } : {})


  timeouts {
    create = var.security_group_create_timeout
    delete = var.security_group_delete_timeout
  }
  dynamic "egress" {
    for_each = var.allow_all_egress ? [1] : []
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

}

resource "aws_security_group_rule" "this" {
  for_each = {for rule in var.all_security_group_rules : rule.description => rule}

  lifecycle {
    create_before_destroy = true
  }

  security_group_id = aws_security_group.this[0].id

  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  description = each.value.description

  cidr_blocks      = try(length(each.value.cidr_blocks), 0) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks = try(length(each.value.ipv6_cidr_blocks), 0) > 0 ? each.value.ipv6_cidr_blocks : null
  prefix_list_ids  = try(length(each.value.prefix_list_ids), 0) > 0 ? each.value.prefix_list_ids : null
  source_security_group_id = try(each.value.source_security_group_id, null)
  self = try(each.value.self, null) == true ? true : null


}

