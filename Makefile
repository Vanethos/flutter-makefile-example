.PHONY: all run_dev_web run_dev_mobile run_unit clean upgrade help

all: run_web

# Adding a help file: https://gist.github.com/prwhite/8168133#gistcomment-1313022
help: ## This help dialog.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
	for help_line in $${help_lines[@]}; do \
		IFS=$$'#' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf "%-30s %s\n" $$help_command $$help_info ; \
	done

run_dev_web: ## Runs the web application in dev
	@echo "Running the app"
	@flutter run -d chrome --dart-define=ENVIRONMENT=dev

run_dev_mobile: ## Runs the mobile application in dev
	@echo "Running the app"
	@flutter run --flavor dev

run_unit: ## Runs unit tests
	@echo "Running the tests"
	@flutter test || (echo "Error while running tests"; exit 1)

clean: ## Cleans the environment
	@rm -rf pubspec.lock
	@flutter clean

format: ## Formats the code
	@dart format .

lint: ## Lints the code
	@dart analyze . || (echo "Error in project"; exit 1)

upgrade: clean ## Upgrades dependencies
	@flutter pub upgrade

commit: format lint run_unit
	git add .
	git commit
	

# Missing: Add one to prepare a PR that formats, lints, runs tests and then creates the PR

	
