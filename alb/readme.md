# Dalkia Terraform AWS Application Load Balancer Pattern

## General Purpose
This Terraform project automates the provisioning of an AWS Application Load Balancer (ALB) along with associated resources, such as target groups, listeners, health checks, and Route 53 DNS records. It provides a flexible and customizable solution for load balancing applications in various scenarios.

## Project Structure
### Modules
1. ALB Target Group (alb_target_group):
    * Manages the target group settings for the ALB.
2. ALB Listener (alb_listener):
    * Configures HTTP and HTTPS listeners for the ALB.
3. ALB (alb):
    * Creates the main Application Load Balancer.
4. Route 53 DNS Record (alb_r53):
    * Configures Route 53 DNS records for the ALB.

## Variables
### VPC Configuration:
- **vpc_id:**
    * Description: The VPC ID to associate with the ALB.
    * Type: String

### Target Group Configuration:
- **target_group_port:**
    * Description: The port for the default target group.
    * Type: Number
- **target_group_protocol:**
    * Description: The protocol for the default target group (HTTP or HTTPS).
    * Type: String
- **target_group_protocol_version:**
    * Description: The protocol version for the default target group (HTTP1, HTTP2, or GRPC).
    * Type: String
- **target_group_name:**
    * Description: The name for the default target group; uses a module label name if left empty.
    * Type: String
- **target_group_target_type:**
    * Description: The type of targets that can be registered with the target group (`instance`, `ip`, or `lambda`).
    * Type: String
- **target_group_tags:**
    * Description: Additional tags to apply to the target group.
    * Type: Map(String)

- **stickiness:**
    * Description: Target group sticky configuration
    * Type: Object:
        * cookie_duration: Number - The time period, in seconds, during which requests from a client should be routed to the same target
        * enabled: bool - Boolean to enable / disable

### Health Check Configuration:
- **health_check_path:**
    * Description: The destination for the health check request.
    * Type: String
- **health_check_port:**
    * Description: The port to use for the health check.
    * Type: String
- **health_check_protocol:**
    * Description: The protocol to use for the health check; defaults to the traffic protocol if not specified.
    * Type: String
- **health_check_timeout:**
    * Description: The time in seconds to wait before failing a health check request.
    * Type: Number
- **health_check_healthy_threshold:**
    * Description: The number of consecutive health check successes required before considering a target healthy.
    * Type: Number
- **health_check_unhealthy_threshold:**
    * Description: The number of consecutive health check failures required before considering a target unhealthy.
    * Type: Number
- **health_check_interval:**
    * Description: The duration in seconds between health checks.
    * Type: Number
- **health_check_matcher:**
    * Description: The HTTP response codes to indicate a healthy check.
    * Type: String

### Load Balancer Configuration:
- **load_balancer_name:**
    * Description: The name for the default load balancer; uses a module label name if left empty.
    * Type: String
- **http_enabled:**
    * Description: Enables or disables the HTTP listener.
    * Type: Bool
- **http_redirect:**
    * Description: Enables or disables HTTP redirect to HTTPS.
    * Type: Bool
- **http_port:**
    * Description: The port for the HTTP listener.
    * Type: Number
- **https_enabled:**
    * Description: Enables or disables the HTTPS listener.
    * Type: Bool
- **https_port:**
    * Description: The port for the HTTPS listener.
    * Type: Number
- **certificate_arn:**
    * Description: The ARN of the default SSL certificate for the HTTPS listener.
    * Type: String

### Listener Configuration:
- **listener_http_fixed_response:**
    * Description: Configures fixed HTTP response for the default action.
    * Type: Object:
        * content_type: String - The content type of the fixed response.
        * message_body: String - The body of the fixed response.
        * status_code: String - The HTTP status code of the fixed response.
