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

BUILD_DIR="$1"
CACHE_DIR="$2"
ENV_DIR="$3"

# dans votre buildpack (bin/compile)
if [ -x "$CACHE_DIR/rr" ]; then
  echo "-----> Reusing cached RR..."
  cp "$CACHE_DIR/rr" "$BUILD_DIR/bin/rr"
else
  echo "-----> Installing RR..."
  php ./vendor/bin/rr get --no-interaction --location bin/ && chmod +x "$BUILD_DIR/bin/rr"
  cp "$BUILD_DIR/bin/rr" "$CACHE_DIR/rr"
fi

echo "-----> Assert GeoLite2 database is present..."
if [[ -n "${GEOLITE_LICENSE_KEY:-}" ]]; then
    exec ./bin/cli visit:download-db
else
    echo "GEOLITE_LICENSE_KEY is not set. Skipping GeoLite2 database download."
fi

echo "-----> Starting Shlink (via RR)..."
exec ./bin/rr serve -c config/roadrunner/.rr.yml
