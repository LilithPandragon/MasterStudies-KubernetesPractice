# Get the directory where this script is located and change to it
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "Removing deployment..."

Write-Host "Setting context to mcce-g1..."
kubectl config set-context --current --namespace=mcce-g1

Write-Host "Deleting RabbitMQ deployment..."
kubectl delete -f ./rabbitmq-secret.yaml
kubectl delete -f ./rabbitmq-deployment.yaml
kubectl delete -f ./rabbitmq-service.yaml
kubectl delete -f ./rabbitmq-serviceaccount.yaml

Write-Host "Deleting cronjob as producer..."
kubectl delete -f ./producer.yaml
kubectl delete -f ./producer-serviceaccount.yaml

Write-Host "Deleting consumer deployment..."
kubectl delete -f ./consumer-deployment.yaml
kubectl delete -f ./consumer-service.yaml
kubectl delete -f ./consumer-serviceaccount.yaml

Write-Host "Deleting Network Policies..."
kubectl delete -f ./rabbitmq-networkpolicy.yaml
kubectl delete -f ./consumer-networkpolicy.yaml
kubectl delete -f ./producer-networkpolicy.yaml

Write-Host "Namespace removed!"
kubectl delete -f ./namespace.yaml

Write-Host "Deployment removed!" 