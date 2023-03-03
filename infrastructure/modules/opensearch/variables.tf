variable "region" {
  description = "Region"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "Account id"
  type        = string
}

variable "domain_name" {
  default = "testtask-node"
}

variable "instance_count" {
  default = 1
}

variable "instance_type" {
  default = "t3.small.search"
}

variable "security_options" {
  default = true
}

variable "anonymous_auth_enabled" {
  default = false
}

variable "internal_user_database_enabled" {
  default = true
}

variable "master_user_name" {
  default = "user"
}

variable "master_user_password" {
  default = "Password1!"
}

variable "encrypt_at_rest" {
  default = true
}

variable "node_to_node_encryption"{
    default = true
}

variable "ebs_enabled" {
  default = true
}

variable "volume_size" {
  default = 10
}