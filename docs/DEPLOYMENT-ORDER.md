# XiaoZhi HAOS deployment sequence (not yet validated)

**Do not install as a production replacement until GitHub build and HAOS integration tests pass.**

1. Keep your existing Home Assistant MariaDB and Sherpa-ONNX add-ons running; do not uninstall or reset them.
2. Install XiaoZhi Redis; configure a unique password, verify Redis starts and its persistence directory survives an add-on restart.
3. In MariaDB, create a **separate** XiaoZhi database and account using [MARIADB-SETUP.md](MARIADB-SETUP.md).
4. Install XiaoZhi Console; set MariaDB/Redis hostnames and credentials. Confirm the Java API starts, database migrations complete, and the web UI works on port 8002.
5. Register the initial Console administrator, locate the `server.secret` configuration value, and configure it as the XiaoZhi Server add-on's `manager_secret`. The `manager_url` must be reachable **from the Server container** (not merely from your browser).
6. Install XiaoZhi Server; verify its WebSocket listener (8000) and HTTP listener (8003), plus its ability to fetch settings from the Console.
7. Configure NVIDIA's official OpenAI-compatible LLM endpoint in the Console only after verifying the exact current model identifier. Keep the API key in the Console's protected configuration, never in the GitHub repository.
8. Connect the existing Sherpa-ONNX STT/TTS services and test real audio on a device, including the Phicomm R1 if applicable.

The four folders in this repository are **independent HAOS add-ons**, not a single Docker Compose stack. Internal hostnames, network access, database schema compatibility, upstream image availability, and the voice API must be tested in the target environment.

The optional Sherpa add-on in this repository has a distinct slug to avoid replacing your already installed Sherpa instance.

Useful URLs: https://github.com/Yunlliang/xiaozhi-ha-addons/actions
