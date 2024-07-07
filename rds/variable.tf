variable "optional_tags" {
  default = {}
}
variable "common_tags" {}

# DB subnet group
variable "create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
  default     = false
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC"
  type        = string
  default     = null
}


variable "db_subnet_group_description" {
  description = "Description of the DB subnet group to create"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = []
}
variable "db_subnet_group_tags" {
  description = "Additional tags for the DB subnet group"
  type        = map(string)
  default     = {}
}

# DB parameter group
variable "create_db_parameter_group" {
  description = "Whether to create a database parameter group"
  type        = bool
  default     = false
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate or create"
  type        = string
  default     = null
}

variable "parameter_group_description" {
  description = "Description of the DB parameter group to create"
  type        = string
  default     = null
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = null
}

variable "parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
  default     = []
}
variable "db_parameter_group_tags" {
  description = "Additional tags for the  DB parameter group"
  type        = map(string)
  default     = {}
}

# DB option group
variable "create_db_option_group" {
  description = "Create a database option group"
  type        = bool
  default     = false
}

variable "option_group_name" {
  description = "Name of the option group"
  type        = string
  default     = null
}

variable "option_group_description" {
  description = "The description of the option group"
  type        = string
  default     = null
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = null
}

variable "options" {
  description = "A list of Options to apply"
  type        = any
  default     = []
}
variable "option_group_timeouts" {
  description = "Define maximum timeout for deletion of `aws_db_option_group` resource"
  type        = string
  default     = ""
}
variable "db_option_group_tags" {
  description = "Additional tags for the DB option group"
  type        = map(string)
  default     = {}
}

## DB Instance

variable "create_db_instance" {
  description = "Whether to create a database instance"
  type        = bool
  default     = false
}
variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
}
variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = null
}
variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = null
}
variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
}
variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (new generation of general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. If you specify 'io1' or 'gp3' , you must also include a value for the 'iops' parameter"
  type        = string
}

variable "storage_throughput" {
  description = "Storage throughput value for the DB instance. See `notes` for limitations regarding this variable for `gp3`"
  type        = number
  default     = null
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used. Be sure to use the full ARN, not a key alias."
  type        = string
  default     = null
}
variable "license_model" {
  description = "License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1"
  type        = string
  default     = null
}
variable "db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = null
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = null
}
variable "password" {
  description = "Password for the master DB user. The password provided will not be used if manage_master_user_password is set to true."
  type        = string
  default     = null
  sensitive   = true
}
variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager"
  type        = bool
  default     = true
}
variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = null
}
variable "iam_database_authentication_enabled" {
  description = "Specifies whether or not the mappings of AWS Identity and Access Management (IAM) accounts to database accounts are enabled"
  type        = bool
  default     = false
}
variable "custom_iam_instance_profile" {
  description = "RDS custom iam instance profile"
  type        = string
  default     = null
}
variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}
variable "network_type" {
  description = "The type of network stack to use"
  type        = string
  default     = null
}
variable "availability_zone" {
  description = "The Availability Zone of the RDS instance"
  type        = string
  default     = null
}
variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}
variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1' or `gp3`. See `notes` for limitations regarding this variable for `gp3`"
  type        = number
  default     = null
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}
variable "ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  type        = string
  default     = null
}
variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  type        = bool
  default     = false
}
variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}
variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}
variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = null
}
variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05"
  type        = string
  default     = null
}
variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot"
  type        = bool
  default     = false
}
variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = false
}
variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Valid values are `7`, `731` (2 years) or a multiple of `31`"
  type        = number
  default     = 7
}
variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate"
  type        = string
  default     = null
}

