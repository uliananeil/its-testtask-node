variable "aws_secret_manager_role_arn" {
  type = string
}

variable "aws_load_balancer_controller_role_arn" {
  type = string
}

variable "CONTENTFUL_DELIVERY_API_HOST" {
  type    = string
  default = "cdn.contentful.com"
}

variable "CONTENTFUL_PREVIEW_API_HOST" {
  type    = string
  default = "preview.contentful.com"
}

variable "NODE_ENV" {
  type    = string
  default = "development"
}

variable "PORT" {
  default = 3000
}

//----SecretProviderClass
variable "secret_manager_arn" {
  type    = string
  default = "arn:aws:secretsmanager:us-east-1:841962000336:secret:Contenful-jx3BTb"
}

variable "region" {
  default = "us-east-1"
}

//----Service
variable "port" {
  default = 3000
}
variable "targetPort" {
  default = 3000
}

//----Deployment
variable "image" {
  default = "841962000336.dkr.ecr.us-east-1.amazonaws.com/testtask:latest"
}
variable "name" {
  default = "testtask"
}

variable "containerPort" {
  default = 3000
}

//----Ingress
variable "certificate-arn" {
  default = "arn:aws:acm:us-east-1:841962000336:certificate/bb175253-c561-4f03-9166-29dc01aa7f6d"
}

variable "host" {
  default = "anyname.site"
}