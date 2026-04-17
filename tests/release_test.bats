#!/usr/bin/env bats

# Load assertion helpers
load 'bats_helper.sh'

setup() {
    # Absolute path to the release script
    RELEASE_SCRIPT="$(realpath .github/release.sh)"

    tmpdir="$BATS_TMPDIR/fake_repo"
    mkdir -p "$tmpdir"
    export HOME="$tmpdir/home"
    mkdir -p "$HOME"
    export PATH="$tmpdir/bin:$PATH"

    # Mock `gem` CLI
    mkdir -p "$tmpdir/bin"
    cat <<EOF >"$tmpdir/bin/gem"
#!/bin/bash
if [[ "\$1" == "build" ]]; then
  echo "  Successfully built RubyGem"
  echo "  File: test-0.1.0.gem"
  touch test-0.1.0.gem
elif [[ "\$1" == "push" ]]; then
  echo "Pushed \$2 to \$4"
fi
EOF
    chmod +x "$tmpdir/bin/gem"

    # Create release script in the test environment
    cp "$RELEASE_SCRIPT" "$tmpdir/release.sh"
    chmod +x "$tmpdir/release.sh"

    cd "$tmpdir"
}

teardown() {
    rm -rf "$tmpdir"
}

@test "Fails when no .gemspec file exists" {
    export RUBYGEMS_API_KEY="fake-key"
    run ./release.sh --dry-run
    assert_failure
    assert_output_contains "Expected exactly one .gemspec file"
}

@test "Fails when multiple .gemspec files exist" {
    export RUBYGEMS_API_KEY="fake-key"
    touch a.gemspec b.gemspec
    run ./release.sh --dry-run
    assert_failure
    assert_output_contains "Expected exactly one .gemspec file"
}

@test "Detects single .gemspec and runs successfully (dry run)" {
    export RUBYGEMS_API_KEY="fake-key"
    echo "Gem::Specification.new { |s| s.name = 'test' }" >test.gemspec
    run ./release.sh --dry-run
    assert_success
    assert_output_contains "Detected gemspec: test.gemspec"
    assert_output_contains "Generated gem file: test-0.1.0.gem"
    assert_output_contains "[DRY RUN] Skipping gem push"
}

@test "Runs successfully with .gemspec passed as argument" {
    export RUBYGEMS_API_KEY="fake-key"
    echo "Gem::Specification.new { |s| s.name = 'test' }" >custom.gemspec
    run ./release.sh custom.gemspec
    assert_success
    assert_output_contains "Starting release for test from custom.gemspec"
    assert_output_contains "Generated gem file: test-0.1.0.gem"
    assert_output_contains "Released test-0.1.0.gem"
}

@test "Handles --dry-run and gemspec together (any order)" {
    export RUBYGEMS_API_KEY="fake-key"
    echo "Gem::Specification.new { |s| s.name = 'test' }" >alt.gemspec
    run ./release.sh --dry-run alt.gemspec
    assert_success
    assert_output_contains "Starting release for test from alt.gemspec"
    assert_output_contains "[DRY RUN] Skipping credential setup"
    assert_output_contains "[DRY RUN] Skipping gem push"
}


@test "Loads .env file and reads RUBYGEMS_API_KEY" {
    echo "RUBYGEMS_API_KEY=env-fake-key" >.env
    echo "Gem::Specification.new { |s| s.name = 'test' }" >test.gemspec
    run ./release.sh --dry-run
    assert_success
    assert_output_contains "Loading environment variables from .env"
}
