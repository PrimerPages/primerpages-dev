#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${REPO_ROOT}"

PORT="${PORT:-4000}"
SITE_DIR="${SITE_DIR:-_site}"

cleanup() {
  if [[ -n "${SERVER_PID:-}" ]]; then
    kill "${SERVER_PID}" 2>/dev/null || true
  fi
}

trap cleanup EXIT INT TERM

echo "Serving ${SITE_DIR} at http://localhost:${PORT}"
ruby -run -e httpd "${SITE_DIR}" -p "${PORT}" &
SERVER_PID=$!

echo "Starting Guard..."
bundle exec guard
