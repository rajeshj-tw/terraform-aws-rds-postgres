variable db_identifier_name {
  type              = string
  description       = "Database identifier name to be passed"
}
variable "create_option_group" {
  type              = bool
  description       = "Optional, used for group/re-group security groups"
  default           =  true
}
variable "engine_name" {
  type              = string
  description       = "db engine name to be used for the option group"
}
variable "major_engine_version" {
  type              = string
  description       = "db major engine version to be used for the option group"
}
variable "options" {
  type              = list(map(string))
  description       = "Default set of options to be applied to the option group"
  default           = []
}
variable "tags" {
    type              = map(string)
    description       = "Tags to be applied to the option group"
    default           = {}
}