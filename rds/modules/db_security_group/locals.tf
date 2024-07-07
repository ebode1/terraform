/*
locals {

  self_rules = [for rule in var.all_security_group_rules : {
    type        = rule.type
    from_port   = rule.from_port
    to_port     = rule.to_port
    protocol    = rule.protocol
    description = rule.description

    cidr_blocks      = []
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = true

    source_security_group_id = null
  } if rule.self == true]

  cidr_rules = [for rule in var.all_security_group_rules : {
    type        = rule.type
    from_port   = rule.from_port
    to_port     = rule.to_port
    protocol    = rule.protocol
    description = rule.description

    cidr_blocks      = rule.cidr_blocks
    ipv6_cidr_blocks = rule.ipv6_cidr_blocks
    prefix_list_ids  = rule.prefix_list_ids
    self             = null

    source_security_group_id = null
  } if length(rule.cidr_blocks) + length(rule.ipv6_cidr_blocks) + length(rule.prefix_list_ids) > 0]

  sg_source_rules = [for rule in var.all_security_group_rules : {
    type        = rule.type
    from_port   = rule.from_port
    to_port     = rule.to_port
    protocol    = rule.protocol
    description = rule.description

    cidr_blocks              = []
    ipv6_cidr_blocks         = []
    prefix_list_ids          = []
    self                     = null
    source_security_group_id = rule.source_security_group_id
  } if length(rule.source_security_group_id) > 0]

  allow_egress_rule = {
    type                     = "egress"
    from_port                = 0
    to_port                  = 0
    protocol                 = "-1"
    description              = "Allow all egress"
    cidr_blocks              = ["0.0.0.0/0"]
    ipv6_cidr_blocks         = ["::/0"]
    prefix_list_ids          = []
    self                     = null
    security_groups          = []
    source_security_group_id = null
  }

  extra_rules = var.allow_all_egress ? [local.allow_egress_rule] : []


  all_resource_rules = var.create ? concat(coalesce(local.self_rules, []), coalesce(local.sg_source_rules, []), coalesce(local.cidr_rules, []), coalesce(local.extra_rules, [])) : []

}*/
