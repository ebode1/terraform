variable "create" {
  type    = bool
  default = false
}
variable "key_pair_name" {
  description = "The name of the given key pair or the one to create "
  type        = string
}