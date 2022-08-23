#!/bin/bash

# Enable strict mode:
set -euo pipefail

# Script variables:
GITHUB_RELEASES_URL="https://github.com/slateci/slate-client-server/releases"
SLATE_VERSION="${1}"

echo "Downloading SLATE client version: \"${SLATE_VERSION}\"..."
cd /tmp
if [[ ${SLATE_VERSION} == "latest" ]]
then
  curl -fsSL "${GITHUB_RELEASES_URL}/latest/download/slate-linux.tar.gz" -o slate-linux.tar.gz
  curl -fsSL "${GITHUB_RELEASES_URL}/latest/download/slate-linux.sha256" -o slate-linux.sha256
else
  curl -fsSL "${GITHUB_RELEASES_URL}/download/v${SLATE_VERSION}/slate-linux.tar.gz" -o slate-linux.tar.gz
  curl -fsSL "${GITHUB_RELEASES_URL}/download/v${SLATE_VERSION}/slate-linux.sha256" -o slate-linux.sha256
fi

echo "Verifying download..."
cat slate-linux.sha256
echo "Verifying download..."
sha256sum -c slate-linux.sha256 || exit 1

echo "Installing SLATE client..."
tar xzvf slate-linux.tar.gz
mv slate /usr/bin/slate

echo "Cleaning up..."
rm slate-linux.tar.gz slate-linux.sha256