#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

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
cat > ./rabbitmq-secret.yaml << EOF
apiVersion: v1
kind: Secret
metadata:
  name: rabbitmq-secret
type: Opaque
data:
  username: $USERNAME_B64
  password: $PASSWORD_B64
EOF

echo "Applying Namespace..."
kubectl apply -f ./namespace.yaml

echo "Applying RabbitMQ deployment..."
kubectl apply -f ./rabbitmq-serviceaccount.yaml
kubectl apply -f ./rabbitmq-secret.yaml
kubectl apply -f ./rabbitmq-deployment.yaml
kubectl apply -f ./rabbitmq-service.yaml

echo "Applying CronJob as producer..."
kubectl apply -f ./producer-serviceaccount.yaml
kubectl apply -f ./producer.yaml

echo "Applying Consumer deployment..."
kubectl apply -f ./consumer-serviceaccount.yaml
kubectl apply -f ./consumer-deployment.yaml
kubectl apply -f ./consumer-service.yaml

echo "Applying Network Policies..."
kubectl apply -f ./rabbitmq-networkpolicy.yaml
kubectl apply -f ./consumer-networkpolicy.yaml
kubectl apply -f ./producer-networkpolicy.yaml

echo "Deployment completed!"

echo "Showing pods..."
kubectl get pods

echo "Showing services..."
kubectl get services

# Store credentials in plain text for reference (optional)
echo "Generated credentials:"
echo "Username: $RabbitMQ_USER"
echo "Password: $RabbitMQ_PASS"
echo "-------------------"
