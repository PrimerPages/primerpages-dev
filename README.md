# primerpages-dev

Source-of-truth development repository for PrimerPages.

## Repository layout

- `theme/`: canonical source for the theme package and downstream theme repository.
- `templates/`: canonical source content for downstream template repositories.
- `site/`: docs and project site content.

## Publishing model

- Development happens in this repository.
- CI syncs content to downstream repositories:
  - `theme/` -> The PrimerPages theme
  - `templates` -> A set of PrimerPages repo templates
  - `site/` -> The main site for PrimerPages
- Downstream repos are treated as published outputs, not primary authoring locations.

## Contribution entry point

- Open issues and pull requests in `primerpages-dev`.
- If your change affects downstream repositories (`primerpages.github.io`, `primerpages-theme`, `primerpages-gh-pages`, `primerpages-minimal`, `primerpages-recommended`), make the change here and let sync automation propagate it.

## Testing fixtures

- Test-only config fixtures live under `tests/configs/`.
- Published template configs are kept under `templates/` and separate from local/CI test fixture setup.

## Notes

- `templates/` is a normal folder in this monorepo (not a nested git repo/submodule).
- Use `.github/serve.sh` for local multi-site development.
- Use `bash .github/local_theme.sh --source <template>` to emit JSON for local theme wiring (`local_theme_source`, `local_theme_config`, `bundle_gemfile`).
- Convenience wrappers:
  - `bash .github/local_build.sh --source <template>`
  - `bash .github/local_serve.sh --source <template>`
  - `bash .github/local_smoke_test.sh --source <template>`

## License

- Code: MIT
- Documentation: CC BY-NC-ND 4.0
