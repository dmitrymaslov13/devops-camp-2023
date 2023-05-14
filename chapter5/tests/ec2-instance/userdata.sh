#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent nginx
sudo systemctl start amazon-ssm-agent nginx
