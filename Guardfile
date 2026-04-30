# Guardfile

ignore(%r{^_site/})
ignore(%r{(^|/)\.jekyll-cache/})
ignore(%r{(^|/)\.jekyll-metadata$})
ignore(%r{(^|/)\.sass-cache/})
ignore(%r{(^|/)\.bundle/})
ignore(%r{(^|/)vendor/bundle/})

def build_all
  system(".github/local_build.sh --source site --destination _site -- --incremental")
  system(".github/local_build.sh --source templates/primerpages-minimal --baseurl /primerpages-minimal --destination _site/primerpages-minimal -- --incremental")
  system(".github/local_build.sh --source templates/primerpages-recommended --baseurl /primerpages-recommended --destination _site/primerpages-recommended -- --incremental")
  system(".github/local_build.sh --source templates/primerpages-gh-pages --baseurl /primerpages-gh-pages --destination _site/primerpages-gh-pages -- --incremental")
end

guard :livereload, port: 35730 do
  watch(%r{^_site/.+})
end

guard :shell, all_on_start: false do
  # per-site rebuilds
  watch(%r{^site/(?!\.jekyll-cache/|\.bundle/|vendor/bundle/).+}) do
    puts "site change detected"
    system(".github/local_build.sh --source site --destination _site -- --incremental")
  end

  watch(%r{^templates/primerpages-minimal/(?!\.jekyll-cache/|\.bundle/|vendor/bundle/).+}) do
    puts "templates/primerpages-minimal change detected"
    system(".github/local_build.sh --source templates/primerpages-minimal --baseurl /primerpages-minimal --destination _site/primerpages-minimal -- --incremental")
  end

  watch(%r{^templates/primerpages-recommended/(?!\.jekyll-cache/|\.bundle/|vendor/bundle/).+}) do
    puts "templates/primerpages-recommended change detected"
    system(".github/local_build.sh --source templates/primerpages-recommended --baseurl /primerpages-recommended --destination _site/primerpages-recommended -- --incremental")
  end

  watch(%r{^templates/primerpages-gh-pages/(?!\.jekyll-cache/|\.bundle/|vendor/bundle/).+}) do
    puts "templates/primerpages-gh-pages change detected"
    system(".github/local_build.sh --source templates/primerpages-gh-pages --baseurl /primerpages-gh-pages --destination _site/primerpages-gh-pages -- --incremental")
  end

  # global rebuild when theme changes
  watch(%r{^theme/}) do
    puts "Theme change detected:"
    build_all
  end
end
