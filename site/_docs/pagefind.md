---
title: "Search with Pagefind"
category: Advanced
order: 90
---

PrimerPages provides optional site search with [Pagefind](https://pagefind.app/).
To use search, enable it in your site configuration and generate an index after
Jekyll builds your site. Search runs in the visitor's browser; you don't need a
search server.

## Before you begin

Install Node.js and npm on the machine that builds your site to use the `npx`
commands in this guide. If you prefer to build without Node.js, see
[Pagefind's installation options](https://pagefind.app/docs/installation/) for
standalone binaries and a Python wrapper.

The `primerpages-docs` and `primerpages-recommended` templates enable search and
include the indexing step in their deployment workflows. The `primerpages-minimal` and `primerpages-gh-pages` templates leave search disabled.

## Enable search

In your site's `_config.yml`, add the following settings:

```yaml
search:
  enabled: true
  max_results: 8
```

`max_results` limits the number of results shown in the dialog. To disable search, set `enabled: false` or remove the `search` settings.

The header displays a search button beside the color-mode button. On mobile and
in the collapsed sidebar, the button displays a search icon. Click the button or
press `/` to open the dialog. Enter at least two characters to search. Use the
arrow keys to select a result and press Enter to open it. To close the dialog,
press Escape or click the close button.

## Build and preview search

1. In your site directory, build the HTML:

   ```sh
   bundle exec jekyll build
   ```

2. Generate the search index and start a preview server:

   ```sh
   npx -y pagefind --site _site --serve
   ```

   If you use a custom Jekyll output directory, replace `_site` with that path.

3. Open the URL printed by Pagefind and search for text from one of your pages.

After changing content, rebuild Jekyll and rerun Pagefind. `jekyll serve` alone
doesn't update the search index.

## Deploy search

Run Pagefind after Jekyll builds, then publish the generated HTML and search
index together. You can upload the output as a Pages artifact or commit it to a
publishing branch. GitHub's built-in Jekyll build doesn't run Pagefind for you.

### Publish a Pages artifact

For GitHub Pages, in **Settings > Pages > Build and deployment**, set **Source**
to **GitHub Actions**.

In your existing deployment workflow, run Pagefind after Jekyll builds and before
you upload the site. The build runner must have Ruby, Bundler, Node.js, and npm
installed.

{% raw %}
```yaml
- name: Set up Pages
  id: pages
  uses: actions/configure-pages@v6

- name: Build HTML
  run: >-
    bundle exec jekyll build
    --baseurl "${{ steps.pages.outputs.base_path }}"
    --destination _site

- name: Build search index
  run: npx -y pagefind --site _site

- name: Upload site
  uses: actions/upload-pages-artifact@v5
  with:
    path: _site
```
{% endraw %}

Keep the deployment job that publishes this artifact with `actions/deploy-pages`.
For a complete workflow, see [Using with GitHub Actions](github-action.md).

Pagefind writes its files to `_site/pagefind/`. Publish the entire `_site`
directory, including `pagefind/`. For a project site at
`https://example.github.io/my-project/`, Jekyll's `baseurl` is `/my-project`.
The workflow sets this value automatically. The search bundle remains at
`_site/pagefind/` on disk and is served at `/my-project/pagefind/`.

### Publish prebuilt files from a branch

If your workflow commits build output to a branch such as `gh-pages`, you can use
**Deploy from a branch**:

1. Build Jekyll and run Pagefind as described in [Build and preview search](#build-and-preview-search), without `--serve`.
2. Add an empty `.nojekyll` file to the output directory to prevent another Jekyll build:

   ```sh
   touch _site/.nojekyll
   ```

3. Commit the contents of `_site`, including `pagefind/` and `.nojekyll`, to your publishing branch.
4. In **Settings > Pages**, select **Deploy from a branch**, then select the publishing branch and folder.

Pushes made with a workflow's `GITHUB_TOKEN` don't trigger a Pages build. For
automated branch publishing, use authentication that triggers Pages, such as a
personal access token. See [GitHub's publishing source guide](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site).

## Troubleshoot search

| Problem | Solution |
| --- | --- |
| The search button is missing. | Enable `search.enabled` and rebuild Jekyll. On mobile, look for the search icon beside the color-mode button. |
| The dialog displays "Search is unavailable". | Check that `pagefind/pagefind.js` is in your published output. Verify that Jekyll's `baseurl` matches your site's URL path. |
| Results are outdated or missing pages. | Run Pagefind after the final Jekyll build and publish the regenerated index. |

To control which pages and content appear in results, see
[Pagefind's indexing guide](https://pagefind.app/docs/indexing/). PrimerPages
provides the search interface, so you don't need to add Pagefind's default UI.
