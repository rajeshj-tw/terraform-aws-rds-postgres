locals {
  create_db_subnet_group    = var.db_subnet_group_name == null && length(var.subnet_ids) > 0
  create_db_parameter_group = var.parameter_group_name == null && length(var.parameters) > 0
  create_db_option_group    = var.option_group_name == null && length(var.option_group_name) > 0
  cleaned_relative_path     = replace(path.module, "../", "")
  resource_path             = replace(local.cleaned_relative_path, "^/+", "")
  final_snapshot_identifier = var.skip_final_snapshot ? null : (
    var.final_snapshot_identifier != null ? var.final_snapshot_identifier : "${var.identifier}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  )
}
