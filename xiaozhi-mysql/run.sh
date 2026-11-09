#!/bin/sh
set -eu
umask 077
CONFIG=/data/options.json
read_opt() { jq -r --arg k "$1" '.[$k] // ""' "$CONFIG"; }
ROOT_PASSWORD="$(read_opt root_password)"
DB_NAME="$(read_opt database_name)"
DB_USER="$(read_opt database_user)"
DB_PASSWORD="$(read_opt database_password)"
if [ -z "$ROOT_PASSWORD" ] || [ -z "$DB_PASSWORD" ]; then
  echo "ERROR: Configure root_password and database_password before starting." >&2
  exit 1
fi
for value in "$DB_NAME" "$DB_USER"; do
  case "$value" in
    ""|*[!a-zA-Z0-9_]*)
      echo "ERROR: Database name and user must contain only letters, digits, underscores." >&2
      exit 1;;
  esac
done
if [ "$DB_USER" = "root" ]; then
  echo "ERROR: Use a dedicated non-root database user." >&2
  exit 1
fi
export MYSQL_ROOT_PASSWORD="$ROOT_PASSWORD"
export MYSQL_DATABASE="$DB_NAME"
export MYSQL_USER="$DB_USER"
export MYSQL_PASSWORD="$DB_PASSWORD"
mkdir -p /data/mysql
# The official MySQL entrypoint creates the user/database on the first boot only.
# Changing passwords in add-on options after initialization does not rotate DB credentials.
exec docker-entrypoint.sh mysqld --datadir=/data/mysql --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
