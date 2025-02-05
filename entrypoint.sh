#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for database
until nc -z -v -w30 db 5432
do
  echo "Waiting for postgres database connection..."
  sleep 5
done
echo "Database connection established"

# Setup database if needed
bundle exec rails db:prepare

# Execute the main process
exec "$@" 