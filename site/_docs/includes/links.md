---
title: Links
category: includes
order: 41
---

This include file generates a collection of link cards, typically used for displaying a set of important links on a page.

## Usage

To use this include in your Jekyll theme, add the following line to your template:

{% raw %}
```liquid
{% include links.html links=page.featured_links %}
```
{% endraw %}

## Parameters

This include expects an explicit `include.links` value:

| Variable        | Default  | Description                        |
| --------------- | -------- | ---------------------------------- |
| `include.links` | Required | The collection of links to display |

## Functionality

1. The include renders the provided `include.links` collection.
2. It creates a container for the link cards.
3. It iterates through each link in the collection and includes a `link-card.html` for each one.

## Dependencies

This include file depends on:

1. `link-card.html`: Another include file that defines how each link card is displayed.

## Customization

To customize the appearance of the links collection:

1. Modify the CSS classes in this file to change the layout and spacing.
2. Edit the `link-card.html` include to change how individual links are displayed.
3. Adjust the container structure if you need a different layout for the links.

## Notes

- If `include.links` is not provided, the include renders nothing.
- The layout uses flexbox for responsive design, allowing the links to adapt to different screen sizes.
