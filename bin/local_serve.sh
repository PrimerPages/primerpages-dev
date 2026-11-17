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

SOURCE=""
CONFIG=""
GEMFILE=""
DESTINATION=""
HOST="${HOST:-0.0.0.0}"
FORCE_POLLING="${FORCE_POLLING:-true}"
PAGEFIND_ON_SERVE="${PAGEFIND_ON_SERVE:-true}"
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

THEME_ARGS=(--gemfile "${GEMFILE}" --config "${CONFIG}")

THEME_JSON="$(bash "${SCRIPT_DIR}/local_theme.sh" "${THEME_ARGS[@]}")"

LOCAL_THEME_CONFIG="$(ruby -rjson -e 'puts JSON.parse(STDIN.read).fetch("local_theme_config")' <<< "${THEME_JSON}")"
LOCAL_GEMFILE="$(ruby -rjson -e 'puts JSON.parse(STDIN.read).fetch("local_gemfile")' <<< "${THEME_JSON}")"

echo "Using source: ${SOURCE}"
echo "Using config: ${LOCAL_THEME_CONFIG}"
echo "Using Gemfile: ${LOCAL_GEMFILE}"

SOURCE_ABS="$(cd "$SOURCE" && pwd)"
SOURCE_KEY="${SOURCE//\//-}"

export BUNDLE_GEMFILE="${LOCAL_GEMFILE}"
export BUNDLE_APP_CONFIG="${REPO_ROOT}/.bundle/local-serve/${SOURCE_KEY}"
export BUNDLE_PATH="${REPO_ROOT}/vendor/local-serve/${SOURCE_KEY}/bundle"

bundle install

JEKYLL_CMD=(bundle exec jekyll)
if [[ "${PAGEFIND_ON_SERVE}" != "false" ]]; then
  if command -v npx >/dev/null 2>&1; then
    JEKYLL_CMD=(bundle exec ruby "${SCRIPT_DIR}/pagefind_serve.rb")
  else
    echo "Warning: npx not found; continuing without a Pagefind search index." >&2
  fi
fi

SERVE_CMD=(
  "${JEKYLL_CMD[@]}" serve
  --source "${SOURCE}"
  --config "${LOCAL_THEME_CONFIG}"
  --destination "${DESTINATION}"
  --host "${HOST}"
  --livereload
)

if [[ "${FORCE_POLLING}" != "false" ]]; then
  SERVE_CMD+=(--force_polling)
fi

SERVE_CMD+=("${EXTRA_ARGS[@]}")

"${SERVE_CMD[@]}"
