Write-Host "Removing deployment..."

Write-Host "Deleting RabbitMQ deployment..."
kubectl delete -f ./rabbitmq-secret.yaml
kubectl delete -f ./rabbitmq-deployment.yaml
kubectl delete -f ./rabbitmq-service.yaml
kubectl delete -f ./rabbitmq-serviceaccount.yaml

Write-Host "Deleting cronjob as producer..."
kubectl delete -f ./cronjob.yaml
kubectl delete -f ./producer-serviceaccount.yaml

Write-Host "Deleting consumer deployment..."
kubectl delete -f ./consumer-deployment.yaml
kubectl delete -f ./consumer-service.yaml
kubectl delete -f ./consumer-serviceaccount.yaml

Write-Host "Deployment removed!" 