#!/bin/bash

# Script to start the application nodes by scaling ASG to 2

ENV="dev"
PROJECT="node-3tier"
CAPACITY=2

echo "Starting Web and API nodes (Scaling to $CAPACITY)..."

aws autoscaling update-auto-scaling-group --auto-scaling-group-name "${PROJECT}-${ENV}-web-asg" --min-size 2 --desired-capacity $CAPACITY
aws autoscaling update-auto-scaling-group --auto-scaling-group-name "${PROJECT}-${ENV}-api-asg" --min-size 2 --desired-capacity $CAPACITY

echo "Node scaling triggered successfully. Instances are launching."
