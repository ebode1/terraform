# Dalkia Terraform RDS Pattern
## General Purpose
This Terraform module provisions EC2 instances, key pairs, IAM roles, and an autoscaling group on AWS. It is designed to be modular, allowing you to configure different components based on your requirements.


## Project Structure
### Modules
1. ec2_key_pair:
   * Generates an RSA key pair and manages related resources.
2. ec2_iam_role:
   * Creates an IAM Role for the EC2 instance, along with associated policies.
3. ec2_autoscale_group:
   * Sets up an Auto Scaling Group (ASG) and Launch Template for managing EC2 instances.


## Variables

### EC2 Instance Variables:

#### image_id:
* **Description:** The EC2 image ID to launch.
* **Type:** String

#### instance_type:
* **Description:** Instance type to launch.
* **Type:** String

#### block_device_mappings:
* **Description:** Specify volumes to attach to the instance besides the volumes specified by the AMI.
* **Type:** List(Object)
  * `device_name` (Optional): Device name.
  * `no_device` (Optional): Boolean.
  * `virtual_name` (Optional): Virtual name.
  * `ebs` (Object):
    * `delete_on_termination` (Optional): Boolean.
    * `encrypted` (Optional): Boolean.
    * `iops` (Optional): Number.
    * `throughput` (Optional): Number.
    * `kms_key_id` (Optional): String.
    * `snapshot_id` (Optional): String.
    * `volume_size` (Optional): Number.
    * `volume_type` (Optional): String.

#### disable_api_termination:
* **Description:** If `true`, enables EC2 Instance Termination Protection.
* **Type:** Boolean

#### ebs_optimized:
* **Description:** If true, the launched EC2 instance will be EBS-optimized.
* **Type:** Boolean

#### os_type:
* **Description:** EC2 OS type, windows or linux.
* **Type:** String

#### user_data_path_list:
* **Description:** List of user data file paths.
* **Type:** List of Strings

#### user_data_vars:
* **Description:** User data variables.
* **Type:** Map of Strings

#### account_id:
* **Description:** AWS Account ID.
* **Type:** String

#### enable_monitoring:
* **Description:** Enable/disable detailed monitoring
* **Type:** Boolean
* **Default:** true

#### iam_instance_profile_name:
* **Description:** The IAM instance profile name to associate with launched instances if create_iam_role is false
* **Type:** String

#### associate_public_ip_address:
* **Description:** Associate a public IP address with an instance in a VPC. If `network_interface_id` is specified, this can only be `false`.
* **Type:** Boolean
* **Default:** false

#### create_key_pair:
* **Description:** Whether to create an SSH key pair for EC2 instances.
* **Type:** Boolean
* **Default:** false

#### key_name:
* **Description:** The SSH key name that should be used for the instance (to attach an existing KP if create_key_pair is false, to create if not )
* **Type:** String

### Autoscaling Group Variables:

#### name_prefix:
* **Description:** Creates a unique name beginning with the specified prefix
* **Type:** String

#### create_asg:
* **Description:** Whether to create an ASG
* **Type:** Boolean
* **Default:** false

#### force_delete:
* **Description:** Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling
* **Type:** Boolean
* **Default:** false
#### max_size:
* **Description:** The maximum size of the autoscale group.
* **Type:** Number

#### min_size:
* **Description:** The minimum size of the autoscale group.
* **Type:** Number

#### target_group_arns:
* **Description:** A list of aws_alb_target_group ARNs, for use with Application Load Balancing.
* **Type:** List of Strings

#### termination_policies:
* **Description:** A list of policies to decide how the instances in the auto scale group should be terminated.
* **Type:** List of Strings
* **Default:** ["Default"]

#### enabled_metrics:
* **Description:** A list of metrics to collect.
* **Type:** List of Strings
* **Default:** ["GroupMinSize", "GroupMaxSize", ...]

#### metrics_granularity:
* **Description:** The granularity to associate with the metrics to collect. The only valid value is 1Minute.
* **Type:** String
* **Default:** "1Minute"

#### wait_for_capacity_timeout:
* **Description:** A maximum duration that Terraform should wait for ASG instances to be healthy before timing out.
* **Type:** String
* **Default:** "10m"

