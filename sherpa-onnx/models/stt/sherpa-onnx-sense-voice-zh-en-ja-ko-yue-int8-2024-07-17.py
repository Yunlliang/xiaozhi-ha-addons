"""Built-in SenseVoice Small INT8 loader for the upstream Sherpa-ONNX add-on."""
import os
import sherpa_onnx
import model_utils


def load(cli_args):
    model_name = "sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17"
    model_dir = os.environ.get("STT_MODEL_DIR", "/stt-models")
    model_utils.fetch_stt_model(model_dir, model_name)
    directory = os.path.join(model_dir, model_name)
    return sherpa_onnx.OfflineRecognizer.from_sense_voice(
        model=os.path.join(directory, "model.int8.onnx"),
        tokens=os.path.join(directory, "tokens.txt"),
        num_threads=cli_args.stt_thread_num,
        provider=cli_args.provider,
        language="zh",
        use_itn=True,
        debug=cli_args.debug,
    )
