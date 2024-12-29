# Get script directory
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $SCRIPT_DIR

# Add prompt for environment selection
$ENVIRONMENT = Read-Host "Which environment do you want to deploy to? (test/prod)"
if ($ENVIRONMENT -ne 'test' -and $ENVIRONMENT -ne 'prod') {
    Write-Host "Invalid environment. Please specify 'test' or 'prod'"
    exit 1
}

# Add prompt for rebuilding containers
$REBUILD = Read-Host "Do you want to rebuild the containers? (y/n)"
if ($REBUILD -eq 'y' -or $REBUILD -eq 'Y') {
    Write-Host "Building containers..."
    ../consumer/build.ps1
    ../producer/build.ps1
} else {
    Write-Host "Skipping container rebuild..."
}

Write-Host "Generating RabbitMQ credentials..."

# Generate random username and password (alphanumeric)
$RabbitMQ_USER = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 12 | ForEach-Object {[char]$_})
$RabbitMQ_PASS = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 20 | ForEach-Object {[char]$_})

# Base64 encode the credentials
$USERNAME_B64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($RabbitMQ_USER))
$PASSWORD_B64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($RabbitMQ_PASS))

Write-Host "Creating rabbitmq-secret.yaml with new credentials..."

# Create the secret YAML file
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
$secretYaml | Out-File -FilePath "../overlays/$ENVIRONMENT/rabbitmq-secret.yaml" -Encoding UTF8 -Force

Write-Host "Applying Kustomize deployment for $ENVIRONMENT environment..."

# Apply the kustomization
kubectl apply -k "../overlays/$ENVIRONMENT"

Write-Host "Waiting for RabbitMQ pod to be ready..."
kubectl wait --for=condition=ready pod -l app=rabbitmq --timeout=30s

Write-Host "Deployment completed!" 

Write-Host "Showing pods..."
kubectl get pods

Write-Host "Showing services..."
kubectl get services

# Store credentials in plain text for reference
Write-Host "Generated credentials:"
Write-Host "Username: $RabbitMQ_USER"
Write-Host "Password: $RabbitMQ_PASS"
Write-Host "-------------------"