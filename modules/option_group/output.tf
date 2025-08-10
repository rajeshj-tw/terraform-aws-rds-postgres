output id {
  description = "The ID of the RDS Option Group"
  value = try(aws_db_option_group.db_option_group[0].id,null)
}