# 37-Voice-Reply-Skill-安裝

> 用途：在 macOS / Codex 中建立語音回覆技能。優先使用 Edge-TTS 串流播放，其次 Edge-TTS 整檔播放，最後使用 macOS `say` 離線備援。
>
> 來源轉換：參考 `mathruffian-dot/agent-speak-skill` 的 Edge-TTS 概念，但不直接沿用 Windows PowerShell / WPF / WMPlayer / SAPI 實作。

## 這份文件會安裝什麼

- 全域 skill：`{{SYNC_ROOT}}/skills/voice-reply`
- 專用 runtime：`{{CODEX_HOME}}/voice-reply/.venv`
- 指令 wrapper：`{{CODEX_HOME}}/python-tools/bin/voice-reply`
- Edge-TTS wrapper：`{{CODEX_HOME}}/python-tools/bin/edge-tts`
- Python 套件：`edge-tts`
- macOS 備援：系統內建 `say` / `afplay`

## 優先順序

```text
Edge-TTS streaming + ffplay/mpv
→ Edge-TTS whole-file mp3 + afplay/ffplay/mpv
→ macOS say offline fallback
```

## 先填變數

| 變數 | 說明 | 範例 |
|---|---|---|
| `{{CODEX_HOME}}` | Codex 設定資料夾 | `{{HOME}}/.codex` |
| `{{LOCAL_BIN}}` | 可選的本機 CLI 目錄 | `{{CODEX_HOME}}/python-tools/bin` |
| `{{VOICE_REPLY_EDGE_VOICE}}` | Edge-TTS 預設聲音 | `zh-TW-YunJheNeural` |
| `{{VOICE_REPLY_SAY_VOICE}}` | macOS say 備援聲音 | `Meijia` |

## 前置需求

- macOS
- Python 3.8+
- `ffplay` 或 `mpv`，用於 Edge-TTS 串流播放；若沒有，仍可用整檔模式或 macOS `say`。
- 網路連線，Edge-TTS 需要連到 Microsoft 服務；敏感內容請改用 `--engine say`。

## 安裝

把下方「內建 Skill 完整安裝內容」整段存成 shell script 執行，或交給 Codex 在本機執行。若直接在 shell 執行，請先依 README 設定 `CODEX_HOME`。

安裝完成後測試：

```bash
{{CODEX_HOME}}/python-tools/bin/voice-reply --dry-run "語音回覆安裝測試"
{{CODEX_HOME}}/python-tools/bin/edge-tts --list-voices
{{CODEX_HOME}}/python-tools/bin/voice-reply --list-macos-voices
```

真實播放測試：

```bash
{{CODEX_HOME}}/python-tools/bin/voice-reply "語音回覆已安裝完成。"
```

## 隱私邊界

- Edge-TTS 會把文字送到 Microsoft 服務，品質較好，是本項預設優先方案。
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
description: Use when the user asks Codex to speak, read aloud, use voice reply, summarize by voice, generate a short spoken answer, or create TTS narration on macOS/Codex. Prioritizes Edge-TTS streaming, then Edge-TTS whole-file playback, then macOS say offline fallback.
metadata:
  short-description: Speak Codex replies with Edge-TTS and macOS fallback
---

# Voice Reply

Use this skill when the user wants a short answer, conclusion, summary, or script read aloud from Codex on macOS.

This is a Codex/macOS adaptation of a Windows-first Edge-TTS speak workflow. Do not follow the source repository literally. This skill's supported route is:

1. Edge-TTS streaming through `ffplay` or `mpv`.
2. Edge-TTS whole-file audio through `afplay`, `ffplay`, or `mpv`.
3. macOS `say` offline fallback.

Default voice priority:

- Edge-TTS voice: `zh-TW-YunJheNeural`
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

1. Write a spoken script:
   - Keep it concise, usually 50-250 Chinese characters for interactive reply.
   - Use natural Traditional Chinese.
   - Speak conclusions and next steps; leave long detail in text.
   - Avoid reading secrets, API keys, private tokens, personal IDs, or sensitive private material aloud unless the user explicitly asks and the context is safe.
2. Run the script with the local command:

```bash
voice-reply "這是一段語音回覆測試。"
```

3. For longer text, write it to a file and run:

```bash
voice-reply --file script.txt
```

4. To keep an audio file:

```bash
voice-reply --out narration.mp3 --file script.txt
```

5. Report briefly:
   - mode used: `edge-stream`, `edge-file`, or `say`
   - output file path if `--out` was requested
   - any fallback that occurred

