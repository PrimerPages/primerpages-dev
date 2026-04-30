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

usage() {
  cat <<'EOF'
Usage:
  .github/local_theme.sh --gemfile <path> [options]

Options:
  --gemfile <path>  Gemfile to use for the temporary local-theme bundle (required)
  --config <path>  Config file path (default: <source>/_config.yml)
  -h, --help       Show this help

Output:
  Prints a JSON object with:
    local_theme_config
    local_gemfile
EOF
}

CONFIG=""
GEMFILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --gemfile)
      GEMFILE="$2"
      shift 2
      ;;
    --config)
      CONFIG="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

THEME_DIR="${REPO_ROOT}/theme"

if [[ ! -d "${THEME_DIR}" ]]; then
  echo "Local theme directory not found: ${THEME_DIR}" >&2
  exit 1
fi

if [[ -z "${GEMFILE}" ]]; then
  echo "--gemfile is required." >&2
  exit 1
fi

if [[ "${GEMFILE}" = /* ]]; then
  GEMFILE_PATH="${GEMFILE}"
else
  GEMFILE_PATH="${REPO_ROOT}/${GEMFILE}"
fi

if [[ ! -f "${GEMFILE_PATH}" ]]; then
  echo "Gemfile not found: ${GEMFILE_PATH}" >&2
  exit 1
fi

if [[ -z "${CONFIG}" ]]; then
  echo "--config is required." >&2
  exit 1
fi

if [[ "${CONFIG}" = /* ]]; then
  CONFIG_PATH="${CONFIG}"
else
  CONFIG_PATH="${REPO_ROOT}/${CONFIG}"
fi


if [[ ! -f "${CONFIG_PATH}" ]]; then
  echo "Config file not found: ${CONFIG_PATH}" >&2
  exit 1
fi

TMP_GEMFILE="$(mktemp /tmp/Gemfile.local-theme.XXXXXX)"
TMP_CONFIG="$(mktemp /tmp/_config.local-theme.XXXXXX.yml)"

cp "${GEMFILE_PATH}" "${TMP_GEMFILE}"
cp "${CONFIG_PATH}" "${TMP_CONFIG}"

THEME_LINE="gem 'jekyll-theme-profile', path: '${THEME_DIR}'"
if grep -Eq "^[[:space:]]*gem[[:space:]]+['\"]jekyll-theme-profile['\"]" "${TMP_GEMFILE}"; then
  REWRITE_FILE="$(mktemp /tmp/Gemfile.local-theme.rewrite.XXXXXX)"
  awk -v repl="${THEME_LINE}" '
    BEGIN { replaced = 0 }
    {
      if ($0 ~ /^[[:space:]]*gem[[:space:]]+["\047]jekyll-theme-profile["\047]/) {
        if (!replaced) {
          print repl
          replaced = 1
        }
        next
      }
      print
    }
    END {
      if (!replaced) {
        print repl
      }
    }
  ' "${TMP_GEMFILE}" > "${REWRITE_FILE}"
  mv "${REWRITE_FILE}" "${TMP_GEMFILE}"
else
  printf "\n%s\n" "${THEME_LINE}" >> "${TMP_GEMFILE}"
fi

if grep -Eq "^[[:space:]]*remote_theme:[[:space:]]*" "${TMP_CONFIG}"; then
  sed -E -i "s|^[[:space:]]*remote_theme:[[:space:]]*.*$|theme: jekyll-theme-profile|" "${TMP_CONFIG}"
fi

printf '{"local_theme_config":"%s","local_gemfile":"%s"}\n' \
  "${TMP_CONFIG}" \
  "${TMP_GEMFILE}"
