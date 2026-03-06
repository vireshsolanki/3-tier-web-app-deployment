# CloudWatch Log Groups with 2-day retention
resource "aws_cloudwatch_log_group" "web" {
  name              = "/ecs/${var.project_name}/${var.environment}/web"
  retention_in_days = 3

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Tier        = "web"
  }
}

resource "aws_cloudwatch_log_group" "api" {
  name              = "/ecs/${var.project_name}/${var.environment}/api"
  retention_in_days = 3

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Tier        = "api"
  }
}
