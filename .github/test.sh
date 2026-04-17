#!/bin/bash
set -euo pipefail
BASEURL=${BASEURL:-""}
HOSTURL=${HOSTURL:-""}
REPO_NAME=${REPO_NAME:-"primerpages-dev"}
SOURCE_DIR="_site"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source)
      SOURCE_DIR="$2"
      shift 2
      ;;
    --baseurl)
      BASEURL="$2"
      shift 2
      ;;
    --hosturl)
      HOSTURL="$2"
      shift 2
      ;;
    --ignore-urls)
      IGNORE_URLS="$2"
      shift 2
      ;;
    --repo)
      REPO_NAME="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      echo "Usage: $0 [--source <dir>] [--baseurl <value>] [--hosturl <value>] [--ignore-urls <value>] [--repo <value>]" >&2
      exit 1
      ;;
  esac
done

IGNORE_URLS=${IGNORE_URLS:-"/https://github.com/PrimerPages/$REPO_NAME/edit/main/,/https://www.github.com/PrimerPages/$REPO_NAME/blob/main/"}

# Build the swap string conditionally
swap_urls=""
HOSTURL_NORMALIZED="${HOSTURL//\\:/:}"
HOSTURL_ESCAPED="${HOSTURL_NORMALIZED//:/\\:}"

if [ -n "$HOSTURL" ]; then
  # When HOSTURL is non-blank, add the swap rule.
  swap_urls="${HOSTURL_ESCAPED}${BASEURL}:"
fi

if [ -n "$BASEURL" ]; then
  # If there's already a swap rule, add a comma separator.
  if [ -n "$swap_urls" ]; then
    swap_urls+=","
  fi
  # Add the BASEURL swap rule.
  swap_urls+="^${BASEURL}:"
fi

# Prepare swap_urls flag if necessary
swap_urls_flag=""
if [ -n "$swap_urls" ]; then
  swap_urls_flag="--swap-urls $swap_urls"
fi

# Prepare ignore_urls flag if necessary
ignore_urls_flag=""
if [ -n "$IGNORE_URLS" ]; then
  ignore_urls_flag="--ignore-urls $IGNORE_URLS"
fi

# Run htmlproofer with appropriate flags
echo "Running htmlproofer $swap_urls_flag $ignore_urls_flag $SOURCE_DIR"
bundle exec htmlproofer $swap_urls_flag $ignore_urls_flag "$SOURCE_DIR"
