# XiaoZhi Sherpa-ONNX TTS/STT

This add-on reuses the **upstream published image**, rather than reimplementing speech recognition and synthesis. Upstream: https://github.com/ptbsare/sherpa-onnx-tts-stt, image version 0.3.7.

This is an optional **second instance** with a different HA slug. It is **not required** if your existing Sherpa add-on works. Ports 10400 and 10500 are intentionally not published on the HA host by default to avoid collisions; assign different host ports if installing a second instance.

OpenAI-compatible API (inside the container): `/v1/audio/transcriptions`, `/v1/audio/speech`. Wyoming TCP 10400. Source and license belong to the upstream author; this repository does not claim ownership of the binary image.

Not yet verified on your HAOS installation.
