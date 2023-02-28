include "root" {
  path           = find_in_parent_folders("terragrunt.hcl")
  expose         = true
  merge_strategy = "deep"
}

terraform {
  source = "${dirname(find_in_parent_folders())}//modules//efs"
}

include "vpc" {
  path           = "../dependency/vpc.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
    private_subnets_ids = dependency.vpc.outputs.private_subnets_ids
    vpc_id = dependency.vpc.outputs.vpc_id
    vpc_range = dependency.vpc.outputs.vpc_range
}

dependencies {

  paths = [
    "../iam",
    "../eks-nodes",
    "../eks",
    "../vpc"
  ]
}