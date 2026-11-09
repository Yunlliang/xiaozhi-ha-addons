#!/bin/sh
set -eu
CONFIG=/data/options.json
read_opt() { jq -r --arg k "$1" '.[$k] // ""' "$CONFIG"; }
DB_HOST="$(read_opt database_host)"
DB_PORT="$(read_opt database_port)"
DB_NAME="$(read_opt database_name)"
DB_USER="$(read_opt database_user)"
DB_PASSWORD="$(read_opt database_password)"
REDIS_HOST="$(read_opt redis_host)"
REDIS_PORT="$(read_opt redis_port)"
REDIS_PASSWORD="$(read_opt redis_password)"
if [ -z "$DB_PASSWORD" ] || [ -z "$REDIS_HOST" ]; then
  echo "ERROR: Configure database_password and redis_host before starting." >&2
  exit 1
fi
mkdir -p /data/uploadfile
if [ -L /uploadfile ]; then
  [ "$(readlink /uploadfile)" = "/data/uploadfile" ] || { echo "ERROR: Unexpected /uploadfile symlink" >&2; exit 1; }
elif [ -d /uploadfile ]; then
  cp -an /uploadfile/. /data/uploadfile/ 2>/dev/null || true
  rm -rf /uploadfile
  ln -s /data/uploadfile /uploadfile
else
  ln -s /data/uploadfile /uploadfile
fi
export SPRING_DATASOURCE_DRUID_URL="jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&nullCatalogMeansCurrent=true"
export SPRING_DATASOURCE_DRUID_USERNAME="$DB_USER"
export SPRING_DATASOURCE_DRUID_PASSWORD="$DB_PASSWORD"
export SPRING_DATA_REDIS_HOST="$REDIS_HOST"
export SPRING_DATA_REDIS_PORT="$REDIS_PORT"
export SPRING_DATA_REDIS_PASSWORD="$REDIS_PASSWORD"
exec /start.sh
