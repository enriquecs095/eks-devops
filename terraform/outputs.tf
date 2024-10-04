
output "endpoint" {
  description = "Endpoint of the cluster"
  value = module.devsu_test.endpoint
}

output "aws_load_balancer_controller_role_arn" {
  value = module.devsu_test.aws_load_balancer_controller_role_arn
}