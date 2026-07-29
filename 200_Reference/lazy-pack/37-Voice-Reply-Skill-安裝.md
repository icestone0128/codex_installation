# 37-Voice-Reply-Skill-安裝

> 用途：在 macOS 建立三 Agent 共用語音回覆技能。執行前先確認女聲或男聲；女聲使用 Anna Su → HsiaoChen，男聲跳過 ElevenLabs 使用 YunJhe，最後皆以 macOS `say` 離線備援。
>
> 來源轉換：參考 `mathruffian-dot/agent-speak-skill` 的 Edge-TTS 概念，但不直接沿用 Windows PowerShell / WPF / WMPlayer / SAPI 實作。

## 這份文件會安裝什麼

- 全域 skill：`{{SYNC_ROOT}}/skills/voice-reply`
- 專用 runtime：`{{CODEX_HOME}}/voice-reply/.venv`
- 指令 wrapper：`{{CODEX_HOME}}/python-tools/bin/voice-reply`
- Edge-TTS wrapper：`{{CODEX_HOME}}/python-tools/bin/edge-tts`
- Python 套件：`elevenlabs`、`edge-tts`
- macOS 備援：系統內建 `say` / `afplay`

## 性別與優先順序

```text
female: ElevenLabs Anna Su
        → Edge-TTS HsiaoChen
        → macOS say
male:   skip ElevenLabs
        → Edge-TTS YunJhe
        → macOS say
```

## 先填變數

| 變數 | 說明 | 範例 |
|---|---|---|
| `{{CODEX_HOME}}` | Codex 設定資料夾 | `{{HOME}}/.codex` |
| `{{LOCAL_BIN}}` | 可選的本機 CLI 目錄 | `{{CODEX_HOME}}/python-tools/bin` |
| `{{VOICE_REPLY_ELEVENLABS_VOICE_ID}}` | ElevenLabs 預設 voice ID（Anna Su - Casual, Friendly and Bright） | `9lHjugDhwqoxA5MhX0az` |
| `{{VOICE_REPLY_ELEVENLABS_MODEL}}` | ElevenLabs 預設模型 | `eleven_multilingual_v2` |
| `{{VOICE_REPLY_EDGE_VOICE}}` | 明確覆寫 Edge-TTS profile；未設定時女聲用 HsiaoChen、男聲用 YunJhe | `zh-TW-YunJheNeural` |
| `{{VOICE_REPLY_SAY_VOICE}}` | macOS say 備援聲音 | `Meijia` |

## 前置需求

- macOS
- Python 3.8+
- `ffplay` 或 `mpv`，用於 Edge-TTS 串流播放；若沒有，仍可用整檔模式或 macOS `say`。
- 網路連線；ElevenLabs 與 Edge-TTS 都是雲端服務。
- ElevenLabs key 存在 `{{CODEX_HOME}}/secrets/elevenlabs_api_key`；敏感內容請改用 `--engine say`。

## 安裝

把下方「內建 Skill 完整安裝內容」整段存成 shell script 執行，或交給 Codex 在本機執行。若直接在 shell 執行，請先依 README 設定 `CODEX_HOME`。

安裝完成後測試：

```bash
{{CODEX_HOME}}/python-tools/bin/voice-reply --dry-run "缺少性別測試"  # 預期 exit 2
{{CODEX_HOME}}/python-tools/bin/voice-reply --voice-gender female --dry-run "女聲路由測試"
{{CODEX_HOME}}/python-tools/bin/voice-reply --voice-gender male --dry-run "男聲路由測試"
VOICE_REPLY_ELEVENLABS_KEY_FILE=/tmp/missing-elevenlabs-key \
  {{CODEX_HOME}}/python-tools/bin/voice-reply --voice-gender female --dry-run --out /tmp/edge-fallback.mp3 "女聲 Edge 備援測試"
{{CODEX_HOME}}/python-tools/bin/voice-reply --engine edge --voice-gender female --dry-run "HsiaoChen 女聲測試"
{{CODEX_HOME}}/python-tools/bin/voice-reply --engine edge --voice-gender male --dry-run "YunJhe 男聲測試"
{{CODEX_HOME}}/python-tools/bin/edge-tts --list-voices
{{CODEX_HOME}}/python-tools/bin/voice-reply --list-macos-voices
```

真實播放測試：