#### protect_from_scale_in:
* **Description:** Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale-in events.
* **Type:** Boolean

#### service_linked_role_arn:
* **Description:** The ARN of the service-linked role that the ASG will use to call other AWS services.
* **Type:** String

#### desired_capacity:
* **Description:** The number of Amazon EC2 instances that should be running in the group, if not set will use `min_size` as the value.
* **Type:** Number

#### max_instance_lifetime:
* **Description:** The maximum amount of time, in seconds, that an instance can be in service.
* **Type:** Number

#### capacity_rebalance:
* **Description:** Indicates whether capacity rebalance is enabled. Otherwise, capacity rebalance is disabled.
* **Type:** Boolean

#### mixed_instances_policy:
* **Description:** Configuration for mixed instances policy.
* **Type:** Object

#### security_group_ids:
* **Description:** A list of associated security group IDs.
* **Type:** List of Strings


### IAM Role Variables:

#### create_iam_role:
* **Description:** Whether to create an IAM role for EC2 instances.
* **Type:** Boolean
* **Default:** false

#### role_name_ec2:
* **Description:** Name of EC2 IAM Role.
* **Type:** String

#### managed_policy_arns:
* **Description:** List of IAM managed policy ARNs.
* **Type:** List of Strings

#### policy_name_ec2:
* **Description:** Name of policy.
* **Type:** String

#### assume_role_path:
* **Description:** The path of IAM role for EC2 instance.
* **Type:** String

#### policy_path:
* **Description:** The path of the policy attached to assume role.
* **Type:** String

#### role_name_boundary:
* **Description:** Role/policy boundary associated with the instance profile.
* **Type:** String

### Launch Template Variables:

#### launch_template_version:
* **Description:** Launch template version. Can be version number, `$Latest` or `$Default`.
* **Type:** String
* **Default:** "$Latest"

#### subnet_ids:
* **Description:** A list of subnet IDs to launch resources in.
* **Type:** List of Strings

#### tags:
* **Description:** A map of tags to attach
* **Type:** Map of Strings



## Outputs

- **Keypair Name:**
    - Description: The Name of keypair created

- **Instance Profile Name:**
    - Description: The Instance Profile Name created

## Usage
```hcl
module "rds" {
  source              = "git::https://gitlab.lol.net/xxxx//ec2"
  create_asg          = true
  create_key_pair     = true
  key_name            = "kp.xxxx"
  image_id            = "ami-xxxxx"
  instance_type       = "t2.micro"
  max_size            = 1
  min_size            = 1
  name_prefix         = "ec2.xxx.xxxx"
  os_type             = "windows"
  subnet_ids          = ["subnet-xxxx"]
  security_group_ids  = ["sg-xxx"]
  create_iam_role     = true
  role_name_ec2       = "IAM.ROLE.EC2.xxx.xxx"
  account_id          = "xxxx"
  assume_role_path    = "resources/assume_role.json"
  policy_path         = "resources/ec2_policy.json"
  policy_name_ec2     = "IAM.POLICY.EC2.xxx"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"]
  role_name_boundary  = (terraform.workspace != "eti") ? "IAM.POL.BOUNDARY" : ""
  target_group_arns = ["arn:aws:iam::aws:tg/xxxx"]
  block_device_mappings = [
    {
      device_name = "/dev/sda1"
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 100
        volume_type           = "gp3"
        iops                  = 3000
      }
    },
    {
      device_name = "xvdf"
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 100
        volume_type           = "gp3"
        iops                  = 3000
      }
    },
    {
      device_name = "xvdg"
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 10
        volume_type           = "gp3"
        iops                  = 3000
      }
    }
  ]
  user_data_path_list = [
    "resources/scripts/mount_volume.ps1",
    "resources/scripts/r53_add_record.ps1"
  ]
  user_data_vars = {
    volume_Mapping = "/dev/sda1:C,xvdf:D"
  }
  tags = {
    app          = "xxxx"
    Name         = "ec2-xxx-xxx"
    application  = "xxxx"
    fonction     = "xxx"
    env          = "xxx"
  }

}

```


