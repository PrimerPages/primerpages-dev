---
title: Docs Layout
category: layouts
order: 24
---

The **docs** layout is ideal for documentation pages and follows the document style on [GitHub Docs](https://docs.github.com).

## Usage

To use the Docs layout in your Jekyll site, create a new file in your `_docs` collection with the following front matter:

```yaml
---
title: Your Documentation Title
layout: docs
---
```

## Configuration

Add the following to your `_config.yml`:

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
      show_edit_url: true
      toc: true
```

By default, the theme builds the edit link from `site.repository` and points to the current document path on the `main` branch.

If you need a different repository, branch, or base path, you can override it:

```yaml
defaults:
  - scope:
      path: ""
      type: "docs"
    values:
      edit_url: "https://github.com/{user}/{repo}/edit/{branch}"
```

You can hide the edit link entirely:

```yaml
defaults:
  - scope:
      path: ""
      type: "docs"
    values:
      show_edit_url: false
```

## Features

- Automatically generates a table of contents (`toc: true`)
- Uses a default image for social sharing
- Sorts documentation pages by the `order` front matter
- Adds an "Edit this page" link by default when the theme can build one from `site.repository`
- Lets you disable the edit link with `show_edit_url: false`
- Lets you override the generated GitHub edit link base with `edit_url` when needed

## Demo

[Live demo](/demo/custom-background-docs){:.btn}

[Docs section](../index.html){:.btn}

## Notes

- Ensure your documentation files are placed in the `_docs` folder
- Use the `order` front matter to control the sorting of your documentation pages
- The `toc` option automatically generates a table of contents for each page
- `show_edit_url` can be set globally or per page
- `edit_url` is optional and only needed when the generated GitHub edit link is not the right target
