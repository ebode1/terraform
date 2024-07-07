variable "create" {
  type = bool
}
variable "launch_template_id" {
  description = "A Launch template ID"
  type = string
}
variable "launch_template_version" {
  type        = string
  description = "Launch template version. Can be version number, `$Latest` or `$Default`"
  default     = "$Latest"
}
variable "subnet_id" {
  type = string
  description = "Subnet ID to launch instance from"
}

variable "target_group_arns" {
  type = list(string)
  description = "List of target group arns"
  default = []
}
variable "security_group_ids" {
  description = "A list of associated security group IDs"
  type        = list(string)
}

variable "tags" {
  type = map(string)
}