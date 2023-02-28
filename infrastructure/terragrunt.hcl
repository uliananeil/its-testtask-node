skip = true

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
  region = local.environment_vars.locals.region

provider_vars = read_terragrunt_config(find_in_parent_folders("provider.hcl"))
providers = local.provider_vars.locals.providers
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  %{if contains(local.providers, "aws")}
  provider "aws" {
  region = "${local.region}"
}
%{endif}
%{if contains(local.providers, "helm")}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
%{endif}
EOF
}



inputs = merge(
  local.environment_vars.locals,
)
