#!/usr/bin/env bash

echo -n "-----> Installing RR... "
php $1/vendor/bin/rr get --no-interaction --location $1/bin/ && chmod +x $1/bin/rr
ls -la $1/bin
echo "done"

echo "-----> Starting Shlink..."
exec "$1/bin/rr" serve --port ${PORT:-8080} --host ${HOST:-0.0.0.0}


