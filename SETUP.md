# 3-Tier Node.js Application Setup Guide

This document describes the step-by-step process for deploying the 3-tier Node.js application (Web, API, and DB) on AWS using Packer and Terraform.

## Prerequisites

- **AWS CLI** configured with access to `us-east-1`.
- **Packer** installed.
- **Terraform** installed.
- **Node.js 18.x** (optional, for local development).

## Step 1: Build the Golden AMI (Packer)

We use a "Golden AMI" approach to bake essential dependencies (Node.js, CodeDeploy Agent, CloudWatch Agent, PM2) into the base image for faster scaling and consistent deployments.

1.  Navigate to the `packer` directory:
    ```bash
    cd packer
    ```
2.  Initialize Packer:
    ```bash
    packer init golden-ami.pkr.hcl
    ```
3.  Build the AMI:
    ```bash
    packer build golden-ami.pkr.hcl
    ```
4.  Note down the **AMI ID** from the output (e.g., `ami-020a257ddf6cb83ab`).

## Step 2: Infrastructure Provisioning (Terraform)

Once the AMI is ready, we use Terraform to provision the networking, compute, and database components.

1.  Navigate to the `terraform` directory:
    ```bash
    cd terraform
    ```
2.  Review and update `terraform.tfvars`:
    - Ensure `aws_region` is set to `us-east-1`.
    - Update `domain_name` and `acm_certificate_arn` with your actual domain and SSL certificate.
    - (Optional) Specify the `ami_id` if you want to override the default lookup.

3.  Initialize Terraform:
    ```bash
    terraform init
    ```
4.  (Optional) Create a Plan:
    ```bash
    terraform plan -out=tfplan
    ```
5.  Apply the Configuration:
    ```bash
    terraform apply "tfplan"
    # Or directly:
    # terraform apply -auto-approve
    ```

## Step 3: Application Deployment (CodeDeploy)

Terraform sets up the CodeDeploy Application and Deployment Groups, but you need to push the code from the `web` and `api` directories.

1.  **API Tier**:
    ```bash
    cd api
    # Use AWS CLI to push to S3 and trigger deployment, or use GitHub Actions
    ```
2.  **Web Tier**:
    ```bash
    cd web
    # Similar process for the frontend
    ```

## Infrastructure Components

- **VPC & Networking**: Multi-AZ setup with public, private app, and private DB subnets.
- **ALB**: Application Load Balancer with host-based routing.
- **CloudFront**: CDN for global distribution.
- **ASGs**: Auto Scaling Groups for both Web and API tiers.
- **RDS**: Multi-AZ PostgreSQL instance.
- **Secrets Manager**: For secure DB credential handling.
- **CloudWatch**: Centralized logging and metrics.

## Clean Up

To avoid ongoing costs, destroy the infrastructure when finished:
```bash
cd terraform
terraform destroy -auto-approve
```
