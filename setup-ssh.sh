#!/bin/bash
set -e

echo "=== Installing and configuring SSH ==="
# Install OpenSSH server
sudo apt-get update
sudo apt-get install -y openssh-server

# Start SSH service
sudo systemctl start ssh
sudo systemctl enable ssh

# Configure SSH to allow password authentication temporarily
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Restart SSH service
sudo systemctl restart ssh

# Check SSH status
sudo systemctl status ssh --no-pager

# Show listening ports
sudo netstat -tulpn | grep :22 || sudo ss -tulpn | grep :22

echo "=== SSH service configured and running ==="
