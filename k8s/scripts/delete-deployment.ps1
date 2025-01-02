# Get the directory where this script is located and change to it
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Add prompt for environment selection
$ENVIRONMENT = Read-Host "Which environment do you want to delete? (test/prod)"
if ($ENVIRONMENT -ne 'test' -and $ENVIRONMENT -ne 'prod') {
    Write-Host "Invalid environment. Please specify 'test' or 'prod'"
    exit 1
}

Write-Host "Removing $ENVIRONMENT deployment..."

Write-Host "Setting context to $ENVIRONMENT..."
if ($ENVIRONMENT -eq 'test') {
    kubectl config set-context --current --namespace=mcce-g1-test
} else {
    kubectl config set-context --current --namespace=mcce-g1-prod
}

Write-Host "Deleting all resources using Kustomize..."
kubectl delete -k "../overlays/$ENVIRONMENT"

Write-Host "Deployment removed!" 