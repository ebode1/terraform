output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = try(aws_db_instance.this[0].address, null)
}
output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = try(aws_db_instance.this[0].arn, null)
}
output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = try(aws_db_instance.this[0].resource_id, null)
}

output "db_instance_security_group_ids" {
  description = "Security Group Ids"
  value       = try(aws_db_instance.this[0].vpc_security_group_ids, null)
}

output "db_instance_kms_id" {
  description = "KMS key ID"
  value       = try(aws_db_instance.this[0].kms_key_id, null)
}
