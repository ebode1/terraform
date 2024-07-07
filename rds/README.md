# Dalkia Terraform RDS Pattern
## General Purpose
This Terraform project automates the provisioning of an AWS RDS (Relational Database Service) instance along with associated resources, such as DB subnet group, DB parameter group, DB option group, and CloudWatch logs. Additionally, it configures Route 53 DNS records for the RDS instance.


## Project Structure
### Modules
1. DB Security Group (db_sg):
   * Manages the security group for the RDS instance.
2. DB Subnet Group (db_subnet_group):
   * Creates or associates the DB subnet group for the RDS instance.
3. DB Parameter Group (db_parameter_group):
    * Manages the DB parameter group for the RDS instance.
4. DB Option Group (db_option_group):
    * Creates or associates the DB option group for the RDS instance.
5. DB KMS Key (db_kms):
   * Manages the AWS Key Management Service (KMS) key for encryption.
6. DB Instance (db_instance):
    * Creates the main RDS database instance.
7. DB Route 53 Records (db_r53):
   * Configures Route 53 DNS records for the RDS instance.

## Variables
### DB Subnet Group Variables:

#### create_db_subnet_group:
* Description: Determines whether to create a DB subnet group.
* Type: Boolean
#### db_subnet_group_name:

* Description: Name of the DB subnet group. The DB instance will be created in the VPC associated with the DB subnet group. If unspecified, it will be created in the default VPC.
* Type: String
#### db_subnet_group_description:

* Description: Description of the DB subnet group to create.
* Type: String
#### subnet_ids:

* Description: A list of VPC subnet IDs.
* Type: List of Strings
#### db_subnet_group_tags:

* Description: Additional tags for the DB subnet group.
* Type: Map of Strings

### DB Parameter Group Variables:
#### create_db_parameter_group:

* Description: Determines whether to create a database parameter group.
* Type: Boolean
#### parameter_group_name:

* Description: Name of the DB parameter group to associate or create.
* Type: String
#### parameter_group_description:

* Description: Description of the DB parameter group to create.
* Type: String
#### family:

* Description: The family of the DB parameter group.
* Type: String
#### parameters:

* Description: A list of DB parameters (map) to apply.
* Type: List of Maps of Strings
#### db_parameter_group_tags:

* Description: Additional tags for the DB parameter group.
* Type: Map of Strings
### DB Option Group Variables:
#### create_db_option_group:

* Description: Determines whether to create a database option group.
* Type: Boolean
#### option_group_name:

* Description: Name of the option group.
* Type: String
#### option_group_description:

* Description: The description of the option group.
* Type: String
#### major_engine_version:

* Description: Specifies the major version of the engine that this option group should be associated with.
* Type: String
#### options:

* Description: A list of options to apply.
* Type: Any
#### option_group_timeouts:

* Description: Define maximum timeout for deletion of aws_db_option_group resource.
* Type: String
#### db_option_group_tags:

* Description: Additional tags for the DB option group.
* Type: Map of Strings

### DB Instance Variables
#### create_db_instance:

* Description: Determines whether to create a database instance.
* Type: Boolean
#### identifier:

* Description: The name of the RDS instance.
* Type: String
#### engine:

* Description: The database engine to use.
* Type: String
#### engine_version:

* Description: The engine version to use. 
* Type: String
#### instance_class:

* Description: The instance type of the RDS instance.
* Type: String
#### allocated_storage:

* Description: The allocated storage in gigabytes.
* Type: Number
#### storage_type:

* Description: One of 'standard' (magnetic), 'gp2' (general-purpose SSD), 'gp3' (new generation of general-purpose SSD), or 'io1' (provisioned IOPS SSD).
* Type: String
#### storage_throughput:

* Description: Storage throughput value for the DB instance. See notes for limitations regarding this variable for gp3.
* Type: Number
#### storage_encrypted:

* Description: Specifies whether the DB instance is encrypted.
* Type: Boolean
#### kms_key_id:

* Description: The ARN for the KMS encryption key.
* Type: String
#### license_model:

* Description: License model information for this DB instance. Optional, but required for some DB engines, i.e., Oracle SE1.
* Type: String
#### db_name:

* Description: The DB name to create. If omitted, no database is created initially.
* Type: String
#### username:
* Description: Username for the master DB user.
* Type: String
#### password:

* Description: Password for the master DB user. The password provided will not be used if manage_master_user_password is set to true.
* Type: String
#### manage_master_user_password:

* Description: Set to true to allow RDS to manage the master user password in Secrets Manager.
*Type: Boolean
#### port:

* Description: The port on which the DB accepts connections.
* Type: String
#### iam_database_authentication_enabled:

* Description: Specifies whether or not the mappings of AWS Identity and Access Management (IAM) accounts to database accounts are enabled.
* Type: Boolean
#### custom_iam_instance_profile:

