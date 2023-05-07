#!/bin/bash
# Requires:
#   jq (https://stedolan.github.io/jq/)

# Build cross platform by default
IMAGE="registry.cluster.dellinger.dev/maildev"
DEFAULT_PLATFORM="linux/amd64,linux/arm64"
PLATFORM="${1:-$DEFAULT_PLATFORM}"

VERSION=`npm version --json | jq -r .maildev`

CMD="docker buildx build --platform $PLATFORM -t $IMAGE:$VERSION -t $IMAGE:latest --push ."

echo "Running $CMD..."

$CMD
