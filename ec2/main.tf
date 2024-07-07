data "template_file" "user_data" {
  template = local.user_data_content
  vars     = var.user_data_vars
}
data "local_file" "user_data_scripts" {
  for_each = { for index, file in var.user_data_path_list : index => file }
  filename = each.value
}

locals {
  user_data_content = join("\n", [for script in data.local_file.user_data_scripts : script.content])
  user_data = {
    "linux"   = "${data.template_file.user_data.rendered}",
    "windows" = "<powershell>\n${data.template_file.user_data.rendered}\n</powershell>\n<persist>true</persist>"
  }
  key_pair_name             = var.create_key_pair ? module.ec2_keypair.keypair_name : var.key_name
  iam_instance_profile_name = var.create_iam_role ? module.ec2_iam_role.instance_profile_name : var.iam_instance_profile_name
}

module "ec2_keypair" {
  source        = "./modules/ec2_key_pair"
  create        = var.create_key_pair
  key_pair_name = var.key_name
}

module "ec2_iam_role" {
  source              = "./modules/ec2_iam_role"
  create              = var.create_iam_role
  account_id          = var.account_id
  assume_role_path    = var.assume_role_path
  policy_path         = var.policy_path
  role_name_boundary  = var.role_name_boundary
  role_name_ec2       = var.role_name_ec2
  policy_name_ec2     = var.policy_name_ec2
  managed_policy_arns = var.managed_policy_arns
  policy_description  = var.policy_description
}

module "ec2_launch_template" {
  source = "./modules/ec2_launch_template"
  create = var.create_launch_template
  name_prefix                 = var.name_prefix
  block_device_mappings       = var.block_device_mappings
  disable_api_termination     = var.disable_api_termination
  ebs_optimized               = var.ebs_optimized
  update_default_version      = var.update_default_version
  image_id                    = var.image_id
  instance_type               = var.instance_type
  key_name                    = local.key_pair_name
  user_data_base64            = base64encode(local.user_data[var.os_type])
  iam_instance_profile_name   = local.iam_instance_profile_name
  enable_monitoring           = var.enable_monitoring
  associate_public_ip_address = var.associate_public_ip_address
  security_group_ids          = var.security_group_ids
  tags                        = var.tags
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  create = var.create_ec2_instance
  launch_template_id = module.ec2_launch_template.launch_template_infos.id
  launch_template_version = var.launch_template_version
  subnet_id = try(var.subnet_ids[0], "")
  target_group_arns = var.target_group_arns
  security_group_ids = var.security_group_ids
  tags = var.tags
}

module "ec2_asg" {
  source                      = "./modules/ec2_autoscale_group"
  create                      = var.create_asg
  launch_template_id = module.ec2_launch_template.launch_template_infos.id
  launch_template_version = var.launch_template_version
  mixed_instances_policy      = var.mixed_instances_policy
  name_prefix                 = var.name_prefix
  max_size                    = var.max_size
  desired_capacity            = var.desired_capacity
  min_size                    = var.min_size
  subnet_ids                  = var.subnet_ids
  target_group_arns           = var.target_group_arns
  force_delete                = var.force_delete
  termination_policies        = var.termination_policies
  enabled_metrics             = var.enabled_metrics
  metrics_granularity         = var.metrics_granularity
  wait_for_capacity_timeout   = var.wait_for_capacity_timeout
  protect_from_scale_in       = var.protect_from_scale_in
  service_linked_role_arn     = var.service_linked_role_arn
  capacity_rebalance          = var.capacity_rebalance
  tags                        = var.tags
}