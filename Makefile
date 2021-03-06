SHELL := /bin/bash
app = jules

clean:
	## TODO address when we lack perms to delete these
	find . -name __pycache__ -prune -exec rm -fr {} \;
	find . -name "*.pyc" -exec rm -fr {} \;
	find . -name .eggs -prune -exec rm -fr {} \;
	find . -name "*.egg-info" -prune -exec rm -fr {} \;
	rm -fr build/ dist/
	## Kill pytest_cache for good measure
	rm -rf .pytest_cache
	## fix for file import error...
	rm -rf ./test/__pycache__

require-stage:
ifndef stage
	$(error stage arg is required for this target)
endif

cp-envvars:
	cp ./envvars.sample ./envvars

dist: cp-envvars
	docker-compose run ${app}-dist

build-deploy: dist
	docker-compose build ${app}-deploy

build-dev: dist
	docker-compose build ${app}

deploy: require-stage build-deploy
	docker-compose run ${app}-deploy \
	  ./node_modules/serverless/bin/serverless deploy --stage ${stage}

test: build-dev
	docker-compose run ${app} /test.sh

ftest: require-stage build-dev
	docker-compose run ${app} robot \
	  --variablefile ftest/env/${stage}.py \
	  ftest

test-dev: test

build-docs:
	./node_modules/.bin/spectacle -1 -t docs docs/docs.json

## Mainly local dev helper, runs a lot faster for quick
## syntax updates, etc
## activating shell cmd in make;
## ref: https://stackoverflow.com/a/24736236/8285967
quick-test: clean
	( \
		source .venv/bin/activate; \
		source envvars; \
		pip install --trusted-host None --no-index --find-links ./dist prayerapp; \
		pytest ./test; \
		deactivate; \
	)
