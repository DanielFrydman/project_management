#!/usr/bin/env bash
# exit on error
set -o errexit

bundle exec rails assets:clean
bundle exec rails assets:clobber

bundle install

RAILS_ENV=production bundle exec rails tailwindcss:build
RAILS_ENV=production bundle exec rails assets:precompile

bundle exec rails db:migrate