```bash
{{CODEX_HOME}}/python-tools/bin/voice-reply --voice-gender female "女聲語音回覆已安裝完成。"
{{CODEX_HOME}}/python-tools/bin/voice-reply --voice-gender male "男聲語音回覆已安裝完成。"
```

## 隱私邊界

- ElevenLabs 與 Edge-TTS 都會把文字送到雲端；一般非敏感文字依使用者選定的女聲或男聲 route 執行。
- macOS `say` 是離線備援，不上傳文字，但自然度較低。
- 不要用本技能唸出 API key、token、密碼、個資或敏感私密內容；敏感文字如需語音，請明確指定 `--engine say`。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`voice-reply`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- voice-reply ----
mkdir -p "{{SYNC_ROOT}}/skills/voice-reply"
# voice-reply/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/voice-reply/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/voice-reply/SKILL.md" <<'AGENT_LAZYPACK_VOICE_REPLY_SKILL_MD_0E95F5A366'
---
name: voice-reply
description: >
  Use when the user asks Codex, Claude, or AntiGravity to speak, read aloud,
  use voice reply, summarize by voice, generate a short spoken answer, or
  create TTS narration on macOS. Requires a female/male choice first: female
  uses Anna Su then HsiaoChen fallback; male skips ElevenLabs and uses YunJhe;
  macOS say remains the final fallback.
metadata:
  short-description: Ask female or male, then use the matching TTS route
---

# Voice Reply

Use this skill when the user wants a short answer, conclusion, summary, or script read aloud on macOS.

This is the shared TTS entrypoint for Codex, Claude, and AntiGravity. Before
running TTS, ask whether the user wants a female or male voice unless the
request already states the gender. Do not synthesize with an unspecified
gender.

Supported routes:

- Female: ElevenLabs Anna Su, then Edge-TTS HsiaoChen, then macOS `say`.
- Male: skip ElevenLabs and use Edge-TTS YunJhe, then macOS `say`.

Default voice priority:

- ElevenLabs voice: `Anna Su - Casual, Friendly and Bright`
- ElevenLabs voice ID: `9lHjugDhwqoxA5MhX0az`
- ElevenLabs model: `eleven_multilingual_v2`
- Edge-TTS female profile: `zh-TW-HsiaoChenNeural`
- Edge-TTS male profile: `zh-TW-YunJheNeural`
- macOS fallback voice: `Meijia`

## When To Use

Use this skill for phrases such as:

- "用語音回答"
- "唸出來"
- "唸給我聽"
- "語音摘要"
- "講結論給我聽"
- "read this aloud"
- "speak the answer"

Do not use this skill for authorized voice cloning or a named person's voice. Use the appropriate voice-cloning workflow only when the user explicitly asks for a specific authorized cloned voice.

## Operating Steps

1. Resolve the voice-gender gate:
   - if the user already requested a female or male voice, do not ask again;
   - otherwise ask one concise question: "這次要使用女聲還是男聲？";
   - do not run TTS until the answer is known;
   - female uses `--voice-gender female`; male uses `--voice-gender male`.
2. Write a spoken script:
   - Keep it concise, usually 50-250 Chinese characters for interactive reply.
   - Use natural Traditional Chinese.
   - Speak conclusions and next steps; leave long detail in text.
   - Avoid reading secrets, API keys, private tokens, personal IDs, or sensitive private material aloud unless the user explicitly asks and the context is safe.
3. Run the script with the local command:

```bash
voice-reply --voice-gender female "這是一段女聲語音回覆測試。"
voice-reply --voice-gender male "這是一段男聲語音回覆測試。"
```

4. For longer text, write it to a file and run:

```bash
voice-reply --voice-gender female --file script.txt
```

5. To keep an audio file:

```bash
voice-reply --voice-gender male --out narration.mp3 --file script.txt
```

6. Report briefly:
   - mode used: `elevenlabs-file`, `edge-stream`, `edge-file`, or `say`
   - output file path if `--out` was requested
   - any fallback that occurred

## Command Reference

The portable installer creates:

```bash
{{CODEX_HOME}}/python-tools/bin/voice-reply
```

Common options:

