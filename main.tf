resource "random_password" "master_user_password" {
  count            = var.create_random_password ? 1 : 0
  length           = var.random_password_length
  special          = true
  override_special = "_%@!^#$*()_+-=[]{}|;:,.<>?"
  keepers = {
    master_user_name = var.username == null ? "default" : var.username
    engine_version   = var.engine_version
  }
}

resource "aws_secretsmanager_secret" "master_user_password" {
  count                   = var.create_random_password ? 1 : 0
  name                    = "${var.identifier}-master-user-password"
  recovery_window_in_days = 0
  tags = merge(var.tags, {
    Name             = "${var.identifier}-master-user-password",
    ResourceLocation = local.resource_path
  })
}

resource "aws_secretsmanager_secret_version" "master_user_password" {
  count         = var.create_random_password ? 1 : 0
  secret_id     = aws_secretsmanager_secret.master_user_password[0].id
  secret_string = random_password.master_user_password[0].result

  lifecycle {
    ignore_changes = [secret_string]
  }
}
module "subnet_group" {
  count               = local.create_db_subnet_group ? 1 : 0
  source              = "./modules/subnet_group"
  db_identifier_name  = var.identifier
  create_subnet_group = local.create_db_subnet_group
  subnet_ids          = var.subnet_ids
  tags                = var.tags
}
module "db_parameter_group" {
  count              = local.create_db_parameter_group ? 1 : 0
  source             = "./modules/parameter_group"
  db_identifier_name = var.identifier
  family             = var.parameter_group_family
  tags               = var.tags
}
module "db_option_group" {
  count                = local.create_db_option_group ? 1 : 0
  source               = "./modules/option_group"
  db_identifier_name   = var.identifier
  tags                 = var.tags
  engine_name          = var.engine_name
  major_engine_version = var.engine_version
}
resource "aws_cloudwatch_log_group" "cloudwatch_logs" {
  for_each = var.create_cloudwatch_log_group ? toset(var.enabled_cloudwatch_logs_exports) : toset([])

  name              = "/aws/rds/instance/${var.identifier}/${each.value}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id

  tags = merge(var.tags, {
    Name = "${var.identifier}-${each.value}-log-group", "ResourceName" = "cloudwatch_logs@${local.resource_path}"
  })
}


data "aws_iam_policy_document" "enhanced_monitoring" {
  count = var.monitoring_interval > 0 && var.monitoring_role_arn == null ? 1 : 0

  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "enhanced_monitoring" {
  count = var.monitoring_interval > 0 && var.monitoring_role_arn == null ? 1 : 0

  name               = "${var.identifier}-rds-enhanced-monitoring"
  assume_role_policy = data.aws_iam_policy_document.enhanced_monitoring[0].json

  tags = merge(var.tags, {
    Name = "${var.identifier}-rds-enhanced-monitoring"
  })
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count = var.monitoring_interval > 0 && var.monitoring_role_arn == null ? 1 : 0

  role       = aws_iam_role.enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_instance" "rds" {
  identifier                            = var.identifier
  instance_class                        = var.instance_class
  username                              = var.username
  password                              = var.create_random_password ? random_password.master_user_password[0].result : "${var.username}-password"
  engine                                = var.engine_name
  engine_version                        = var.engine_version
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  storage_encrypted                     = var.storage_encrypted
  db_subnet_group_name                  = local.create_db_subnet_group ? module.subnet_group[0].id : var.db_subnet_group_name
  parameter_group_name                  = local.create_db_parameter_group ? module.db_parameter_group[0].id : var.parameter_group_name
  option_group_name                     = local.create_db_option_group ? module.db_option_group[0].id : var.option_group_name
  vpc_security_group_ids                = var.vpc_security_group_ids
  port                                  = lookup(var.port, var.engine_name)
  multi_az                              = var.multi_az
  db_name                               = try(var.initial_db_name, null)
  backup_retention_period               = var.backup_retention_period
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  skip_final_snapshot                   = var.skip_final_snapshot
  publicly_accessible                   = var.publicly_accessible
  apply_immediately                     = var.apply_immediately
  deletion_protection                   = var.deletion_protection
  final_snapshot_identifier             = local.final_snapshot_identifier
  monitoring_interval                   = var.monitoring_interval > 0 ? var.monitoring_interval : null
  monitoring_role_arn                   = var.monitoring_role_arn != null ? var.monitoring_role_arn : (var.monitoring_interval > 0 ? aws_iam_role.enhanced_monitoring[0].arn : null)
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  tags = merge(var.tags, {
    "Name" : var.identifier, "ResourceName" : "rds@${local.resource_path}"
  })
}
