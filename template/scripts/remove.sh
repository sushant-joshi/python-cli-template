#!/bin/bash
# Removes the system-wide {{PROJECT_NAME}} command installed by deploy.sh.
set -e

PROJECT_NAME="{{PROJECT_NAME}}"
INSTALL_PATH="/usr/local/bin/${PROJECT_NAME}"

if [ -f "$INSTALL_PATH" ]; then
  sudo rm "$INSTALL_PATH"
  echo "✓  Removed ${INSTALL_PATH}"
else
  echo "Nothing found at ${INSTALL_PATH}"
fi