variable "replica_mode" {
  description = "Specifies whether the replica is in either mounted or open-read-only mode. This attribute is only supported by Oracle instances. Oracle replicas operate in open-read-only mode unless otherwise specified"
  type        = string
  default     = null
}
variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = null
}
variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = null
}
variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 0
}
variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60"
  type        = number
  default     = 0
}
variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring_interval is non-zero"
  type        = string
  default     = null
}
variable "monitoring_role_name" {
  description = "Name of the IAM role which will be created when create_monitoring_role is enabled"
  type        = string
  default     = "rds-monitoring-role"
}
variable "monitoring_role_description" {
  description = "Description of the monitoring IAM role"
  type        = string
  default     = null
}
variable "create_monitoring_role" {
  description = "Create IAM role with a defined name that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  type        = bool
  default     = false
}
variable "monitoring_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the monitoring IAM role"
  type        = string
  default     = null
}
variable "timeouts" {
  description = "Updated Terraform resource management timeouts. Applies to `aws_db_instance` in particular to permit resource management times"
  type        = map(string)
  default     = {}
}
variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true"
  type        = bool
  default     = false
}
variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
  type        = bool
  default     = true
}
variable "s3_import" {
  description = "Restore from a Percona Xtrabackup in S3 (only MySQL is supported)"
  type = object({
    source_engine_version = string
    bucket_name           = string
    ingestion_role        = string
    bucket_prefix         = string
  })
  default = null
}
variable "restore_to_point_in_time" {
  description = "Restore to a point in time (MySQL is NOT supported)"
  type = object({
    restore_time                             = string
    source_db_instance_automated_backups_arn = string
    source_db_instance_identifier            = string
    source_dbi_resource_id                   = string
    use_latest_restorable_time               = bool
  })
  default = null
}
variable "db_instance_tags" {
  description = "Additional tags for the DB instance"
  type        = map(string)
  default     = {}
}
variable "final_snapshot_identifier_prefix" {
  description = "The name which is prefixed to the final snapshot on cluster destroy"
  type        = string
  default     = "final"
}

##Cloudwatch log group
variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)"
  type        = list(string)
  default     = []
}
variable "create_cloudwatch_log_group" {
  description = "Determines whether a CloudWatch log group is created for each `enabled_cloudwatch_logs_exports`"
  type        = bool
  default     = false
}
variable "cloudwatch_log_group_retention_in_days" {
  description = "The number of days to retain CloudWatch logs for the DB instance"
  type        = number
  default     = 7
}
##KMS
variable "create_kms" {
  description = "Determines whether a KMS key is created"
  type        = bool
  default     = false
}
variable "db_kms_tags" {
  description = "Additional tags for the kms"
  type        = map(string)
  default     = {}
}
variable "kms_enable_key_rotation" {
  description = "Specifies whether key rotation is enabled. Defaults to `true`"
  type        = bool
  default     = true
}
variable "kms_deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between `7` and `30`, inclusive. If you do not specify a value, it defaults to `30`"
  type        = number
  default     = 30
}

variable "kms_description" {
  description = "The description of the key as viewed in AWS console"
  type        = string
  default     = null
}

variable "kms_multi_region" {
  description = "Indicates whether the KMS key is a multi-Region (`true`) or regional (`false`) key. Defaults to `false`"
  type        = bool
  default     = false
}
variable "kms_alias" {
  description = "The display name of the alias"
  type        = string
  default     = null
}

## Route 53
variable "create_r53_record" {
  description = "Determines whether create a DNS record "
  type        = bool
  default     = false
}
variable "r53_hostname" {
  description = "The name of the DNS record"
  type        = string
  default     = ""
}
variable "r53_type" {
  description = "The record type"
  type        = string
  default     = null
}
variable "r53_ttl" {
  description = "The TTL of the record"
  type        = number
  default     = 60
}
variable "r53_record" {
  description = "The DNS record"
  type        = string
  default     = ""
}
variable "r53_zone_id" {
  description = "ID of DNS zone"
  type        = string
  default     = null
}
variable "r53_zone_name" {
  description = "Name of DNS zone"
  type        = string
  default     = null
}
variable "r53_private_zone" {
  description = "Whether Route53 zone is private or public"
  type        = bool
  default     = false
}

## SGs
variable "create_security_groups" {
  description = "Determines whether create SGs "
  type        = bool
  default     = true
}
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the Security Group will be created."
  default = ""
}
variable "security_groups" {
  type = list(object({
    security_group_name           = string
    security_group_description    = string
    allow_all_egress              = bool
    security_group_create_timeout = string
    security_group_delete_timeout = string
    all_security_group_rules = list(any)
    tags = map(string)
  }))
  default = []
}