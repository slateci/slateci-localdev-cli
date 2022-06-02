#!/bin/bash

# Enable strict mode:
set -euo pipefail

# Create the bash history file if necessary:
if [ ! -f "$HISTFILE" ]
then
  touch /work/.bash_history_docker
fi

# Load environmental values:
source "/docker/scripts/yml.sh"
create_variables "/docker/envs/${SLATE_ENV}.yml" "conf_"
export SLATE_API_ENDPOINT="https://${conf_slate_api_hostname}:${conf_slate_api_port}"

# Set the token:
echo "${conf_slate_api_token}" >> "${HOME}/.slate/token"
chmod 600 "${HOME}/.slate/token"

# Test SLATE API connection for errors:
slate whoami > /dev/null

# Connection Information:
echo "==================== Connection Information ===================="
echo Endpoint: $(echo "$SLATE_API_ENDPOINT")
echo ""
echo "$(slate whoami 2>&1 | head -n 2)"
echo ""
slate version
echo "================================================================"

${1:-/bin/bash}