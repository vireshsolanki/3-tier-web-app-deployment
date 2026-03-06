
output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.compute.alb_dns_name
}

output "db_endpoint" {
  description = "The connection endpoint of the database"
  value       = module.database.db_endpoint
}

output "db_name" {
  value = module.database.db_name
}

output "github_actions_role_arn" {
  value = module.compute.github_actions_role_arn
}
