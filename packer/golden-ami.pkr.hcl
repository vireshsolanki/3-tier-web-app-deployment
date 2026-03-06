packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "node-3tier-golden-ami-{{timestamp}}"
  instance_type = "t4g.micro"
  region        = var.region
  ssh_username  = "ubuntu"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical
  }

  tags = {
    Name        = "node-3tier-golden-ami"
    Environment = "production"
  }
}

build {
  name    = "node-3tier-ami"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "echo 'Waiting for cloud-init...'",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done",
      "sudo -E apt-get update -y",
      "sudo -E apt-get install -y ruby-full wget curl unzip",
      
      "# Install CloudWatch Agent manually via DEB",
      "curl -o /tmp/cwagent.deb https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/arm64/latest/amazon-cloudwatch-agent.deb",
      "sudo dpkg -i -E /tmp/cwagent.deb",
      
      "# Install CodeDeploy Agent",
      "cd /home/ubuntu",
      "wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install",
      "chmod +x ./install",
      "sudo ./install auto",
      "sudo systemctl enable codedeploy-agent",
      
      "# Install Node.js 18",
      "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -",
      "sudo -E apt-get install -y nodejs",
      
      "# Install pm2 for running node apps",
      "sudo npm install -g pm2",
      
      "# Configure CloudWatch Agent to watch PM2 logs and metrics",
      "cat << 'EOCW' | sudo tee /tmp/cwconfig.json",
      "{",
      "  \"agent\": {",
      "    \"metrics_collection_interval\": 60,",
      "    \"run_as_user\": \"root\"",
      "  },",
      "  \"metrics\": {",
      "    \"aggregation_dimensions\": [",
      "      [",
      "        \"InstanceId\"",
      "      ]",
      "    ],",
      "    \"append_dimensions\": {",
      "      \"AutoScalingGroupName\": \"$${aws:AutoScalingGroupName}\",",
      "      \"ImageId\": \"$${aws:ImageId}\",",
      "      \"InstanceId\": \"$${aws:InstanceId}\",",
      "      \"InstanceType\": \"$${aws:InstanceType}\"",
      "    },",
      "    \"metrics_collected\": {",
      "      \"disk\": {",
      "        \"measurement\": [",
      "          \"used_percent\"",
      "        ],",
      "        \"metrics_collection_interval\": 60,",
      "        \"resources\": [",
      "          \"/\"",
      "        ]",
      "      },",
      "      \"mem\": {",
      "        \"measurement\": [",
      "          \"mem_used_percent\"",
      "        ],",
      "        \"metrics_collection_interval\": 60",
      "      }",
      "    }",
      "  },",
      "  \"logs\": {",
      "    \"logs_collected\": {",
      "      \"files\": {",
      "        \"collect_list\": [",
      "          {",
      "            \"file_path\": \"/var/log/syslog\",",
      "            \"log_group_name\": \"/ecs/node-3tier/dev/syslog\",",
      "            \"log_stream_name\": \"{instance_id}\"",
      "          },",
      "          {",
      "            \"file_path\": \"/root/.pm2/logs/*.log\",",
      "            \"log_group_name\": \"/ecs/node-3tier/dev/pm2-logs\",",
      "            \"log_stream_name\": \"{instance_id}\"",
      "          }",
      "        ]",
      "      }",
      "    }",
      "  }",
      "}",
      "EOCW",
      
      "# Restart and Enable CloudWatch Agent",
      "sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/tmp/cwconfig.json -s",
      "sudo systemctl enable amazon-cloudwatch-agent"
    ]
  }
}
