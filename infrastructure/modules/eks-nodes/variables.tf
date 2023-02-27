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

variable "cluster_name" {
    description = "name of eks cluster"
    type        = string
}

variable "cluster_version" {
    description = "version of kubernetes"
    type        = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids"
}

variable "max_unavailable" {
  type        = number
  description = "max unavailable amount of nodes"
  default     = 3
}

variable "desired_size" {
  type        = number
  description = "desired amount of nodes"
  default     = 3
}

variable "max_size" {
  type        = number
  description = "max amount of nodes"
  default     = 3
}

variable "min_size" {
  type        = number
  description = "min amount of nodes"
  default     = 3
}