* Description: RDS custom IAM instance profile.
* Type: String
#### vpc_security_group_ids:

* Description: List of VPC security groups to associate.
* Type: List of Strings
#### network_type:

* Description: The type of network stack to use.
* Type: String
#### availability_zone:

* Description: The Availability Zone of the RDS instance.
* Type: String
#### multi_az:

* Description: Specifies if the RDS instance is multi-AZ.
* Type: Boolean
#### iops:

* Description: The amount of provisioned IOPS. Setting this implies a storage_type of 'io1' or gp3.
* Type: Number
#### publicly_accessible:

* Description: Bool to control if the instance is publicly accessible.
* Type: Boolean
#### ca_cert_identifier:

* Description: Specifies the identifier of the CA certificate for the DB instance.
* Type: String

### CloudWatch Log Group Variables:
#### enabled_cloudwatch_logs_exports:

* Description: List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL).
* Type: List of Strings
#### create_cloudwatch_log_group:

* Description: Determines whether a CloudWatch log group is created for each enabled_cloudwatch_logs_exports.
* Type: Boolean
#### cloudwatch_log_group_retention_in_days:

* Description: The number of days to retain CloudWatch logs for the DB instance.
* Type: Number

### KMS Variables:
#### create_kms:

* Description: Determines whether a KMS key is created.
* Type: Boolean
#### db_kms_tags:

* Description: Additional tags for the KMS key.
* Type: Map of Strings
#### kms_enable_key_rotation:

* Description: Specifies whether key rotation is enabled. Defaults to true.
* Type: Boolean
#### kms_deletion_window_in_days:

* Description: The waiting period, specified in the number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30.
* Type: Number
#### kms_description:

* Description: The description of the key as viewed in the AWS console.
* Type: String
#### kms_multi_region:

* Description: Indicates whether the KMS key is a multi-Region (true) or regional (false) key. Defaults to false.
* Type: Boolean

#### kms_alias:

* Description: The display name of the alias.
* Type: String
### Route 53 Variables:
#### create_r53_record:

* Description: Determines whether to create a DNS record.
* Type: Boolean
#### r53_hostname:

* Description: The name of the DNS record.
* Type: String
#### r53_type:

* Description: The record type.
* Type: String
#### r53_ttl:

* Description: The TTL of the record.
* Type: Number
#### r53_record:

* Description: The DNS record.
* Type: String
#### r53_zone_id:

* Description: ID of DNS zone.
* Type: String
#### r53_zone_name:

* Description: Name of DNS zone.
* Type: String
#### r53_private_zone:

* Description: Whether the Route 53 zone is private or public.
* Type: Boolean

### Security Groups Variables:
#### create_security_groups:

* Description: Determines whether to create security groups.
* Type: Boolean
#### vpc_id:

* Description: The ID of the VPC where the Security Group will be created.
* Type: String
#### security_groups:

* Description: List of security groups to create.
* Type: List of Objects:
  * security_group_name: String - The name of the security group.
  * security_group_description: String - The description of the security group.
  * allow_all_egress: Boolean - Whether to allow all egress traffic.
  * security_group_create_timeout: String - Timeout for creating the security group.
  * security_group_delete_timeout: String - Timeout for deleting the security group.
  * tags: Map of Strings - Additional tags for the security group.

  * all_security_group_rules: List of Any - All security group rules:
    * type: String ("ingress" or "egress") - The type of rule, either "ingress" for inbound or "egress" for outbound. 
    * protocol: String - The protocol that the rule applies to (e.g., "tcp", "udp", "icmp"). 
    * from_port: Number - The starting port for the rule. Should be specified for rules with specific port ranges. 
    * to_port: Number - The ending port for the rule. Should be specified for rules with specific port ranges.
    * cidr_blocks: List of Strings - List of CIDR blocks that the rule applies to (IPv4). 
    * ipv6_cidr_blocks: List of Strings - List of CIDR blocks that the rule applies to (IPv6). 
    * security_groups: List of Strings - List of security group IDs that the rule applies to. 
    * self: Boolean - Whether the security group itself is among the targets. 
    * description: String -  A description for the rule.
    

## Outputs

- **KMS Key ARN:**
    - Description: The ARN of the KMS key.

- **KMS Key Alias ARN:**
    - Description: The ARN of the KMS alias.

- **RDS Instance Address:**
    - Description: The address of the RDS instance.

- **RDS Instance ARN:**
    - Description: The ARN of the RDS instance.

- **RDS Instance Resource ID:**
    - Description: The RDS Resource ID of this instance.


