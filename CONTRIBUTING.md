---
layout: page
title: Contributing
---
Thank you for contributing to `primerpages-dev`. This repository is the source of truth for the Primer Pages ecosystem.

All contribution work for the following repositories should be made in `primerpages-dev`:

- `primerpages.github.io`
- `primerpages-theme`
- `primerpages-gh-pages`
- `primerpages-minimal`
- `primerpages-recommended`

Changes are synced out from `primerpages-dev` via automation. Please do not open direct content or theme change pull requests against those downstream repositories.

## Getting Started

To begin, ensure you have a conducive development environment by installing [Visual Studio Code](https://code.visualstudio.com/) and the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension and [docker](https://docs.docker.com/). This will ensure that you have the necessary development environment in place.

Next, clone the project repository to your local machine and open it with vscode:

```bash
git clone https://github.com/PrimerPages/primerpages-dev.git
cd primerpages-dev
code .
```

And then [develop with vscode and docker](https://www.allisonthackston.com/articles/docker-development.html#how-to-set-up-vs-code-with-docker)

To test locally, run the project scripts in `.github/` for build, serve, and test flows, and verify the generated output and docs updates where relevant.

## Contributing Guidelines

We appreciate various types of contributions, including bug fixes, new features, documentation updates, and code optimizations. When submitting your contributions, please adhere to the following guidelines:

- Create a new branch for your contributions: `git checkout -b feature-or-fix-branch`.
- Commit your changes with descriptive messages: `git commit -m "Add new feature XYZ"`.
- Submit pull requests from your branch to `primerpages-dev` `main`.
- If your change affects synced repositories, make the change in the corresponding source directory in `primerpages-dev` and let sync workflows open downstream PRs.

If you encounter any issues or bugs, please feel free to open an issue on our GitHub repository. We highly value feedback from our community and encourage open communication.

## Branching and Pull Requests

Our project follows my [git style guide](https://www.allisonthackston.com/articles/git-style-guide.html).

## Code Review Process

Once you submit a pull request, our team will review your code. We strive to provide timely feedback and constructive suggestions to improve your contributions. Feel free to engage in discussions, and make updates based on the feedback received.

## Testing Guidelines

Before submitting your contributions, make sure to test your changes thoroughly. We have a test suite in place, and we appreciate new tests for new features or bug fixes.

To run tests locally, use `.github/test.sh` and check there are no errors.

Also run local serve/build flows for affected templates or docs and confirm expected output.

## Documentation

Keeping our documentation up-to-date is vital. If you make any significant changes, please include updates to the relevant documentation.

## Code of Conduct

Contributors are expected to adhere to the [Contributor Covenant](https://www.contributor-covenant.org/) code of conduct.

## License and Copyright

By contributing to `primerpages-dev`, you agree that your work will be subject to the project's MIT License and that you have the right to grant us the necessary permissions.
