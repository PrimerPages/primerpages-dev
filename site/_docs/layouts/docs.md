---
title: Docs layout
category: layouts
order: 24
---

Use the `docs` layout for documentation pages with sidebar navigation, a table of contents, and links to the previous and next pages.

## Set up documentation pages

1. In `_config.yml`, configure a `docs` collection and its page defaults. If you already have a `defaults` list, add the scoped entry to it.

   ```yaml
   collections:
     docs:
       output: true
       sort_by: order
   defaults:
     - scope:
         path: ""
         type: "docs"
       values:
         layout: docs
         permalink: /docs/:path
         toc: true
   ```

2. Create a Markdown file in `_docs`, such as `_docs/get-started.md`:

   ```markdown
   ---
   title: Get started
   description: Set up your first project.
   order: 1
   ---

   ## Before you begin

   Add your documentation here.
   ```

Set `order` in each page's front matter to control the navigation order. To hide a page's table of contents, set `toc: false` in its front matter.

## Configure the edit link

The `docs` layout can display an **Edit this page** link. By default, it uses the repository configured in `_config.yml` and targets the `main` branch:

```yaml
repository: OWNER/REPOSITORY
```

Replace `OWNER` and `REPOSITORY` with your GitHub repository owner and name. If you configure neither a repository nor an edit URL, the layout omits the link.

To use a different repository, branch, or source directory, set `edit_url` in `_config.yml`:

```yaml
edit_url: https://github.com/OWNER/REPOSITORY/edit/BRANCH
```

Replace `BRANCH` with the branch that contains your documentation. If your Jekyll site is in a repository subdirectory, append that directory to the URL. The layout appends the document's source path, such as `_docs/get-started.md`.

You can also set `edit_url` in a page's front matter or in scoped front matter defaults. The layout uses the first nonempty value: the page URL, the site URL, or the URL generated from `repository`. This setting applies only to the `docs` layout.

### Hide the edit link

The edit link is visible when an edit URL is available. To hide it on all docs pages, add this rule to your site's `assets/css/style.scss` or `assets/css/style.css`:

```css
.doc-edit-link {
  display: none;
}
```

To hide it on one page, add the rule through that page's `css_style` front matter. For details, see [Custom styles](../custom-styles.md).

## Example

[View the docs layout demo](/demo/custom-background-docs).
