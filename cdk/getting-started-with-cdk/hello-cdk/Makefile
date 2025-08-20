# ====== Config ======
APP_NAME ?= hello-cdk
STACK    ?= HelloCdkStack
REGION   ?= us-east-1
PROFILE  ?= default

CDK      := npx cdk
CDK_ARGS ?= --profile $(PROFILE) --region $(REGION)

# Load .env if present (GNU make)
ifneq (,$(wildcard .env))
  include .env
  export
endif

.PHONY: help install build clean bootstrap synth diff deploy destroy watch list context

help:
	@echo "Common targets:"
	@echo "  make install     - Install node deps"
	@echo "  make build       - Build TS (if applicable)"
	@echo "  make synth       - cdk synth"
	@echo "  make diff        - cdk diff"
	@echo "  make deploy      - cdk deploy (requires approve)"
	@echo "  make destroy     - cdk destroy (requires approve)"
	@echo "  make bootstrap   - cdk bootstrap (once per acct/region)"
	@echo "  make watch       - cdk watch"
	@echo "  make list        - cdk ls"
	@echo "  make clean       - Remove cdk.out"
	@echo "Options via env: STACK=$(STACK) REGION=$(REGION) PROFILE=$(PROFILE)"

install:
	npm ci || npm install

# If TypeScript: compile before synth/deploy (CDK often uses ts-node; adjust to your project)
build:
	@if [ -f tsconfig.json ]; then npm run build || true; fi

clean:
	rm -rf cdk.out

bootstrap:
	$(CDK) bootstrap

synth: build
	$(CDK) synth $(STACK) $(CDK_ARGS)

diff: build
	$(CDK) diff $(STACK) $(CDK_ARGS)

deploy: build
	$(CDK) deploy $(STACK) $(CDK_ARGS)

# Non-interactive deploy (use in CI)
deploy-auto: build
	$(CDK) deploy $(STACK) $(CDK_ARGS) --require-approval never

destroy:
	$(CDK) destroy $(STACK) $(CDK_ARGS)

watch: build
	$(CDK) watch $(STACK) $(CDK_ARGS)

list:
	$(CDK) ls $(CDK_ARGS)

# Convenience “profiles” (override REGION/PROFILE inline)
dev:
	$(MAKE) deploy STACK=$(STACK) PROFILE=dev REGION=us-east-1

stage:
	$(MAKE) deploy STACK=$(STACK) PROFILE=stage REGION=us-west-2

prod:
	$(MAKE) deploy-auto STACK=$(STACK) PROFILE=prod REGION=eu-west-1
