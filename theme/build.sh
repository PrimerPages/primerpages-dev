#!/bin/bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./build.sh <version>

Examples:
  ./build.sh 1.2.3

Environment:
  GEMSPEC_FILE   Gemspec filename to build (default: jekyll-theme-primerpages.gemspec)
EOF
}

if [[ $# -ne 1 ]]; then
  usage >&2
  exit 1
fi

VERSION="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! [[ "${VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Invalid version format: ${VERSION}" >&2
  echo "Expected format: x.y.z" >&2
  exit 1
fi

shopt -s nullglob
gemspecs=("${SCRIPT_DIR}"/*.gemspec)
shopt -u nullglob

if [[ "${#gemspecs[@]}" -eq 0 ]]; then
  echo "Expected at least one gemspec in ${SCRIPT_DIR}" >&2
  exit 1
fi

GEMSPEC_FILE="${GEMSPEC_FILE:-jekyll-theme-primerpages.gemspec}"
TARGET_GEMSPEC="${SCRIPT_DIR}/${GEMSPEC_FILE}"

if [[ -f "${TARGET_GEMSPEC}" ]]; then
  GEMSPEC="${TARGET_GEMSPEC}"
elif [[ "${#gemspecs[@]}" -eq 1 ]]; then
  GEMSPEC="${gemspecs[0]}"
else
  echo "Found multiple gemspecs in ${SCRIPT_DIR}, but ${GEMSPEC_FILE} was not present:" >&2
  printf ' - %s\n' "${gemspecs[@]##*/}" >&2
  exit 1
fi

GEMSPEC_BASENAME="$(basename "${GEMSPEC}")"
GEM_NAME="$(basename "${GEMSPEC_BASENAME}" .gemspec)"
OUTPUT_GEM="${SCRIPT_DIR}/${GEM_NAME}-${VERSION}.gem"

if [[ ! -f "${GEMSPEC}" ]]; then
  echo "Expected gemspec not found: ${GEMSPEC}" >&2
  exit 1
fi

sed -i.bak -E "s/(spec\.version\s*=\s*['\"])[^'\"]+(['\"])/\1${VERSION}\2/" "${GEMSPEC}"
rm -f "${GEMSPEC}.bak"

rm -f "${OUTPUT_GEM}"

(
  cd "${SCRIPT_DIR}"
  gem build "${GEMSPEC_BASENAME}"
)

if [[ ! -f "${OUTPUT_GEM}" ]]; then
  echo "Expected output gem not found: ${OUTPUT_GEM}" >&2
  exit 1
fi

echo "${OUTPUT_GEM}"
