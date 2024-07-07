variable "vpc_id" {
  type        = string
  description = "VPC ID to associate with ALB"
}

variable "target_group_port" {
  type        = number
  default     = 80
  description = "The port for the default target group"
}

variable "target_group_protocol" {
  type        = string
  default     = "HTTP"
  description = "The protocol for the default target group HTTP or HTTPS"
}

variable "target_group_protocol_version" {
  type        = string
  default     = "HTTP1"
  description = "The protocol version for the default target group HTTP1 or HTTP2 or GRPC"
}

variable "target_group_name" {
  type        = string
  default     = ""
  description = "The name for the default target group, uses a module label name if left empty"
}

variable "target_group_target_type" {
  type        = string
  default     = "ip"
  description = "The type (`instance`, `ip` or `lambda`) of targets that can be registered with the target group"
}

variable "target_group_tags" {
  type        = map(string)
  default     = {}
  description = "The additional tags to apply to the target group"
}
variable "default_target_group_enabled" {
  type        = bool
  description = "Whether the default target group should be created or not."
  default     = true
}
variable "health_check_path" {
  type        = string
  default     = "/"
  description = "The destination for the health check request"
}

variable "health_check_port" {
  type        = string
  default     = "traffic-port"
  description = "The port to use for the healthcheck"
}

variable "health_check_protocol" {
  type        = string
  default     = null
  description = "The protocol to use for the healthcheck. If not specified, same as the traffic protocol"
}

variable "health_check_timeout" {
  type        = number
  default     = 10
  description = "The amount of time to wait in seconds before failing a health check request"
}

variable "health_check_healthy_threshold" {
  type        = number
  default     = 2
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "health_check_unhealthy_threshold" {
  type        = number
  default     = 2
  description = "The number of consecutive health check failures required before considering the target unhealthy"
}

variable "health_check_interval" {
  type        = number
  default     = 15
  description = "The duration in seconds in between health checks"
}

variable "health_check_matcher" {
  type        = string
  default     = "200-399"
  description = "The HTTP response codes to indicate a healthy check"
}


variable "load_balancer_name" {
  type        = string
  default     = ""
  description = "The name for the default load balancer, uses a module label name if left empty"
}

variable "http_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable HTTP listener"
}

variable "http_redirect" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable HTTP redirect to HTTPS"
}
variable "http_port" {
  type        = number
  default     = 80
  description = "The port for the HTTP listener"
}
variable "https_enabled" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable HTTPS listener"
}
variable "https_port" {
  type        = number
  default     = 443
  description = "The port for the HTTPS listener"
}
variable "certificate_arn" {
  type        = string
  default     = ""
  description = "The ARN of the default SSL certificate for HTTPS listener"
}
variable "listener_http_fixed_response" {
  description = "Have the HTTP listener return a fixed response for the default action."
  type = object({
    content_type = string
    message_body = string
    status_code  = string
  })
  default = null
}

variable "listener_https_fixed_response" {
  description = "Have the HTTPS listener return a fixed response for the default action."
  type = object({
    content_type = string
    message_body = string
    status_code  = string
  })
  default = null
}
variable "additional_certs" {
  type        = list(string)
  description = "A list of additonal certs to add to the https listerner"
  default     = []
}
variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to associate with ALB"
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "A list of additional security group IDs to allow access to ALB"
}

variable "internal" {
  type        = bool
  default     = false
  description = "A boolean flag to determine whether the ALB should be internal"
}
variable "cross_zone_load_balancing_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable cross zone load balancing"
}
variable "http2_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable HTTP/2"
}
variable "idle_timeout" {
  type        = number
  default     = 60
  description = "The time in seconds that the connection is allowed to be idle"
}

variable "ip_address_type" {
  type        = string
  default     = "ipv4"
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack`."
}

variable "deletion_protection_enabled" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable deletion protection for ALB"
}
variable "access_logs_prefix" {
  type        = string
  default     = ""
  description = "The S3 log bucket prefix"
}

variable "access_logs_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable access_logs"
}

variable "access_logs_s3_bucket_id" {
  type        = string
  default     = null
  description = "An external S3 Bucket name to store access logs in. If specified, no logging bucket will be created."
}
variable "listener_additional_tags" {
  type        = map(string)
  default     = {}
  description = "The additional tags to apply to all listeners"
}
variable "tags" {
  type    = map(string)
  default = {}
}

variable "stickiness" {
  type = object({
    cookie_duration = number
    enabled         = bool
  })
  description = "Target group sticky configuration"
  default     = null
}

variable "create_r53" {
  description = "Whether to create DNS records"
  type        = bool
  default     = true
}
variable "zone_id" {
  description = "ID of DNS zone"
  type        = string
  default     = null
}

variable "zone_name" {
  description = "Name of DNS zone"
  type        = string
  default     = null
}

variable "private_zone" {
  description = "Whether Route53 zone is private or public"
  type        = bool
  default     = false
}
variable "r53_name" {
  description = "The name of the record"
  type        = string
  default     = ""
}
