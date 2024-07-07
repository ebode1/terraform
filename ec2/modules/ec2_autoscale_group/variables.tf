variable "create" {
  type = bool
}
variable "tags" {
  type = map(string)
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
}
variable "force_delete" {
  type        = bool
  description = "Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
}
variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `Default`"
  type        = list(string)
}
variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are `GroupMinSize`, `GroupMaxSize`, `GroupDesiredCapacity`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupTerminatingInstances`, `GroupTotalInstances`"
  type        = list(string)
}
variable "metrics_granularity" {
  type        = string
  description = "The granularity to associate with the metrics to collect. The only valid value is 1Minute"
}
variable "wait_for_capacity_timeout" {
  type        = string
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior"
}
variable "protect_from_scale_in" {
  type        = bool
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events"
}
variable "service_linked_role_arn" {
  type        = string
  description = "The ARN of the service-linked role that the ASG will use to call other AWS services"
}
variable "desired_capacity" {
  type        = number
  description = "The number of Amazon EC2 instances that should be running in the group, if not set will use `min_size` as value"
}

variable "capacity_rebalance" {
  type        = bool
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
}
variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
}

variable "launch_template_id" {
  description = "A Launch template ID"
  type = string
}