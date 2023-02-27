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

variable "vpc_cidr" {
  description = "Range of Virtual Private Cloud"
}

variable "public_subnets" {
    type        = list(string)
    description = "Public subnets" 
}

variable "private_subnets" {
    type        = list(string)
    description = "Private subnets" 
}