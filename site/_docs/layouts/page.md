---
title: Page Layout
category: layouts
order: 20
---

The **page** layout is the simplest content layout in the theme. It wraps your content in the standard site chrome and optionally shows a title and subtype label.

## Usage

To use the Page layout in your Jekyll site, create a page with the following front matter:

```yaml
---
layout: page
title: About
---
```

## Parameters

| Parameter | Default  | Description                                 |
| --------- | -------- | ------------------------------------------- |
| `layout`  | Required | Must be set to `page`                       |
| `title`   | None     | Page title shown above the content          |
| `subtype` | None     | Small label shown above the title           |
| `tag`     | None     | Used as a fallback title in tag-based pages |

## Functionality

1. Renders the page inside the default theme layout.
2. Shows a title when `title` is present.
3. Shows a subtype label above the title when `subtype` is present.
4. Falls back to `page.tag` as the title in tag-oriented pages.

## Example Usage

```yaml
---
layout: page
title: About this site
subtype: Guide
---
```

## Demo

[Live demo](/demo/topbar/page){:.btn}

## Notes

- This is a good default layout for standalone markdown pages.
- If you need repository cards, post timelines, or profile content, use a more specific layout instead.
