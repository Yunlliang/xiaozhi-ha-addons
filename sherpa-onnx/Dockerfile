ARG BUILD_FROM
FROM ${BUILD_FROM}

# Keep upstream service, APIs, and model cache behavior unchanged.
# Add only the SenseVoice loader as an extra built-in STT model.
COPY models/stt/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.py /app/models/stt/
