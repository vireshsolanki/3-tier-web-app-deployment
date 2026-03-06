output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "web_asg_name" {
  description = "Name of the Web Auto Scaling Group for CodeDeploy"
  value       = aws_autoscaling_group.web.name
}

output "api_asg_name" {
  description = "Name of the API Auto Scaling Group for CodeDeploy"
  value       = aws_autoscaling_group.api.name
}

output "app_security_group_id" {
  description = "ID of the Application Security Group"
  value       = aws_security_group.app.id
}

output "web_target_group_name" {
  description = "Name of the Web ALB Target Group"
  value       = aws_lb_target_group.web.name
}

output "api_target_group_name" {
  description = "Name of the API ALB Target Group"
  value       = aws_lb_target_group.api.name
}
