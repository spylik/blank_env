#!/bin/bash
# Generic wrapper script to load environment variables using direnv
# This script is sourced by Claude Code via CLAUDE_ENV_FILE
# Works with any project that has direnv configured

# Override cd command to auto-trigger direnv on directory change
cd() {
    builtin cd "$@"
    if command -v direnv >/dev/null 2>&1; then
        # Auto-allow .envrc in the new directory if it exists
        if [ -f "${PWD}/.envrc" ]; then
            direnv allow "${PWD}" 2>/dev/null
        fi
        # Export the direnv environment
        eval "$(direnv export bash 2>/dev/null)"
    fi
}

# Get the current working directory (the project directory)
PROJECT_DIR="${PWD}"

# Check if direnv is available
if command -v direnv >/dev/null 2>&1; then
    # Check if there's an .envrc file in the current directory
    if [ -f "${PROJECT_DIR}/.envrc" ]; then
        # Allow direnv for this directory (silently)
        direnv allow "${PROJECT_DIR}" 2>/dev/null

        # Export the direnv environment
        eval "$(direnv export bash 2>/dev/null)"
    fi
fi
