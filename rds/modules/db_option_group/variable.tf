variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
}

variable "name" {
  description = "The name of the option group"
  type        = string
}


variable "option_group_description" {
  description = "The description of the option group"
  type        = string
  default     = null
}

variable "engine_name" {
  description = "Specifies the name of the engine that this option group should be associated with"
  type        = string
  default     = null
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = null
}

variable "options" {
  description = "A list of Options to apply"
  type        = any
  default     = []
}

variable "delete_timeouts" {
  description = "Define maximum timeout for deletion of `aws_db_option_group` resource"
  type        = string
  default     = null
}