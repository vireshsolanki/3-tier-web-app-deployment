#!/bin/bash

# Script to scale the Auto Scaling Groups

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <web|api> <desired_capacity>"
    exit 1
fi

TIER=$1
CAPACITY=$2
ENV="dev" # Update based on target
PROJECT="node-3tier" # Update based on target

if [ "$TIER" == "web" ]; then
    ASG_NAME="${PROJECT}-${ENV}-web-asg"
elif [ "$TIER" == "api" ]; then
    ASG_NAME="${PROJECT}-${ENV}-api-asg"
else
    echo "Invalid tier. Must be 'web' or 'api'."
    exit 1
fi

echo "Scaling $ASG_NAME to $CAPACITY instances..."
aws autoscaling update-auto-scaling-group --auto-scaling-group-name "$ASG_NAME" --desired-capacity "$CAPACITY"

if [ $? -eq 0 ]; then
    echo "Successfully updated desired capacity to $CAPACITY."
else
    echo "Failed to scale ASG. Check your AWS credentials and region config."
fi
