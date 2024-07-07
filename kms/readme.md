# AWS Key Management Service (KMS) Terraform Module
This Terraform module provides resources to create and configure an AWS Key Management Service (KMS) key, alias, and associated IAM role grants.

## Resources
1. **KMS Key (aws_kms_key):**
    * Manages the creation and configuration of the KMS key.

2. **KMS Alias (aws_kms_alias):**
    * Creates an alias for the KMS key.

3. **IAM Policy Document (data.aws_iam_policy_document):**
    * Generates an IAM policy document for granting permissions.

4. **IAM Role (aws_iam_role):**
    * Creates an IAM role for granting permissions to the specified AWS service.

5. **KMS Grant (aws_kms_grant):**
    * Grants the IAM role permissions to use the KMS key.

## Variables
### KMS Key Variables:
#### create_kms:
* **Description:** Determines whether to create a KMS key.
* **Type:** Boolean
* **Default:** false

#### kms_enable_key_rotation:
* **Description:** Specifies whether key rotation is enabled. Defaults to `true`.
* **Type:** Boolean
* **Default:** true

#### kms_deletion_window_in_days:
* **Description:** The waiting period, specified in the number of days. After the waiting period ends, AWS KMS deletes the KMS key. If not specified, it defaults to `30`.
* **Type:** Number
* **Default:** null

#### kms_description:
* **Description:** The description of the key as viewed in the AWS console.
* **Type:** String
* **Default:** null

#### kms_multi_region:
* **Description:** Indicates whether the KMS key is a multi-Region (`true`) or regional (`false`) key. Defaults to `false`.
* **Type:** Boolean
* **Default:** false

#### kms_name:
* **Description:** The display name of the alias.
* **Type:** String
* **Default:** null

#### kms_tags:
* **Description:** Additional tags for the KMS key.
* **Type:** Map of Strings
* **Default:** {}

### IAM Role Variables:
#### service_permission:
* **Description:** The AWS service for which the IAM role is created.
* **Type:** String
* **Default:** ""

#### grant_operations:
* **Description:** Operations to be granted to the IAM role for the KMS key.
* **Type:** List of Strings
* **Default:** []

## Outputs
#### kms_key_id:
* **Description:** The ID of the KMS key.
* **Type:** String

#### kms_key_arn:
* **Description:** The Amazon Resource Name (ARN) of the KMS key.
* **Type:** String

## Example Usage
```hcl
module "kms" {
  source               = "git::https://gitlab.example.com/terraform-modules/aws-kms-key.git"
  create_kms           = true
  kms_enable_key_rotation = true
  kms_deletion_window_in_days = 14
  kms_description      = "My KMS Key for Encryption"
  kms_multi_region     = false
  kms_name             = "my-kms-key"
  kms_tags             = { Terraform = "true", Environment = "Production" }

  service_permission   = "ec2.amazonaws.com"
  grant_operations     = ["Encrypt", "Decrypt"]
}
