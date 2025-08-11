resource "aws_db_subnet_group" "db_subnet_group" {
  count             = var.create_subnet_group ? 1 : 0
  name              = local.name
  description       = "Database security group created for ${local.name}"
  subnet_ids        = var.subnet_ids
  tags              = merge(var.tags, {
    "Name" : local.name,
    "ResourceName" : "db_subnet_group@${local.resource_path}"})
}
