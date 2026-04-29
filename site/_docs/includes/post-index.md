---
title: Post Index
category: includes
order: 42
---

The `post-index.html` include file creates a straightforward, list-style layout for displaying groups of posts. It's designed to present posts in a uniform, easy-to-scan format, ideal for archives, category listings, or any situation where a clean, consistent display is desired.

## Parameters

| Parameter              | Default                                          | Description                                                              |
| ---------------------- | ------------------------------------------------ | ------------------------------------------------------------------------ |
| `sections`             | Required                                         | Grouped post sections to display                                         |
| `section_permalink`    | `page.pagination.permalink`                      | The permalink structure for individual sections                         |
| `replace_value`        | None                                             | The value to replace in the `section_permalink` with the section slug   |
| `per_section`          | `page.per_section` or `page.pagination.per_page` | Number of posts to display per section                                   |

## Usage

To use this include in your Jekyll site, you can call it from a layout or another include file like this:

{% raw %}
```liquid
{% include post-index.html
    sections=site.categories
    section_permalink='/category/:name/'
    replace_value=':name'
    per_section=8
%}
```
{% endraw %}

This include is component-oriented: `sections` should be passed explicitly, while `section_permalink` and `per_section` can optionally fall back to page-level pagination values.

### Layout

The `tag_index` layout utilizes `post-index.html` to create a page that showcases posts with various tags.

To use the `tag_index` layout in a page:

```yaml
---
layout: tag_index
title: Tags
---
```

### Demo Page

To see `post-index.html` in action within the `tag_index` layout, visit our demo page:

[Tag Index Demo](../..//tags/index.html){:.btn}

## Functionality

1. For each section in the collection, the include renders a heading and an optional "View all" link.
2. All posts within a section are displayed using `post-card.html`.
3. Posts are arranged in a flex-wrap layout for responsive display.
4. The "View all" link is hidden on smaller screens and displayed on larger screens.
5. If `sections` is missing, the include renders nothing.

## Dependencies

This include depends on:
- `post-card.html`
- Primer CSS classes
- Octicons for the "View all" arrow

## Customization

You can customize the appearance by modifying the HTML structure and CSS classes within the include file.

## Notes

- Ensure that the `post-card.html` include is properly set up in your Jekyll site.
- The "View all" link uses the `section_permalink` and `replace_value` to generate the correct URL for each section.
