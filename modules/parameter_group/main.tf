resource "aws_db_parameter_group" "db_parameter_group" {
  count                       = var.create_db_parameter_group ? 1 : 0
  name                        = local.name
  description                 = "${local.name}-parameter group"
  family                      = var.family
  dynamic "parameter" {
    for_each          = var.parameters
    content {
      name            = parameter.value.name
      value           = parameter.value.value
      apply_method    = lookup(parameter.value,"apply_method",null)
    }
  }
  tags                        = merge(var.tags, {"Name" = local.name, "ResourceName" = "db_parameter_group@${local.resource_path}"})
  lifecycle {
    create_before_destroy = true
  }
}