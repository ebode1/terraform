resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  count      = var.create ? 1 : 0
  key_name   = var.key_pair_name
  public_key = tls_private_key.this.public_key_openssh

  provisioner "local-exec" { # Copy the key locally
    command = "echo '${tls_private_key.this.private_key_pem}' > ./${var.key_pair_name}.pem"
  }
}

resource "aws_secretsmanager_secret" "this" {
  count                   = var.create ? 1 : 0
  name                    = "${var.key_pair_name}-secret"
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "this" {
  count         = var.create ? 1 : 0
  secret_id     = aws_secretsmanager_secret.this[0].id
  secret_string = tls_private_key.this.private_key_pem
}