```bash
voice-reply --voice-gender female "女聲文字"
voice-reply --voice-gender male --file script.txt
voice-reply --engine elevenlabs --voice-gender female "Anna Su 女聲測試"
voice-reply --voice-gender female --eleven-voice-id 9lHjugDhwqoxA5MhX0az "指定 Anna Su 聲音"
voice-reply --engine edge --voice-gender female "HsiaoChen 女聲測試"
voice-reply --engine edge --voice-gender male "YunJhe 男聲測試"
voice-reply --voice-gender female --voice zh-TW-HsiaoYuNeural "明確覆寫 Edge 聲音"
voice-reply --engine say "離線測試"
voice-reply --say-voice Meijia "macOS say 測試"
voice-reply --voice-gender female --out narration.mp3 --file script.txt
voice-reply --list-edge-voices
voice-reply --list-macos-voices
```

## Privacy Boundary

ElevenLabs and Edge-TTS send text to cloud services. The user's standing
preference authorizes the matching female or male route for ordinary,
non-sensitive TTS, but do not send secrets, private identifiers, confidential
work content, or other sensitive text to either service without
content-specific approval.

Use `voice-reply --engine say ...` when the content must stay offline. macOS `say` is less natural but does not upload text.

## Installation And Validation

Install or repair the runtime:

```bash
{{SYNC_ROOT}}/skills/voice-reply/scripts/install_voice_reply.sh
```

Validate:

```bash
voice-reply --dry-run "缺少性別測試"  # 預期 exit 2，不產生音檔
voice-reply --voice-gender female --dry-run "女聲路由測試"
voice-reply --voice-gender male --dry-run "男聲路由測試"
VOICE_REPLY_ELEVENLABS_KEY_FILE=/tmp/missing-elevenlabs-key \
  voice-reply --voice-gender female --dry-run --out /tmp/edge-fallback.mp3 "女聲 Edge 備援測試"
voice-reply --engine edge --voice-gender female --dry-run "HsiaoChen 女聲設定測試"
voice-reply --engine edge --voice-gender male --dry-run "YunJhe 男聲設定測試"
voice-reply --engine say --dry-run "離線備援測試"
voice-reply --list-macos-voices
```

For a real playback smoke test:

```bash
voice-reply --voice-gender female "女聲語音回覆已安裝完成。"
voice-reply --voice-gender male "男聲語音回覆已安裝完成。"
```

## References

- `references/source-adaptation.md` explains what was changed from the Windows-first source design.
AGENT_LAZYPACK_VOICE_REPLY_SKILL_MD_0E95F5A366

# voice-reply/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/voice-reply/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/voice-reply/agents/openai.yaml" <<'AGENT_LAZYPACK_VOICE_REPLY_AGENTS_OPENAI_YAML_DEB9755D27'
name: "voice-reply"
description: "Ask for female or male, then speak with the matching Anna Su or Edge-TTS route."
default_prompt: "Use $voice-reply when the user asks to speak, read aloud, or provide a voice summary. If gender is not already specified, ask female or male before running TTS; then use the matching voice-reply route."
AGENT_LAZYPACK_VOICE_REPLY_AGENTS_OPENAI_YAML_DEB9755D27

# voice-reply/references/source-adaptation.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/voice-reply/references/source-adaptation.md")"
cat > "{{SYNC_ROOT}}/skills/voice-reply/references/source-adaptation.md" <<'AGENT_LAZYPACK_VOICE_REPLY_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40'
# Source Adaptation

Source reviewed: `mathruffian-dot/agent-speak-skill`.

Useful source ideas:

- Use Edge-TTS as a free cloud fallback.
- Stream audio chunks into a pipe player so voice starts quickly.
- Fall back to whole-file audio generation when streaming fails.
- Fall back to a local offline system voice when Edge-TTS is unavailable.

Codex/macOS changes:

- Do not use the Windows PowerShell control flow as the runtime contract.
- Do not use WPF MediaPlayer, WMPlayer COM, or Windows SAPI. They are Windows-only.
- Use Python as the cross-platform runtime wrapper.
- On macOS, use `ffplay` or `mpv` for streaming playback.
- On macOS, use `afplay`, `ffplay`, or `mpv` for whole-file playback.
- Use macOS `say` as the offline local fallback.
- Add ElevenLabs Anna Su as the female-route first choice; the male route skips ElevenLabs.
- Keep a privacy boundary: ElevenLabs and Edge-TTS send text to cloud services; macOS `say` does not.

Ask for female or male before TTS unless the request already specifies it.
Runtime priority:

```text
female: ElevenLabs Anna Su
        → Edge-TTS HsiaoChen streaming / whole-file
        → macOS say offline fallback
male:   skip ElevenLabs
        → Edge-TTS YunJhe streaming / whole-file
        → macOS say offline fallback
```

