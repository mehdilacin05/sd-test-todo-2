SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := check
.PHONY: check secrets format lint typecheck test build audit image

check: secrets format lint typecheck test build audit

format:
	./node_modules/.bin/prettier --check .

lint:
	./node_modules/.bin/eslint . --max-warnings 0

secrets:
	gitleaks git --redact --no-banner .
	gitleaks dir --redact --no-banner .

typecheck:
	npm run typecheck

test:
	npm test

build:
	npm run build

audit:
	npm audit --omit=dev --audit-level=high

image:
	docker build --build-arg GIT_SHA=$$(git rev-parse HEAD) -t sd-test-todo-2:local .
