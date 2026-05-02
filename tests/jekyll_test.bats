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

assert_versioned_docs() {
  local page="_site/dev/docs/get-started/index.html"
  local release_page="_site/1.2.3/docs/get-started/index.html"

  run test -f "$page"
  assert_success "Versioned docs page was not generated"
  run test -f "$release_page"
  assert_success "Release docs page was not generated"

  run grep -FR "data-version-selector" "$page"
  assert_success "Version selector did not render on docs page"
  run grep -FR "data-version-warning" "$page"
  assert_success "Version warning did not render on docs page"
  run grep -FR "data-doc-version=\"dev\"" "$page"
  assert_success "Docs page did not expose the configured doc version"
  run grep -FR "data-versioned-docs=\"true\"" "$page"
  assert_success "Docs page did not expose versioned docs mode"
  run grep -FR "data-default-doc-alias=\"latest\"" "$page"
  assert_success "Docs page did not expose the default doc alias"
  run grep -FR "data-versions-json=\"/versions.json\"" "$page"
  assert_success "Docs page did not expose the versions JSON URL"
  run grep -FR "/assets/js/versioning.js" "$page"
  assert_success "Versioning script was not included"
  run grep -FR "data-doc-version=\"1.2.3\"" "$release_page"
  assert_success "Release docs page did not expose its doc version"

  run test -f "_site/versions.json"
  assert_success "versions.json was not copied into the built site"
  run test -f "_site/index.html"
  assert_success "Root redirect index.html was not generated"
  run grep -FR "latest/" "_site/index.html"
  assert_success "Root redirect does not point at latest"
  run test -L "_site/latest"
  assert_success "latest alias was not generated as a symlink"
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

@test "versioned-docs builds version selector fixture" {
  pushd "$BATS_TEST_DIRNAME/fixtures/versioned-docs" >/dev/null
    run bash build.sh
    assert_success "Could not build versioned docs fixture"
    assert_versioned_docs
  popd >/dev/null
}