Default voices:

- ElevenLabs: `Anna Su - Casual, Friendly and Bright`, voice ID `9lHjugDhwqoxA5MhX0az`, model `eleven_multilingual_v2`
- Edge-TTS female profile: `zh-TW-HsiaoChenNeural`
- Edge-TTS male profile: `zh-TW-YunJheNeural`
- macOS say: `Meijia`

Portable packaging:

- Public install docs must use `{{CODEX_HOME}}`, `{{LOCAL_BIN}}`, and `{{SECRETS_DIR}}` style placeholders.
- Do not publish the maintainer's real local paths.
- Do not package generated audio files or personal voice samples.
AGENT_LAZYPACK_VOICE_REPLY_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40

# voice-reply/scripts/install_voice_reply.sh
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/voice-reply/scripts/install_voice_reply.sh")"
cat > "{{SYNC_ROOT}}/skills/voice-reply/scripts/install_voice_reply.sh" <<'AGENT_LAZYPACK_VOICE_REPLY_SCRIPTS_INSTALL_VOICE_REPLY_SH_81825105CB'
#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PYTHON_TOOLS_HOME="${PYTHON_TOOLS_HOME:-$CODEX_HOME/python-tools}"
RUNTIME_HOME="${VOICE_REPLY_HOME:-$CODEX_HOME/voice-reply}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="${VOICE_REPLY_SKILL_DIR:-$(dirname "$SCRIPT_DIR")}"
PYTHON_BIN="${PYTHON_BIN:-python3}"

mkdir -p "$RUNTIME_HOME" "$PYTHON_TOOLS_HOME/bin"

if [ ! -x "$RUNTIME_HOME/.venv/bin/python" ]; then
  "$PYTHON_BIN" -m venv "$RUNTIME_HOME/.venv"
fi

"$RUNTIME_HOME/.venv/bin/python" -m pip install --upgrade pip
"$RUNTIME_HOME/.venv/bin/python" -m pip install --upgrade edge-tts elevenlabs

cat > "$PYTHON_TOOLS_HOME/bin/voice-reply" <<EOF
#!/usr/bin/env bash
set -euo pipefail
CODEX_HOME="\${CODEX_HOME:-$CODEX_HOME}"
VOICE_REPLY_HOME="\${VOICE_REPLY_HOME:-$RUNTIME_HOME}"
VOICE_REPLY_SKILL_DIR="\${VOICE_REPLY_SKILL_DIR:-$SKILL_DIR}"
exec "\$VOICE_REPLY_HOME/.venv/bin/python" "\$VOICE_REPLY_SKILL_DIR/scripts/voice_reply.py" "\$@"
EOF
chmod +x "$PYTHON_TOOLS_HOME/bin/voice-reply"

cat > "$PYTHON_TOOLS_HOME/bin/edge-tts" <<EOF
#!/usr/bin/env bash
set -euo pipefail
VOICE_REPLY_HOME="\${VOICE_REPLY_HOME:-$RUNTIME_HOME}"
exec "\$VOICE_REPLY_HOME/.venv/bin/edge-tts" "\$@"
EOF
chmod +x "$PYTHON_TOOLS_HOME/bin/edge-tts"

"$RUNTIME_HOME/.venv/bin/python" - <<'PY'
import importlib.metadata as md
print("edge-tts", md.version("edge-tts"))
print("elevenlabs", md.version("elevenlabs"))
PY

echo "voice-reply installed"
echo "wrapper: {{CODEX_HOME}}/python-tools/bin/voice-reply"
echo "edge-tts wrapper: {{CODEX_HOME}}/python-tools/bin/edge-tts"
AGENT_LAZYPACK_VOICE_REPLY_SCRIPTS_INSTALL_VOICE_REPLY_SH_81825105CB
chmod +x "{{SYNC_ROOT}}/skills/voice-reply/scripts/install_voice_reply.sh"

# voice-reply/scripts/voice_reply.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/voice-reply/scripts/voice_reply.py")"
cat > "{{SYNC_ROOT}}/skills/voice-reply/scripts/voice_reply.py" <<'AGENT_LAZYPACK_VOICE_REPLY_SCRIPTS_VOICE_REPLY_PY_AC7A3C8A16'
#!/usr/bin/env python3
"""Cross-agent macOS voice reply helper.

Priority:
1. ElevenLabs multilingual cloud TTS.
2. Edge-TTS streaming or whole-file generation.
3. macOS say offline fallback.
"""

