output "keypair_name" {
  value = module.ec2_keypair.keypair_name
}
output "instance_profile_name" {
  value = module.ec2_iam_role.instance_profile_name
}

output "launch_template_infos" {
  value = module.ec2_launch_template.launch_template_infos
}