variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
variable "deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between `7` and `30`, inclusive. If you do not specify a value, it defaults to `30`"
  type        = number
  default     = null
}

variable "description" {
  description = "The description of the key as viewed in AWS console"
  type        = string
  default     = null
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled. Defaults to `true`"
  type        = bool
  default     = true
}
variable "multi_region" {
  description = "Indicates whether the KMS key is a multi-Region (`true`) or regional (`false`) key. Defaults to `false`"
  type        = bool
  default     = false
}
variable "name" {
  description = "The display name of the alias"
  type        = string
}