from __future__ import annotations

import argparse
import asyncio
import os
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path


DEFAULT_EDGE_MALE_VOICE = "zh-TW-YunJheNeural"
DEFAULT_EDGE_FEMALE_VOICE = "zh-TW-HsiaoChenNeural"
DEFAULT_EDGE_VOICE = DEFAULT_EDGE_MALE_VOICE
EDGE_VOICE_BY_GENDER = {
    "female": DEFAULT_EDGE_FEMALE_VOICE,
    "male": DEFAULT_EDGE_MALE_VOICE,
}
DEFAULT_SAY_VOICE = "Meijia"
DEFAULT_ELEVENLABS_VOICE_ID = "9lHjugDhwqoxA5MhX0az"
DEFAULT_ELEVENLABS_MODEL = "eleven_multilingual_v2"
DEFAULT_ELEVENLABS_OUTPUT_FORMAT = "mp3_44100_128"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Speak text through a required female/male route, "
            "with macOS say as the final fallback."
        )
    )
    parser.add_argument("text", nargs="?", help="Text to speak.")
    parser.add_argument("--file", "-f", help="Read text from UTF-8 file.")
    parser.add_argument("--out", "-o", help="Keep generated audio file. Implies whole-file mode.")
    parser.add_argument(
        "--voice",
        default=os.environ.get("VOICE_REPLY_EDGE_VOICE"),
        help="Explicit Edge-TTS voice. Overrides the --voice-gender profile.",
    )
    parser.add_argument(
        "--voice-gender",
        "--edge-gender",
        dest="voice_gender",
        choices=sorted(EDGE_VOICE_BY_GENDER),
        help=(
            "Required TTS route: female tries Anna Su then HsiaoChen; "
            "male skips ElevenLabs and uses YunJhe."
        ),
    )
    parser.add_argument("--say-voice", default=os.environ.get("VOICE_REPLY_SAY_VOICE", DEFAULT_SAY_VOICE), help="macOS say fallback voice.")
    parser.add_argument(
        "--eleven-voice-id",
        default=os.environ.get(
            "VOICE_REPLY_ELEVENLABS_VOICE_ID", DEFAULT_ELEVENLABS_VOICE_ID
        ),
        help="ElevenLabs voice ID.",
    )
    parser.add_argument(
        "--eleven-model",
        default=os.environ.get(
            "VOICE_REPLY_ELEVENLABS_MODEL", DEFAULT_ELEVENLABS_MODEL
        ),
        help="ElevenLabs model ID.",
    )
    parser.add_argument(
        "--eleven-output-format",
        default=os.environ.get(
            "VOICE_REPLY_ELEVENLABS_OUTPUT_FORMAT",
            DEFAULT_ELEVENLABS_OUTPUT_FORMAT,
        ),
        help="ElevenLabs output format.",
    )
    parser.add_argument(
        "--engine",
        choices=["auto", "elevenlabs", "edge", "say"],
        default=os.environ.get("VOICE_REPLY_ENGINE", "auto"),
        help="Start the fallback route at this engine.",
    )
    parser.add_argument("--no-stream", action="store_true", help="Skip Edge-TTS streaming and use whole-file mode.")
    parser.add_argument("--rate", default=os.environ.get("VOICE_REPLY_RATE", "+0%"), help="Edge-TTS rate, e.g. +0%%, -10%%, +15%%.")
    parser.add_argument("--volume", default=os.environ.get("VOICE_REPLY_VOLUME", "+0%"), help="Edge-TTS volume, e.g. +0%%, -20%%.")
    parser.add_argument("--pitch", default=os.environ.get("VOICE_REPLY_PITCH", "+0Hz"), help="Edge-TTS pitch, e.g. +0Hz, -10Hz.")
    parser.add_argument("--dry-run", action="store_true", help="Print selected route without playback or network synthesis.")
    parser.add_argument("--list-edge-voices", action="store_true", help="List Edge-TTS voices and exit.")
    parser.add_argument("--list-macos-voices", action="store_true", help="List macOS say voices and exit.")
    return parser.parse_args()


