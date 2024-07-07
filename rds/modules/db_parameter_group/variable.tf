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
  description = "The name of the DB parameter group"
  type        = string
}
variable "description" {
  description = "The description of the DB parameter group"
  type        = string
  default     = null
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = null
}

variable "parameters" {
  description = "A list of DB parameter maps to apply"
  type = list(object({
    name         = string
    value        = string
    apply_method = string
  }))
}
