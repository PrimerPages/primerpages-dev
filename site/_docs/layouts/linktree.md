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

## Functionality

1. The layout creates a responsive grid of link cards.
2. Each link is displayed as a card with an optional thumbnail or icon.
3. The layout includes a theme toggle button for light/dark mode.
4. It supports optional social links above or below the cards.
5. It applies page-level custom CSS through `css_style`.

## Usage

This example shows a basic Linktree page with various links:

```yaml
---
layout: linktree
links:
  - name: My website
    url: https://www.allisonthackston.com
    thumbnail: https://avatars.githubusercontent.com/u/6098197?v=4
  - name: Github Dashboard
    url: https://dashboard.althack.dev
    thumbnail: https://github.com/athackst/dashboard/raw/main/assets/dashboard.png
  - name: Github Profile
    url: https://github.com/athackst
    octicon: mark-github
  - name: Dockerhub
    url: https://hub.docker.com/u/althack
    thumbnail: https://img.icons8.com/?size=100&id=cdYUlRaag9G9&format=png&color=000000
  - name: VSCode Extensions
    url: https://marketplace.visualstudio.com/publishers/althack
    thumbnail: https://img.icons8.com/?size=100&id=0OQR1FYCuA9f&format=png&color=000000
  - name: Ruby Gems
    url: https://rubygems.org/profiles/althack
    octicon: ruby
  - name: Python packages
    url: https://pypi.org/user/athackst/
    thumbnail: https://pypi.org/static/images/logo-small.8998e9d1.svg
---
```

[Live demo](/demo/linktree){:.btn}

## Customization

1. **Background Image**: Add a `background.image` value to set a custom background.
2. **Custom CSS**: Use the `css_style` parameter to add custom CSS directly in the front matter.
3. **Link Icons**: Use either `thumbnail` for custom images or `octicon` for GitHub's Octicons.
4. **Layout Variations**: The layout supports different styles like topbar, appbar, sidebar, and stacked. Use the appropriate URL to see these variations.
5. **Social Placement**: Set `socials: top` or `socials: bottom` to show your configured social links above or below the link list.

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
    url: /demo/custom-background
    thumbnail: /media/icon-bg.png
  - name: Example Linktree page
    url: /demo/linktree
    thumbnail: /media/links.png
  - name: Example Profile page
    url: /demo/profile
    thumbnail: /media/user-image.jpg
  - name: Example Repositories page
    url: /demo/repositories
    thumbnail: /media/repositories.png
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
