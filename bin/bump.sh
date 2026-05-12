#!/bin/bash
set -euo pipefail

# === Defaults ===
DRY_RUN=false
VERSION="${VERSION:-}"

# === Parse arguments ===
while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --version"
        exit 1
      fi
      VERSION="$2"
      shift 2
      ;;
    --file)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --file"
        exit 1
      fi
      VERSION_FILE="$2"
      shift 2
      ;;
    --version-file)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --version-file"
        exit 1
      fi
      VERSION_FILE="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -*)
      echo "Unknown flag: $1"
      exit 1
      ;;
    *)
      if [[ -z "$VERSION" ]]; then
        VERSION="$1"
        shift
      else
        echo "Unexpected argument: $1"
        exit 1
      fi
      ;;
  esac
done

VERSION_FILE="${VERSION_FILE:-theme/VERSION}"

# === Validate input ===
if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 [--version VERSION] [--version-file FILE] [--dry-run]"
  exit 1
fi

if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Invalid version format: $VERSION"
  echo "Expected format: x.y.z (e.g., 1.2.3)"
  exit 1
fi

if [[ ! -f "$VERSION_FILE" ]]; then
  echo "Version file not found: $VERSION_FILE"
  exit 1
fi

# === Main ===

echo "Bumping version to $VERSION in $VERSION_FILE"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "[DRY RUN] Would update version to $VERSION in $VERSION_FILE"
  exit 0
fi

# === Update version in file ===
sed -i.bak -E "s/[0-9]+\.[0-9]+\.[0-9]+/$VERSION/" "$VERSION_FILE"
rm -f "$VERSION_FILE.bak"

echo "Updated to version $VERSION"
