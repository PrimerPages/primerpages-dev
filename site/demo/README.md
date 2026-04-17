# GitHub Pages Remote Theme Demo

This is a demo repository showcasing how to use a **remote theme** with [GitHub Pages](https://pages.github.com/). Remote themes make it easy to apply and maintain a consistent look and feel across multiple Jekyll sites.

## Live Demo

View the live site: [https://primerpages.github.io/github-pages-demo/](https://primerpages.github.io/github-pages-demo/)

## What This Repo Demonstrates

- Using a `remote_theme` in a Jekyll site hosted on GitHub Pages
- Simple structure for GitHub Pages projects
- How to override theme defaults with custom content

## Setup

To create your own site using a remote theme:

1. Create a new GitHub repository.
2. Add the following to your `_config.yml`:

   ```yaml
   remote_theme: PrimerPages/jekyll-theme-profile@githubpages
   ```

3. Create an `index.md` or `index.html` with your content.
4. Commit and push your changes.
5. Enable GitHub Pages in your repo settings.

## Notes

- GitHub Pages supports remote themes that are compatible with a [certain set](https://pages.github.com/versions/) of plugins. `jekyll-theme-profile` is one of them.
- For other supported themes, see the [GitHub Pages Themes](https://github.com/topics/github-pages-theme) topic.

## License

This project is licensed under the [MIT License](LICENSE).
