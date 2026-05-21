#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SITE_DIR="${SCRIPT_DIR}/_site"

cd "${SCRIPT_DIR}"

export BUNDLE_GEMFILE="${SCRIPT_DIR}/Gemfile"
export BUNDLE_APP_CONFIG="${SCRIPT_DIR}/.bundle"
export BUNDLE_PATH="${SCRIPT_DIR}/vendor/bundle"

bundle install

rm -rf "${SITE_DIR}"
mkdir -p "${SITE_DIR}"

build_version() {
  local version="$1"
  local destination="${SITE_DIR}/${version}"

  bundle exec jekyll build \
    --source "${SCRIPT_DIR}" \
    --config "${SCRIPT_DIR}/_config.yml" \
    --destination "${destination}" \
    --baseurl "/${version}"
}

build_version "dev"
build_version "1.2.3"

cp "${SCRIPT_DIR}/versions.json" "${SITE_DIR}/versions.json"

rm -f "${SITE_DIR}/latest"
ln -s "1.2.3" "${SITE_DIR}/latest"

cat > "${SITE_DIR}/index.html" <<'HTML'
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Redirecting</title>
  <noscript>
    <meta http-equiv="refresh" content="1; url=latest/" />
  </noscript>
  <script>
    window.location.replace(
      "latest/" + window.location.search + window.location.hash
    );
  </script>
</head>
<body>
  Redirecting to <a href="latest/">latest/</a>...
</body>
</html>
HTML
