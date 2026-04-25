#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SOURCE="templates/primerpages-gh-pages"
CONFIG=""
GEMFILE=""
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
    --gemfile)
      GEMFILE="$2"
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

if [[ -z "${GEMFILE}" ]]; then
  echo "--gemfile is required." >&2
  exit 1
fi

THEME_ARGS=(--source "${SOURCE}" --gemfile "${GEMFILE}")
if [[ -n "${CONFIG}" ]]; then
  THEME_ARGS+=(--config "${CONFIG}")
fi

THEME_JSON="$(bash "${SCRIPT_DIR}/local_theme.sh" "${THEME_ARGS[@]}")"

LOCAL_THEME_SOURCE="$(ruby -rjson -e 'puts JSON.parse(STDIN.read).fetch("local_theme_source")' <<< "${THEME_JSON}")"
LOCAL_THEME_CONFIG="$(ruby -rjson -e 'puts JSON.parse(STDIN.read).fetch("local_theme_config")' <<< "${THEME_JSON}")"
BUNDLE_GEMFILE_VALUE="$(ruby -rjson -e 'puts JSON.parse(STDIN.read).fetch("bundle_gemfile")' <<< "${THEME_JSON}")"

echo "Using source: ${LOCAL_THEME_SOURCE}"
echo "Using config: ${LOCAL_THEME_CONFIG}"
echo "Using Gemfile: ${BUNDLE_GEMFILE_VALUE}"

exec env BUNDLE_GEMFILE="${BUNDLE_GEMFILE_VALUE}" \
  bash -lc 'bundle install && bundle exec jekyll serve --source "$1" --config "$2" "${@:3}"' \
  -- \
  "${LOCAL_THEME_SOURCE}" \
  "${LOCAL_THEME_CONFIG}" \
  "${EXTRA_ARGS[@]}"
