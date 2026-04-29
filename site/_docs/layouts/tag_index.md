---
title: Tag Index Layout
category: layouts
order: 27
---

The **tag_index** layout renders an index of tags and their associated posts. It works with `jekyll-tagging` or other tag-page generation approaches that provide tag collections and permalinks.

## Usage

Create a tag index page like this:

```yaml
---
layout: tag_index
title: Tags
---
```

## Parameters

| Parameter              | Default                                                      | Description                           |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------- |
| `layout`               | Required                                                     | Must be set to `tag_index`            |
| `title`                | `Tags`                                                       | Page title                            |
| `tags`                 | `site.tags`                                                  | Tag collection to render              |
| `tag_path`             | `site.tag_page_dir`                                          | Base path used to build tag links     |
| `pagination.permalink` | `site.autopages.tags.permalink` or generated from `tag_path` | Tag page permalink pattern            |
| `per_section`          | `page.pagination.per_page`                                   | Number of posts shown per tag section |

## Functionality

1. Uses `site.tags` by default.
2. Builds tag permalinks from `tag_path` or `pagination.permalink`.
3. Renders grouped tag sections using `post-index.html`.

## Demo

[Live demo](/tags/index.html){:.btn}

## Notes

- This layout complements the setup described in [Tagging](../plugins/tagging.md).
- If you want more control over tag permalinks, set `pagination.permalink` explicitly.
