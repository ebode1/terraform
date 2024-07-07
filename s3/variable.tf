variable "bucket" {
  description = "The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type        = string

}
variable "tags" {
  description = "A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}
variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}
variable "versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
  default     = {}
  ## versioning = {
  ##  status     = true
  ##  mfa_delete = false
  ## }
}
variable "server_side_encryption" {
  description = "A boolean that indicates server side encryption activation"
  type        = bool
  default     = false
}
variable "sse_algorithm" {
  description = "Server-side encryption algorithm to use"
  type        = string
  default     = null
}
variable "kms_master_key_id" {
  description = "WS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms"
  type        = string
  default     = null
}
variable "bucket_kms_key" {
  description = "Whether or not to use Amazon S3 Bucket Keys for SSE-KMS."
  type        = bool
  default     = true
}
variable "attach_policy" {
  type        = bool
  description = "Whether or not to attach a policy to the bucket"
  default     = false
}
variable "policy_path" {
  type        = string
  description = "Policy path to attach to the bucket"
  default     = ""
}
variable "policy_vars" {
  description = "Vars of the policy file, if needed"
  default     = {}
}