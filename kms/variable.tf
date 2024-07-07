variable "create_kms" {
  type    = bool
  default = false
}
variable "kms_enable_key_rotation" {
  description = "Specifies whether key rotation is enabled. Defaults to `true`"
  type        = bool
  default     = true
}
variable "kms_deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between `7` and `30`, inclusive. If you do not specify a value, it defaults to `30`"
  type        = number
  default     = null
}

variable "kms_description" {
  description = "The description of the key as viewed in AWS console"
  type        = string
  default     = null
}
variable "kms_multi_region" {
  description = "Indicates whether the KMS key is a multi-Region (`true`) or regional (`false`) key. Defaults to `false`"
  type        = bool
  default     = false
}
variable "kms_name" {
  description = "The display name of the alias"
  type        = string
  default     = null
}
variable "kms_tags" {
  type    = map(string)
  default = {}
}

variable "service_premission" {
  type    = string
  default = ""
}
variable "grant_operations" {
  default = []
}