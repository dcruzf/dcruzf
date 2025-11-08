PYTHONPATH := .:$(PYTHONPATH)
export PYTHONPATH
.DEFAULT_GOAL := all
sources = dcruzf
project_dir = dcruzf


.PHONY: .uv  ## Check that uv is installed
.uv:
	@uv -V || curl -LsSf https://astral.sh/uv/install.sh | sh || echo 'Please install uv: https://docs.astral.sh/uv/getting-started/installation/'

.PHONY: docs  ## Serve the documentation at http://localhost:8000
docs:
	uvx --with mkdocs-material \
    --with ruff \
    mkdocs serve -a 127.0.0.1:8000

.PHONY: docs-build  ## Build static docs into site/
docs-build: .uv
	uvx --with mkdocs-material \
		--with ruff \
		mkdocs build

.PHONY: docs-deploy  ## deploy gh-pages
docs-deploy: .uv
	uvx --with mkdocs-material \
		--with ruff \
		mkdocs gh-deploy

.PHONY: clean  ## Clear local caches and build artifacts
clean:
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]'`
	rm -f `find . -type f -name '*~'`
	rm -f `find . -type f -name '.*~'`
	rm -rf .cache
	rm -rf .pytest_cache
	rm -rf .ruff_cache
	rm -rf htmlcov
	rm -rf *.egg-info
	rm -f .coverage
	rm -f .coverage.*
	rm -rf build
	rm -rf dist

.PHONY: help  ## Display this message
help:
	@grep -E \
		'^.PHONY: .*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ".PHONY: |## "}; {printf "\033[36m%-19s\033[0m %s\n", $$2, $$3}'