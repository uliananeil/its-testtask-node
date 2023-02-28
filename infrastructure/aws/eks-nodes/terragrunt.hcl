include "root" {
  path           = find_in_parent_folders()
  expose         = true
  merge_strategy = "deep"
}

terraform {
  source = "${dirname(find_in_parent_folders())}//modules//eks-nodes"
}

include "vpc" {
  path           = "../dependency/vpc.hcl"
  expose         = true
  merge_strategy = "deep"
}
include "eks" {
  path           = "../dependency/eks.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
    cluster_name = dependency.eks.outputs.cluster_name
  cluster_version = "1.24"
  subnet_ids       = dependency.vpc.outputs.private_subnets_ids
  desired_size = 2
  max_size =2
  min_size = 0
  max_unavailable = 1
}

dependencies {

  paths = [
    "../eks-nodes",
    "../eks",
    "../vpc"
  ]
}