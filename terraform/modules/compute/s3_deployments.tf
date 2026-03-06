
# Deployment Bucket for CodeDeploy Artifacts
resource "aws_s3_bucket" "deployments" {
  bucket = "${var.project_name}-${var.environment}-deployments-833899002429" # Appended account ID for global uniqueness

  tags = {
    Name        = "${var.project_name}-${var.environment}-deployments"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_public_access_block" "deployments" {
  bucket = aws_s3_bucket.deployments.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
