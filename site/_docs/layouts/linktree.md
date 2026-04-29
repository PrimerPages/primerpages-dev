---
title: Linktree Layout
category: layouts
order: 22
---

The **linktree** layout is a versatile template for creating a page that displays a collection of important links, similar to the popular Linktree service. This layout is highly customizable and can be used to create both simple and complex link pages.

## Usage

To use the Linktree layout in your Jekyll site, create a new file with the following front matter:

```yaml
---
layout: linktree
---
```

## Parameters

The Linktree layout accepts several parameters in the front matter:

| Parameter          | Default  | Description                                       |
| ------------------ | -------- | ------------------------------------------------- |
| `layout`           | Required | Must be set to `linktree`                         |
| `links`            | `[]`     | An array of link objects to display               |
| `background.image` | None     | Background image URL for the page                 |
| `title`            | None     | Title to display at the top of the page           |
| `css_style`        | None     | Custom CSS to apply to the page                   |
| `socials`          | None     | Optional social link placement: `top` or `bottom` |

Each link object in the `links` array can have the following properties:

| Property    | Description                                             |
| ----------- | ------------------------------------------------------- |
| `name`      | The text to display for the link                        |
| `url`       | The URL the link should point to                        |
| `thumbnail` | URL of an image to use as the link's icon (optional)    |
| `octicon`   | Name of an Octicon to use as the link's icon (optional) |

## Examples

This example shows a basic Linktree page with various links:

```yaml
---
layout: linktree
links:
  - name: My website
    url: https://www.primerpages.com
    thumbnail: /media/user-image.jpg
  - name: My repositories
    url: /demo/repositories
    thumbnail: /media/repositories.png
---
```

[Live demo](/demo/linktree){:.btn}

The following example demonstrates how to customize the Linktree layout with a background image and custom CSS:

```yaml
---
layout: linktree
background:
  image: https://www.allisonthackston.com/assets/img/cover-1920.jpg
title: Linktree
css_style: |
    .Link-btn {
        background: rgba(0.1, 0.1, 0.1, 0.4);
        color: #FFFF;
    }
    h1 {
        color: #FFFF;
    }
    .octicon {
        fill: black;
    }
    a {
        color: #FFFF;
    }
    a:hover {
        text-decoration: none;
        color: var(--color-fg-default);
    }
---
```

[Live demo](/demo/linktree-custom){:.btn}

## Notes

- Ensure all image URLs are correct and accessible.
- The `octicon` property requires the Octicons library to be included in your theme.
- Custom CSS can override the theme's default styles, so use it carefully.
- Background images follow the same `background.image` configuration pattern used elsewhere in the theme.
- The layout is responsive and should work well on various screen sizes.

## Dependencies

This layout may depend on:

1. The `link-card.html` include for rendering individual links.
2. The `toggle.html` include for the theme toggle functionality.
3. Octicons for icon display.

Ensure these dependencies are properly set up in your Jekyll theme for the Linktree layout to function correctly.
