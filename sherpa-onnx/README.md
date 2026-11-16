# XiaoZhi Sherpa-ONNX TTS/STT

This add-on reuses the **upstream published image**, rather than reimplementing speech recognition and synthesis. Upstream: https://github.com/ptbsare/sherpa-onnx-tts-stt, upstream image (add-on manifest version 0.3.8; image version is controlled by upstream).

This is an optional **second instance** with a different HA slug. It is **not required** if your existing Sherpa add-on works. Ports 10400 and 10500 are intentionally not published on the HA host by default to avoid collisions; assign different host ports if installing a second instance.

OpenAI-compatible API (inside the container): `/v1/audio/transcriptions`, `/v1/audio/speech`. Wyoming TCP 10400. Source and license belong to the upstream author; this repository does not claim ownership of the binary image.

Not yet verified on your HAOS installation.

## SenseVoice Small INT8 (experimental STT)

The add-on configuration now exposes `sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17` as an STT model choice. **This is NOT a one-click model integration**: the upstream image has no verified built-in Python loader for this name. Selecting it alone may fail startup. Keep the working Paraformer configuration until the custom loader has been tested.

For an isolated test instance, set the STT model to that exact name and configure `custom_stt_model_eval` as follows:

```yaml
stt_model: sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17
stt_use_online_processing: false
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
```

This custom expression is executed by upstream Python `eval()`. Only use reviewed, trusted expressions. Model download, compatibility with the pinned upstream image, and the HA add-on options-to-environment mapping **remain unverified**; do not apply to the production instance without testing.

Rollback: restore the original `stt_model` and remove `custom_stt_model_eval` (or set it to the upstream-supported `null` string), then restart only this add-on. No TTS, LLM, database, or other add-on settings need to change.

Official model: https://k2-fsa.github.io/sherpa/onnx/sense-voice/pretrained.html
