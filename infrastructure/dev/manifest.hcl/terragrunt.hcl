include "root" {
  path           = find_in_parent_folders(kubernetes.hcl)
  expose         = true
  merge_strategy = "deep"
}


terraform {
  source = "${dirname(find_in_parent_folders())}//modules//manifest"
}


inputs = {
}