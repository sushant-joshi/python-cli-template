#!/bin/bash
# Deploys {{PROJECT_NAME}} as a system-wide command available from any terminal.
# Bakes the project path into a wrapper script and places it in /usr/local/bin.
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_NAME="{{PROJECT_NAME}}"
INSTALL_PATH="/usr/local/bin/${PROJECT_NAME}"

echo ""
echo "▶  Installing dependencies"
(cd "$PROJECT_DIR" && poetry install)

echo ""
echo "▶  Writing wrapper to ${INSTALL_PATH}"
WRAPPER=$(mktemp)
cat > "$WRAPPER" << EOF
#!/bin/bash
cd "${PROJECT_DIR}" && poetry run ${PROJECT_NAME} "\$@"
EOF

sudo mv "$WRAPPER" "$INSTALL_PATH"
sudo chmod +x "$INSTALL_PATH"

echo ""
echo "✓  ${PROJECT_NAME} is now available system-wide"
echo "   Open any terminal and run: ${PROJECT_NAME} \"Hello\""
