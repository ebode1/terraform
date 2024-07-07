resource "aws_lb_target_group" "this" {
  count            = var.default_target_group_enabled ? 1 : 0
  name             = var.target_group_name
  port             = var.target_group_port
  protocol         = var.target_group_protocol
  protocol_version = var.target_group_protocol_version
  vpc_id           = var.vpc_id
  target_type      = var.target_group_target_type

  dynamic "stickiness" {
    for_each = var.stickiness == null ? [] : [var.stickiness]
    content {
      type            = "lb_cookie"
      cookie_duration = stickiness.value.cookie_duration
      enabled         = var.target_group_protocol == "TCP" ? false : stickiness.value.enabled
    }
  }

  health_check {
    protocol            = var.health_check_protocol != null ? var.health_check_protocol : var.target_group_protocol
    path                = var.health_check_path
    port                = var.health_check_port
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, var.target_group_tags)
}


resource "aws_lb_listener" "http_forward" {
  count             = var.http_enabled && var.http_redirect != true ? 1 : 0
  load_balancer_arn = one(aws_lb.this[*].arn)
  port              = var.http_port
  protocol          = "HTTP"
  tags              = merge(var.tags, var.listener_additional_tags)

  default_action {
    target_group_arn = var.listener_http_fixed_response != null ? null : one(aws_lb_target_group.this[*].arn)
    type             = var.listener_http_fixed_response != null ? "fixed-response" : "forward"

    dynamic "fixed_response" {
      for_each = var.listener_http_fixed_response != null ? [var.listener_http_fixed_response] : []
      content {
        content_type = fixed_response.value["content_type"]
        message_body = fixed_response.value["message_body"]
        status_code  = fixed_response.value["status_code"]
      }
    }
  }
}

resource "aws_lb_listener" "http_redirect" {
  count             = var.http_enabled && var.http_redirect == true ? 1 : 0
  load_balancer_arn = one(aws_lb.this[*].arn)
  port              = var.http_port
  protocol          = "HTTP"
  tags              = merge(var.tags, var.listener_additional_tags)

  default_action {
    target_group_arn = one(aws_lb_target_group.this[*].arn)
    type             = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  count             = var.https_enabled ? 1 : 0
  load_balancer_arn = one(aws_lb.this[*].arn)

  port            = var.https_port
  protocol        = "HTTPS"
  certificate_arn = var.certificate_arn
  tags            = merge(var.tags, var.listener_additional_tags)

  default_action {
    target_group_arn = var.listener_https_fixed_response != null ? null : one(aws_lb_target_group.this[*].arn)
    type             = var.listener_https_fixed_response != null ? "fixed-response" : "forward"

    dynamic "fixed_response" {
      for_each = var.listener_https_fixed_response != null ? [var.listener_https_fixed_response] : []
      content {
        content_type = fixed_response.value["content_type"]
        message_body = fixed_response.value["message_body"]
        status_code  = fixed_response.value["status_code"]
      }
    }
  }
}

resource "aws_lb_listener_certificate" "https_sni" {
  count           = var.https_enabled && length(var.additional_certs) > 0 ? length(var.additional_certs) : 0
  listener_arn    = one(aws_lb_listener.https[*].arn)
  certificate_arn = var.additional_certs[count.index]
}


resource "aws_lb" "this" {
  name               = var.load_balancer_name
  tags               = var.tags
  internal           = var.internal
  load_balancer_type = "application"

  security_groups = var.security_group_ids

  subnets                          = var.subnet_ids
  enable_cross_zone_load_balancing = var.cross_zone_load_balancing_enabled
  enable_http2                     = var.http2_enabled
  idle_timeout                     = var.idle_timeout
  ip_address_type                  = var.ip_address_type
  enable_deletion_protection       = var.deletion_protection_enabled

  access_logs {
    bucket  = try(var.access_logs_s3_bucket_id, "")
    prefix  = var.access_logs_prefix
    enabled = var.access_logs_enabled
  }
}

data "aws_route53_zone" "this" {
  count = var.create_r53 && (var.zone_id != null || var.zone_name != null) ? 1 : 0

  zone_id      = var.zone_id
  name         = var.zone_name
  private_zone = var.private_zone
}

resource "aws_route53_record" "this" {
  count = var.create_r53 && (var.zone_id != null || var.zone_name != null) ? 1 : 0

  name    = var.r53_name
  zone_id = data.aws_route53_zone.this[0].zone_id

  type    = "CNAME"
  ttl     = "60"
  records = [one(aws_lb.this[*].dns_name)]
}