# AWS S3 Terraform Module
This Terraform module provides resources to create and configure an AWS S3 bucket.

## Resources
1. **S3 Bucket (aws_s3_bucket):**
    * Manages the creation and configuration of the S3 bucket.

2. **S3 Bucket Versioning (aws_s3_bucket_versioning):**
    * Configures versioning for the S3 bucket.

3. **S3 Bucket Server-Side Encryption Configuration (aws_s3_bucket_server_side_encryption_configuration):**
    * Configures server-side encryption for the S3 bucket.

4. **S3 Bucket Policy (aws_s3_bucket_policy):**
    * Optionally attaches a policy to the S3 bucket.

## Variables
### S3 Bucket Variables:
#### bucket:
* **Description:** The name of the bucket. If omitted, Terraform will assign a random, unique name.
* **Type:** String

#### tags:
* **Description:** A mapping of tags to assign to the bucket.
* **Type:** Map of Strings
* **Default:** {}

#### force_destroy:
* **Description:** A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable.
* **Type:** Boolean
* **Default:** false

### Versioning Configuration Variables:
#### versioning:
* **Description:** Map containing versioning configuration.
* **Type:** Map of Strings
* **Default:** {}

### Server-Side Encryption Configuration Variables:
#### server_side_encryption:
* **Description:** A boolean that indicates server-side encryption activation.
* **Type:** Boolean
* **Default:** false

#### sse_algorithm:
* **Description:** Server-side encryption algorithm to use.
* **Type:** String
* **Default:** null

#### kms_master_key_id:
* **Description:** AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms.
* **Type:** String
* **Default:** null

#### bucket_kms_key:
* **Description:** Whether or not to use Amazon S3 Bucket Keys for SSE-KMS.
* **Type:** Boolean
* **Default:** true

### S3 Bucket Policy Variables:
#### attach_policy:
* **Description:** Whether or not to attach a policy to the bucket.
* **Type:** Boolean
* **Default:** false

#### policy_path:
* **Description:** Policy path to attach to the bucket.
* **Type:** String
* **Default:** ""

#### policy_vars:
* **Description:** Vars of the policy file, if needed.
* **Type:** Map of Strings
* **Default:** {}

## Outputs
#### bucket_arn:
* **Description:** The Amazon Resource Name (ARN) of the S3 bucket.
* **Type:** String

## Example Usage
```hcl
module "s3_bucket" {
  source          = "git::https://gitlab.example.com/terraform-modules/aws-s3-bucket.git"
  bucket          = "my-example-bucket"
  tags            = { Environment = "Production", Project = "MyProject" }
  force_destroy   = true
  versioning      = { status = true, mfa_delete = false }
  server_side_encryption = true
  sse_algorithm   = "aws:kms"
  kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd5678"
  bucket_kms_key   = true
  attach_policy    = true
  policy_path      = "path/to/s3_policy.json"
  policy_vars      = { var_name = "value" }
}
