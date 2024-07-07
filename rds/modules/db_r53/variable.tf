variable "create" {
  description = "Whether to create DNS records"
  type        = bool
  default     = true
}
variable "zone_id" {
  description = "ID of DNS zone"
  type        = string
  default     = null
}

variable "zone_name" {
  description = "Name of DNS zone"
  type        = string
  default     = null
}

variable "private_zone" {
  description = "Whether Route53 zone is private or public"
  type        = bool
  default     = false
}
variable "name" {
  description = "The name of the record"
  type        = string
}
variable "type" {
  description = "The record type"
  type        = string
}
variable "ttl" {
  description = "The TTL of the record"
  type        = number
  default     = 60
}
variable "record" {
  description = "The DNS record"
  type        = string
}
