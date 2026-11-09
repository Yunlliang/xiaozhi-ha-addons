# NVIDIA 官方 API 接入约定

小智 LLM 选择 NVIDIA 官方 API，不使用 OpenRouter。此文件为部署目标配置，尚未完成小智 Server 适配或实测。

- Provider：NVIDIA（OpenAI 兼容 API）
- Base URL：`https://integrate.api.nvidia.com/v1`
- Model：`nvidia/nemotron-3.5-lightning-30b-a3b`（实际可用性与模型 ID 以 NVIDIA 控制台为准）
- 鉴权：`Authorization: Bearer <NVIDIA_API_KEY>`
- 优先启用流式输出；验证小智 Server 的 LLM 插件兼容性、首 token 延迟、语音中断与工具调用。
- API Key 必须通过 HA 加载项的敏感配置注入，不能写入公开 GitHub、日志或镜像。

上线前需要在 NVIDIA 官方模型页面核实账号访问权限、接口能力和限额。
