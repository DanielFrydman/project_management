#!/usr/bin/env bash
# exit on error
set -o errexit

# Install bundler with the correct version
gem install bundler

# Install dependencies and generate binstubs
bundle install
bundle binstubs bundler --force

# Clean and prepare assets
bundle exec rails assets:clean
bundle exec rails assets:clobber

# Build assets
RAILS_ENV=production bundle exec rails tailwindcss:build
RAILS_ENV=production bundle exec rails assets:precompile

# Run migrations
bundle exec rails db:migrate
