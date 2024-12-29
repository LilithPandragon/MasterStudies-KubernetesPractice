#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Add prompt for environment selection
read -p "Which environment do you want to deploy to? (test/prod): " ENVIRONMENT
if [[ $ENVIRONMENT != "test" && $ENVIRONMENT != "prod" ]]; then
    echo "Invalid environment. Please specify 'test' or 'prod'"
    exit 1
fi

# Add prompt for rebuilding containers
read -p "Do you want to rebuild the containers? (y/n): " REBUILD
if [[ $REBUILD =~ ^[Yy]$ ]]; then
    echo "Building containers..."
    ../consumer/build.sh
    ../producer/build.sh
else
    echo "Skipping container rebuild..."
fi

# Change to script directory
cd "$SCRIPT_DIR"
echo "Current directory: $SCRIPT_DIR"

echo "Generating RabbitMQ credentials..."

# Generate random username and password (alphanumeric)
RabbitMQ_USER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RabbitMQ_PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1)

# Base64 encode the credentials
USERNAME_B64=$(echo -n "$RabbitMQ_USER" | base64)
PASSWORD_B64=$(echo -n "$RabbitMQ_PASS" | base64)

echo "Creating rabbitmq-secret.yaml with new credentials..."

# Create the secret YAML file
cat > "../overlays/$ENVIRONMENT/rabbitmq-secret.yaml" << EOF
apiVersion: v1
kind: Secret
metadata:
  name: rabbitmq-secret
type: Opaque
data:
  username: $USERNAME_B64
  password: $PASSWORD_B64
EOF

echo "Applying Kustomize deployment for $ENVIRONMENT environment..."

# Apply the kustomization
kubectl apply -k "../overlays/$ENVIRONMENT"

echo "Waiting for RabbitMQ pod to be ready..."
kubectl wait --for=condition=ready pod -l app=rabbitmq --timeout=30s

echo "Deployment completed!"

if [[ $ENVIRONMENT == "test" ]]; then
    kubectl config set-context --current --namespace=mcce-g1-test
else
    kubectl config set-context --current --namespace=mcce-g1-prod
fi

echo "Showing pods..."
kubectl get pods

echo "Showing services..."
kubectl get services

# Store credentials in plain text for reference
echo "Generated credentials:"
echo "Username: $RabbitMQ_USER"
echo "Password: $RabbitMQ_PASS"
echo "-------------------"
