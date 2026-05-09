#!/bin/bash
# Runs {{PROJECT_NAME}} locally via Poetry.
# Usage: ./scripts/run.sh [input]
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

poetry run {{PROJECT_NAME}} "$@"
