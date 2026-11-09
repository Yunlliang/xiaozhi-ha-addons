#!/bin/sh
set -eu
CONFIG=/data/options.json
PASSWORD="$(jq -r '.password // empty' "$CONFIG")"
MAXMEMORY="$(jq -r '.maxmemory // "256mb"' "$CONFIG")"
if [ -z "$PASSWORD" ] || [ "$PASSWORD" = "CHANGE_ME_BEFORE_START" ]; then
  echo "ERROR: Set a unique Redis password in the add-on options before starting." >&2
  exit 1
fi
case "$MAXMEMORY" in
  *[!0-9a-zA-Z]*|"") echo "ERROR: Invalid maxmemory" >&2; exit 1;;
esac
mkdir -p /data/redis
exec redis-server --bind 0.0.0.0 --port 6379 --protected-mode yes --requirepass "$PASSWORD" --dir /data/redis --appendonly yes --maxmemory "$MAXMEMORY" --maxmemory-policy noeviction
