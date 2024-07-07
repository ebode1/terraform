resource "aws_kms_key" "this" {
  count = var.create_kms ? 1 : 0

  deletion_window_in_days = var.kms_deletion_window_in_days
  description             = var.kms_description
  enable_key_rotation     = var.kms_enable_key_rotation
  multi_region            = var.kms_multi_region

  tags = var.kms_tags
}
resource "aws_kms_alias" "this" {
  count = var.create_kms ? 1 : 0

  name          = "alias/${var.kms_name}"
  target_key_id = aws_kms_key.this[0].key_id
}

data "aws_iam_policy_document" "assume_role" {
  count = var.create_kms ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["${var.service_premission}.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  count              = var.create_kms ? 1 : 0
  name               = "IAM.KMS.Grant.${var.service_premission}"
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
}

resource "aws_kms_grant" "this" {
  count             = var.create_kms ? 1 : 0
  grantee_principal = aws_iam_role.this[0].arn
  key_id            = aws_kms_key.this[0].id
  operations        = var.grant_operations
}