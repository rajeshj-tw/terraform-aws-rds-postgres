# test {
#     name = "RDS Instance Test"
#     description = "Test to ensure RDS instance is created with the correct properties."
#
#     assertions = [
#         {
#         condition = "aws_db_instance.rds != null"
#         error_message = "RDS instance should be created."
#         },
#         {
#         condition = "aws_db_instance.rds.engine == 'postgres'"
#         error_message = "RDS instance should use postgres engine."
#         },
#         {
#         condition = "aws_db_instance.rds.instance_class == 'db.t3.micro'"
#         error_message = "RDS instance should be of class db.t3.micro."
#         },
#         {
#         condition = "aws_db_instance.rds.storage_type == 'gp3'"
#         error_message = "RDS instance should use gp3 storage type."
#         },
#         {
#         condition = "aws_db_instance.rds.allocated_storage == 20"
#         error_message = "RDS instance should have 20 GB of allocated storage."
#         }
#     ]
# }
