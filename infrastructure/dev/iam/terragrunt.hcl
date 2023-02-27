include "root" {
  path           = find_in_parent_folders()
  expose         = true
  merge_strategy = "deep"
}

terraform {
  source = "${dirname(find_in_parent_folders())}//modules//iam"
}

include "eks_cluster" {
  path           = "../dependency/eks.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
  issuer                 = dependency.eks.outputs.issuer
}

dependencies {

  paths = [
    "../eks"
  ]
}