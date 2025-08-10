variable db_identifier_name {
  type              = string
  description       = "Database identifier name to be passed"
}
variable "create_subnet_group" {
  type              = bool
  description       = "Optional, used for group/re-group security groups"
  default           =  true
}
variable "subnet_ids" {
  type              = list(string)
  description       = "list of subnet ids to be added to subnet ids"
}
variable "tags" {
  type              = map(string)
  description       = "A map of tags to assign to the resource"
  default           = {}
}