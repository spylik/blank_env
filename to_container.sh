#!/bin/bash

# Configuration
CONTAINER_NAME="blank_env_claude-blank-dev-env"
SSH_PORT="3222"
TEMP_DIR="./temp/ssh"
PRIVATE_KEY="${TEMP_DIR}/id_rsa"

# Create temp directory if it doesn't exist
mkdir -p "${TEMP_DIR}"

# Function to extract SSH key from container
extract_key() {
    echo "Extracting SSH private key from container..."

    # Find the actual container name
    ACTUAL_CONTAINER=$(docker-compose ps | grep "${CONTAINER_NAME}" | awk '{print $1}')

    if [ -z "$ACTUAL_CONTAINER" ]; then
        echo "Error: Container with name pattern '${CONTAINER_NAME}' is not running."
        echo "Please start it with: docker-compose run -d ${CONTAINER_NAME}"
        exit 1
    fi

    echo "Found container: ${ACTUAL_CONTAINER}"

    # Extract the private key from the container using actual container name
    echo "Attempting to extract key from container..."

    if ! docker exec "${ACTUAL_CONTAINER}" cat /root/.ssh/id_rsa > "${PRIVATE_KEY}" 2>&1; then
        echo "Error: Failed to extract SSH key from container."
        echo "Make sure the container is fully started and SSH keys are generated."
        echo ""
        echo "Waiting 5 seconds for container to initialize..."
        sleep 5

        if ! docker exec "${ACTUAL_CONTAINER}" cat /root/.ssh/id_rsa > "${PRIVATE_KEY}" 2>&1; then
            echo "Error: Still cannot extract SSH key. Please check container logs:"
            echo "  docker logs ${ACTUAL_CONTAINER}"
            exit 1
        fi
    fi

    # Set correct permissions
    chmod 600 "${PRIVATE_KEY}"

    echo "SSH key extracted to ${PRIVATE_KEY}"
}

# Check if private key exists, if not extract it
if [ ! -f "${PRIVATE_KEY}" ]; then
    extract_key
else
    # Check if key is still valid (container might have been recreated)
    if ! ssh -i "${PRIVATE_KEY}" -p "${SSH_PORT}" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes root@localhost exit 2>/dev/null; then
        echo "Existing key is invalid, extracting fresh key..."
        extract_key
    fi
fi

# Connect to container via SSH
echo "Connecting to container via SSH on port ${SSH_PORT}..."
ssh -i "${PRIVATE_KEY}" \
    -p "${SSH_PORT}" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    root@localhost
