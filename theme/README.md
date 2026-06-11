# PrimerPages Jekyll Theme

PrimerPages is a Jekyll theme for GitHub-flavored project sites, profile pages,
documentation, blogs, and link pages. It is built with GitHub Primer styles and
published as the `jekyll-theme-primerpages` gem.

> [!NOTE]
> This theme was renamed from `jekyll-theme-profile` to
> `jekyll-theme-primerpages`. New sites should use the PrimerPages package name.

## Quick Start

Add the theme to your site's `Gemfile`:

```ruby
source "https://rubygems.org"

gem "jekyll-theme-primerpages"
```

Install the gem:

```sh
bundle install
```

Enable the theme in `_config.yml`:

```yaml
theme: jekyll-theme-primerpages
title: My Site
description: A site built with PrimerPages
```

Create an `index.md` page:

```markdown
---
layout: profile
---

# Hello, PrimerPages
```

Run the site locally:

```sh
bundle exec jekyll serve
```

Then open `http://localhost:4000`.

## Documentation

Full documentation is available at [primerpages.com](https://www.primerpages.com).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development and contribution
guidelines.

## License

The theme is available as open source under the terms of the
[MIT License](LICENSE).
