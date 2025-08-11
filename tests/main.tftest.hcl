provider "aws" {
  region          = "us-west-2"
}
variables {
  identifier      = "test-rds-instance"

}
run "plan_rds_instance" {
  command         = plan
}
