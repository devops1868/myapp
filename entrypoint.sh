#!/bin/bash
set -e

# Generate database.yml with your specific values
cat <<EOF > config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: <%= ENV['DB_HOST'] || 'db' %>
  username: <%= ENV['DB_USER'] || 'postgres' %>
  password: <%= ENV['DB_PASSWORD'] || 'postgres' %>
  database: <%= ENV['DB_NAME'] || 'myapp' %>

development:
  <<: *default

test:
  <<: *default
  database: <%= ENV['DB_NAME'] || 'myapp_test' %>

production:
  <<: *default
EOF

# Remove a potentially pre-existing server.pid for Rails.
rm -f tmp/pids/server.pid

# Then exec the container's main process
exec "$@"
