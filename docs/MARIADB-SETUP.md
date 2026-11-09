# MariaDB database preparation for XiaoZhi Console

The Console uses the upstream Java API, which expects a MySQL-compatible database named `xiaozhi_esp32_server`. Your existing Home Assistant MariaDB add-on can be reused **without modifying the Home Assistant database**.

## Prepare a dedicated database and least-privilege account

Run these statements **only** in an authenticated MariaDB admin session. Replace the example password before execution; do not put real passwords in GitHub.

```sql
CREATE DATABASE IF NOT EXISTS xiaozhi_esp32_server
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'xiaozhi'@'%' IDENTIFIED BY 'REPLACE_WITH_A_LONG_RANDOM_PASSWORD';
GRANT ALL PRIVILEGES ON xiaozhi_esp32_server.* TO 'xiaozhi'@'%';
```

If the user already exists, `CREATE USER IF NOT EXISTS` does **not** reset its password. Set the intended password explicitly with `ALTER USER` if required.

Set the Console add-on options:
- `database_host`: `core-mariadb` (verify the installed add-on hostname)
- `database_port`: `3306`
- `database_name`: `xiaozhi_esp32_server`
- `database_user`: `xiaozhi`
- `database_password`: the dedicated user's password
- `redis_host`: the actual hostname of the XiaoZhi Redis add-on
- `redis_password`: the Redis add-on password

## Schema migrations

The upstream Console includes a Liquibase change log at `main/manager-api/src/main/resources/db/changelog/db.changelog-master.yaml` and dated SQL migrations. Do **not** manually import an arbitrary SQL snapshot on top of its migrations. First verify the upstream application starts and applies its change sets on a **fresh, empty** database. If a migration fails on MariaDB, stop and inspect the precise SQL error before attempting manual fixes.

Back up MariaDB before first launch. Test the integration in HAOS before exposing the Console to any network outside the trusted LAN.

Upstream migration source: https://github.com/xinnan-tech/xiaozhi-esp32-server/tree/main/main/manager-api/src/main/resources/db/changelog
