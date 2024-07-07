variable "create" {
  type    = bool
  default = false
}
variable "managed_policy_arns" {
  description = "list of iam managed policy arn"
  default     = []
}
variable "policy_description" {
  description = "description for policy"
  default     = null
}
variable "policy_name_ec2" {
  description = "name of policy"
  default     = "test-policy"
}
variable "role_name_ec2" {
  description = "name of EC2 IAM Role"
  default     = "ec2-role"
}
variable "assume_role_path" {
  description = "the path of iam role for ec2 instance"
}
variable "policy_path" {
  description = "the path of policy attached to assume role"
}
variable "account_id" {
  description = "account id for target aws account"
}
variable "role_name_boundary" {
  description = "role / policy boundary associated to instance profile"
}
