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

  default = []
}
variable "disable_api_termination" {
  type        = bool
  description = "If `true`, enables EC2 Instance Termination Protection"
  default     = false
}
variable "ebs_optimized" {
  type        = bool
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = false
}
variable "update_default_version" {
  type        = bool
  description = "Whether to update Default version of Launch template each update"
  default     = true
}
variable "key_name" {
  type        = string
  description = "The SSH key name that should be used for the instance"
  default     = ""
}
variable "iam_instance_profile_name" {
  type        = string
  description = "The IAM instance profile name to associate with launched instances"
  default     = ""
}
variable "enable_monitoring" {
  type        = bool
  description = "Enable/disable detailed monitoring"
  default     = true
}
variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address with an instance in a VPC. If `network_interface_id` is specified, this can only be `false` (see here for more info: https://stackoverflow.com/a/76808361)."
  default     = false
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "launch_template_version" {
  type        = string
  description = "Launch template version. Can be version number, `$Latest` or `$Default`"
  default     = "$Latest"
}
variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to launch resources in"
}
variable "max_size" {
  type        = number
  description = "The maximum size of the autoscale group"
}

variable "min_size" {
  type        = number
  description = "The minimum size of the autoscale group"
}
variable "target_group_arns" {
  type        = list(string)
  description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing"
  default     = []
}
variable "force_delete" {
  type        = bool
  description = "Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
  default     = false
}
variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `Default`"
  type        = list(string)
  default     = ["Default"]
}
variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are `GroupMinSize`, `GroupMaxSize`, `GroupDesiredCapacity`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupTerminatingInstances`, `GroupTotalInstances`"
  type        = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}
variable "metrics_granularity" {
  type        = string
  description = "The granularity to associate with the metrics to collect. The only valid value is 1Minute"
  default     = "1Minute"
}
variable "wait_for_capacity_timeout" {
  type        = string
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior"
  default     = "10m"
}
variable "protect_from_scale_in" {
  type        = bool
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events"
  default     = false
}
variable "service_linked_role_arn" {
  type        = string
  description = "The ARN of the service-linked role that the ASG will use to call other AWS services"
  default     = ""
}
variable "desired_capacity" {
  type        = number
  description = "The number of Amazon EC2 instances that should be running in the group, if not set will use `min_size` as value"
  default     = null
}
variable "max_instance_lifetime" {
  type        = number
  default     = null
  description = "The maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 604800 and 31536000 seconds"
}
variable "capacity_rebalance" {
  type        = bool
  default     = false
  description = "Indicates whether capacity rebalance is enabled. Otherwise, capacity rebalance is disabled."
}
variable "mixed_instances_policy" {

  type = object({
    instances_distribution = object({
      on_demand_allocation_strategy            = string
      on_demand_base_capacity                  = number
      on_demand_percentage_above_base_capacity = number
      spot_allocation_strategy                 = string
      spot_instance_pools                      = number
      spot_max_price                           = string
    })
    override = list(object({
      instance_type     = string
      weighted_capacity = number
    }))
  })
  default = null
}
variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type = string
}
variable "security_group_ids" {
  description = "A list of associated security group IDs"
  type        = list(string)
  default     = []
}
variable "create_key_pair" {
  type    = bool
  default = false
}
variable "create_asg" {
  type    = bool
  default = false
}
variable "create_launch_template" {
  type    = bool
  default = false
}
variable "create_ec2_instance" {
  type    = bool
  default = false
}
variable "os_type" {
  description = "EC2 OS type windows or linux"
}
variable "user_data_path_list" {
  description = "list ofuser data file path"
  default     = []
}
variable "user_data_vars" {
  description = "user data variables"
  default     = {}
}
variable "account_id" {
  type    = string
  default = ""
}
variable "create_iam_role" {
  type    = bool
  default = false
}
variable "managed_policy_arns" {
  description = "list of iam managed policy arn"
  default     = []
}
variable "policy_description" {
  description = "description for policy"
  default     = null
}
variable "policy_name_ec2" {
  description = "name of policy"
  default     = "test-policy"
}
variable "role_name_ec2" {
  description = "name of EC2 IAM Role"
  default     = "ec2-role"
}
variable "assume_role_path" {
  description = "the path of iam role for ec2 instance"
  default     = ""
}
variable "policy_path" {
  description = "the path of policy attached to assume role"
  default     = ""
}
variable "role_name_boundary" {
  description = "role / policy boundary associated to instance profile"
  default     = ""
}