# Dalkia Terraform Security Group Pattern

## General Purpose
This Terraform module manages AWS Security Groups, providing fine-grained control over inbound and outbound traffic rules for resources within a Virtual Private Cloud (VPC).

## Security Group Resources
1. **AWS Security Group (aws_security_group):**
    - Manages the creation and configuration of an AWS Security Group.

2. **AWS Security Group Rule (aws_security_group_rule):**
    - Creates inbound and outbound rules for the associated AWS Security Group.

## Variables

### Security Group Variables:

#### security_group_name:
* **Description:** The name to assign to the security group. Must be unique within the VPC.
* **Type:** String

#### security_group_description:
* **Description:** The description to assign to the created Security Group. Changing the description causes the security group to be replaced.
* **Type:** String
* **Default:** "Managed by Terraform"

#### allow_all_egress:
* **Description:** A convenience that adds to the rules specified elsewhere a rule that allows all egress. If false and no egress rules are specified via `all_security_group_rules`, then no egress will be allowed.
* **Type:** Boolean
* **Default:** true

#### security_group_create_timeout:
* **Description:** How long to wait for the security group to be created.
* **Type:** String
* **Default:** "10m"

#### security_group_delete_timeout:
* **Description:** How long to retry on `DependencyViolation` errors during security group deletion from lingering ENIs left by certain AWS services.
* **Type:** String
* **Default:** "15m"

#### vpc_id:
* **Description:** The ID of the VPC where the Security Group will be created.
* **Type:** String

#### all_security_group_rules:
* **Description:** A list of objects representing individual security group rules.
* **Type:** List of Objects
    * **type:** String - The type of rule, either "ingress" or "egress".
    * **from_port:** Number - The starting port for the rule.
    * **to_port:** Number - The ending port for the rule.
    * **protocol:** String - The protocol that the rule applies to (e.g., "tcp", "udp", "icmp").
    * **description:** String - A description for the rule.
    * **cidr_blocks:** Optional list of Strings - List of CIDR blocks that the rule applies to (IPv4).
    * **ipv6_cidr_blocks:** Optional list of Strings - List of CIDR blocks that the rule applies to (IPv6).
    * **prefix_list_ids:** Optional list of Strings - List of prefix list IDs for AWS service integration.
    * **source_security_group_id:** Optional String - ID of the source security group.
    * **self:** Optional Boolean - Whether the security group itself is among the targets.
> **Note:**
> - In a security group rule, you can define either `cidr_blocks`, `ipv6_cidr_blocks`, `prefix_list_ids`, `source_security_group_id`, or `self` based on your specific requirements.
> - When modifying a rule with `cidr_blocks`, be aware that it may force a replacement of the Security Group rule. During replacement, if a duplicate Security Group rule is found, Terraform will raise an error: "A duplicate Security Group rule was found."
### Output:

#### security_group_id:
* **Description:** The ID of the security group.
* **Type:** String

## Usage
```hcl
module "security_group" {
  source = "git::https://gitlab.dalkia.net/accenture/dalkia-terraform-pattern.git//security_group"

  # Security Group Configuration
  security_group_name           = "my-security-group"
  security_group_description    = "My Security Group"
  allow_all_egress              = true
  security_group_create_timeout = "10m"
  security_group_delete_timeout = "15m"
  vpc_id                        = "vpc-0123456789abcdef0"

  # Security Group Rules
  all_security_group_rules = [
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow HTTP traffic from anywhere"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  # Optional Tags
  tags = {
    Project     = "MyProject"
    Environment = "Production"
  }
}

output "my_security_group_id" {
  value = module.security_group.security_group_id
}
```