#!/usr/bin/env bats

# Load assertion helpers
load 'bats_helper.sh'

setup() {
  # Absolute path to the bump script
  BUMP_SCRIPT="$(realpath .github/bump.sh)"

  # Temp directory for the test repo
  tmpdir="$BATS_TMPDIR/fake_repo"
  mkdir -p "$tmpdir"

  # Copy bump.sh into the temp test repo
  cp "$BUMP_SCRIPT" "$tmpdir/bump.sh"
  chmod +x "$tmpdir/bump.sh"

  cd "$tmpdir"
}

teardown() {
  rm -rf "$tmpdir"
}

@test "bump.sh updates quoted version" {
  mkdir -p theme
  echo 'VERSION = "1.2.3"' > theme/VERSION
  run ./bump.sh 2.0.0
  assert_success
  run grep VERSION theme/VERSION
  assert_output 'VERSION = "2.0.0"'
}

@test "bump.sh updates unquoted version" {
  mkdir -p theme
  echo 'VERSION = 1.2.3' > theme/VERSION
  run ./bump.sh 2.0.0
  assert_success
  run grep VERSION theme/VERSION
  assert_output 'VERSION = 2.0.0'
}

@test "bump.sh updates bare version line" {
  mkdir -p theme
  echo '1.2.3' > theme/VERSION
  run ./bump.sh 2.0.0
  assert_success
  run cat theme/VERSION
  assert_output '2.0.0'
}

@test "bump.sh rejects invalid version" {
  mkdir -p theme
  echo 'VERSION = "1.2.3"' > theme/VERSION
  run ./bump.sh "v2.0"
  assert_failure
  assert_output --partial "Invalid version format"
}

@test "bump.sh uses --version-file flag" {
  echo 'VERSION = "1.2.3"' > custom.txt
  run ./bump.sh 3.0.0 --file custom.txt
  assert_success
  run grep VERSION custom.txt
  assert_output 'VERSION = "3.0.0"'
}

@test "bump.sh uses VERSION_FILE env var" {
  echo 'VERSION = "4.5.6"' > env_version.txt
  VERSION_FILE=env_version.txt run ./bump.sh 5.0.0
  assert_success
  run grep VERSION env_version.txt
  assert_output 'VERSION = "5.0.0"'
}

@test "bump.sh prefers --version-file over env var" {
  echo 'VERSION = "6.6.6"' > ignored.txt
  echo 'VERSION = "7.7.7"' > preferred.txt
  VERSION_FILE=ignored.txt run ./bump.sh 8.8.8 --file preferred.txt
  assert_success
  run grep VERSION preferred.txt
  assert_output 'VERSION = "8.8.8"'
}

@test "bump.sh fails if version file is missing" {
  run ./bump.sh 1.2.3 --file missing.txt
  assert_failure
  assert_output --partial "Version file not found"
}

@test "bump.sh uses VERSION env var when --version is omitted" {
  mkdir -p theme
  echo 'VERSION = "1.2.3"' > theme/VERSION
  VERSION=2.0.0 run ./bump.sh
  assert_success
  run grep VERSION theme/VERSION
  assert_output 'VERSION = "2.0.0"'
}

@test "bump.sh prefers --version over VERSION env var" {
  mkdir -p theme
  echo 'VERSION = "1.2.3"' > theme/VERSION
  VERSION=2.0.0 run ./bump.sh --version 3.0.0
  assert_success
  run grep VERSION theme/VERSION
  assert_output 'VERSION = "3.0.0"'
}
