#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [[ -f "${REPO_ROOT}/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${REPO_ROOT}/.env"
  set +a
fi

${SCRIPT_DIR}/local_build.sh --source site --destination _site
${SCRIPT_DIR}/local_build.sh --source templates/primerpages-minimal --baseurl "/primerpages-minimal" --destination _site/primerpages-minimal
${SCRIPT_DIR}/local_build.sh --source templates/primerpages-recommended --baseurl "/primerpages-recommended" --destination _site/primerpages-recommended
${SCRIPT_DIR}/local_build.sh --source templates/primerpages-gh-pages --baseurl "/primerpages-gh-pages" --destination _site/primerpages-gh-pages
