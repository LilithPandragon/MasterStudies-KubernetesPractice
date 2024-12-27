# Get and script directory
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

# Add prompt for rebuilding containers
$REBUILD = Read-Host "Do you want to rebuild the containers? (y/n)"
if ($REBUILD -eq 'y' -or $REBUILD -eq 'Y') {
    Write-Host "Building containers..."
    ../consumer/build.ps1
    ../producer/build.ps1
} else {
    Write-Host "Skipping container rebuild..."
}

#Change script directory
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $SCRIPT_DIR
Write-Host "Current directory: $SCRIPT_DIR"

Write-Host "Generating RabbitMQ credentials..."

# Generate random username and password (alphanumeric)
$RabbitMQ_USER = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 12 | ForEach-Object {[char]$_})
$RabbitMQ_PASS = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 20 | ForEach-Object {[char]$_})

#$RabbitMQ_USER = "admin"
#$RabbitMQ_PASS = "admin"

# Base64 encode the credentials
$USERNAME_B64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($RabbitMQ_USER))
$PASSWORD_B64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($RabbitMQ_PASS))

Write-Host "Creating rabbitmq-secret.yaml with new credentials..."

# Create the entire secret YAML file
$secretYaml = @"
apiVersion: v1
kind: Secret
metadata:
  name: rabbitmq-secret
type: Opaque
data:
  username: $USERNAME_B64
  password: $PASSWORD_B64
"@

# Write the YAML content to file
$secretYaml | Out-File -FilePath "./rabbitmq-secret.yaml" -Encoding UTF8 -Force

Write-Host "Applying RabbitMQ deployment..."
kubectl apply -f ./rabbitmq-secret.yaml
kubectl apply -f ./rabbitmq-deployment.yaml
kubectl apply -f ./rabbitmq-service.yaml

Write-Host "Applying CronJob as producer..."
kubectl apply -f ./producer-serviceaccount.yaml
kubectl apply -f ./cronjob.yaml

Write-Host "Applying Consumer deployment..."
kubectl apply -f ./consumer-serviceaccount.yaml
kubectl apply -f ./consumer-deployment.yaml
kubectl apply -f ./consumer-service.yaml

Write-Host "Deployment completed!" 

Write-Host "Showing pods..."
kubectl get pods

Write-Host "Showing services..."
kubectl get services

# Store credentials in plain text for reference (optional)
Write-Host "Generated credentials:"
Write-Host "Username: $RabbitMQ_USER"
Write-Host "Password: $RabbitMQ_PASS"
Write-Host "-------------------"