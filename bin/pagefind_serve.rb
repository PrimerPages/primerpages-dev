# frozen_string_literal: true

require "jekyll"

# Index the final HTML on every build, after Jekyll has cleaned its destination.
Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll.logger.info "Pagefind:", "Indexing #{site.dest}"
  unless system("npx", "-y", "pagefind", "--site", site.dest)
    Jekyll.logger.warn "Pagefind:", "Index generation failed; continuing without a search index."
  end
end

load Gem.bin_path("jekyll", "jekyll")
