---
layout: profile
posts_limit: 3
---

# PrimerPages theme Github Pages Branch Deploy Template

Use this template when you want the standard GitHub Pages flow: **Deploy from a branch**.

## Contributing

This template is maintained in `primerpages-dev`.

- Source repo: `PrimerPages/primerpages-dev`
- Please open issues and pull requests there, not in the generated template repository.

## What This Template Is For

- `remote_theme: PrimerPages/jekyll-theme-profile` in `_config.yml`
- A starter site structure (`index.md`, `blog/`, `tags/`, docs, and sample posts)
- A setup that works with GitHub Pages branch publishing

## Quick Setup

1. Create a new repository from this template.
2. Update `_config.yml`:
   - `title`
   - `description`
   - `repository` (set to `OWNER/REPO`)
3. Commit and push to your default branch.
4. In GitHub, go to `Settings -> Pages`.
5. Under `Build and deployment`, set:
   - `Source`: `Deploy from a branch`
   - `Branch`: usually `main`
   - `Folder`: `/(root)` (or `/docs` if you intentionally publish from docs)
6. Save and wait for the first deployment.

## Important Notes

- Branch publishing supports only branch + folder as source (`/(root)` or `/docs`).
- Commits made by workflows using `GITHUB_TOKEN` do **not** trigger Pages branch builds.
- If you need custom build behavior, switch Pages source to `GitHub Actions`.

## Verify It Works

- Visit `https://<owner>.github.io/<repo>/` for project pages.
- Confirm this home page renders and nav links work.
- Open `/debug` to inspect the active Jekyll/theme info.

## Reference

- GitHub Docs: [Configuring a publishing source for your GitHub Pages site](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)
