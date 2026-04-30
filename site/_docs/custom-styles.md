---
title: "Custom styles"
order: 100
category: Advanced
---

## Site style

You can override theme styles in `/assets/css/style.css` or `/assets/css/style.scss`. Using Sass is especially helpful when you want to reference Jekyll variables.

## Page style

You can add CSS to any page through the `css_style` variable in front matter.

```yaml
---
css_style: |
    .Link-btn {
        background: rgba(0.1, 0.1, 0.1, 0.4);
        color: #FFFF;
    }
    h1 {
        color: #FFFF;
    }
---

```
