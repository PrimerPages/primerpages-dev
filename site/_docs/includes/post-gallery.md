---
title: Post Gallery
category: includes
order: 42
---

The `post-gallery.html` include file creates a magazine-style layout for displaying groups of posts. It's designed to showcase posts in a visually appealing manner, with the first post of each section displayed prominently and subsequent posts in a more compact format.

## Parameters

| Parameter           | Default                                          | Description                                                           |
| ------------------- | ------------------------------------------------ | --------------------------------------------------------------------- |
| `sections`          | Required                                         | Grouped post sections to display                                      |
| `section_permalink` | `page.pagination.permalink`                      | The permalink structure for individual sections                       |
| `replace_value`     | None                                             | The value to replace in the `section_permalink` with the section slug |
| `per_section`       | `page.per_section` or `page.pagination.per_page` | Number of posts to display per section                                |

## Usage

To use this include in your Jekyll site, you can call it from a layout or another include file like this:

{% raw %}
```liquid
{% include post-gallery.html
    sections=site.categories
    section_permalink='/category/:name/'
    replace_value=':name'
    per_section=4
%}
```
{% endraw %}

This include is component-oriented: `sections` should be passed explicitly, while `section_permalink` and `per_section` can optionally fall back to page-level pagination values.

### Layout

The `category_index` layout utilizes `post-gallery.html` to create a page that showcases posts from various categories.

To use the `category_index` layout in a page:

```yaml
---
layout: category_index
title: Explore Our Categories
---
```

### Demo Page

To see `post-gallery.html` in action within the `category_index` layout, visit our demo page:

[Category Index Demo](../../category/index.html){:.btn}

## Functionality

1. For each section in the collection, the include renders a heading and an optional "View all" link.
2. The first post in each section is displayed using `post-tease-image-card.html`.
3. Subsequent posts use `post-tease-text-card.html`.
4. The layout alternates direction between sections for visual variety.
5. If `sections` is missing, the include renders nothing.

## Dependencies

This include depends on:

- `post-tease-image-card.html`
- `post-tease-text-card.html`
- Primer CSS classes
- Octicons for the "View all" arrow

## Customization

You can customize the appearance by modifying the HTML structure and CSS classes within the include file.

## Notes

- Ensure that the `post-tease-image-card.html` and `post-tease-text-card.html` includes are properly set up in your Jekyll site.
- The `{% raw %}{% cycle '', 'flex-row-reverse' %}{% endraw %}` tag alternates the layout direction for visual interest.
- The "View all" link uses the `section_permalink` and `replace_value` to generate the correct URL for each section.
