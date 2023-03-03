include "root" {
  path           = find_in_parent_folders("helm.hcl")
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
include "opensearch" {
  path           = "../dependency/opensearch.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
    aws_load_balancer_controller_arn = dependency.iam.outputs.aws_load_balancer_controller_role_arn
    efs_csi_controller_arn = dependency.iam.outputs.efs_csi_controller_arn
    aws_secret_manager_role_arn = dependency.iam.outputs.aws_secret_manager_role_arn
    file_system_id = dependency.efs.outputs.file_system_id
    domain_name_endpoint = dependency.opensearch.outputs.domain_endpoint
    fluent_bit_arn = dependency.iam.outputs.fluent_bit_arn
}

dependencies {

  paths = [
    "../iam",
    "../efs",
    "../opensearch"
  ]
}