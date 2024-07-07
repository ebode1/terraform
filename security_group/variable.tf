variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
variable "security_group_name" {
  type        = string
  description = "The name to assign to the security group. Must be unique within the VPC."
  default     = ""

}
variable "security_group_description" {
  type        = string
  description = "The description to assign to the created Security Group. Changing the description causes the security group to be replaced"
  default     = "Managed by Terraform"
}
variable "allow_all_egress" {
  type        = bool
  description = <<-EOT
    A convenience that adds to the rules specified elsewhere a rule that allows all egress.
    If this is false and no egress rules are specified via `all_security_group_rules`, then no egress will be allowed.
    EOT
  default     = true
}

variable "security_group_create_timeout" {
  type        = string
  description = "How long to wait for the security group to be created."
  default     = "10m"
}

variable "security_group_delete_timeout" {
  type        = string
  description = <<-EOT
    How long to retry on `DependencyViolation` errors during security group deletion from
    lingering ENIs left by certain AWS services.
    EOT
  default     = "15m"
}
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the Security Group will be created."
}

variable "all_security_group_rules" {
  type = list(object({
    type                    = string
    from_port               = number
    to_port                 = number
    protocol                = string
    description             = string
    cidr_blocks             = optional(list(string))
    ipv6_cidr_blocks        = optional(list(string))
    prefix_list_ids         = optional(list(string))
    source_security_group_id = optional(string)
    self                    = optional(bool)
  }))
  default     = []
}