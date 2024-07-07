output "rendered_policy" {
  value = templatefile("${path.module}/templates/s3_backend_policy.tftpl", { bucket_name = "${aws_s3_bucket.backend.id}" })
}

output "aws_s3_bucket_name" {
  value = aws_s3_bucket.backend.id
}
