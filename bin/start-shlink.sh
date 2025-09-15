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

echo "-----> Current directory: $(pwd)"

echo "-----> Listing files in /: $(ls -m /)"

echo "-----> Listing files in /build: $(ls -m /build)"


echo "-----> Installing RR..."
php /app/vendor/bin/rr get --no-interaction --location bin/ && chmod +x bin/rr

echo "-----> Starting Shlink..."
exec bin/rr serve -o ${HOST:-0.0.0.0}:${PORT:-8080}
