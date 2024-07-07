variable "create" {
  type = bool
}
variable "image_id" {
  type        = string
  description = "The EC2 image ID to launch"
}
variable "instance_type" {
  type        = string
  description = "Instance type to launch"
}
variable "block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"

  type = list(object({
    device_name  = optional(string)
    no_device    = optional(bool)
    virtual_name = optional(string)
    ebs = object({
      delete_on_termination = optional(bool)
      encrypted             = optional(bool)
      iops                  = optional(number)
      throughput            = optional(number)
      kms_key_id            = optional(string)
      snapshot_id           = optional(string)
      volume_size           = optional(number)
      volume_type           = optional(string)
    })
  }))

}
variable "disable_api_termination" {
  type        = bool
  description = "If `true`, enables EC2 Instance Termination Protection"
}
variable "ebs_optimized" {
  type        = bool
  description = "If true, the launched EC2 instance will be EBS-optimized"
}
variable "update_default_version" {
  type        = bool
  description = "Whether to update Default version of Launch template each update"
}
variable "key_name" {
  type        = string
  description = "The SSH key name that should be used for the instance"
}
variable "iam_instance_profile_name" {
  type        = string
  description = "The IAM instance profile name to associate with launched instances"
}
variable "enable_monitoring" {
  type        = bool
  description = "Enable/disable detailed monitoring"
}
variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address with an instance in a VPC. If `network_interface_id` is specified, this can only be `false` (see here for more info: https://stackoverflow.com/a/76808361)."
}
variable "tags" {
  type = map(string)
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
}
variable "user_data_base64" {
  type        = string
  description = "The Base64-encoded user data to provide when launching the instances"
}
variable "security_group_ids" {
  description = "A list of associated security group IDs"
  type        = list(string)
}