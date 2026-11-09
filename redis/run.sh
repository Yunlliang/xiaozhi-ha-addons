#!/bin/sh
set -eu
umask 077
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
# Do not pass the secret as a command-line argument (visible via process listing).
# Redis accepts JSON-compatible double-quoted strings in its configuration.
PASS_QUOTED="$(jq -r '.password | @json' "$CONFIG")"
cat > /data/redis/redis.conf <<EOF
bind 0.0.0.0
port 6379
protected-mode yes
requirepass $PASS_QUOTED
dir /data/redis
appendonly yes
maxmemory $MAXMEMORY
maxmemory-policy noeviction
EOF
chmod 600 /data/redis/redis.conf
exec redis-server /data/redis/redis.conf
