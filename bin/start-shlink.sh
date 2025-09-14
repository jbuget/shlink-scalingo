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

echo -n "-----> Installing RR... "
php /app/vendor/bin/rr get --no-interaction --location /app/bin/ && chmod +x /app/bin/rr
echo "done"

echo "-----> Starting Shlink..."
exec "/app/bin/rr" serve --port ${PORT:-8080} --host ${HOST:-0.0.0.0}

