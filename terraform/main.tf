module "network" {
  source = "./modules/network"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  environment  = var.environment
  azs          = ["us-east-1a", "us-east-1b"]
}

module "compute" {
  source = "./modules/compute"

  project_name        = var.project_name
  environment         = var.environment
  domain_name         = var.domain_name
  web_subdomain       = var.web_subdomain
  api_subdomain       = var.api_subdomain
  acm_certificate_arn = var.acm_certificate_arn
  vpc_id              = module.network.vpc_id
  vpc_cidr            = var.vpc_cidr
  public_subnets      = module.network.public_subnets
  private_app_subnets = module.network.private_app_subnets

  api_instance_type = var.api_instance_type
  web_instance_type = var.web_instance_type
  ami_id            = var.ami_id

  db_password_secret_arn = module.secrets.db_password_secret_arn
}

module "secrets" {
  source = "./modules/secrets"

  project_name = var.project_name
  environment  = var.environment
}

module "database" {
  source = "./modules/database"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  private_db_subnets    = module.network.private_db_subnets
  app_security_group_id = module.compute.app_security_group_id
  vpc_cidr              = var.vpc_cidr

  db_instance_class = var.db_instance_class
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = coalesce(var.db_password, module.secrets.db_password)
}

/*
module "codedeploy" {
  source = "./modules/codedeploy"

  project_name = var.project_name
  environment  = var.environment
  web_asg_name = module.compute.web_asg_name
  api_asg_name = module.compute.api_asg_name

  web_target_group_name = module.compute.web_target_group_name
  api_target_group_name = module.compute.api_target_group_name
}
*/
