output "formatted_project_name" {
  description = "The formatted project name"
  value = local.formatted_project_name
}

output "port_list" {
  description = "The list of allowed ports"
  value = local.port_list
}

output "sg_rules" {
  description = "The security group rules"
  value = local.sg_rules
}

output "instance_sizes" {
  description = "The instance sizes"
  value = local.instance_sizes
}