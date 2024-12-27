Write-Host "Removing deployment..."

Write-Host "Deleting RabbitMQ deployment..."
kubectl delete -f ./rabbitmq-secret.yaml
kubectl delete -f ./rabbitmq-deployment.yaml
kubectl delete -f ./rabbitmq-service.yaml

Write-Host "Deleting cronjob as producer..."
kubectl delete -f ./cronjob.yaml

Write-Host "Deleting consumer deployment..."
kubectl delete -f ./consumer-deployment.yaml
kubectl delete -f ./consumer-service.yaml

Write-Host "Deployment removed!" 