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

variable "issuer" {
    description = "should be provided from aws_eks_cluster.cluster.identity[0].oidc[0].issuer"
    type        = string
}
