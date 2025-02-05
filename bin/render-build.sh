#!/usr/bin/env bash
# exit on error
set -o errexit

mkdir -p bin
mkdir -p public/assets
mkdir -p tmp/cache

gem install bundler --no-document
bundle config set --local path 'vendor/bundle'
bundle config set --local without 'development test'

bundle install

bundle binstubs bundler --force

bundle exec rails assets:clean
bundle exec rails assets:clobber

RAILS_ENV=production bundle exec rails tailwindcss:build
RAILS_ENV=production bundle exec rails assets:precompile

bundle exec rails db:migrate
