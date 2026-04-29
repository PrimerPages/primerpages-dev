---
title: Post Layout
category: layouts
order: 23
---

The **post** layout is designed for full blog posts. It renders a large hero image, post metadata, optional embedded video, tag links, an optional table of contents, and related posts.

## Usage

To use the Post layout in your Jekyll site, create a post with the following front matter:

```yaml
---
layout: post
title: My Post
description: A short summary of the post
---
```

## Parameters

The Post layout accepts these commonly used parameters in front matter:

| Parameter          | Default                                   | Description                                                    |
| ------------------ | ----------------------------------------- | -------------------------------------------------------------- |
| `layout`           | Required                                  | Must be set to `post`                                          |
| `title`            | Required                                  | Post title shown in the hero section                           |
| `description`      | None                                      | Short summary shown below the title                            |
| `image`            | `site.image` or `/assets/img/default.png` | Hero image for the post                                        |
| `author`           | `site.github.owner.name` or login         | Display name in post metadata                                  |
| `date`             | Filename date                             | Publication date shown in the header                           |
| `video`            | None                                      | Optional embed URL rendered above the content                  |
| `toc`              | `false` unless set                        | Shows a table of contents when headings are present            |
| `tags`             | None                                      | Tag list rendered below the content when tag pages are enabled |
| `related_by`       | `site.related_by`                         | Controls related-post matching                                 |
| `related_limit`    | `site.related_limit` or `3`               | Maximum number of related posts                                |
| `related_template` | `post-card.html`                          | Include used to render related posts                           |

## Functionality

1. Renders a full-width post header with title, description, and image.
2. Shows author and publication date metadata.
3. Adds sharing links for X, Facebook, and LinkedIn.
4. Supports optional embedded video content through `page.video`.
5. Links tags to generated tag pages when `site.tag_page_dir` is configured.
6. Shows a table of contents when `toc: true` and the content contains headings.
7. Includes the related-posts section at the bottom of the page.

## Example Usage

```yaml
---
layout: post
title: Building a theme site
description: Notes from setting up a theme-based Jekyll project
image: /media/cover.jpg
author: Primer Pages
toc: true
tags: [jekyll, theme]
related_by: "tags or categories"
---
```

## Demo

[Live demo](/demo/topbar/post){:.btn}

## Notes

- Tag links are generated only when tag pages are configured.
- The related-post section can be tuned with the settings documented in [Theme configuration](../configuration.md#related).
- The table of contents appears only when `toc` is enabled and the post has headings.
