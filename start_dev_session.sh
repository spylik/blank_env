#!/bin/bash

if [ -z "${SSH_HOST_PORT}" ]; then
    echo "Error: SSH_HOST_PORT is not set. Run 'direnv allow' in this folder first."
    exit 1
fi

echo "Project: ${COMPOSE_PROJECT_NAME}, SSH port: ${SSH_HOST_PORT}"
docker-compose run --service-ports claude-blank-dev-env
