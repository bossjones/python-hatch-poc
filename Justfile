set	shell := ["zsh", "-cu"]
LOCATION_PYTHON := `python -c "import sys;print(sys.executable)"`

# just manual: https://github.com/casey/just/#readme

# Ignore the .env file that	is only	used by the	web	service
set	dotenv-load	:= false


HATCH_VERSION := `hatch	version`

_default:
	@just --list

info:
    print "Python location: {{LOCATION_PYTHON}}"

# install pip-tools
pip-tools: info
	pip	install	pip	setuptools==66.1.1 wheel
	pip	install	pip-tools==6.13.0 pipdeptree

# run pip-compile to generate requirements.txt
pip-compile: pip-tools
	pip-compile	-v --pip-args "-v" --resolver=backtracking --output-file requirements.txt requirements.in
	# pip-compile --rebuild --output-file requirements.txt requirements.in

# run pip-complie to generate requirements.txt and force rebuild
pip-compile-rebuild: pip-tools
	rm requirements.txt
	touch requirements.txt
	pip-compile	-v --pip-args "-v" --resolver=backtracking --rebuild --output-file requirements.txt	requirements.in


# upgrade pip-tools
pip-tools-upgrade:
	pip	install	--upgrade pip setuptools==66.1.1 wheel
	pip	install	pip-tools==6.13.0 pipdeptree --upgrade
	# rm -v requirements*.txt || true
	pip-compile	-v --pip-args "-v" --resolver=backtracking --upgrade --output-file	requirements.txt requirements.in

install-opencv-typing:
	./contrib/install_opencv_typing.sh

editable-install:
	pip	install	-e .[dev,tests,experimental,docs]

install-deps-all:
	pip	install	-r requirements.txt
	# pip install -r requirements-dev.txt
	# pip install -r requirements-test.txt
	# pip install -r requirements-doc.txt
	# pip install -r requirements-experimental.txt

install-editable:
	pip	install	-e .

pip-sync: pip-compile install-deps-all install-editable
	# pip-sync requirements.txt	requirements-dev.txt requirements-doc.txt requirements-experimental.txt	requirements-test.txt
	pip-sync requirements.txt

dev: pip-compile install-deps-all editable-install install-opencv-typing

pip-compile-upgrade-downloaders-and-install: dev

upgrade-reset-dev-env: pip-tools-upgrade pip-sync editable-install

upgrade-downloaders-reset-dev-env: pip-sync	editable-install

# setup	dev	environment	with all packages synced to lockfiles
reset-dev-env: pip-compile pip-sync	install-deps-all install-editable

# sync dev env to lock files
syncenv:  reset-dev-env	editable-install

# SOURCE: https://medium.com/jobtome-engineering/improve-productivity-of-python-projects-with-commitizen-678f012f4772

pre-flight:
	git	stash
	git	pull --rebase
	git	stash pop
	echo -e "\n	Environment	ready, please run hatchpocctl run"

rerun-latest:
	git	stash; git pull	--rebase; git stash	pop; hatchpocctl run


lock:
	pip-compile	-v --pip-args "-v" --resolver=backtracking -o ./requirements.txt ./requirements.in
	# pip-compile -v --pip-args	"-v" --resolver=backtracking --upgrade --extra dev -o ./requirements-dev.txt ./pyproject.toml
	# pip-compile -v --pip-args	"-v" --resolver=backtracking --upgrade --extra test	-o ./requirements-test.txt ./pyproject.toml
	# pip-compile -v --pip-args	"-v" --resolver=backtracking --upgrade --extra doc -o ./requirements-doc.txt ./pyproject.toml

# verify python	is running under pyenv
which-python:
	python -c "import sys;print(sys.executable)"

# install all pre-commit hooks
pre-commit-install:
	pre-commit install -f --install-hooks

# install taplo	if not found
# https://github.com/mlops-club/awscdk-clearml/blob/3d47f23479dd18e864fda43e11ecc8d5624613a9/Justfile

# install just task	runner tool
install-just:
	which just || (which brew && brew install just)

# install taplo	a tool for working with	TOML
install-taplo:
	which taplo	|| (which brew && brew install taplo)

fmt: install-taplo
	taplo fmt pyproject.toml
	validate-pyproject pyproject.toml
	inv	ci.lint	-vvvv

ruff-completion:
	ruff generate-shell-completion zsh >  ~/.zsh/completions/_ruff

