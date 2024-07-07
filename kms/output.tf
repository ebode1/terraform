output "kms_key_id" {
  value = aws_kms_key.this[0].key_id
}
output "kms_key_arn" {
  value = aws_kms_key.this[0].arn
}