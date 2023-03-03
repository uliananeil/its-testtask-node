include "root" {
  path           = find_in_parent_folders()
  expose         = true
  merge_strategy = "deep"
}

terraform {
  source = "${dirname(find_in_parent_folders())}//modules//opensearch"
}


inputs = {
    domain_name = "testtask-node"
    instance_count = 1
}
