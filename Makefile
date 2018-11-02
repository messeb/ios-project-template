RUBY := $(shell command -v ruby 2>/dev/null)
HOMEBREW := $(shell command -v brew 2>/dev/null)
BUNDLER := $(shell command -v bundle 2>/dev/null)

default: setup

setup: \
	pre_setup \
	check_for_ruby \
	check_for_homebrew \
	update_homebrew \
	install_carthage \
	install_bundler_gem \
	install_ruby_gems \
	install_carthage_dependencies

pull_request: \
	test \
	codecov_upload \
	danger

pre_setup:
	$(info iOS project setup ...)

check_for_ruby:
	$(info Checking for Ruby ...)

ifeq ($(RUBY),)	
	$(error Ruby is not installed)
endif

check_for_homebrew:
	$(info Checking for Homebrew ...)

ifeq ($(HOMEBREW),)
	$(error Homebrew is not installed)
endif

update_homebrew:
	$(info Update Homebrew ...)

	brew update

install_swift_lint:
	$(info Install swiftlint ...)

	brew unlink swiftlint || true
	brew install swiftlint
	brew link --overwrite swiftlint

install_bundler_gem:
	$(info Checking and install bundler ...)

ifeq ($(BUNDLER),)
	gem install bundler -v '~> 1.17'
else
	gem update bundler '~> 1.17'
endif

install_ruby_gems:
	$(info Install Ruby Gems ...)

	bundle install

install_carthage:
	$(info Install Carthage ...)

	brew unlink carthage || true
	brew install carthage
	brew link --overwrite carthage

install_carthage_dependencies:
	$(info Install Carthage Dependencies ...)

	carthage bootstrap --platform ios --cache-builds

codecov_upload:
	curl -s https://codecov.io/bash | bash

danger: 
	bundle exec danger

test:
	bundle exec fastlane test

staging:
	bundle exec fastlane test # staging

release:
	bundle exec fastlane test # release
