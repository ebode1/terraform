locals {
  launch_template_block = {
    id      = var.launch_template_id
    version = var.launch_template_version
  }
  launch_template = (
    var.mixed_instances_policy == null ? local.launch_template_block
  : null)
  mixed_instances_policy = (
    var.mixed_instances_policy == null ? null : {
      instances_distribution = var.mixed_instances_policy.instances_distribution
      launch_template        = local.launch_template_block
      override               = var.mixed_instances_policy.override
  })

}

resource "aws_autoscaling_group" "default" {
  count = var.create ? 1 : 0

  name_prefix               = "${var.name_prefix}.asg"
  vpc_zone_identifier       = var.subnet_ids
  max_size                  = var.max_size
  min_size                  = var.min_size
  target_group_arns         = var.target_group_arns
  force_delete              = var.force_delete
  termination_policies      = var.termination_policies
  enabled_metrics           = var.enabled_metrics
  metrics_granularity       = var.metrics_granularity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  protect_from_scale_in     = var.protect_from_scale_in
  service_linked_role_arn   = var.service_linked_role_arn
  desired_capacity          = var.desired_capacity
  capacity_rebalance        = var.capacity_rebalance


  dynamic "launch_template" {
    for_each = (local.launch_template != null ?
    [local.launch_template] : [])
    content {
      id      = local.launch_template_block.id
      version = local.launch_template_block.version
    }
  }

  dynamic "mixed_instances_policy" {
    for_each = (local.mixed_instances_policy != null ?
    [local.mixed_instances_policy] : [])
    content {
      dynamic "instances_distribution" {
        for_each = (
          mixed_instances_policy.value.instances_distribution != null ?
        [mixed_instances_policy.value.instances_distribution] : [])
        content {
          on_demand_allocation_strategy = lookup(
          instances_distribution.value, "on_demand_allocation_strategy", null)
          on_demand_base_capacity = lookup(
          instances_distribution.value, "on_demand_base_capacity", null)
          on_demand_percentage_above_base_capacity = lookup(
          instances_distribution.value, "on_demand_percentage_above_base_capacity", null)
          spot_allocation_strategy = lookup(
          instances_distribution.value, "spot_allocation_strategy", null)
          spot_instance_pools = lookup(
          instances_distribution.value, "spot_instance_pools", null)
          spot_max_price = lookup(
          instances_distribution.value, "spot_max_price", null)
        }
      }
      launch_template {
        launch_template_specification {
          launch_template_id = mixed_instances_policy.value.launch_template.id
          version            = mixed_instances_policy.value.launch_template.version
        }
        dynamic "override" {
          for_each = (mixed_instances_policy.value.override != null ?
          mixed_instances_policy.value.override : [])
          content {
            instance_type     = lookup(override.value, "instance_type", null)
            weighted_capacity = lookup(override.value, "weighted_capacity", null)
          }
        }
      }
    }
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}