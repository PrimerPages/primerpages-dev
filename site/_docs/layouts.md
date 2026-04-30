---
title: "Advanced theme settings"
category: advanced
order: 50
published: false
---

Layouts in Jekyll define the structure and appearance of pages, making it easier to keep a consistent design across your site while supporting different kinds of content. Below are examples of each layout, along with configuration details and usage notes.

## Docs

This layout is ideal for documentation and follows the visual structure used on [GitHub Docs](https://docs.github.com).

[Live demo](index.html){:.btn}

**_config.yml**

```yaml
collections:
  docs:
    output: true
    sort_by: order
defaults:
  - scope:
      path: "" # an empty string here means all files in the project
      type: "docs"
    values:
      layout: "docs"
      image: /assets/img/default.png # The default image used for social and posts.
      permalink: /docs/:path
      toc: true
```

**markdown front matter**

```yaml
---
title: Documentation
layout: docs
---
```

## Landing

This layout includes your `site.nav` links and repository card.

[Live demo](../index.md){:.btn}

**_config.yml**

```yaml

repo_info: true # Show the information for the source of this project
user_metadata: true # Show the metadata associated with the user
profile_link: true # Show a link to the user's GitHub profile

####################
# Navigation links
nav:
  - name: Topbar
    url: /topbar.html
  - name: Appbar
    url: /appbar.html
  - name: Sidebar
    url: /sidebar.html
  - name: Stacked
    url: /stacked.html
```

**markdown front matter**

```yaml
---
layout: landing
---
```

## Linktree

This layout provides a Linktree-style view for your page.

[Live demo](../linktree.md){:.btn}

**_config.yml**

```yaml
####################
# List of links for link cards
links:
  - name: Example page with topbar
    url: /demo/topbar/page
    thumbnail: /media/topbar-icon.png
  - name: Example page with appbar
    url: /demo/appbar/page
    thumbnail: /media/appbar-icon.png
  - name: Example page with sidebar
    url: /demo/sidebar/page
    thumbnail: /media/sidebar-icon.png
  - name: Example page with stacked header
    url: /demo/stacked/page
    thumbnail: /media/stacked-icon.png
  - name: Example custom background
    url: /background
    thumbnail: /media/icon-bg.png
  - name: Example Linktree page
    url: /linktree
    thumbnail: /media/links.png
  - name: Example Profile page
    url: /profile
    thumbnail: /media/user-image.jpg
  - name: Example Repositories page
    url: /repositories
    thumbnail: /media/repositories.png
```

**markdown front matter**

```yaml
---
layout: linktree
title: Linktree
links:
  - name: Example page with topbar
    url: /demo/topbar/page
    thumbnail: /media/topbar-icon.png
  - name: Example page with appbar
    url: /demo/appbar/page
    thumbnail: /media/appbar-icon.png
  - name: Example page with sidebar
    url: /demo/sidebar/page
    thumbnail: /media/sidebar-icon.png
  - name: Example page with stacked header
    url: /demo/stacked/page
    thumbnail: /media/stacked-icon.png
  - name: Example custom background
    url: /background
    thumbnail: /media/icon-bg.png
  - name: Example Linktree page
    url: /linktree
    thumbnail: /media/links.png
  - name: Example Profile page
    url: /profile
    thumbnail: /media/user-image.jpg
  - name: Example Repositories page
    url: /repositories
    thumbnail: /media/repositories.png
```

## Profile

A profile page similar to the one on GitHub.

[Live demo](../profile.md){:.btn}

**_config.yml**

```yaml
# The user/project avatar.  If not set the avatar of the project owner will be used.
user_image: /media/user-image.jpg
repo_info: true # Show the information for the source of this project
user_metadata: true # Show the metadata associated with the user
profile_link: true # Show a link to the user's GitHub profile
```

**markdown page**

```md
---
layout: profile
---
```

## Repositories

A view of all of your repositories

[Live demo](../repositories.md){:.btn}

**_config.yml**

```yaml
###################
# Repositories to show on home page
repositories:
  sort_by: stars
  # sort_by options:
  #   - pushed
  #   - stars
  limit: 24
  exclude:
    archived: true
    forks: true
    repositories:
      # - list of repositories to exclude
```

**markdown page**
```md
---
layout: repositories
title: My Repositories
---
```

## Page

The basic layout for standalone markdown content pages.

[More details](layouts/page.md){:.btn}

## Post

The full blog post layout with hero media, metadata, sharing links, optional table of contents, tags, and related posts.

[More details](layouts/post.md){:.btn}

## Paginate

A paginated blog index that renders posts as cards.

[More details](layouts/paginate.md){:.btn}

## Tags

An index view of all of your tags

[Live demo](../tags/index.html){:.btn}

**_config.yml**

```yaml
# jekyll-tagging settings
# Include `gem jekyll-tagging` in your gemfile
tag_page_layout: tags
tag_page_dir: tags
# related
related_by: "tags or categories"
```

**markdown page**

```md
---
title: Tags
layout: tag_index
---
```

## Tag Index

This layout renders a grouped index of tags and their posts.

[More details](layouts/tag_index.md){:.btn}

# Categories

An index view of all of your categories

[Live demo](../category/index.html){:.btn}

**_config.yml**

```yaml
# jekyll-category-pages settings
category_path: category
category_layout: category_layout.html
```

**markdown page**

```md
---
title: Category
layout: category_index
---

```

## Category Index

This layout renders a grouped index of categories and their posts.

[More details](layouts/category_index.md){:.btn}
