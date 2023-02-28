include "root" {
  path           = find_in_parent_folders("terragrunt.hcl")
  expose         = true
  merge_strategy = "deep"
}

terraform {
  source = "${dirname(find_in_parent_folders())}//modules//eks"
}

include "vpc" {
  path           = "../dependency/vpc.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
  cluster_version = "1.24"
  subnet_ids       = dependency.vpc.outputs.private_subnets_ids
}

dependencies {

  paths = [
    "../eks",
    "../vpc"
  ]
}