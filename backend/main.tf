resource "aws_s3_bucket" "backend" {
  bucket = var.aws_s3_bucket_name
  lifecycle {
    prevent_destroy = true
  }
}

# Policy 56 ACN : Activation du SSL
resource "aws_s3_bucket_policy" "enforce_ssl_policy" {
  bucket = aws_s3_bucket.backend.id
  policy = templatefile("${path.module}/templates/s3_backend_policy.tftpl", { bucket_name = "${aws_s3_bucket.backend.id}" })
}

# Policy 56 ACN : Activation du Chiffrement
resource "aws_s3_bucket_server_side_encryption_configuration" "backend_encryption" {
  bucket = aws_s3_bucket.backend.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "backend" {
  bucket                  = aws_s3_bucket.backend.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_ownership_controls" "backend_ownership" {
  bucket = aws_s3_bucket.backend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "backend_versioning" {
  bucket = aws_s3_bucket.backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "backend_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.backend_ownership]
  bucket     = aws_s3_bucket.backend.id
  acl        = "private"
}

resource "aws_dynamodb_table" "backend_lock" {
  name = var.aws_dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}