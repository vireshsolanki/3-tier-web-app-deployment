variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "my-app"
}

variable "domain_name" {
  description = "Base domain name for the application"
  type        = string
}

variable "web_subdomain" {
  description = "Subdomain for the web application"
  type        = string
  default     = "web"
}

variable "api_subdomain" {
  description = "Subdomain for the api application"
  type        = string
  default     = "api"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate to use for HTTPS"
  type        = string
}

variable "db_password" {
  description = "Database password (will bypass if using secret manager generator)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "db_instance_class" {
  description = "RDS Instance Class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_name" {
  description = "Initial DB Name"
  type        = string
  default     = "nodeappdb"
}

variable "db_username" {
  description = "Master DB Username"
  type        = string
  default     = "admin"
}

variable "web_instance_type" {
  description = "EC2 Instance type for Web tier"
  type        = string
  default     = "t4g.micro"
}

variable "api_instance_type" {
  description = "EC2 Instance type for API tier"
  type        = string
  default     = "t4g.micro"
}

variable "ami_id" {
  description = "Golden AMI ID for the web and api EC2 instances"
  type        = string
}
