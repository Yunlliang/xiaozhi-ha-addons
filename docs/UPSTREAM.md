# 上游源码与迁移说明

本仓库不是 GitHub 原生 Fork，属于多项目的 HAOS 加载项集成仓库。尚未导入可安装源码。

## 小智 Server / Console

上游：https://github.com/xinnan-tech/xiaozhi-esp32-server
许可证：MIT（Copyright 2025 xinnan-tech）。上游包含 `main/xiaozhi-server`、`main/manager-api`、`main/manager-web`，不能仅复制 Dockerfile 就宣称可运行。

## Sherpa-ONNX

上游：https://github.com/ptbsare/sherpa-onnx-tts-stt
上游 HA 加载项 slug：`sherpa_onnx_tts_stt`，版本配置为 0.3.7；提供 10400/TCP（Wyoming）与 10500/TCP（OpenAI 兼容语音 API）。当前 HAOS 已有运行实例，迁移版必须使用不同 slug，且不得自动抢占相同端口。复制前需要核实许可证及其依赖许可证。

## Redis

当前 HAOS 已安装的 Redis 加载项上游未确认。先核对实际 slug、镜像和版本，再选择来源；不要冒用现有加载项的身份。

## MariaDB

使用现有 `core-mariadb`，必须单独创建小智数据库与账号，并验证上游 MySQL 方言兼容性。

## 验收条件

1. 所有组件在 HAOS 内运行，Debian 无需部署小智。
2. HAOS x86_64 构建通过，配置文件和持久化目录正确。
3. 检查 8000、8002、8003、10400、10500 端口占用。
4. 验证 Server 与 Console、MariaDB、Redis 的通信。
5. 小智使用云端 Qwen，STT/TTS 优先调用现有 Sherpa 10500 API。
6. 不替换运行中的 Sherpa、Redis、MariaDB、Asterisk；R1 SIP 保持不变。
7. 验证管理后台鉴权、备份恢复及重启行为后才发布安装说明。
