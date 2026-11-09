# XiaoZhi Home Assistant Add-ons

本仓库用于在 Home Assistant OS 内部署小智相关服务，Debian 宿主机不部署小智。

## 计划组件（尚未导入）

- XiaoZhi Server、Console：上游 https://github.com/xinnan-tech/xiaozhi-esp32-server
- Redis：尚未安装，计划新增独立 HAOS 加载项
- Sherpa-ONNX STT/TTS：上游 https://github.com/ptbsare/sherpa-onnx-tts-stt

计划复用现有 MariaDB、Redis、Sherpa-ONNX 加载项，LLM 使用NVIDIA 云端 Nemotron 3.5 Lightning 30B A3B。此仓库当前仅为规划，不是可安装的 HA 加载项仓库。迁移时保留原项目许可证和署名。

## LLM 目标配置（待实现与验证）

- 提供方：NVIDIA API（OpenAI 兼容）
- Base URL：`https://integrate.api.nvidia.com/v1`
- 模型 ID：`nvidia/nemotron-3.5-lightning-30b-a3b`
- 密钥：由 HA 加载项安全配置注入，**禁止提交 API Key 到 GitHub**
- 需验证小智 Server 的 LLM 提供方配置及流式响应、工具调用兼容性；此处只是目标配置，尚未接入。
