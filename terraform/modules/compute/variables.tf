variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "web_subdomain" {
  type = string
}

variable "api_subdomain" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_app_subnets" {
  type = list(string)
}

variable "api_instance_type" {
  type    = string
  default = "t4g.micro" # Graviton
}

variable "web_instance_type" {
  type    = string
  default = "t4g.micro" # Graviton
}

variable "db_password_secret_arn" {
  type        = string
  description = "ARN of the Secrets Manager secret containing the DB password"
}

variable "ami_id" {
  type        = string
  description = "Golden AMI ID containing PM2, Node, CodeDeploy Agent, and CloudWatch Agent"
}
