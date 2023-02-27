skip = true

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
  region = local.environment_vars.locals.region
}

generate "provider" {

  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  
  contents  = <<EOF
  provider "aws" {
  region = "${local.region}"
}
EOF
}



inputs = merge(
  local.environment_vars.locals,
)
