#!/usr/bin/env bash
set -euo pipefail

# Dossiers runtime (écrivable sur Scalingo)
mkdir -p /tmp/shlink/{cache,proxies,geoip,locks,log}
mkdir -p ./data

# (Re)lier vers /tmp (idempotent)
rm -rf ./data/cache  ./data/proxies  ./data/geoip  ./data/locks  ./data/log || true
ln -s /tmp/shlink/cache   ./data/cache
ln -s /tmp/shlink/proxies ./data/proxies
ln -s /tmp/shlink/geoip   ./data/geoip
ln -s /tmp/shlink/locks   ./data/locks
ln -s /tmp/shlink/log     ./data/log

# Purge du cache de config (important après modifs d’ENV)
rm -f ./data/cache/app_config.php || true