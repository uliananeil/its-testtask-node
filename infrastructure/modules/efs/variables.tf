variable "project" {
  description = "Project name"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "Account id"
  type        = string
}

variable "private_subnets_ids" {
  type        = list(string)
  description = "List of subnet ids"
}

variable "vpc_id" {
  type = string
}

variable "from_port" {
  default = 2049
}

variable "to_port" {
  default = 2049
}

variable "vpc_range" {
  description = "Range of VPC"
}