# testing out ruff check only mode
ruff-check:
	ruff check --isolated --ignore ALL --select	F841,ARG001,ARG002,ARG003,ARG004,ARG005,F401,F842,F811,F821,F407,F405,F821,F823	--no-fix --diff	--exclude ./typings	--exclude ./tasks --exclude	./scripts --exclude	./contrib --show-files . | diff-so-fancy

# run ruff check against a single file
ruff-check-one argument:
	@contrib/ansi --green "	[ruff] show	fixes"
	ruff check --show-fixes	--config pyproject.toml	'{{argument}}'|| true
	@echo ""
	@contrib/ansi --green "	[ruff] show	diff"
	ruff check --diff --config pyproject.toml '{{argument}}' || true
	@echo ""

# run ruff against a single	file
ruff-one argument:
	@contrib/ansi --green "	[ruff] show	fixes"
	ruff check --show-fixes	--config pyproject.toml	'{{argument}}'|| true
	@echo ""
	@contrib/ansi --green "	[ruff] show	diff"
	ruff check --diff --config pyproject.toml '{{argument}}' || true
	@echo ""
	@contrib/ansi --green "	[ruff] running fix ..."
	ruff --force-exclude --no-fix --no-cache --format json --config=pyproject.toml --fix '{{argument}}'
	@echo ""

# F401 = pyflakes unused import	rules
# I	= isort	rules

# Run ruff version of isort	check
ruff-isort-check argument:
	@contrib/ansi --green "	[ruff] show	fixes"
	ruff check --config=pyproject.toml --no-cache --ignore ALL --select	I,F401 --no-fix	--show-fixes '{{argument}}'	|| true
	@echo ""
	@contrib/ansi --green "	[ruff] show	diff"
	ruff check --config=pyproject.toml --no-cache --ignore ALL --select	I,F401 --no-fix	--diff '{{argument}}' || true

# F401 = pyflakes unused import	rules
# I	= isort	rules

# Run ruff version of isort
ruff-isort argument:
	@contrib/ansi --green "	[ruff] show	fixes"
	ruff check --config=pyproject.toml --ignore	ALL	--select I,F401	--no-fix --show-fixes '{{argument}}' || true
	@echo ""
	@contrib/ansi --green "	[ruff] show	diff"
	ruff check --config=pyproject.toml --ignore	ALL	--select I,F401	--no-fix --diff	'{{argument}}' || true
	@echo ""
	@contrib/ansi --green "	[ruff] running fix ..."
	ruff --config=pyproject.toml --force-exclude --no-fix --no-cache --format text --ignore	ALL	--select I,F401	--fix '{{argument}}'
	@echo ""


# ruff check --isolated	--ignore ALL --select I	--no-fix --diff	--exclude ./typings	--exclude ./tasks --exclude	./scripts --exclude	./contrib --show-files . | diff-so-fancy

vulture-check:
	vulture	./try.py

download-redis-tui:
	curl -L 'https://github.com/mylxsw/redis-tui/releases/download/0.1.6/redis-tui-linux' >	~/.local/src/redis-tui
	chmod +x ~/.local/src/redis-tui


# SOURCE: https://github.com/SFDO-Tooling/CumulusCI/blob/c1462e5a565466ac8c38f2e0e3ac3e408f92ae3d/Makefile#L86
clean: clean-build clean-pyc clean-test	## remove all build, test, coverage	and	Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr pybuild/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec	rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python	file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec	rm -f {} +
	find . -name '__pycache__' -exec rm -fr	{} +

clean-test:	## remove test and coverage	artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -f output.xml
	rm -f report.html

release: clean ## package and upload a release
	python contrib/pin_dependencies.py
	hatch build
	hatch publish

dist: clean	## builds source and wheel package
	hatch build
	ls -l dist

install: clean ## install the package to the active	Python's site-packages
	python -m pip install .

tag: clean ## release a	github tag
	git	tag	-a -m 'version {{HATCH_VERSION}}' v{{HATCH_VERSION}}
	git	push --follow-tags

gen-autocomplete: ## generate hatch	autocomplete
	_HATCH_COMPLETE=zsh_source hatch > ./contrib/_hatch
	just --completions zsh > ./contrib/_just

hatch-dev: pip-compile ## install hatch	environment
	pip	install	--upgrade --requirement=requirements.txt --editable='.[dev]'
