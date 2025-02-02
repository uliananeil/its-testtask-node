output "aws_load_balancer_controller_role_arn" {
  value = aws_iam_role.aws_load_balancer_controller.arn
}

output "aws_secret_manager_role_arn" {
  value = aws_iam_role.aws_secret_manager_role.arn
}

output "efs_csi_controller_arn" {
  value = aws_iam_role.efs-csi-controller.arn
}

output "fluent_bit_arn" {
  value = aws_iam_role.fluent-bit-role.arn
}