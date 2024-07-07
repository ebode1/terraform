resource "aws_launch_template" "default" {
  count = var.create ? 1 : 0

  name_prefix = "${var.name_prefix}.lt"

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name  = lookup(block_device_mappings.value, "device_name", null)
      no_device    = lookup(block_device_mappings.value, "no_device", null)
      virtual_name = lookup(block_device_mappings.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = lookup(block_device_mappings.value, "ebs", null) == null ? [] : ["ebs"]
        content {
          delete_on_termination = lookup(block_device_mappings.value.ebs, "delete_on_termination", null)
          encrypted             = lookup(block_device_mappings.value.ebs, "encrypted", null)
          iops                  = lookup(block_device_mappings.value.ebs, "iops", null)
          throughput            = lookup(block_device_mappings.value.ebs, "throughput", null)
          kms_key_id            = lookup(block_device_mappings.value.ebs, "kms_key_id", null)
          snapshot_id           = lookup(block_device_mappings.value.ebs, "snapshot_id", null)
          volume_size           = lookup(block_device_mappings.value.ebs, "volume_size", null)
          volume_type           = lookup(block_device_mappings.value.ebs, "volume_type", null)
        }
      }
    }
  }


  disable_api_termination = var.disable_api_termination
  ebs_optimized           = var.ebs_optimized
  update_default_version  = var.update_default_version


  image_id = var.image_id

  instance_type = var.instance_type
  key_name      = var.key_name


  user_data = var.user_data_base64

  dynamic "iam_instance_profile" {
    for_each = var.iam_instance_profile_name != "" ? [var.iam_instance_profile_name] : []
    content {
      arn = iam_instance_profile.value
    }
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  vpc_security_group_ids = var.security_group_ids
  dynamic "network_interfaces" {
    for_each = var.associate_public_ip_address != false ? [1] : []
    content {
      device_index                = 0
      associate_public_ip_address = var.associate_public_ip_address
      delete_on_termination       = true
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}