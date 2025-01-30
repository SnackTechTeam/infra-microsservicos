#!/bin/bash

REPOSITORY_NAME=$1

aws ecr batch-delete-image --repository-name "$REPOSITORY_NAME" --image-ids "$(aws ecr list-images --repository-name "$REPOSITORY_NAME" --query 'imageIds[*].imageDigest' --output text)"