## Command Reference

The portable installer creates:

```bash
{{CODEX_HOME}}/python-tools/bin/voice-reply
```

Common options:

```bash
voice-reply "文字"
voice-reply --file script.txt
voice-reply --voice zh-TW-HsiaoChenNeural "女聲測試"
voice-reply --engine say "離線測試"
voice-reply --say-voice Meijia "macOS say 測試"
voice-reply --out narration.mp3 --file script.txt
voice-reply --list-edge-voices
voice-reply --list-macos-voices
```

## Privacy Boundary

Edge-TTS sends text to Microsoft's service through the `edge-tts` package. It gives better voice quality and is this skill's first route by user preference, but do not use it for sensitive text unless the user has explicitly accepted cloud TTS for that content.

macOS `say` is the offline fallback. It is less natural but does not upload text.

## Installation And Validation

Install or repair the runtime:

```bash
{{SYNC_ROOT}}/skills/voice-reply/scripts/install_voice_reply.sh
```

Validate:

```bash
voice-reply --dry-run "語音回覆安裝測試"
voice-reply --engine say --dry-run "離線備援測試"
voice-reply --list-macos-voices
```

For a real playback smoke test:

```bash
voice-reply "語音回覆已安裝完成。"
```

## References

- `references/source-adaptation.md` explains what was changed from the Windows-first source design.
AGENT_LAZYPACK_VOICE_REPLY_SKILL_MD_0E95F5A366

# voice-reply/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/voice-reply/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/voice-reply/agents/openai.yaml" <<'AGENT_LAZYPACK_VOICE_REPLY_AGENTS_OPENAI_YAML_DEB9755D27'
name: "voice-reply"
description: "Speak concise Codex replies using Edge-TTS first and macOS say fallback."
default_prompt: "Use $voice-reply when the user asks to speak, read aloud, or provide a voice summary. Keep the spoken script concise and use the voice-reply command."
AGENT_LAZYPACK_VOICE_REPLY_AGENTS_OPENAI_YAML_DEB9755D27

# voice-reply/references/source-adaptation.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/voice-reply/references/source-adaptation.md")"
cat > "{{SYNC_ROOT}}/skills/voice-reply/references/source-adaptation.md" <<'AGENT_LAZYPACK_VOICE_REPLY_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40'
# Source Adaptation

Source reviewed: `mathruffian-dot/agent-speak-skill`.

Useful source ideas:

- Use Edge-TTS as the highest-quality free voice route.
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
- Keep Edge-TTS as first priority because the user prefers the better Microsoft voice quality.
- Keep a privacy boundary: Edge-TTS sends text to Microsoft; macOS `say` does not.

Runtime priority:

```text
Edge-TTS streaming
→ Edge-TTS whole-file audio
→ macOS say offline fallback
```

Default voices:

