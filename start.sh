#!/bin/bash
# Usage: ./start.sh <project-name>
set -e

PROJECT_NAME="${1:-}"
SCAFFOLD_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$(pwd)/${PROJECT_NAME}"

# --- Validate ---------------------------------------------------------------

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: ./start.sh <project-name>"
  exit 1
fi

if [ -d "$TARGET_DIR" ]; then
  echo "ERROR: Directory '${PROJECT_NAME}' already exists."
  echo "       Delete it or choose a different name."
  exit 1
fi

if ! docker info > /dev/null 2>&1; then
  echo "ERROR: Docker is not running. Start Docker Desktop and try again."
  exit 1
fi

if ! command -v poetry &> /dev/null; then
  echo "ERROR: poetry not found on PATH."
  echo "       Install: curl -sSL https://install.python-poetry.org | python3"
  exit 1
fi

# --- Generate project -------------------------------------------------------

echo ""
echo "▶  Creating project: ${PROJECT_NAME}  →  ${TARGET_DIR}"
cp -r "$SCAFFOLD_DIR/template" "$TARGET_DIR"

# Substitute {{PROJECT_NAME}} in all template text files (macOS + Linux compatible)
find "$TARGET_DIR" -type f ! -name "*.pyc" | while read -r file; do
  sed -i '' "s/{{PROJECT_NAME}}/${PROJECT_NAME}/g" "$file" 2>/dev/null \
    || sed -i "s/{{PROJECT_NAME}}/${PROJECT_NAME}/g" "$file"
done

# --- Poetry lock ------------------------------------------------------------

echo ""
echo "▶  Generating poetry.lock"
(cd "$TARGET_DIR" && poetry lock --no-update)

# --- Docker build -----------------------------------------------------------

echo ""
echo "▶  Building Docker images: ${PROJECT_NAME}:dev + ${PROJECT_NAME}:test"
docker build -t "${PROJECT_NAME}:dev"  --target dev  "$TARGET_DIR"
docker build -t "${PROJECT_NAME}:test" --target test "$TARGET_DIR"

# --- Tests ------------------------------------------------------------------

echo ""
echo "▶  Running tests"
docker run --rm "${PROJECT_NAME}:test"

# --- Launch -----------------------------------------------------------------

echo ""
echo "▶  Launching app"
echo "   src/ is volume-mounted — edit files locally without rebuilding."
echo ""
echo "   Useful commands:"
echo "     Re-run app:    docker run -it --rm -v \"\$(pwd)/src:/app/src\" ${PROJECT_NAME}:dev"
echo "     Add dep:       cd ${PROJECT_NAME} && poetry add <pkg>"
echo "     Rebuild:       docker build -t ${PROJECT_NAME}:dev --target dev ${TARGET_DIR}"
echo ""

docker run -it --rm \
  -v "$TARGET_DIR/src:/app/src" \
  "${PROJECT_NAME}:dev"
