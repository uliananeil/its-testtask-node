variable "region" {
  description = "Region"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "Account id"
  type        = string
}

variable "cluster_name" {
  default = "testtask-cluster"
}

variable "aws_load_balancer_controller_arn" {

}

variable "efs_csi_controller_arn" {

}

variable "aws_secret_manager_role_arn" {

}
variable "fluent_bit_arn" {

}

variable "file_system_id" {

}

variable "domain_name_endpoint" {
  description = "Domain endpoint of Opensearch"
}