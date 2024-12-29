# Use timestamp as version
$VERSION = Get-Date -Format "yyyyMMdd-HHmmss"

# Get and changescript directory
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $SCRIPT_DIR
Write-Host "Current directory: $SCRIPT_DIR"

# Image name
$IMAGE_NAME = "akkt1-g1-producer"
$REGISTRY = "ghcr.io/mcce2024"

Write-Host "Building ${REGISTRY}/${IMAGE_NAME}:${VERSION}"

docker build -t "${REGISTRY}/${IMAGE_NAME}:${VERSION}" .
docker tag "${REGISTRY}/${IMAGE_NAME}:${VERSION}" "${REGISTRY}/${IMAGE_NAME}:latest"
docker push "${REGISTRY}/${IMAGE_NAME}:${VERSION}"
docker push "${REGISTRY}/${IMAGE_NAME}:latest"

Write-Host "Build complete!"
Write-Host "To run the image: docker run ${IMAGE_NAME}:${VERSION}" 