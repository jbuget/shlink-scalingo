#!/usr/bin/env bash

# Debug, echo every command
if [[ -n "$BUILDPACK_DEBUG" ]]; then
  set -x
fi

# Fail immediately on non-zero exit code.
set -e
# Fail immediately on non-zero exit code within a pipeline.
set -o pipefail
# Fail on undeclared variables.
set -u

echo "-----> Installing RR..."
php ./vendor/bin/rr get --no-interaction --location bin/ && chmod +x "./bin/rr"

echo "-----> Assert GeoLite2 database is present..."
if [[ -n "${GEOLITE_LICENSE_KEY:-}" ]]; then
    exec ./bin/cli visit:download-db
else
    echo "GEOLITE_LICENSE_KEY is not set. Skipping GeoLite2 database download."
fi

echo "-----> Starting Shlink (via RR)..."
exec ./bin/rr serve -c config/roadrunner/.rr.yml
