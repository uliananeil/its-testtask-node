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

variable "cluster_version" {
    description = "kubernetes version"
    type        = string
    default     = "1.24"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids"
}