def load_elevenlabs_api_key() -> str | None:
    value = os.environ.get("ELEVENLABS_API_KEY", "").strip()
    if value:
        return value
    configured = os.environ.get("VOICE_REPLY_ELEVENLABS_KEY_FILE", "").strip()
    secret_path = (
        Path(configured).expanduser()
        if configured
        else Path.home() / ".codex" / "secrets" / "elevenlabs_api_key"
    )
    if secret_path.is_file():
        value = secret_path.read_text(encoding="utf-8").strip()
        return value or None
    return None


def concise_error(prefix: str, exc: Exception, api_key: str | None = None) -> str:
    message = " ".join(str(exc).split())
    if api_key:
        message = message.replace(api_key, "[redacted]")
    if len(message) > 240:
        message = f"{message[:237]}..."
    return f"{prefix}:{type(exc).__name__}:{message or 'unknown-error'}"


def read_text(args: argparse.Namespace) -> str:
    if args.file:
        return Path(args.file).read_text(encoding="utf-8").strip()
    if args.text:
        return args.text.strip()
    if not sys.stdin.isatty():
        return sys.stdin.read().strip()
    return ""


def find_stream_player() -> list[str] | None:
    mpv = shutil.which("mpv")
    if mpv:
        return [mpv, "--no-video", "--really-quiet", "--keep-open=no", "-"]
    ffplay = shutil.which("ffplay")
    if ffplay:
        return [ffplay, "-nodisp", "-autoexit", "-loglevel", "quiet", "-i", "pipe:0"]
    return None


def find_file_player() -> str | None:
    for name in ("afplay", "ffplay", "mpv"):
        path = shutil.which(name)
        if path:
            return path
    return None


def play_file(path: Path) -> None:
    player = find_file_player()
    if not player:
        return
    if Path(player).name == "ffplay":
        subprocess.run(
            [player, "-nodisp", "-autoexit", "-loglevel", "quiet", str(path)],
            check=False,
        )
    elif Path(player).name == "mpv":
        subprocess.run(
            [player, "--no-video", "--really-quiet", str(path)],
            check=False,
        )
    else:
        subprocess.run([player, str(path)], check=False)


def elevenlabs_file(text: str, args: argparse.Namespace) -> tuple[bool, str]:
    api_key = load_elevenlabs_api_key()
    if not api_key:
        return False, "elevenlabs-key-missing"

    if args.dry_run:
        return (
            True,
            "dry-run mode=elevenlabs-file "
            f"voice_id={args.eleven_voice_id} model={args.eleven_model} "
            f"output={Path(args.out).expanduser() if args.out else '<temp>'}",
        )

    try:
        from elevenlabs.client import ElevenLabs
    except Exception as exc:  # pragma: no cover - depends on local install
        return False, concise_error("elevenlabs-sdk-unavailable", exc, api_key)

    keep_file = bool(args.out)
    target_path = Path(args.out).expanduser() if args.out else None
    if target_path:
        target_path.parent.mkdir(parents=True, exist_ok=True)

    work_dir = target_path.parent if target_path else None
    fd, raw_name = tempfile.mkstemp(
        prefix=".voice-reply-elevenlabs-",
        suffix=".mp3",
        dir=work_dir,
    )
    os.close(fd)
    raw_path = Path(raw_name)
    final_path = raw_path

    try:
        client = ElevenLabs(api_key=api_key)
        audio = client.text_to_speech.convert(
            voice_id=args.eleven_voice_id,
            model_id=args.eleven_model,
            output_format=args.eleven_output_format,
            text=text,
        )
        with raw_path.open("wb") as handle:
            for chunk in audio:
                if chunk:
                    handle.write(chunk)

        if target_path:
            if target_path.suffix.lower() == ".mp3":
                raw_path.replace(target_path)
            else:
                ffmpeg = shutil.which("ffmpeg")
                if not ffmpeg:
                    return False, "elevenlabs-conversion-needs-ffmpeg"
                fd, converted_name = tempfile.mkstemp(
                    prefix=".voice-reply-converted-",
                    suffix=target_path.suffix or ".wav",
                    dir=target_path.parent,
                )
                os.close(fd)
                converted_path = Path(converted_name)
                try:
                    subprocess.run(
                        [ffmpeg, "-y", "-i", str(raw_path), str(converted_path)],
                        check=True,
                        stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL,
                    )
                    converted_path.replace(target_path)
                finally:
                    converted_path.unlink(missing_ok=True)
            final_path = target_path
        else:
            play_file(raw_path)
        return (
            True,
            "mode=elevenlabs-file "
            f"voice_id={args.eleven_voice_id} model={args.eleven_model} "
            f"output={final_path if keep_file else '<temp>'}",
        )
    except Exception as exc:
        return False, concise_error("elevenlabs-failed", exc, api_key)
    finally:
        raw_path.unlink(missing_ok=True)


