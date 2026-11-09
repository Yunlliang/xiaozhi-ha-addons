# 上游源码与迁移说明

本仓库不是 GitHub 原生 Fork，属于多项目的 HAOS 加载项集成仓库。尚未导入可安装源码。

## 小智 Server / Console

上游：https://github.com/xinnan-tech/xiaozhi-esp32-server
许可证：MIT（Copyright 2025 xinnan-tech）。上游包含 `main/xiaozhi-server`、`main/manager-api`、`main/manager-web`，不能仅复制 Dockerfile 就宣称可运行。

## Sherpa-ONNX

上游：https://github.com/ptbsare/sherpa-onnx-tts-stt
上游 HA 加载项 slug：`sherpa_onnx_tts_stt`，版本配置为 0.3.7；提供 10400/TCP（Wyoming）与 10500/TCP（OpenAI 兼容语音 API）。当前 HAOS 已有运行实例，迁移版必须使用不同 slug，且不得自动抢占相同端口。复制前需要核实许可证及其依赖许可证。

## Redis

用户已确认 HAOS 尚未安装 Redis。计划新建独立 Redis 加载项，先核对官方 Redis 镜像及许可、持久化、密码、内部网络与端口暴露策略；不使用现有加载项身份。

## MariaDB

使用现有 `core-mariadb`，必须单独创建小智数据库与账号，并验证上游 MySQL 方言兼容性。

## 验收条件

1. 所有组件在 HAOS 内运行，Debian 无需部署小智。
2. HAOS x86_64 构建通过，配置文件和持久化目录正确。
3. 检查 8000、8002、8003、10400、10500 端口占用。
4. 验证 Server 与 Console、MariaDB、Redis 的通信。
5. 小智使用NVIDIA 云端 Nemotron 3.5 Lightning 30B A3B，STT/TTS 优先调用现有 Sherpa 10500 API。
6. 不替换运行中的 Sherpa、MariaDB、Asterisk；Redis 作为新加载项部署；R1 SIP 保持不变。
7. 验证管理后台鉴权、备份恢复及重启行为后才发布安装说明。

## LLM 目标配置（待实现与验证）

- 提供方：NVIDIA API（OpenAI 兼容）
- Base URL：`https://integrate.api.nvidia.com/v1`
- 模型 ID：`nvidia/nemotron-3.5-lightning-30b-a3b`
- 密钥：由 HA 加载项安全配置注入，**禁止提交 API Key 到 GitHub**
- 需验证小智 Server 的 LLM 提供方配置及流式响应、工具调用兼容性；此处只是目标配置，尚未接入。
