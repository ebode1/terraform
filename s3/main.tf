resource "aws_s3_bucket" "this" {
  bucket        = var.bucket
  force_destroy = var.force_destroy
  tags          = var.tags
}
resource "aws_s3_bucket_versioning" "this" {
  count = length(keys(var.versioning)) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id
  mfa    = try(var.versioning["mfa"], null)

  versioning_configuration {
    status     = var.versioning["status"] ? "Enabled" : "Suspended"
    mfa_delete = try(tobool(var.versioning["mfa_delete"]) ? "Enabled" : "Disabled", title(lower(var.versioning["mfa_delete"])), null)
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.server_side_encryption ? 1 : 0

  bucket = aws_s3_bucket.this.id
  rule {
    bucket_key_enabled = var.bucket_kms_key
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = try(var.kms_master_key_id, null)
    }
  }
}
resource "aws_s3_bucket_policy" "this" {
  count  = var.attach_policy ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = templatefile(var.policy_path, var.policy_vars)
}
