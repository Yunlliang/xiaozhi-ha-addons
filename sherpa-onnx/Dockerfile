ARG BUILD_FROM
FROM ${BUILD_FROM}

# Preserve upstream Paraformer/TTS paths; add SenseVoice support to the
# legacy 0.3.7 model initializer actually shipped in the base image.
COPY models/stt/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.py /app/models/stt/
RUN python3 - <<'PY'
from pathlib import Path
p = Path("/app/model_utils.py")
source = p.read_text()
needle = "if 'sherpa-onnx-paraformer-zh-2023-03-28' == cli_args.stt_model:"
assert source.count(needle) == 1, "Upstream model initializer changed; refusing unsafe patch"
replacement = """if cli_args.stt_model == 'sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17':
            import importlib.util
            loader_path = '/app/models/stt/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.py'
            spec = importlib.util.spec_from_file_location('sensevoice_loader', loader_path)
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)
            stt_model = module.load(cli_args)
        elif 'sherpa-onnx-paraformer-zh-2023-03-28' == cli_args.stt_model:"""
p.write_text(source.replace(needle, replacement))
PY
