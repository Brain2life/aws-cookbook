# Makefile for the CDK Private S3 Bucket App
#
# Provides simple commands to manage the CDK application lifecycle.

# ============== Variables ==============
# The AWS profile to use. Can be overridden from the command line.
# Example: make deploy PROFILE=my-prod-profile
PROFILE ?= default

# Suppress command echoing for a cleaner output.
.SILENT:

# Set the shell to bash for more consistent behavior.
SHELL := /bin/bash

# ============== Default Target ==============
# The default target that runs when you just type 'make'.
# It should always be the first target in the file.
all: help

# ============== Primary Workflow ==============

deploy: build ## Deploy the stack to your AWS account
	@echo "🚀  Deploying stack with profile [$(PROFILE)]..."
	cdk deploy --profile $(PROFILE) --require-approval never

destroy: build ## Destroy the stack and remove all resources
	@echo "💥  Destroying stack with profile [$(PROFILE)]..."
	cdk destroy --profile $(PROFILE) --force

diff: build ## Show differences between your code and the deployed stack
	@echo "🔍  Checking for differences..."
	cdk diff --profile $(PROFILE)

# ============== Build & Setup Steps ==============

build: ## Compile TypeScript to JavaScript
	@echo "🔨  Compiling TypeScript..."
	npm run build

install: ## Install project dependencies from package.json
	@echo "📦  Installing npm dependencies..."
	npm install

bootstrap: ## Bootstrap the CDK environment (a one-time setup per AWS account/region)
	@echo "✨  Bootstrapping CDK environment for profile [$(PROFILE)]..."
	cdk bootstrap --profile $(PROFILE)

synth: build ## Synthesize the CloudFormation template
	@echo "📜  Synthesizing CloudFormation template..."
	cdk synth --profile $(PROFILE)

# ============== Housekeeping ==============

clean: ## Clean up the project (removes build artifacts and dependencies)
	@echo "🧹  Cleaning up project..."
	rm -rf node_modules cdk.out

help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples with a specific AWS profile:"
	@echo -e "  \033[32mmake deploy PROFILE=my-prod-profile\033[0m"
	@echo -e "  \033[32mmake diff PROFILE=dev-account\033[0m"
	@echo ""


# The .PHONY directive tells make that these are not files.
.PHONY: all help clean install build bootstrap synth diff deploy destroy