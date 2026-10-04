#!/bin/bash

source "$(dirname "$0")/dev-env.sh"

echo "Project: ${COMPOSE_PROJECT_NAME}, SSH port: ${SSH_HOST_PORT}"
docker-compose run --service-ports "${SERVICE_NAME}"
