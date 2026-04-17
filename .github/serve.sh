#!/bin/bash
set -e

bundle install
bundle exec jekyll serve \
  --config site/_config.yml \
  --source site/ \
  --watch --livereload --incremental --port 4000
