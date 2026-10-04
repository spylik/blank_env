docker-compose run --service-ports claude-blank-dev-env

docker-compose run --service-ports --rm claude-blank-dev-env


## Parallel sessions

Each copy of this repo (e.g. `blank_env`, `blank_env_second`) gets its own compose
project and SSH port, derived from the folder name in `.envrc` (same name → same
port, in the 20000-29999 range), so direnv must be allowed in each copy.
`./start_dev_session.sh` prints the port and `./to_container.sh` uses the same one.
