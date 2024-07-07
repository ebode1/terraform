output "keypair_name" {
  value = try(aws_key_pair.this[0].key_name, null)
}
output "keypair_private_pem" {
  value = tls_private_key.this.private_key_pem
}