---
title: Category Index Layout
category: layouts
order: 28
---

The **category_index** layout renders an index of categories and their posts. It is designed to work with generated category pages or a category collection built from `site.categories`.

## Usage

Create a category index page like this:

```yaml
---
layout: category_index
title: Categories
---
```

## Parameters

| Parameter              | Default                                                                 | Description                                |
| ---------------------- | ----------------------------------------------------------------------- | ------------------------------------------ |
| `layout`               | Required                                                                | Must be set to `category_index`            |
| `title`                | `Category`                                                              | Page title                                 |
| `categories`           | `site.categories`                                                       | Category collection to render              |
| `category_path`        | `site.category_path`                                                    | Base path used to build category links     |
| `pagination.permalink` | `site.autopages.categories.permalink` or generated from `category_path` | Category page permalink pattern            |
| `per_section`          | `page.pagination.per_page`                                              | Number of posts shown per category section |

## Functionality

1. Uses `site.categories` by default.
2. Builds category permalinks from `category_path` or `pagination.permalink`.
3. Renders grouped category sections using `post-gallery.html`.

## Demo

[Live demo](/category/index.html){:.btn}

## Notes

- This layout complements the setup described in [Category pages](../plugins/category-pages.md).
- If you want more control over category permalinks, set `pagination.permalink` explicitly.
