output "id" {
  description = "The ID of the RDS Subnet Group"
  value       = try(aws_db_subnet_group.db_subnet_group[0].id, null)
}
