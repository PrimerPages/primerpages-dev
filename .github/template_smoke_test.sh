#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SOURCE=""
CONFIG=""
DESTINATION=""
GEMFILE=""

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
    --gemfile)
      GEMFILE="$2"
      shift 2
      ;;
    --destination)
      DESTINATION="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      echo "Usage: $0 --gemfile <path> [--source <path>] [--config <path>] [--destination <path>]" >&2
      exit 1
      ;;
  esac
done

if [[ ! -d "${SOURCE}" ]]; then
  echo "Source directory not found: ${SOURCE}" >&2
  exit 1
fi

if [[ -z "${GEMFILE}" ]]; then
  GEMFILE="${SOURCE}/Gemfile"
fi

if [[ -z "${CONFIG}" ]]; then
  CONFIG="${SOURCE}/_config.yml"
fi

if [[ -z "${DESTINATION}" ]]; then
  DESTINATION="${SOURCE}/_site"
fi

BUILD_ARGS=(--source "templates/${SOURCE}" --gemfile "${GEMFILE}" --config "${CONFIG}" --destination "${DESTINATION}")


bash "${SCRIPT_DIR}/local_build.sh" "${BUILD_ARGS[@]}"
bash "${SCRIPT_DIR}/test.sh" --source "${DESTINATION}" --repo "${SOURCE}" --hosturl "https://github.com/PrimerPages" --baseurl "/${SOURCE}"
