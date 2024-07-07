data "aws_route53_zone" "this" {
  count = var.create && (var.zone_id != null || var.zone_name != null) ? 1 : 0

  zone_id      = var.zone_id
  name         = var.zone_name
  private_zone = var.private_zone
}

resource "aws_route53_record" "this" {
  count = var.create && (var.zone_id != null || var.zone_name != null) ? 1 : 0

  name    = var.name
  zone_id = data.aws_route53_zone.this[0].zone_id

  type    = var.type
  ttl     = var.ttl
  records = [var.record]
}