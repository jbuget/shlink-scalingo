#!/usr/bin/env bash
set -euo pipefail

echo "-----> Assert GeoLite2 database is present..."
if [[ -n "${GEOLITE_LICENSE_KEY:-}" ]]; then
    exec ./bin/cli visit:download-db
else
    echo "GEOLITE_LICENSE_KEY is not set. Skipping GeoLite2 database download."
fi
echo "done"