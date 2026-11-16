# 小智 STT 低延迟测试：SenseVoice Small INT8（可回退）

本方案只针对 `sherpa-onnx` 加载项；不修改小智 Server、LLM、TTS、数据库或其他加载项。

## 已核对的实现

- 此仓库的 `sherpa-onnx/config.yaml` 复用 `ghcr.io/ptbsare/home-assistant-addons/{arch}-addon-sherpa-onnx-tts-stt` 上游镜像，而不是自行编译 Sherpa-ONNX。
- 上游 `model_utils.py`：当 `custom_stt_model_eval` 不为字符串 `null` 时，会按 `stt_model` 从 sherpa-onnx 的 ASR release 下载模型，之后使用 `eval()` 创建识别器。
- 上游 `run.py`：`stt_use_online_processing` 仅在识别器支持在线流式处理时才会逐块解码。SenseVoice Small 是离线整句识别模型；打开该开关不会让它变成流式。
- **未在用户的 HAOS / 当前镜像版本上实测**。下述配置是候选方案，先检查兼容性再切换。

## 测试前备份

1. 在 HA 加载项“配置”中复制保存现有完整配置（尤其 `stt_model`、`stt_thread_num`、`stt_use_int8_onnx_model`、`custom_stt_model_eval`）。
2. 确认当前模型 `sherpa-onnx-paraformer-zh-small-2024-03-09` 可以正常识别，并保存测试音频/识别结果。
3. **先确认小智 Server 当前实际使用的 STT 服务地址**。如果未连接本加载项，切换模型不会改善小智识别。
4. 若有第二实例，优先在第二实例测试；确认没有端口冲突，勿占用已有 10400/10500 宿主端口。

## SenseVoice Small INT8 候选配置

模型名（官方 ASR 模型包）：

`sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17`

在加载项配置中选择 `custom_stt_model`，然后在 YAML 配置里设置如下 **两个字段**（其余配置保留原值）：

```yaml
stt_model: sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17
custom_stt_model_eval: >-
  sherpa_onnx.OfflineRecognizer.from_sense_voice(
    model="/stt-models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17/model.int8.onnx",
    tokens="/stt-models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17/tokens.txt",
    num_threads=3,
    provider="cpu",
    language="zh",
    use_itn=True,
    debug=False
  )
stt_use_online_processing: false
```

**注意：** 当前 `config.yaml` 中 `stt_model` 是受限的 `list(...|custom_stt_model)`，所以这段候选 YAML **不能保证通过 HA 配置校验**；不能直接复制并保存到生产实例。需要先在隔离测试分支中调整 schema，或使用上游镜像独立测试该模型。此文档保留候选配置用于下一步兼容性开发，避免误导用户以为已实现一键切换。

上游模型下载及 Python API：
- https://github.com/k2-fsa/sherpa-onnx/releases/tag/asr-models
- https://k2-fsa.github.io/sherpa/onnx/sense-voice/python-api.html

## 评测

使用相同的 10–20 条中文指令（数字、联系人、设备名、近音字、噪声环境）对比 Paraformer Small INT8 与 SenseVoice Small INT8。记录：
- 识别正确率（尤其设备名/联系人名）
- 语音结束到识别文字返回的耗时（p50 / p95）
- CPU 使用量与内存
- 首次加载时间与持续运行稳定性

优先优化实际识别准确率与尾延迟，而非只看模型参数大小。若新模型不兼容，恢复原配置并重启**该加载项**即可；不要重启其他服务。
