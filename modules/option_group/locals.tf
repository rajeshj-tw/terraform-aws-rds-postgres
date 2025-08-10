locals {
  name                      = "${var.db_identifier_name}-db-optiongroup"
  cleaned_relative_path     = replace(path.module,"../","")
  resource_path             = replace(local.cleaned_relative_path,"^/+","")
}