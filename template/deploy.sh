#!/bin/bash
# Installs {{PROJECT_NAME}} as a system-wide command available from any terminal.
set -e

DEPLOY_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_NAME="{{PROJECT_NAME}}"
INSTALL_PATH="/usr/local/bin/${PROJECT_NAME}"

echo ""
echo "▶  Installing ${PROJECT_NAME} into current Python environment"
pip install -e "$DEPLOY_DIR"

SCRIPT_BIN=$(python -c "import sysconfig; print(sysconfig.get_path('scripts'))")
INSTALLED_SCRIPT="${SCRIPT_BIN}/${PROJECT_NAME}"

if [ ! -f "$INSTALLED_SCRIPT" ]; then
  echo "ERROR: script not found at ${INSTALLED_SCRIPT}"
  echo "       Check that 'pip install -e .' completed successfully."
  exit 1
fi

echo "▶  Linking ${INSTALLED_SCRIPT} → ${INSTALL_PATH}"
sudo ln -sf "$INSTALLED_SCRIPT" "$INSTALL_PATH"

echo ""
echo "✓  ${PROJECT_NAME} is now available system-wide"
echo "   Open any terminal and run: ${PROJECT_NAME} \"Hello\""
