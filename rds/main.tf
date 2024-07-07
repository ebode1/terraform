locals {
  db_subnet_group_name    = var.create_db_subnet_group ? module.db_subnet_group.db_subnet_group_id : var.db_subnet_group_name
  parameter_group_name_id = var.create_db_parameter_group ? module.db_parameter_group.db_parameter_group_id : var.parameter_group_name

  vpc_security_group_ids = var.create_security_groups ? [for security_group in var.security_groups : module.db_sg[security_group.security_group_name].security_group_id] : var.vpc_security_group_ids
  create_db_option_group = var.create_db_option_group && var.engine != "postgres"
  option_group           = local.create_db_option_group ? module.db_option_group.db_option_group_id : var.option_group_name
  kms_key_id             = var.create_kms ? module.db_kms.db_kms_key_arn : var.kms_key_id
  tags                   = merge(var.common_tags, var.optional_tags)
}


module "db_sg" {
  source   = "./modules/db_security_group"
  create   = var.create_security_groups
  for_each = var.create_security_groups ? { for key, sg in var.security_groups :  sg.security_group_name => sg } : {}

  security_group_name = each.value.security_group_name

  vpc_id                        = var.vpc_id
  allow_all_egress              = each.value.allow_all_egress
  security_group_create_timeout = each.value.security_group_create_timeout
  security_group_delete_timeout = each.value.security_group_delete_timeout
  security_group_description    = each.value.security_group_description
  all_security_group_rules      = each.value.all_security_group_rules
  tags                          = each.value.tags

}

module "db_subnet_group" {
  source = "./modules/db_subnet_group"

  create = var.create_db_subnet_group

  name        = coalesce(var.db_subnet_group_name, var.identifier)
  description = var.db_subnet_group_description
  subnet_ids  = var.subnet_ids

  tags = var.db_subnet_group_tags
}

module "db_parameter_group" {
  source = "./modules/db_parameter_group"

  create = var.create_db_parameter_group

  name        = coalesce(var.parameter_group_name, var.identifier)
  description = var.parameter_group_description
  family      = var.family

  parameters = var.parameters

  tags = var.db_parameter_group_tags
}

module "db_option_group" {
  source = "./modules/db_option_group"

  create = local.create_db_option_group

  name                     = coalesce(var.option_group_name, var.identifier)
  option_group_description = var.option_group_description
  engine_name              = var.engine
  major_engine_version     = var.major_engine_version

  options = var.options

  delete_timeouts = var.option_group_timeouts

  tags = var.db_option_group_tags
}

module "db_kms" {

  source = "./modules/db_kms"

  create                  = var.create_kms
  name                    = var.kms_alias
  deletion_window_in_days = var.kms_deletion_window_in_days
  description             = var.kms_description
  enable_key_rotation     = var.kms_enable_key_rotation
  tags                    = var.db_kms_tags
  multi_region            = var.kms_multi_region
}
module "db_instance" {
  source = "./modules/db_instance"

  create     = var.create_db_instance
  identifier = var.identifier

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = local.kms_key_id
  license_model     = var.license_model

  db_name                             = var.db_name
  username                            = var.username
  password                            = var.manage_master_user_password ? null : var.password
  port                                = var.port
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  custom_iam_instance_profile         = var.custom_iam_instance_profile
  manage_master_user_password         = var.manage_master_user_password

  vpc_security_group_ids = local.vpc_security_group_ids
  db_subnet_group_name   = local.db_subnet_group_name
  parameter_group_name   = local.parameter_group_name_id
  option_group_name      = var.engine != "postgres" ? local.option_group : null
  network_type           = var.network_type

  availability_zone   = var.availability_zone
  multi_az            = var.multi_az
  iops                = var.iops
  storage_throughput  = var.storage_throughput
  publicly_accessible = var.publicly_accessible
  ca_cert_identifier  = var.ca_cert_identifier

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window

  snapshot_identifier   = var.snapshot_identifier
  copy_tags_to_snapshot = var.copy_tags_to_snapshot
  skip_final_snapshot   = var.skip_final_snapshot

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  performance_insights_kms_key_id       = var.performance_insights_enabled ? local.kms_key_id : null

  replicate_source_db                  = var.replicate_source_db
  replica_mode                         = var.replica_mode
  backup_retention_period              = var.backup_retention_period
  backup_window                        = var.backup_window
  max_allocated_storage                = var.max_allocated_storage
  monitoring_interval                  = var.monitoring_interval
  monitoring_role_arn                  = var.monitoring_role_arn
  monitoring_role_name                 = var.monitoring_role_name
  monitoring_role_description          = var.monitoring_role_description
  create_monitoring_role               = var.create_monitoring_role
  monitoring_role_permissions_boundary = var.monitoring_role_permissions_boundary

  enabled_cloudwatch_logs_exports        = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group            = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days

  timeouts = var.timeouts

  deletion_protection      = var.deletion_protection
  delete_automated_backups = var.delete_automated_backups

  restore_to_point_in_time = var.restore_to_point_in_time
  s3_import                = var.s3_import

  final_snapshot_identifier_prefix = var.final_snapshot_identifier_prefix

  tags = merge(local.tags, var.db_instance_tags)
}
module "db_r53" {
  source       = "./modules/db_r53"
  create       = var.create_r53_record
  name         = var.r53_hostname
  record       = module.db_instance.db_instance_address
  type         = var.r53_type
  private_zone = var.r53_private_zone
  zone_id      = var.r53_zone_id != null ? var.r53_zone_id : null
  zone_name    = var.r53_zone_name != null ? var.r53_zone_name : null
}