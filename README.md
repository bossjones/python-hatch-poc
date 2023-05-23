# 🎈 Python Package Template

## ✨ Features

* Package configuration with `pyproject.toml` built with `hatch`
* Code formatting and linting with `ruff`, and `black`
* `Dockerfile` with package installation
* `pre-commit` configuration file
* GitHub Codespaces can be created from `.devcontainer`
* CI-CD Pipelines with GitHub Actions
* Basic `pytest` set-up for unit tests
* Auto-generated docs with `mkdocs` and `mkdocs-material`

## 🚚 Replacements

* `hatchpoc`: name of the package (usually the same name as the repository in which it's hosted).
* `REPLACE_PACKAGE_DESCRIPTION`: description of the package.
* `Malcolm Jones`: user's full name.
* `bossjones@theblacktonystark.com`: user's email.
* `bossjones`: GitHub username of the package owner.

## Example repo

https://github.com/alvarobartt/opentrain


## Installation

```bash
pip install hatchpoc
```

## Development

To work with your project you can drop into a shell that keeps your
dependencies synced with the entries in your `pyproject.toml` file. You can have
dependency groups there that allow for custom shells.

You can enter a shell simply with:

```bash
hatch shell
# You can still run other shell commands such as git helpers from within the shell
hatch run git:commit
```

Project dependencies for the build can be listed with:

```bash
❯ hatch dep show table
 Env: default
┏━━━━━━━━━━━━┓
┃ Name       ┃
┡━━━━━━━━━━━━┩
│ black      │
│ pytest     │
│ pytest-cov │
│ ruff       │
└────────────┘
```

You can update these and include sub shells in your pyproject.toml.
[Environments](https://hatch.pypa.io/latest/environment/#creation)

Working on the project source code with code-completion can be done by simply
calling: `hatch shell`.

## Versioning

Commitzen is used to handle the version bumping (Hatch can do this as well but
doesn't get git tags by default)[^1](https://hatch.pypa.io/latest/version/#versioning)

```bash
hatch run git:version
```

(It is really a wrapper for `cz bump {args}`)

```console
❯ hatch run git:version --help
```

## Committing

Helper functions for nice commit messages are also built-in using commitizen.

```bash
hatch run git:commit
```

## Building

Hatch complies with modern Python packaging specs and therefore your projects
can be used by other tools with Hatch serving as just the build backend.

Invoking the build command without any arguments will build the sdist and wheel targets:

[Build](https://hatch.pypa.io/latest/build/#building)

```bash
hatch build
```

## Publishing

After your project is built, you can distribute it using the publish command.

The `-p/--publisher` option controls which publisher to use, with the default
being index.

[Publish](https://hatch.pypa.io/latest/publish/#publishing)

```bash
hatch publish
```

### Pip-tools

When you run the `remove-poetry` with the `-c` option which create a virtual environment for you, you will also get [`pip-tools`](https://github.com/jazzband/pip-tools) and [`hatch`](https://github.com/pypa/hatch) installed.
Pip-tools is a set of tools to help you manage your dependencies. As the name suggests, it is based on pip.
The most basic workflow will look something like this:

Add a new package in your `pyproject.toml` (or `requirements.ini` if you prefer) file and run `pip-compile` to generate a new `requirements.txt` file.
```shell
pip-tools compile -o requirements.txt pyproject.toml --resolver=backtracking
```
The command also take an `--extra` option to specify dependencies groups, more infos on their [github readme](https://github.com/jazzband/pip-tools).

```shell
pip-sync
```
`pip-sync` will synchronize your virtual environment with the `requirements.txt` file, this means that any package in the virtual
environment that is not in the `requirements.txt` file will be removed. You can also just use a good old `python -m pip install -r requirements.txt`
to install the dependencies.

### Hatch

Installed at the same time as  `pip-tools`, [Hatch](https://hatch.pypa.io/latest/) is the build system specified in the `pyproject.toml` file. Since you are probably
not going to package and publish your django project you don't really need it, but `pip-tools` does need a build system defined
to work.

!!! Quote "Official hatch documentation"
    Hatch is a modern, extensible Python project manager.

Hatch does everything you need to manage a python project, dependencies, virtual environments, packaging, publishing, scripts, etc and it also uses
the `pyproject.toml` file. The one available after the `remove-poetry` command is a good base to start using hatch.

Just run
```shell
hatch env create
```

Read the [hatch documentation](https://hatch.pypa.io/latest/) for more infos.

## License

hatcpoc is distributed under the terms of the
[MIT](https://spdx.org/licenses/MIT.html) license.
