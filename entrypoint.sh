#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Install dependencies if needed
bundle check || bundle install

# Execute the main process
exec "$@" 