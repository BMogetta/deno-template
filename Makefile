OS := $(shell uname)

ifeq ($(OS),Darwin) # Mac OS
  PATHSEP = /
  INSTALL_DIR = /usr/local
  REMOVE_CMD = rm
  PYTHON_CMD = python3
else ifeq ($(OS),Linux) # Linux
  PATHSEP = /
  INSTALL_DIR = /usr/local
  REMOVE_CMD = rm
  PYTHON_CMD = python3
endif

ifeq ($(OS),Windows_NT) # Windows  Git Bash or Windows Subsystem for Linux (WSL)
  PATHSEP = \\
  INSTALL_DIR = %USERPROFILE%\\deno
  REMOVE_CMD = del
  PYTHON_CMD = python
endif

setup: log-os denoinstall install-hooks

denoinstall:
	@echo "Checking for Deno..."
	@which deno || (echo "Installing Deno..." && curl -fsSL https://deno.land/x/install/install.sh | sudo DENO_INSTALL=$(INSTALL_DIR) sh)

install-hooks:
	@echo "Setting up git hooks..."
	# Remove the existing .git/hooks folder
	$(REMOVE_CMD) -rf .git$(PATHSEP)hooks
	# Copy the new hooks from the config/githooks folder
	cp -r config/githooks .git$(PATHSEP)hooks
	# Make all hooks executable
	chmod +x .git$(PATHSEP)hooks$(PATHSEP)*
	@echo "Git hooks setup complete."

lcovinstall:
ifeq ($(OS),Linux)
	@echo "Checking for lcov..."
	@which lcov || ( \
	echo "Installing lcov..." && \
	( \
		if [ -x "$(command -v apt-get)" ]; then sudo apt-get update && sudo apt-get install -y lcov; \
		elif [ -x "$(command -v dnf)" ]; then sudo dnf install -y lcov; \
		elif [ -x "$(command -v yum)" ]; then sudo yum install -y lcov; \
		elif [ -x "$(command -v pacman)" ]; then sudo pacman -S --noconfirm lcov; \
		else echo "Your package manager is not supported. Please install lcov manually."; exit 1; \
		fi \
	) \
	)
endif

denodelete:
	sudo $(REMOVE_CMD) $(shell which deno)

coverage-report:
	deno test --cached-only --coverage=coverage --parallel --allow-none --allow-net --allow-env --allow-read --allow-run
	deno coverage coverage --lcov --output=lcov.info
	genhtml lcov.info --no-branch-coverage --output-directory out > coverage.txt
	coverage=$$(grep -o '[0-9]\+.[0-9]\+%' coverage.txt | head -n 1) ; \
	coverage=$$(echo $$coverage | sed 's/%/%25/g') ; \
	echo "Coverage: $$coverage" ; \
	curl -o public/coverage.svg "https://img.shields.io/badge/Coverage-$$coverage-brightgreen"
	rm -rf coverage out coverage.txt

.PHONY: setup log-os denoinstall lcovinstall denodelete install-hooks
