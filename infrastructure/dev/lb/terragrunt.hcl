include "root" {
  path           = find_in_parent_folders(helm.hcl)
  expose         = true
  merge_strategy = "deep"
}

terraform {
  source = "${dirname(find_in_parent_folders())}//modules//lb"
}

include "iam" {
  path           = "../dependency/iam.hcl"
  expose         = true
  merge_strategy = "deep"
}


inputs = {
    aws_load_balancer_controller_arn = dependency.iam.outputs.aws_load_balancer_controller_arn
}

dependencies {

  paths = [
    "../iam"
    "../eks-nodes",
    "../eks",
    "../vpc"
  ]
}