resource "aws_kms_key" "this" {
  count = var.create ? 1 : 0

  deletion_window_in_days = var.deletion_window_in_days
  description             = var.description
  enable_key_rotation     = var.enable_key_rotation
  multi_region            = var.multi_region

  tags = var.tags
}
resource "aws_kms_alias" "this" {
  count = var.create ? 1 : 0

  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.this[0].key_id
}