#!/bin/bash
# Removes the system-wide {{PROJECT_NAME}} command.
set -e

PROJECT_NAME="{{PROJECT_NAME}}"
INSTALL_PATH="/usr/local/bin/${PROJECT_NAME}"

if [ -L "$INSTALL_PATH" ]; then
  sudo rm "$INSTALL_PATH"
  echo "✓  Removed ${INSTALL_PATH}"
else
  echo "Nothing to remove at ${INSTALL_PATH}"
fi

pip uninstall -y "$PROJECT_NAME"
echo "✓  Uninstalled ${PROJECT_NAME} from Python environment"
