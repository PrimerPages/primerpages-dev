#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SOURCE="primerpages-gh-pages"
CONFIG=""
DESTINATION="_site"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source)
      SOURCE="$2"
      shift 2
      ;;
    --config)
      CONFIG="$2"
      shift 2
      ;;
    --destination)
      DESTINATION="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      echo "Usage: $0 [--source <path>] [--config <path>] [--destination <path>]" >&2
      exit 1
      ;;
  esac
done

BUILD_ARGS=(--source "templates/${SOURCE}")
if [[ -n "${CONFIG}" ]]; then
  BUILD_ARGS+=(--config "${CONFIG}")
fi
BUILD_ARGS+=(--destination "${DESTINATION}")

bash "${SCRIPT_DIR}/local_build.sh" "${BUILD_ARGS[@]}"
bash "${SCRIPT_DIR}/test.sh" --source "${DESTINATION}" --repo "${SOURCE}" --hosturl "https://github.com/PrimerPages" --baseurl "/${SOURCE}"
