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

# 1) Dossiers runtime écrivable (sur Scalingo, /tmp est toujours RW)
mkdir -p /tmp/shlink/{cache,proxies,geoip,locks,log}
mkdir -p ./data

# 2) (Re)lier data/* -> /tmp/shlink/* (idempotent)
rm -rf ./data/cache  ./data/proxies  ./data/geoip  ./data/locks  ./data/log || true
ln -s /tmp/shlink/cache   ./data/cache
ln -s /tmp/shlink/proxies ./data/proxies
ln -s /tmp/shlink/geoip   ./data/geoip
ln -s /tmp/shlink/locks   ./data/locks
ln -s /tmp/shlink/log     ./data/log

# 3) Purger le cache de config en cas de changement d'ENV
rm -f ./data/cache/app_config.php || true

# 4) Sanity-check : le dossier proxies DOIT exister et être écrit/lu
php -r 'echo (is_dir("data/proxies") && is_writable("data/proxies")) ? "proxies:OK\n" : "proxies:KO\n";'

echo "-----> Installing RR..."
php ./vendor/bin/rr get --no-interaction --location bin/ && chmod +x "./bin/rr"

echo "-----> Starting Shlink (via RR)..."
exec ./bin/rr serve -c config/roadrunner/.rr.yml