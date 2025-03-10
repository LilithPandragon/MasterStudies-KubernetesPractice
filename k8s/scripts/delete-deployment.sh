#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Add prompt for environment selection
read -p "Which environment do you want to delete? (test/prod): " ENVIRONMENT
if [[ $ENVIRONMENT != "test" && $ENVIRONMENT != "prod" ]]; then
    echo "Invalid environment. Please specify 'test' or 'prod'"
    exit 1
fi

echo "Removing $ENVIRONMENT deployment..."

echo "Setting context to $ENVIRONMENT..."
if [[ $ENVIRONMENT == "test" ]]; then
    kubectl config set-context --current --namespace=mcce-g1-test
else
    kubectl config set-context --current --namespace=mcce-g1-prod
fi

echo "Deleting all resources using Kustomize..."
kubectl delete -k "../overlays/$ENVIRONMENT"

echo "Deployment removed!"