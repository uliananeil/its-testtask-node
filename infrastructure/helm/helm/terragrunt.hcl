include "root" {
  path           = find_in_parent_folders()
  expose         = true
  merge_strategy = "deep"
}

terraform {
  source = "${dirname(find_in_parent_folders())}//modules//helm"
}

include "iam" {
  path           = "../dependency/iam.hcl"
  expose         = true
  merge_strategy = "deep"
}
include "efs" {
  path           = "../dependency/efs.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
    aws_load_balancer_controller_arn = dependency.iam.outputs.aws_load_balancer_controller_arn
    efs_csi_controller_arn = dependency.iam.outputs.efs_csi_controller_arn
    aws_secret_manager_role_arn = dependency.iam.outputs.aws_secret_manager_role_arn
    file_system_id = dependency.efs.outputs.file_system_id
}

dependencies {

  paths = [
    "../../aws/iam",
    "../../aws/efs"
  ]
}