- **listener_https_fixed_response:**
    * Description: Configures fixed HTTPS response for the default action.
    * Type: Object:
      * content_type: String - The content type of the fixed response.
      * message_body: String - The body of the fixed response.
      * status_code: String - The HTTP status code of the fixed response.
- **additional_certs:**
    * Description: A list of additional certificates to add to the HTTPS listener.
    * Type: List(String)
- **subnet_ids:**
    * Description: A list of subnet IDs to associate with the ALB.
    * Type: List(String)
- **security_group_ids:**
    * Description: A list of additional security group IDs to allow access to the ALB.
    * Type: List(String)
- **internal:**
    * Description: Determines whether the ALB should be internal.
    * Type: Bool
- **cross_zone_load_balancing_enabled:**
    * Description: Enables or disables cross-zone load balancing.
    * Type: Bool
- **http2_enabled:**
    * Description: Enables or disables HTTP/2.
    * Type: Bool
- **idle_timeout:**
    * Description: The time in seconds that the connection is allowed to be idle.
    * Type: Number
- **ip_address_type:**
    * Description: The type of IP addresses used by the subnets for the ALB. Possible values are `ipv4` and `dualstack`.
    * Type: String
- **deletion_protection_enabled:**
    * Description: Enables or disables deletion protection for the ALB.
    * Type: Bool

### Access Logs Configuration:
- **access_logs_prefix:**
    * Description: The S3 log bucket prefix.
    * Type: String
- **access_logs_enabled:**
    * Description: Enables or disables access logs.
    * Type: Bool
- **access_logs_s3_bucket_id:**
    * Description: An external S3 Bucket name to store access logs. If specified, no logging bucket will be created.
    * Type: String

### Route 53 Configuration:
- **create_r53:**
    * Description: Whether to create DNS records.
    * Type: Bool
- **zone_id:**
    * Description: ID of the DNS zone.
    * Type: String
- **zone_name:**
    * Description: Name of the DNS zone.
    * Type: String
- **private_zone:**
    * Description: Whether the Route 53 zone is private or public.
    * Type: Bool
- **r53_name:**
    * Description: The name of the DNS record.
    * Type: String
  
## Outputs

- **Default target-group ARN:**
  - Description: The ARN of the default target group if created

## Example Usage
```hcl
module "alb" {
  source = "git::https://gitlab.lol.net/lol/alb"

  vpc_id               = "vpc-xxxx"
  target_group_port    = 8080
  https_enabled        = true
  certificate_arn      = "arn:xxxyyy"
  load_balancer_name   = "my-alb"
  subnet_ids           = ["subnet-xxxxxx", "subnet-yyyyyy"]
  security_group_ids   = ["sg-000000000"]
  internal             = false
  idle_timeout         = 60
  deletion_protection_enabled = false

  # Access Logs Configuration
  access_logs_enabled        = true
  access_logs_prefix         = "alb-logs/"
  access_logs_s3_bucket_id   = "my-access-logs-bucket"

  # Health Check Configuration
  health_check_path          = "/health"
  health_check_port          = "traffic-port"
  health_check_protocol      = "HTTP"
  health_check_timeout       = 5
  health_check_healthy_threshold   = 3
  health_check_unhealthy_threshold = 2
  health_check_interval      = 30
  health_check_matcher       = "200"

  # Listener HTTP Fixed Response Configuration
  listener_http_fixed_response = {
    content_type = "text/plain"
    message_body = "OK"
    status_code  = "200"
  }

  # Listener HTTPS Fixed Response Configuration
  listener_https_fixed_response = {
    content_type = "text/plain"
    message_body = "OK"
    status_code  = "200"
  }

  # Additional SSL Certificates
  additional_certs = [
    "arn:xxxx",
    "arn:yyyy"
  ]

  # Route 53 DNS Configuration
  create_r53       = true
  zone_id          = "ytfvgjvjyuhvgjbkg"
  zone_name        = "example.com"
  private_zone     = false
  r53_name         = "my-alb-dns-record"



  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```
