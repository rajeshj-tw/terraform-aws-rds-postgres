output "db_instance_address" {
  description = "The hostname of the RDS instance"
  value       = aws_db_instance.rds.address
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.rds.arn
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = aws_db_instance.rds.availability_zone
}

output "db_instance_endpoint" {
  description = "The connection endpoint in address:port format"
  value       = aws_db_instance.rds.endpoint
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = aws_db_instance.rds.hosted_zone_id
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.rds.id
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of rds instance"
  value       = aws_db_instance.rds.resource_id
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = aws_db_instance.rds.status
}

output "db_instance_name" {
  description = "The database name"
  value       = aws_db_instance.rds.db_name
}

output "db_instance_port" {
  description = "The database port"
  value       = aws_db_instance.rds.port
}

output "db_instance_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  value       = aws_db_instance.rds.ca_cert_identifier
}

output "db_instance_domain" {
  description = "The ID of the Directory Service Active Directory domain the instance is joined to"
  value       = aws_db_instance.rds.domain
}

output "db_instance_domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service"
  value       = aws_db_instance.rds.domain_iam_role_name
}


output "enhanced_monitoring_iam_role_name" {
  description = "The name of the monitoring role"
  value       = try(aws_iam_role.enhanced_monitoring[0].name, null)
}

output "enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the monitoring role"
  value       = try(aws_iam_role.enhanced_monitoring[0].arn, null)
}

output "db_instance_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = aws_cloudwatch_log_group.cloudwatch_logs
}

# Secrets Manager outputs (when using managed master password)
output "db_instance_master_user_secret_arn" {
  description = "The ARN of the master user secret"
  value       = aws_db_instance.rds.master_user_secret != null ? aws_db_instance.rds.master_user_secret[0].secret_arn : null
  sensitive   = true
}

output "db_instance_master_user_secret_status" {
  description = "The status of the master user secret"
  value       = aws_db_instance.rds.master_user_secret != null ? aws_db_instance.rds.master_user_secret[0].secret_status : null
}

output "db_instance_master_user_secret_kms_key_id" {
  description = "The KMS key ID used to encrypt the master user secret"
  value       = aws_db_instance.rds.master_user_secret != null ? aws_db_instance.rds.master_user_secret[0].kms_key_id : null
}