async def edge_stream(text: str, args: argparse.Namespace) -> tuple[bool, str]:
    player_cmd = find_stream_player()
    if not player_cmd:
        return False, "no-stream-player"
    try:
        import edge_tts
    except Exception as exc:  # pragma: no cover - depends on local install
        return False, f"edge-tts-unavailable:{exc}"

    if args.dry_run:
        return True, f"dry-run mode=edge-stream voice={args.voice} player={Path(player_cmd[0]).name}"

    started = time.perf_counter()
    proc = subprocess.Popen(player_cmd, stdin=subprocess.PIPE)
    first_sound = None
    try:
        communicate = edge_tts.Communicate(
            text,
            args.voice,
            rate=args.rate,
            volume=args.volume,
            pitch=args.pitch,
        )
        async for chunk in communicate.stream():
            if chunk.get("type") != "audio":
                continue
            if first_sound is None:
                first_sound = time.perf_counter() - started
            try:
                assert proc.stdin is not None
                proc.stdin.write(chunk["data"])
            except (BrokenPipeError, OSError):
                break
        if proc.stdin:
            proc.stdin.close()
        proc.wait()
        elapsed = time.perf_counter() - started
        first = "unknown" if first_sound is None else f"{first_sound:.1f}s"
        return proc.returncode == 0, f"mode=edge-stream voice={args.voice} first_sound={first} total={elapsed:.1f}s"
    except Exception as exc:
        try:
            if proc.stdin:
                proc.stdin.close()
        except Exception:
            pass
        proc.terminate()
        return False, f"edge-stream-failed:{exc}"


async def edge_file(text: str, args: argparse.Namespace) -> tuple[bool, str]:
    try:
        import edge_tts
    except Exception as exc:  # pragma: no cover
        return False, f"edge-tts-unavailable:{exc}"

    keep_file = bool(args.out)
    target_path = Path(args.out).expanduser() if args.out else None
    if target_path:
        target_path.parent.mkdir(parents=True, exist_ok=True)

    if args.dry_run:
        return (
            True,
            f"dry-run mode=edge-file voice={args.voice} "
            f"output={target_path if keep_file else '<temp>'}",
        )

    if target_path:
        fd, tmp = tempfile.mkstemp(
            prefix=".voice-reply-edge-",
            suffix=".mp3",
            dir=target_path.parent,
        )
        os.close(fd)
        out_path = Path(tmp)
        needs_conversion = target_path.suffix.lower() not in {"", ".mp3"}
    else:
        fd, tmp = tempfile.mkstemp(prefix="voice-reply-", suffix=".mp3")
        os.close(fd)
        out_path = Path(tmp)
        needs_conversion = False

    try:
        communicate = edge_tts.Communicate(
            text,
            args.voice,
            rate=args.rate,
            volume=args.volume,
            pitch=args.pitch,
        )
        await communicate.save(str(out_path))
        if target_path:
            if needs_conversion:
                ffmpeg = shutil.which("ffmpeg")
                if not ffmpeg:
                    return False, "edge-conversion-needs-ffmpeg"
                fd, converted_name = tempfile.mkstemp(
                    prefix=".voice-reply-edge-converted-",
                    suffix=target_path.suffix,
                    dir=target_path.parent,
                )
                os.close(fd)
                converted_path = Path(converted_name)
                try:
                    subprocess.run(
                        [ffmpeg, "-y", "-i", str(out_path), str(converted_path)],
                        check=True,
                        stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL,
                    )
                    converted_path.replace(target_path)
                finally:
                    converted_path.unlink(missing_ok=True)
            else:
                out_path.replace(target_path)
    except Exception as exc:
        out_path.unlink(missing_ok=True)
        return False, f"edge-file-failed:{exc}"

    try:
        play_file(target_path or out_path)
    finally:
        out_path.unlink(missing_ok=True)
    return (
        True,
        f"mode=edge-file voice={args.voice} "
        f"output={target_path if keep_file else '<temp>'}",
    )


