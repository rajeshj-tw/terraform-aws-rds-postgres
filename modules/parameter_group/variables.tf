variable db_identifier_name {
  type              = string
  description       = "Database identifier name to be passed"
}
variable "create_db_parameter_group" {
  type              = bool
  description       = "Optional, used for creating db parameter group"
  default           =  true
}
variable "family" {
  type              = string
  description       = "The DB parameter group family (e.g., postgres15)"
}
variable "parameters" {
  type              = list(map(string))
  description       = "A list of DB parameter maps to apply"
  default           = []
}
variable "tags" {
  type              = map(string)
  description       = "Default tags to be applied for"
}