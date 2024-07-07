output "db_kms_key_id" {
  description = "The Id of the kms key"
  value       = try(aws_kms_key.this[0].id, null)
}

output "db_kms_key_alias_arn" {
  description = "The ARN of the kms alias"
  value       = try(aws_kms_alias.this[0].arn, null)
}
output "db_kms_key_arn" {
  description = "The arn of the kms key"
  value       = try(aws_kms_key.this[0].arn, null)
}
