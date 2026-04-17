#!/bin/bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  .github/local_theme.sh [options]

Options:
  --source <path>  Template source directory (default: templates/primerpages-gh-pages)
  --config <path>  Config file path (default: <source>/_config.yml)
  -h, --help       Show this help

Output:
  Prints a JSON object with:
    local_theme_source
    local_theme_config
    bundle_gemfile
EOF
}

SOURCE="templates/primerpages-gh-pages"
CONFIG=""

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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
THEME_DIR="${REPO_ROOT}/theme"
CURRENT_GEMFILE="${BUNDLE_GEMFILE:-${REPO_ROOT}/Gemfile}"

if [[ ! -f "${CURRENT_GEMFILE}" ]]; then
  echo "Gemfile not found: ${CURRENT_GEMFILE}" >&2
  exit 1
fi

if [[ ! -d "${THEME_DIR}" ]]; then
  echo "Local theme directory not found: ${THEME_DIR}" >&2
  exit 1
fi

if [[ "${SOURCE}" = /* ]]; then
  SOURCE_DIR="${SOURCE}"
else
  SOURCE_DIR="${REPO_ROOT}/${SOURCE}"
fi

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Template source not found: ${SOURCE_DIR}" >&2
  exit 1
fi

if [[ -n "${CONFIG}" ]]; then
  if [[ "${CONFIG}" = /* ]]; then
    CONFIG_PATH="${CONFIG}"
  else
    CONFIG_PATH="${REPO_ROOT}/${CONFIG}"
  fi
else
  CONFIG_PATH="${SOURCE_DIR}/_config.yml"
fi

if [[ ! -f "${CONFIG_PATH}" ]]; then
  echo "Config file not found: ${CONFIG_PATH}" >&2
  exit 1
fi

TMP_GEMFILE="$(mktemp /tmp/Gemfile.local-theme.XXXXXX)"
TMP_CONFIG="$(mktemp /tmp/_config.local-theme.XXXXXX.yml)"

cp "${CURRENT_GEMFILE}" "${TMP_GEMFILE}"
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

printf '{"local_theme_source":"%s","local_theme_config":"%s","bundle_gemfile":"%s"}\n' \
  "${SOURCE_DIR}" \
  "${TMP_CONFIG}" \
  "${TMP_GEMFILE}"
