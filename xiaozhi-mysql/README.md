# XiaoZhi MySQL (HAOS)

Dedicated MySQL 8.0 instance for XiaoZhi. Uses the official MySQL image and persists the database under the add-on's /data/mysql. It is independent of Home Assistant's MariaDB.

1. Install and configure unique `root_password` and `database_password`. Start this add-on and wait for "ready for connections".
2. Set XiaoZhi Console: `database_host: bd45c431-xiaozhi-mysql`, `database_port: 3306`, `database_name: xiaozhi_esp32_server`, `database_user: xiaozhi`, and the same `database_password`.
3. Keep host port 3306 unexposed. The internal Supervisor network resolves the add-on hostname.

**Important:** The database and account are created only when the MySQL data directory is empty. Changing option passwords later does not update an existing database. Back up data before uninstalling or resetting the add-on. This add-on is currently experimental and not HAOS integration-tested.
