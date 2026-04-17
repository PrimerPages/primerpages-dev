#!/bin/bash
set -euo pipefail

# === CONFIG ===
RUBYGEMS_HOST="https://rubygems.org"

# === Functions ===

# Automatically detect the only .gemspec file in the current directory
detect_gemspec_file() {
  local files
  mapfile -t files < <(find . -maxdepth 1 -type f -name '*.gemspec')

  if [[ ${#files[@]} -ne 1 ]]; then
    echo "Error: Expected exactly one .gemspec file in the current directory, found ${#files[@]}." >&2
    exit 1
  fi

  # Strip leading ./ for readability and echo result
  echo "${files[0]#./}"
}

# Validate the gemspec file has the right name and exists
validate_gemspec() {
  if [[ "$GEMSPEC_FILE" != *.gemspec ]]; then
    echo "Error: Provided file '$GEMSPEC_FILE' does not end in '.gemspec'" >&2
    exit 1
  fi
  if [[ ! -f "$GEMSPEC_FILE" ]]; then
    echo "Error: File '$GEMSPEC_FILE' does not exist." >&2
    exit 1
  fi
}

# Load environment variables from .env if available
load_env_file() {
  local env_file=".env"
  if [[ -f "$env_file" ]]; then
    echo "Loading environment variables from $env_file..."
    set -a
    source "$env_file"
    set +a
  fi
}

# Extract the gem name from the gemspec
get_gem_name() {
  ruby -e 'puts Gem::Specification.load(ARGV[0]).name' "$1"
}

# Ensure RUBYGEMS_API_KEY is set
setup_rubygems_credentials() {
  if [[ -z "${RUBYGEMS_API_KEY:-}" ]]; then
    echo "RUBYGEMS_API_KEY environment variable is not set."
    exit 1
  fi

  mkdir -p ~/.gem
  echo -e "---\n:rubygems_api_key: $RUBYGEMS_API_KEY" > ~/.gem/credentials
  chmod 0600 ~/.gem/credentials

  # Cleanup credentials file on exit
  trap 'rm -f ~/.gem/credentials' EXIT
  echo "Ruby gem credentials set up"
}

# Build the gem and return the file name
build_gem() {
  local gemspec_file="$1"

  local gem_file
  gem_file=$(gem build "$gemspec_file" | awk '/File:/ { print $2 }')

  if [[ -z "$gem_file" || ! -f "$gem_file" ]]; then
    echo "Failed to build gem. Check your gemspec."
    exit 1
  fi

  echo "$gem_file"
}

# Upload the gem to RubyGems unless it's a dry run
upload_gem() {
  local gem_file="$1"

  echo "Publishing $gem_file to RubyGems..."
  gem push "$gem_file" --host "$RUBYGEMS_HOST"
}

# === Argument Parsing ===

dry_run=false
GEMSPEC_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      dry_run=true
      shift
      ;;
    -*)
      echo "Unknown option: $1"
      print_usage
      ;;
    *.gemspec)
      if [[ -n "$GEMSPEC_FILE" ]]; then
        echo "Error: Multiple .gemspec files specified."
        print_usage
      fi
      GEMSPEC_FILE="$1"
      shift
      ;;
    *)
      echo "Unknown argument: $1"
      print_usage
      ;;
  esac
done

# === Main ===

load_env_file

# Check for DRY_RUN in environment (only if not already set by CLI)
if [[ "$dry_run" == "false" && "${DRY_RUN:-}" == "true" ]]; then
  dry_run=true
fi

# Determine gemspec file if not given
if [[ -z "$GEMSPEC_FILE" ]]; then
  GEMSPEC_FILE="$(detect_gemspec_file)"
  echo "Detected gemspec: $GEMSPEC_FILE"
fi

validate_gemspec
gem_name=$(get_gem_name $GEMSPEC_FILE)
echo "Starting release for $gem_name from $GEMSPEC_FILE"

if [[ "$dry_run" == true ]]; then
  echo "[DRY RUN] Skipping credential setup"
else
  setup_rubygems_credentials
fi

gem_file=$(build_gem "$GEMSPEC_FILE")
echo "Generated gem file: $gem_file"

if [[ "$dry_run" == true ]]; then
  echo "[DRY RUN] Skipping gem push for $gem_file to $RUBYGEMS_HOST/gems/$gem_name"
else
  upload_gem "$gem_file" "$dry_run"
  echo "Released $gem_file to $RUBYGEMS_HOST/gems/$gem_name"
fi
