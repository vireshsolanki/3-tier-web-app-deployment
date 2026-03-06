#!/bin/bash

# Script to stop the application nodes by scaling ASG to 0
# This effectively stops the servers without destroying the base infrastructure

ENV="dev"
PROJECT="node-3tier"

echo "Stopping all Web and API nodes (Scaling to 0)..."

aws autoscaling update-auto-scaling-group --auto-scaling-group-name "${PROJECT}-${ENV}-web-asg" --desired-capacity 0 --min-size 0
aws autoscaling update-auto-scaling-group --auto-scaling-group-name "${PROJECT}-${ENV}-api-asg" --desired-capacity 0 --min-size 0

echo "Node scaling triggered successfully. Instances are terminating."
