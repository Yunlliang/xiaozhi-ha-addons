# XiaoZhi Server — experimental HAOS wrapper

This add-on packages the **full upstream Server image** `ghcr.io/xinnan-tech/xiaozhi-esp32-server:server_latest`, rather than replacing the server with a stub.

**Not yet tested in HAOS. Do not install as a production replacement.**

Prerequisites: XiaoZhi Console (manager-api) must be working, its `server.secret` must be copied into this add-on's `manager_secret` option. Configure `manager_url` to a reachable Console URL.

Ports: 8000 (WebSocket), 8003 (HTTP/OTA). Console and MariaDB/Redis are separate components. The NVIDIA LLM selection and Sherpa STT/TTS must be configured through the Console and validated after it is available. This add-on does **not** automatically configure them.

Important limitations:
- Upstream image tag is mutable and needs pinning after successful validation.
- Startup wrapper creates `data/.config.yaml` from upstream `config_from_api.yaml`; does not yet persist user-customized config or models between updates.
- HAOS build/startup and full end-to-end protocol tests have not run.
- Do not expose ports publicly before authentication and security review.

Upstream: https://github.com/xinnan-tech/xiaozhi-esp32-server (MIT license).
