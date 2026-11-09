# XiaoZhi Console — experimental HAOS wrapper

Uses the **full upstream Web image**, including Java manager API and Vue front end, on port 8002. This is not a placeholder.

**Not yet build-tested or integration-tested on HAOS.**

Requires an existing MariaDB database and dedicated user, plus the separately installed Redis add-on. Fill in database and Redis hostnames and passwords through add-on options. The upstream uses MySQL; MariaDB compatibility and schema initialization still require verification. Never expose the Console publicly without authentication/security review.

The default database hostname `core-mariadb` assumes the HA MariaDB add-on; Redis hostname must be confirmed after its installation. Start Console first, register the first administrator, obtain `server.secret`, and then configure XiaoZhi Server.

Upstream: https://github.com/xinnan-tech/xiaozhi-esp32-server (MIT).