def say_fallback(text: str, args: argparse.Namespace) -> tuple[bool, str]:
    say = shutil.which("say")
    if not say:
        return False, "macos-say-unavailable"

    if args.dry_run:
        return True, f"dry-run mode=say voice={args.say_voice}"

    try:
        if args.out:
            out_path = Path(args.out).expanduser()
            out_path.parent.mkdir(parents=True, exist_ok=True)
            if out_path.suffix.lower() in {".aiff", ".aif"}:
                subprocess.run(
                    [say, "-v", args.say_voice, "-o", str(out_path), text],
                    check=True,
                )
                return True, f"mode=say voice={args.say_voice} output={out_path}"

            with tempfile.NamedTemporaryFile(
                prefix="voice-reply-",
                suffix=".aiff",
                delete=False,
            ) as tmp:
                tmp_path = Path(tmp.name)
            try:
                subprocess.run(
                    [say, "-v", args.say_voice, "-o", str(tmp_path), text],
                    check=True,
                )
                ffmpeg = shutil.which("ffmpeg")
                if ffmpeg:
                    subprocess.run(
                        [ffmpeg, "-y", "-i", str(tmp_path), str(out_path)],
                        check=True,
                        stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL,
                    )
                else:
                    tmp_path.replace(out_path.with_suffix(".aiff"))
                    return (
                        True,
                        f"mode=say voice={args.say_voice} "
                        f"output={out_path.with_suffix('.aiff')}",
                    )
            finally:
                tmp_path.unlink(missing_ok=True)
            return True, f"mode=say voice={args.say_voice} output={out_path}"

        subprocess.run([say, "-v", args.say_voice, text], check=True)
        return True, f"mode=say voice={args.say_voice}"
    except Exception as exc:
        return False, concise_error("macos-say-failed", exc)


def list_macos_voices() -> int:
    say = shutil.which("say")
    if not say:
        print("macOS say not found", file=sys.stderr)
        return 1
    subprocess.run([say, "-v", "?"], check=False)
    return 0


def list_edge_voices() -> int:
    edge = shutil.which("edge-tts")
    if edge:
        return subprocess.run([edge, "--list-voices"], check=False).returncode
    try:
        import edge_tts  # noqa: F401
    except Exception as exc:
        print(f"edge-tts not installed: {exc}", file=sys.stderr)
        return 1
    return subprocess.run([sys.executable, "-m", "edge_tts", "--list-voices"], check=False).returncode


async def run() -> int:
    args = parse_args()
    if args.list_macos_voices:
        return list_macos_voices()
    if args.list_edge_voices:
        return list_edge_voices()

    if args.engine != "say" and not args.voice_gender:
        print(
            "Voice gender required. Ask the user to choose female or male, "
            "then pass --voice-gender female|male.",
            file=sys.stderr,
        )
        return 2

    if args.voice_gender and not args.voice:
        args.voice = EDGE_VOICE_BY_GENDER[args.voice_gender]

    text = read_text(args)
    if not text:
        print("No text provided. Use positional text, --file, or stdin.", file=sys.stderr)
        return 2

    if args.engine == "say":
        ok, msg = say_fallback(text, args)
        print(msg)
        return 0 if ok else 1

    should_try_elevenlabs = (
        args.voice_gender == "female"
        and args.engine in {"auto", "elevenlabs"}
    )
    if should_try_elevenlabs:
        ok, msg = elevenlabs_file(text, args)
        if ok:
            print(msg)
            return 0
        print(f"fallback=edge reason={msg}", file=sys.stderr)
    elif args.voice_gender == "male" and args.engine in {"auto", "elevenlabs"}:
        print("skip=elevenlabs reason=male-voice-route", file=sys.stderr)

    if args.engine in {"auto", "elevenlabs", "edge"}:
        if not args.no_stream and not args.out:
            ok, msg = await edge_stream(text, args)
            if ok:
                print(msg)
                return 0
            print(f"fallback=edge-file reason={msg}", file=sys.stderr)

        ok, msg = await edge_file(text, args)
        if ok:
            print(msg)
            return 0
        print(f"fallback=say reason={msg}", file=sys.stderr)

    ok, msg = say_fallback(text, args)
    print(msg)
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(asyncio.run(run()))
AGENT_LAZYPACK_VOICE_REPLY_SCRIPTS_VOICE_REPLY_PY_AC7A3C8A16
chmod +x "{{SYNC_ROOT}}/skills/voice-reply/scripts/voice_reply.py"

test -f "{{SYNC_ROOT}}/skills/voice-reply/SKILL.md" && echo "voice-reply installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
