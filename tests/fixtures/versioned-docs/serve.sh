#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SITE_DIR="${SCRIPT_DIR}/_site"
PORT=4000

bash "${SCRIPT_DIR}/build.sh"

ruby -run -e httpd "${SITE_DIR}" -p "${PORT}"
