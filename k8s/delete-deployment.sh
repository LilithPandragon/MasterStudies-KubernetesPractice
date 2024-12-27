#!/bin/bash

echo "Removing deployment..."

echo "Deleting RabbitMQ deployment..."
kubectl delete -f ./rabbitmq-secret.yaml
kubectl delete -f ./rabbitmq-deployment.yaml
kubectl delete -f ./rabbitmq-service.yaml

echo "Deleting cronjob as producer..."
kubectl delete -f ./cronjob.yaml

echo "Deleting consumer deployment..."
kubectl delete -f ./consumer-deployment.yaml
kubectl delete -f ./consumer-service.yaml

echo "Deployment removed!"