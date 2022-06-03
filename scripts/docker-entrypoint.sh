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
create_variables "/docker/secrets/envs.yml" "conf_"
SLATE_API_HOSTNAME=conf_envs_${SLATE_ENV}_api_hostname
SLATE_API_PORT=conf_envs_${SLATE_ENV}_api_port
SLATE_API_TOKEN=conf_envs_${SLATE_ENV}_api_token

# Set the endpoint:
export SLATE_API_ENDPOINT="https://${!SLATE_API_HOSTNAME}:${!SLATE_API_PORT}"

# Set the token:
echo "${!SLATE_API_TOKEN}" >> "${HOME}/.slate/token"
chmod 600 "${HOME}/.slate/token"

# Test SLATE API connection for errors:
echo "Testing connection to API server..."
slate whoami > /dev/null

# Connection Information:
echo "===================================================================================="
echo "= Connection Information                                                           ="
echo "===================================================================================="
echo Endpoint: $(echo "$SLATE_API_ENDPOINT")
echo ""
echo "$(slate whoami 2>&1 | head -n 2)"
echo ""
slate version
echo ""
echo ""
echo ""
echo ""

${1:-/bin/bash}