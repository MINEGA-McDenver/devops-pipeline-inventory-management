#!/bin/bash
set -e

# ACR credentials from Terraform outputs
ACR_LOGIN_SERVER="devopspipelinedevacr4vokg.azurecr.io"
ACR_USERNAME="devopspipelinedevacr4vokg"
ACR_PASSWORD="zbuTFzB4pbvVviDg/TDgXbwQy2Kqpji/d0fyc64xk3+ACRBgqOlz"

echo "=== Logging into Azure Container Registry ==="
echo "$ACR_PASSWORD" | sudo docker login "$ACR_LOGIN_SERVER" -u "$ACR_USERNAME" --password-stdin

echo "=== Creating application directory ==="
sudo mkdir -p /opt/devops-app
cd /opt/devops-app

echo "=== Creating docker-compose.yml ==="
sudo tee docker-compose.yml > /dev/null <<EOF
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: devops-postgres
    environment:
      POSTGRES_USER: devops
      POSTGRES_PASSWORD: devops123
      POSTGRES_DB: devops_app
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U devops"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    image: ${ACR_LOGIN_SERVER}/devops-backend:latest
    container_name: devops-backend
    environment:
      NODE_ENV: production
      PORT: 3000
      DATABASE_URL: postgresql://devops:devops123@postgres:5432/devops_app
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - app-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  frontend:
    image: ${ACR_LOGIN_SERVER}/devops-frontend:latest
    container_name: devops-frontend
    ports:
      - "80:80"
      - "3000:3000"
    depends_on:
      - backend
    networks:
      - app-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:80"]
      interval: 30s
      timeout: 3s
      retries: 3

networks:
  app-network:
    driver: bridge

volumes:
  postgres_data:
EOF

echo "=== Creating .env file ==="
sudo tee .env > /dev/null <<EOF
ACR_LOGIN_SERVER=$ACR_LOGIN_SERVER
NODE_ENV=production
DB_USER=devops
DB_PASSWORD=devops123
DB_NAME=devops_app
EOF

echo "=== Pulling images from ACR ==="
sudo docker pull ${ACR_LOGIN_SERVER}/devops-backend:latest
sudo docker pull ${ACR_LOGIN_SERVER}/devops-frontend:latest

echo "=== Starting application containers ==="
sudo docker compose up -d

echo "=== Waiting for services to be healthy ==="
sleep 20

echo "=== Checking container status ==="
sudo docker compose ps

echo "=== Deployment complete ==="
