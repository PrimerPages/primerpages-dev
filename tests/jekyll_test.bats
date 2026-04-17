#!/usr/bin/env bats

# Load assertion helpers
load 'bats_helper.sh'

build_site() {
  rm -fr _site

  run bundle install
  assert_success "Could not install bundle"

  run bundle exec jekyll build --config _config.yml
  assert_success "Could not build Jekyll site"
  assert_output_contains "done in"
}

assert_jekyll_version() {
  local expected_v="$1"

  run grep -FR "<h2 id=\"jekyll-version\">Jekyll version</h2>" "_site/index.html"
  assert_success "Missing the Jekyll version heading in _site/index.html"
  run grep -FR "<pre>${expected_v}</pre>" "_site/index.html"
  assert_success "Debug page does not render Jekyll version ${expected_v}"
}

assert_theme() {
  run grep -FR "Made with <a href=\"https://primerpages.github.io/jekyll-theme-profile/\">jekyll theme profile</a>" "_site/index.html"
  assert_success "PrimerPages theme not detected"
}

@test "jekyll-githubpages builds and reports version" {
  pushd "$BATS_TEST_DIRNAME/fixtures/jekyll-githubpages" >/dev/null
    build_site
    assert_jekyll_version "3.10.0"
    assert_theme
  popd >/dev/null
}

@test "jekyll-3.10.0 builds and reports version" {
  pushd "$BATS_TEST_DIRNAME/fixtures/jekyll-3.10.0" >/dev/null
    build_site
    assert_jekyll_version "3.10.0"
    assert_theme
  popd >/dev/null
}

@test "jekyll-4.3.4 builds and reports version" {
  pushd "$BATS_TEST_DIRNAME/fixtures/jekyll-4.3.4" >/dev/null
    build_site
    assert_jekyll_version "4.3.4"
    assert_theme
  popd >/dev/null
}

@test "jekyll-4.4.0 builds and reports version" {
  pushd "$BATS_TEST_DIRNAME/fixtures/jekyll-4.4.0" >/dev/null
    build_site
    assert_jekyll_version "4.4.0"
    assert_theme
  popd >/dev/null
}

@test "jekyll-4.4.1 builds and reports version" {
  pushd "$BATS_TEST_DIRNAME/fixtures/jekyll-4.4.1" >/dev/null
    build_site
    assert_jekyll_version "4.4.1"
    assert_theme
  popd >/dev/null
}
