output "security_groups_ids" {
  description = "Security Group Ids"
  value       = module.db_instance.db_instance_security_group_ids
}
output "kms_key_id" {
  description = "The Id of the kms key"
  value       = module.db_instance.db_instance_kms_id
}
output "kms_key_arn" {
  description = "The ARN of the kms key"
  value       = module.db_kms.db_kms_key_arn
}
output "kms_key_alias_arn" {
  description = "The ARN of the kms alias"
  value       = module.db_kms.db_kms_key_alias_arn
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db_instance.db_instance_address
}
output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db_instance.db_instance_arn
}
output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.db_instance.db_instance_resource_id
}
