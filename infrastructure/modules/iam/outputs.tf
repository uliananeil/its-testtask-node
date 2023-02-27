output "aws_load_balancer_controller_role_arn" {
  value = aws_iam_role.aws_load_balancer_controller.arn
}

output "aws_secret_manager_role_arn" {
  value = aws_iam_role.aws_secret_manager_role.arn
}