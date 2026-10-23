---
title: "Search with Pagefind"
category: Advanced
order: 90
---

PrimerPages uses [Pagefind](https://pagefind.app/) for optional header search.
Pagefind indexes the HTML produced by Jekyll and writes a search bundle alongside your built pages. Visitors search that bundle in their browser, so no search server is required.

## Enable header search

Add this to your site's `_config.yml`:

```yaml
search:
  enabled: true
  max_results: 8
```

Search appears in the appbar, topbar, sidebar, and stacked headers. `max_results` limits the number of results displayed in the dropdown. Set `enabled: false` or remove the block to hide search.

The theme provides the search interface. Enabling it does not generate an index;
your build must run Pagefind after Jekyll.

## Install Pagefind

Choose an installation method for your build machine:

| Method | Requirements | Index command |
| --- | --- | --- |
| npm wrapper | Node.js and npm, which provides `npx` | `npx -y pagefind --site _site` |
| Standalone binary | Download the release for your operating system and architecture | `./pagefind --site _site` |

For the Node.js route, check that `node --version` and `npx --version` work.
The first `npx` invocation downloads Pagefind; `-y` accepts the installation prompt.
You do not need a `package.json` to use this command. To pin a build to a specific Pagefind release, use `npx -y pagefind@VERSION` instead.

If you prefer to build without Node.js, download and extract an official
[Pagefind binary](https://github.com/CloudCannon/pagefind/releases).
`pagefind_extended` additionally supports indexing Chinese, Japanese, and Thai.
The npm wrapper uses the extended binary automatically.

See [Pagefind's installation guide](https://pagefind.app/docs/installation/)
for platform details and the Python wrapper alternative. Node.js, Python, or the
binary is needed only on the build machine, not on the static host or visitors'
devices.

## Build and preview locally

From your Jekyll site directory, run:

```sh
bundle exec jekyll build
npx -y pagefind --site _site --serve
```

Open the preview address printed by Pagefind and search for a phrase from one of
your pages. With a standalone binary, replace `npx -y pagefind` with `./pagefind`.

The `--site` directory must match Jekyll's output directory. Pagefind creates
`_site/pagefind/`, including `pagefind.js` and the index files. Publish that
directory together with the generated HTML.

After editing content, rebuild Jekyll and rerun Pagefind. A plain `jekyll serve`
does not generate or refresh the search index. Use the preview through HTTP;
opening an HTML file directly from disk does not provide a working search preview.

### Developing PrimerPages itself

In the PrimerPages development repository, this helper builds the docs site,
generates the index using `npx`, and starts Jekyll:

```sh
bash bin/local_serve.sh --source site
```

The helper requires Node.js and npm for its automatic indexing. If `npx` is
missing or indexing fails, it warns and continues serving. It regenerates the
search index after the initial Jekyll build and every subsequent rebuild, using
the same build options (such as `--baseurl` and `--drafts`). You can disable
its indexing with `PAGEFIND_ON_SERVE=false` and use a standalone binary manually.

## Deploy with GitHub Actions

Run Pagefind after Jekyll builds and before uploading or publishing the generated
site. For a runner with Node.js and npm installed, add this step:

```yaml
- name: Build search index
  run: npx -y pagefind --site ./_site
```

The `primerpages-docs` and `primerpages-recommended` templates enable header
search by default and their workflows include an indexing step.
The `primerpages-minimal` and `primerpages-gh-pages`
templates omit it; add the step above if you enable search in those templates.
If you customize the Jekyll destination, update Pagefind's `--site` path too.
Add `--serve` only for local previews, not deployment builds.

### GitHub Pages publishing mode

GitHub Pages has two publishing modes in **Settings → Pages → Build and deployment
→ Source**:

- **Deploy from a branch** uses GitHub's built-in Jekyll build for your source
  files. It does not run `npx -y pagefind --site _site`, so enabling search in
  `_config.yml` alone will not produce a search index.
- **GitHub Actions** lets your workflow run both Jekyll and Pagefind, then publish their combined output. Choose this mode to generate search during deployment.

The Pagefind command is required to generate search files; Jekyll alone builds
the pages and search box. It is needed only when you enable search.

For example, in a Pages deployment workflow with Ruby, Bundler, Node.js, and npm
available, use this sequence in the build job:

{% raw %}
```yaml
- name: Setup Pages
  id: pages
  uses: actions/configure-pages@v6

- name: Build HTML with Jekyll
  run: >-
    bundle exec jekyll build
    --baseurl "${{ steps.pages.outputs.base_path }}"
    --destination _site

- name: Build search index
  run: npx -y pagefind --site _site

- name: Upload complete site
  uses: actions/upload-pages-artifact@v5
  with:
    path: _site
```
{% endraw %}

Your deployment job then publishes that artifact with `actions/deploy-pages`.
See [Using with GitHub Actions](github-action.md) for a complete workflow and
[GitHub's publishing source guide](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)
for the repository settings.

### Project sites and `baseurl`

For a site at `https://example.github.io/my-project/`, the base URL is
`/my-project`. Set `baseurl: /my-project` in `_config.yml` for local builds, or
pass it with Jekyll's `--baseurl` option as the workflow above does automatically.

The files still go directly into `_site`, without an extra `my-project` folder:

```text
_site/
  index.html
  pagefind/
    pagefind.js
    ...
```

GitHub Pages hosts `_site/index.html` at `/my-project/` and the search bundle at
`/my-project/pagefind/pagefind.js`. The theme uses `baseurl` to request that URL.
Point Pagefind at `_site`, and upload all of `_site`, including `pagefind/`.

## Troubleshooting

| Symptom | What to check |
| --- | --- |
| Search box is missing | Enable `search.enabled` and rebuild Jekyll. |
| "Search is unavailable" | Confirm `pagefind/pagefind.js` exists in the deployed output and loads successfully in the browser's network panel. Check the output directory, deployment artifact, and `baseurl`. |
| Results are outdated or missing new pages | Run Pagefind again after the final Jekyll build and deploy the regenerated bundle. |
| Typing does not show results yet | Enter at least two characters. |

## More Pagefind documentation

- [Getting started](https://pagefind.app/docs/)
- [Running the indexer](https://pagefind.app/docs/running-pagefind/)
- [Choosing what content is indexed](https://pagefind.app/docs/indexing/)
- [Configuration options](https://pagefind.app/docs/config-options/)

PrimerPages already supplies the header interface, so you can skip adding
Pagefind's separate default search UI when following its guides.
