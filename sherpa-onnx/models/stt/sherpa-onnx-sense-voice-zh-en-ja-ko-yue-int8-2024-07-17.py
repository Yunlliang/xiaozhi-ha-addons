"""SenseVoice Small INT8 loader for the legacy Sherpa-ONNX add-on."""
import os
from pathlib import Path
import subprocess
import tempfile

import sherpa_onnx

MODEL = "sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17"


def load(cli_args):
    root = Path(os.environ.get("STT_MODEL_DIR", "/stt-models"))
    directory = root / MODEL
    model = directory / "model.int8.onnx"
    tokens = directory / "tokens.txt"
    if not (model.is_file() and tokens.is_file()):
        root.mkdir(parents=True, exist_ok=True)
        url = f"https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/{MODEL}.tar.bz2"
        with tempfile.TemporaryDirectory(dir=str(root), prefix=".sensevoice-") as tmp:
            archive = Path(tmp) / "model.tar.bz2"
            subprocess.run(["curl", "-fL", "--retry", "3", "-o", str(archive), url], check=True)
            subprocess.run(["tar", "-tjf", str(archive)], check=True, stdout=subprocess.DEVNULL)
            # Extract into staging first, so failed downloads do not leave a false cache.
            staging = Path(tmp) / "extract"
            staging.mkdir()
            subprocess.run(["tar", "-xjf", str(archive), "-C", str(staging)], check=True)
            extracted = staging / MODEL
            if not ((extracted / "model.int8.onnx").is_file() and (extracted / "tokens.txt").is_file()):
                raise RuntimeError("SenseVoice archive missing model.int8.onnx or tokens.txt")
            if directory.exists():
                # An incomplete old cache must not be silently treated as valid.
                raise RuntimeError(f"Incomplete SenseVoice cache at {directory}; remove it after inspection")
            extracted.rename(directory)
    return sherpa_onnx.OfflineRecognizer.from_sense_voice(
        model=str(model),
        tokens=str(tokens),
        num_threads=cli_args.stt_thread_num,
        provider=cli_args.provider,
        language="zh",
        use_itn=True,
        debug=cli_args.debug,
    )
