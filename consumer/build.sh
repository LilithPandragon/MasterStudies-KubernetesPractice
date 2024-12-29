#!/bin/bash

# Use timestamp as version
VERSION=$(date +%Y%m%d-%H%M%S)

# Image name
IMAGE_NAME="akkt1-g1-consumer"
REGISTRY="ghcr.io/mcce2024"

echo "Building ${IMAGE_NAME}:${VERSION}"

docker build -t ${REGISTRY}/${IMAGE_NAME}:${VERSION} .
docker tag ${REGISTRY}/${IMAGE_NAME}:${VERSION} ${REGISTRY}/${IMAGE_NAME}:latest
docker push ${REGISTRY}/${IMAGE_NAME}:${VERSION}
docker push ${REGISTRY}/${IMAGE_NAME}:latest


echo "Build complete!"
echo "To run the image: docker run -p 3000:3000 ${IMAGE_NAME}:${VERSION}" 