- Edge-TTS: `zh-TW-YunJheNeural`
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
"$RUNTIME_HOME/.venv/bin/python" -m pip install --upgrade edge-tts

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
"""macOS/Codex voice reply helper.

Priority:
1. Edge-TTS streaming to ffplay/mpv.
2. Edge-TTS whole-file generation and playback.
3. macOS say fallback.
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


DEFAULT_EDGE_VOICE = "zh-TW-YunJheNeural"
DEFAULT_SAY_VOICE = "Meijia"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Speak text with Edge-TTS first, macOS say fallback.")
    parser.add_argument("text", nargs="?", help="Text to speak.")
    parser.add_argument("--file", "-f", help="Read text from UTF-8 file.")
    parser.add_argument("--out", "-o", help="Keep generated audio file. Implies whole-file mode.")
    parser.add_argument("--voice", default=os.environ.get("VOICE_REPLY_EDGE_VOICE", DEFAULT_EDGE_VOICE), help="Edge-TTS voice.")
    parser.add_argument("--say-voice", default=os.environ.get("VOICE_REPLY_SAY_VOICE", DEFAULT_SAY_VOICE), help="macOS say fallback voice.")
    parser.add_argument("--engine", choices=["auto", "edge", "say"], default=os.environ.get("VOICE_REPLY_ENGINE", "auto"), help="Engine route.")
    parser.add_argument("--no-stream", action="store_true", help="Skip Edge-TTS streaming and use whole-file mode.")
    parser.add_argument("--rate", default=os.environ.get("VOICE_REPLY_RATE", "+0%"), help="Edge-TTS rate, e.g. +0%%, -10%%, +15%%.")
    parser.add_argument("--volume", default=os.environ.get("VOICE_REPLY_VOLUME", "+0%"), help="Edge-TTS volume, e.g. +0%%, -20%%.")
    parser.add_argument("--pitch", default=os.environ.get("VOICE_REPLY_PITCH", "+0Hz"), help="Edge-TTS pitch, e.g. +0Hz, -10Hz.")
    parser.add_argument("--dry-run", action="store_true", help="Print selected route without playback or network synthesis.")
    parser.add_argument("--list-edge-voices", action="store_true", help="List Edge-TTS voices and exit.")
    parser.add_argument("--list-macos-voices", action="store_true", help="List macOS say voices and exit.")
    return parser.parse_args()


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

    out_path: Path
    keep_file = bool(args.out)
    if args.out:
        out_path = Path(args.out).expanduser()
        out_path.parent.mkdir(parents=True, exist_ok=True)
    else:
        suffix = ".mp3"
        fd, tmp = tempfile.mkstemp(prefix="voice-reply-", suffix=suffix)
        os.close(fd)
        out_path = Path(tmp)

    if args.dry_run:
        return True, f"dry-run mode=edge-file voice={args.voice} output={out_path if keep_file else '<temp>'}"

    try:
        communicate = edge_tts.Communicate(
            text,
            args.voice,
            rate=args.rate,
            volume=args.volume,
            pitch=args.pitch,
        )
        await communicate.save(str(out_path))
    except Exception as exc:
        if not keep_file:
            out_path.unlink(missing_ok=True)
        return False, f"edge-file-failed:{exc}"

    player = find_file_player()
    if player:
        try:
            if Path(player).name == "ffplay":
                subprocess.run([player, "-nodisp", "-autoexit", "-loglevel", "quiet", str(out_path)], check=False)
            elif Path(player).name == "mpv":
                subprocess.run([player, "--no-video", "--really-quiet", str(out_path)], check=False)
            else:
                subprocess.run([player, str(out_path)], check=False)
        finally:
            if not keep_file:
                out_path.unlink(missing_ok=True)
    return True, f"mode=edge-file voice={args.voice} output={out_path if keep_file else '<temp>'}"


def say_fallback(text: str, args: argparse.Namespace) -> tuple[bool, str]:
    say = shutil.which("say")
    if not say:
        return False, "macos-say-unavailable"

    if args.dry_run:
        return True, f"dry-run mode=say voice={args.say_voice}"

    if args.out:
        out_path = Path(args.out).expanduser()
        out_path.parent.mkdir(parents=True, exist_ok=True)
        if out_path.suffix.lower() in {".aiff", ".aif"}:
            subprocess.run([say, "-v", args.say_voice, "-o", str(out_path), text], check=True)
            return True, f"mode=say voice={args.say_voice} output={out_path}"

        with tempfile.NamedTemporaryFile(prefix="voice-reply-", suffix=".aiff", delete=False) as tmp:
            tmp_path = Path(tmp.name)
        try:
            subprocess.run([say, "-v", args.say_voice, "-o", str(tmp_path), text], check=True)
            ffmpeg = shutil.which("ffmpeg")
            if ffmpeg:
                subprocess.run([ffmpeg, "-y", "-i", str(tmp_path), str(out_path)], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            else:
                tmp_path.replace(out_path.with_suffix(".aiff"))
                return True, f"mode=say voice={args.say_voice} output={out_path.with_suffix('.aiff')}"
        finally:
            tmp_path.unlink(missing_ok=True)
        return True, f"mode=say voice={args.say_voice} output={out_path}"

    subprocess.run([say, "-v", args.say_voice, text], check=True)
    return True, f"mode=say voice={args.say_voice}"


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

    text = read_text(args)
    if not text:
        print("No text provided. Use positional text, --file, or stdin.", file=sys.stderr)
        return 2

    if args.engine == "say":
        ok, msg = say_fallback(text, args)
        print(msg)
        return 0 if ok else 1

    if args.engine in {"auto", "edge"}:
        if not args.no_stream and not args.out:
            ok, msg = await edge_stream(text, args)
            if ok:
                print(msg)
                return 0
            if args.engine == "edge":
                print(msg, file=sys.stderr)
                return 1
            print(f"fallback=edge-file reason={msg}", file=sys.stderr)

        ok, msg = await edge_file(text, args)
        if ok:
            print(msg)
            return 0
        if args.engine == "edge":
            print(msg, file=sys.stderr)
            return 1
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
