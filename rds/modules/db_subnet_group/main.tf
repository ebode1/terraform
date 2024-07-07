locals {
  description = coalesce(var.description, format("%s subnet group", var.name))
}

resource "aws_db_subnet_group" "this" {
  count = var.create ? 1 : 0

  name        = var.name
  description = local.description
  subnet_ids  = var.subnet_ids

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}