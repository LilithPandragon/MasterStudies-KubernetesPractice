#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "Removing deployment..."

echo "Setting context to mcce-g1..."
kubectl config set-context --current --namespace=mcce-g1

echo "Deleting RabbitMQ deployment..."
kubectl delete -f ./rabbitmq-secret.yaml
kubectl delete -f ./rabbitmq-deployment.yaml
kubectl delete -f ./rabbitmq-service.yaml
kubectl delete -f ./rabbitmq-serviceaccount.yaml
echo "Deleting cronjob as producer..."
kubectl delete -f ./producer.yaml
kubectl delete -f ./producer-serviceaccount.yaml

echo "Deleting consumer deployment..."
kubectl delete -f ./consumer-deployment.yaml
kubectl delete -f ./consumer-service.yaml
kubectl delete -f ./consumer-serviceaccount.yaml

echo "Deleting Network Policies..."
kubectl delete -f ./rabbitmq-networkpolicy.yaml
kubectl delete -f ./consumer-networkpolicy.yaml
kubectl delete -f ./producer-networkpolicy.yaml

echo "Namespace removed!"
kubectl delete -f ./namespace.yaml

echo "Deployment removed!"