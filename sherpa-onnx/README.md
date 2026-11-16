# XiaoZhi Sherpa-ONNX TTS/STT

Version **0.4.0**. This add-on builds a **thin local derivative** of the upstream published image, adding one SenseVoice Small INT8 Python loader. The Wyoming and OpenAI-compatible API servers remain upstream code.

Upstream: https://github.com/ptbsare/sherpa-onnx-tts-stt

## What changed

- `Dockerfile` extends the upstream 0.3.7 CPU image via `build.yaml` (amd64/aarch64), copying a new loader into `/app/models/stt/`.
- The STT selector offers the two original Paraformer models and `sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17`.
- The SenseVoice loader downloads the official sherpa-onnx model on first start, then constructs `OfflineRecognizer.from_sense_voice` using `model.int8.onnx` and `tokens.txt`.
- Existing TTS choices and API endpoints are unchanged.

**Status: source integrated, not yet build-tested or validated on HAOS.** An upstream image tag, model archive layout, or sherpa-onnx API mismatch can cause the new model to fail. Do not switch the only working STT instance until a second instance has passed a test.

## Safe installation/test

1. Keep the existing Sherpa-ONNX add-on running. This repository uses a different slug (`xiaozhi_sherpa_onnx`) for a separate test instance.
2. Refresh this GitHub repository in the HA add-on store, then inspect the **0.4.0** add-on. A local build may take longer than pulling a published image.
3. Leave host port mappings for 10400 and 10500 **empty** until you have checked for collisions. For a separate externally accessible test, assign unused host ports.
4. Start with Paraformer Small INT8 and verify startup/logs, then select SenseVoice Small INT8 and restart **only this test add-on**.
5. Inspect logs for download errors, missing files, API errors, and successful startup on 10400/10500. Test a short Chinese WAV against `/v1/audio/transcriptions` through the chosen host mapping.
6. Compare recognition text, response latency and CPU use using identical recordings. Confirm XiaoZhi Server actually calls the tested STT endpoint before attributing improvements to the model.

## Rollback

Switch `stt_model` back to `sherpa-onnx-paraformer-zh-small-2024-03-09`, save and restart only this add-on. The original separate Sherpa add-on is untouched.

The model is offline/utterance-based; `stt_use_online_processing` should remain `false`. Enabling it does not make SenseVoice streaming.

The optional custom expression fields are upstream advanced features and may execute Python code. Do not paste untrusted expressions.

Model: https://github.com/k2-fsa/sherpa-onnx/releases/tag/asr-models