## Usage
```hcl
module "rds" {
source = "git::https://gitlab.dalkia.net/accenture/dalkia-terraform-pattern.git//rds"

# Optional Tags
optional_tags = {
  Project     = "MyProject"
  }

# Common Tags
common_tags = {
  Terraform   = "true"
  Environment = "Production"
  }

# Database Subnet Group
create_db_subnet_group      = true
db_subnet_group_name        = "my-db-subnet-group"
db_subnet_group_description = "My DB Subnet Group"
subnet_ids                  = ["subnet-12345678", "subnet-87654321"]
db_subnet_group_tags        = {
  SubnetGroup   = "Created"
  }

# Database Parameter Group
create_db_parameter_group      = true
parameter_group_name           = "my-db-parameter-group"
parameter_group_description    = "My DB Parameter Group"
family                         = "mysql8.0"
parameters                     = [
  {
    name  = "character_set_client"
    value = "utf8"
  }
]
db_parameter_group_tags        = {
Terraform   = "true"
Environment = "Production"
}

# Database Option Group
create_db_option_group         = true
option_group_name              = "my-db-option-group"
option_group_description       = "My DB Option Group"
major_engine_version           = "8.0"
options                        = [
    {
      option_name              = "MARIADB_AUDIT_PLUGIN"
      option_settings          = [  
      {
        name  = "SERVER_AUDIT_EVENTS"
        value = "CONNECT"
      },
      {
        name  = "SERVER_AUDIT_FILE_ROTATIONS"
        value = "37"
      },
      ]
    }
]
option_group_timeouts          = "30m"
db_option_group_tags           = {
  Terraform   = "true"
  Environment = "Production"
  }
  # ...

  # Database Key Management Service (KMS)
  create_kms                      = true
  kms_enable_key_rotation         = true
  kms_deletion_window_in_days     = 7
  kms_description                 = "My KMS Key for RDS Encryption"
  db_kms_tags                     = {
    Terraform   = "true"
    Environment = "Production"
  }
  kms_multi_region                = false
  kms_alias                       = "my-rds-key"

  # RDS Instance
  create_db_instance              = true
  identifier                      = "my-rds-instance"
  engine                          = "mysql"
  engine_version                  = "8.0"
  instance_class                  = "db.t3.medium"
  allocated_storage               = 50
  storage_type                    = "gp2"
  storage_encrypted               = true
  kms_key_id                      = "kms-1A234334" # if create_kms is false
  license_model                   = "general-public-license"
  db_name                         = "mydatabase"
  username                        = "admin"
  password                        = "supersecret"
  vpc_security_group_ids          = ["sg-0123456789abcdef0", "sg-0123456789abcdef1"]
  network_type                    = "default"
  availability_zone                = "us-east-1a"
  multi_az                         = true
  iops                            = 1000
  publicly_accessible             = false
  ca_cert_identifier              = "rds-ca-2019"
  allow_major_version_upgrade      = false
  auto_minor_version_upgrade       = true
  apply_immediately               = false
  maintenance_window              = "Mon:00:00-Mon:03:00"
  snapshot_identifier             = "my-snapshot"
  copy_tags_to_snapshot           = false
  skip_final_snapshot             = false
  performance_insights_enabled     = true
  performance_insights_retention_period = 14
  replicate_source_db             = null
  replica_mode                    = null
  backup_retention_period          = 30
  backup_window                    = "02:00-03:00"
  max_allocated_storage            = 100
  monitoring_interval              = 60
  monitoring_role_arn              = "arn:aws:iam::123456789012:role/rds-monitoring-role"
  monitoring_role_name             = "rds-monitoring-role"
  monitoring_role_description      = "Role for RDS enhanced monitoring"
  create_monitoring_role           = true
  timeouts                        = {
    create = "30m"
    update = "40m"
    delete = "20m"
  }
  deletion_protection             = false
  delete_automated_backups        = true

  db_instance_tags                = {
    Terraform   = "true"
    Environment = "Production"
  }
  final_snapshot_identifier_prefix = "final"

  # CloudWatch Logs Export
  enabled_cloudwatch_logs_exports  = ["error", "general"]
  create_cloudwatch_log_group      = true
  cloudwatch_log_group_retention_in_days = 14

  # Route 53 DNS Record
  create_r53_record                = true
  r53_hostname                    = "my-rds-instance"
  r53_type                        = "CNAME"
  r53_ttl                         = 300
  r53_record                      = module.rds.db_instance_address
  r53_zone_id                     = "Z0123456789ABCDEFGHIJ"
  r53_zone_name                   = "example.com"
  r53_private_zone                = false

  # Security Groups
  create_security_groups           = true
  vpc_id                           = "vpc-0123456789abcdef0"
  security_groups = [
    {
      security_group_name           = "rds-sg"
      security_group_description    = "Security Group RDS"
      allow_all_egress              = true
      security_group_create_timeout = "5m"
      security_group_delete_timeout = "5m"
      all_security_group_rules = [

      ]
      tags = {
        Terraform   = "true"
        Environment = "Production"
      }
    }
  ]
}

```


