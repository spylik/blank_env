#!/bin/bash
# Sourced by start_dev_session.sh and to_container.sh.
# Derives a per-folder compose project name and SSH host port, so several
# copies of this repo (e.g. blank_env, blank_env_second) can run side by side.
# The same folder name always yields the same port.

ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${ENV_DIR}" || exit 1

# Same normalization docker-compose applies to the project name
export COMPOSE_PROJECT_NAME="$(basename "${COMPOSE_PROJECT_NAME:-${ENV_DIR}}" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9_-')"

SERVICE_NAME="claude-blank-dev-env"

# Stable port in 20000-29999 derived from the project name (cksum is POSIX,
# so macOS and Linux agree). Override with SSH_HOST_PORT=... if it collides.
if [ -z "${SSH_HOST_PORT}" ]; then
    PORT_HASH=$(printf '%s' "${COMPOSE_PROJECT_NAME}" | cksum | awk '{print $1}')
    SSH_HOST_PORT=$((20000 + PORT_HASH % 10000))
fi
export SSH_HOST_PORT
