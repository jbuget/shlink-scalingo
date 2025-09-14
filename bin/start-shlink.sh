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

echo "-----> Starting Shlink..."
exec "/app/bin/rr" serve -o ${HOST:-0.0.0.0}:${PORT:-8080}
