provider "aws" {
  region          = "us-west-2"
}
test {
  parallel        = false
}
variables {
  identifier      = "test-rds-instance"

}
run "plan_rds_instance" {
  command         = plan
}