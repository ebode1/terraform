resource "aws_security_group" "this" {

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
  count = length(var.all_security_group_rules)

  lifecycle {
    create_before_destroy = true
  }

  security_group_id = aws_security_group.this.id

  type        = var.all_security_group_rules[count.index].type
  from_port   = var.all_security_group_rules[count.index].from_port
  to_port     = var.all_security_group_rules[count.index].to_port
  protocol    = var.all_security_group_rules[count.index].protocol
  description = var.all_security_group_rules[count.index].description

  cidr_blocks              = try(length(var.all_security_group_rules[count.index].cidr_blocks), 0) > 0 ? var.all_security_group_rules[count.index].cidr_blocks : null
  ipv6_cidr_blocks         = try(length(var.all_security_group_rules[count.index].ipv6_cidr_blocks), 0) > 0 ? var.all_security_group_rules[count.index].ipv6_cidr_blocks : null
  prefix_list_ids          = try(length(var.all_security_group_rules[count.index].prefix_list_ids), 0) > 0 ? var.all_security_group_rules[count.index].prefix_list_ids : null
  source_security_group_id = try(var.all_security_group_rules[count.index].source_security_group_id, null)
  self                     = try(var.all_security_group_rules[count.index].self, null) == true ? true : null
}


