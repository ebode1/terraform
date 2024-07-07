output "launch_template_infos" {
  value = try(
    {
      id = aws_launch_template.default[0].id
      tags = aws_launch_template.default[0].tags
      latest_version = aws_launch_template.default[0].latest_version
    }, null)
}