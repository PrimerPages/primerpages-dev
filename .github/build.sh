#!/bin/bash
set -euo pipefail

SOURCE="site/"
CONFIG="site/_config.yml"
DESTINATION=""
EXTRA_ARGS=()

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
    --)
      shift
      EXTRA_ARGS+=("$@")
      break
      ;;
    *)
      EXTRA_ARGS+=("$1")
      shift
      ;;
  esac
done

BUILD_ARGS=(--source "${SOURCE}" --config "${CONFIG}")
if [[ -n "${DESTINATION}" ]]; then
  BUILD_ARGS+=(--destination "${DESTINATION}")
fi
BUILD_ARGS+=("${EXTRA_ARGS[@]}")

bundle install
bundle exec jekyll build "${BUILD_ARGS[@]}"
