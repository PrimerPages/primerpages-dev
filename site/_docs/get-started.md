---
title: "Get started"
order: 1
category: Getting started
image: "https://raw.githubusercontent.com/PrimerPages/jekyll-theme-profile/main/screenshot.png"
---

This theme is based on GitHub's primer style. It supports both light and dark modes, and four style options: [appbar](styles/appbar.md), [sidebar](styles/sidebar.md), [stacked](styles/stacked.md), and [topbar](styles/topbar.md),.

![jekyll-theme-profile](https://raw.githubusercontent.com/PrimerPages/jekyll-theme-profile/main/screenshot.png)

## Installation

Add this line to your Jekyll site's `Gemfile`:

```ruby
gem "jekyll-theme-profile"
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install jekyll-theme-profile
```

## Configuration

And add this line to your Jekyll site's `_config.yml`:

```yaml
theme: jekyll-theme-profile
style: topbar # One of "stacked", "sidebar", "topbar", "appbar"
repository: PrimerPages/jekyll-theme-profile # for repository info to be included
repo_info: true # Show the information for the source of this project
user_metadata: true # Show the metadata associated with the user
profile_link: true # Show a link to the github profile for the user
```

Or you can start with one of the [template configs](https://github.com/PrimerPages/primerpages-dev/tree/main/templates){: data-proofer-ignore='' } and copy/customize the profile that best matches your setup.

## Building

Build the site and make it available on a local server

```shell
bundle exec jekyll serve
```
