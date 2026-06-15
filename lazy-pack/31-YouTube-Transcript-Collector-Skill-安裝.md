# 31-YouTube-Transcript-Collector-Skill-安裝

> 版本：2026-06-15 Codex App 版
> 用途：安裝 `youtube-transcript-collector` 全域 skill，固定「先產生 YouTube 影片總表 MD，再逐支抓繁體中文字幕 MD」的工作流程。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/youtube-transcript-collector/`。

## 來源與歷史紀錄

- 初次同步日期：2026-06-15。
- 來源：本次 Sense Bar YouTube 字幕整理工作流。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/youtube-transcript-collector/SKILL.md`。
- 本機驗證：`quick_validate.py` 通過；`fetch_zh_tw_subtitles.py` 語法檢查通過；已用既有 `總表.md` 與 `zh-TW` VTT 離線重建字幕 MD 成功。
- 驗證依賴：若 `quick_validate.py` 缺 `yaml` module，先安裝 `python3 -m pip install --user PyYAML`；本機已驗證 PyYAML 6.0.3 可 import。

## 這個 Skill 解決什麼

使用者未來提出 YouTube 字幕整理需求時，預設流程固定為：

1. 先搜尋或整理影片清單。
2. 先輸出 `總表.md`。
3. 依 `總表.md` 的影片順序逐支抓取字幕。
4. 只抓繁體中文字幕 `zh-TW`。
5. 每支字幕 MD 的檔名使用總表的「影片標題」。
6. 遇到 YouTube `429 Too Many Requests` 時停止，標記 `限流待重試`，避免連續請求。

## yt-dlp 安裝

檢查：

```bash
command -v yt-dlp
yt-dlp --version
python3 -m pip show yt-dlp
```

安裝或升級：

```bash
python3 -m pip install --user --upgrade yt-dlp
```

macOS 使用者 site install 常見路徑：

```text
{{HOME}}/Library/Python/3.9/bin/yt-dlp
```

若 `yt-dlp` 已安裝但 shell 找不到，將該目錄加入 PATH，或直接使用完整路徑呼叫。

## yt-dlp 可以做到的功能

- 下載影片、音訊、playlist、channel 與直播封存。
- 匯出影片 metadata，例如標題、網址、ID、長度、頻道、上傳日期、描述、標籤與縮圖。
- 列出可下載格式，並選擇特定影像或音訊格式。
- 下載人工字幕與自動產生字幕。
- 將字幕輸出成 `vtt` 等格式。
- 使用 browser cookies 取用登入後才可讀的內容。
- 用 sleep / interval 參數降低請求頻率。

限制：YouTube 可能對字幕端點回 `HTTP 429 Too Many Requests`、`IpBlocked`，或要求 PO token。遇到限制時應停止、冷卻、稍後重試，不要平行或連續硬抓。

## 使用方式

建立任務資料夾後，先手動或半自動產生 `總表.md`。表格欄位固定如下：

```markdown
| # | 分類 | 影片標題 | YouTube URL | 字幕 MD |
|---:|---|---|---|---|
```

逐支抓字幕：

```bash
python3 "{{CODEX_HOME}}/skills/youtube-transcript-collector/scripts/fetch_zh_tw_subtitles.py" --table "<task-folder>/總表.md" --next --cookies
```

指定第 N 支：

```bash
python3 "{{CODEX_HOME}}/skills/youtube-transcript-collector/scripts/fetch_zh_tw_subtitles.py" --table "<task-folder>/總表.md" --index 1 --cookies
```

只用既有 VTT 重新產生 MD，不連 YouTube：

```bash
python3 "{{CODEX_HOME}}/skills/youtube-transcript-collector/scripts/fetch_zh_tw_subtitles.py" --table "<task-folder>/總表.md" --index 1 --from-existing --sleep-after 0
```

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/youtube-transcript-collector/SKILL.md" && echo "skill ok"
test -f "{{CODEX_HOME}}/skills/youtube-transcript-collector/scripts/fetch_zh_tw_subtitles.py" && echo "script ok"
python3 -m py_compile "{{CODEX_HOME}}/skills/youtube-transcript-collector/scripts/fetch_zh_tw_subtitles.py"
python3 -m pip install --user PyYAML
python3 -c 'import yaml; print(yaml.__version__)'
```

## 踩坑

- 不要一開始就抓字幕；先產生 `總表.md`，再讓總表成為唯一處理順序與檔名來源。
- 不要一次抓多部。YouTube 字幕端點容易限流。
- 不要抓所有語言。預設只抓 `zh-TW`，否則一支影片可能展開成上百個自動翻譯字幕請求。
- 使用 Chrome cookie 前要取得使用者同意。
- 不要把 Google 帳號、cookie、token 或瀏覽器 profile 的敏感資訊寫進總表或輸出檔。
- 字幕 MD 檔名要跟總表影片標題一致；只有 `/` 需改成 `／`。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`youtube-transcript-collector`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

```bash
set -e

# ---- youtube-transcript-collector ----
mkdir -p "{{CODEX_HOME}}/skills/youtube-transcript-collector/agents"
mkdir -p "{{CODEX_HOME}}/skills/youtube-transcript-collector/scripts"

# youtube-transcript-collector/SKILL.md
cat > "{{CODEX_HOME}}/skills/youtube-transcript-collector/SKILL.md" <<'CODEX_LAZYPACK_YOUTUBE_TRANSCRIPT_COLLECTOR_SKILL_MD'
---
name: youtube-transcript-collector
description: Build YouTube video URL inventory tables and fetch Traditional Chinese subtitle Markdown files with yt-dlp. Use when the user asks to find videos from a YouTube channel or URL set, create a 總表.md / summary table first, then download or regenerate zh-TW / 繁體中文 subtitles one video at a time while avoiding YouTube rate limits.
---

# YouTube Transcript Collector

## Default Workflow

Use this skill when a task involves YouTube videos, `yt-dlp`, subtitle downloads, transcript Markdown, or a request such as "先列出總表 MD，再抓繁體中文字幕 MD".

Default sequence:

1. Verify or install `yt-dlp`.
2. Build a `總表.md` before downloading subtitles.
3. Fetch only Traditional Chinese subtitles (`zh-TW`) unless the user explicitly asks otherwise.
4. Process videos one by one; do not run subtitle downloads in parallel.
5. Name each subtitle Markdown file from the exact video title in `總表.md`; only replace `/` with `／` if needed for file paths.
6. Update `總表.md` after each success or rate-limit failure.

## yt-dlp Setup

Check availability:

```bash
command -v yt-dlp
yt-dlp --version
python3 -m pip show yt-dlp
```

Install or upgrade when missing:

```bash
python3 -m pip install --user --upgrade yt-dlp
```

On macOS with user-site installs, the binary is commonly under:

```text
~/Library/Python/3.9/bin/yt-dlp
```

If the binary is installed but not on `PATH`, add the user-site bin directory to the shell profile or call it with the full path. Prefer a user-local install over system-wide package changes.

## yt-dlp Capabilities

Summarize these capabilities when the user asks what `yt-dlp` can do:

- Download videos, audio, playlists, channels, and livestream archives from supported sites.
- Extract metadata such as title, URL, ID, duration, upload date, channel, description, tags, and thumbnails.
- List available video/audio formats and select specific formats.
- Download manual subtitles and auto-generated subtitles.
- Convert subtitle formats, commonly to `vtt`, when the required converter is available.
- Use browser cookies with `--cookies-from-browser` for content that needs an authenticated session.
- Rate-limit and slow requests with options such as `--sleep-requests`, `--sleep-interval`, and `--max-sleep-interval`.

Important limitation: YouTube may return `HTTP 429 Too Many Requests`, `IpBlocked`, or require PO tokens for some subtitle endpoints. Slow down, stop after failures, and retry later instead of forcing many requests.

## Build The Summary Table First

Create a new task folder, then produce `總表.md` before fetching subtitles.

Recommended columns:

```markdown
| # | 分類 | 影片標題 | YouTube URL | 字幕 MD |
|---:|---|---|---|---|
```

For channel research:

- Use `yt-dlp --flat-playlist --dump-json` on channel `/videos`, `/streams`, or playlist URLs when possible.
- Cross-check with YouTube search or browser inspection when a channel mixes videos, streams, and Shorts.
- Filter by the user's keywords, such as Claude AI, Claude Code, Codex, AntiGravity, OpenCode, AI Agent.
- Keep the list stable in `總表.md`; use it as the source of truth for titles and processing order.

When building file outputs, use this folder shape:

```text
<task-folder>/
├── 總表.md
├── md/
├── raw_subtitles/
└── status.json
```

## Fetch Traditional Chinese Subtitles

Use the bundled helper when the task already has a `總表.md` in the expected table format:

```bash
python3 <skill-dir>/scripts/fetch_zh_tw_subtitles.py --table <task-folder>/總表.md --next --cookies
```

Useful options:

```bash
python3 <skill-dir>/scripts/fetch_zh_tw_subtitles.py --table <task-folder>/總表.md --index 1 --cookies
python3 <skill-dir>/scripts/fetch_zh_tw_subtitles.py --table <task-folder>/總表.md --next --cookies --sleep-after 180
python3 <skill-dir>/scripts/fetch_zh_tw_subtitles.py --table <task-folder>/總表.md --index 1 --from-existing --sleep-after 0
```

Cookie rule:

- Use `--cookies-from-browser` only with user agreement.
- If the user says their YouTube is logged in with their Google account, use the relevant browser profile, commonly `chrome:Profile 1` in this user's environment.
- Do not reveal private account identifiers from cookie extraction logs.

Rate-limit rule:

- Process a single video per command.
- If one video returns `429`, mark it as `限流待重試`, stop, and retry later.
- Do not skip ahead unless the user explicitly says to continue with later videos.

## Markdown Naming Rule

Subtitle Markdown filenames must follow the `影片標題` value in `總表.md`.

Example:

```text
AntiGravity 基本功 EP07:一句話生成 Padlet 課程牆_分區、投票、AI 插圖全自動完成.md
```

Only replace `/` with `／`; otherwise preserve title punctuation, spacing, Chinese characters, and casing.

## Validation Checklist

If Codex's `quick_validate.py` fails with `ModuleNotFoundError: No module named 'yaml'`, install the missing validation dependency:

```bash
python3 -m pip install --user PyYAML
python3 -c 'import yaml; print(yaml.__version__)'
```

Before finishing:

- `總表.md` exists and includes all requested videos.
- Each successful row links to an MD file under `md/`.
- Each subtitle MD title matches the `影片標題` from `總表.md`.
- Raw subtitle files under `raw_subtitles/` are `zh-TW` only.
- `status.json` records successes and failures.
- No parallel subtitle download processes are still running.
CODEX_LAZYPACK_YOUTUBE_TRANSCRIPT_COLLECTOR_SKILL_MD

# youtube-transcript-collector/agents/openai.yaml
cat > "{{CODEX_HOME}}/skills/youtube-transcript-collector/agents/openai.yaml" <<'CODEX_LAZYPACK_YOUTUBE_TRANSCRIPT_COLLECTOR_OPENAI_YAML'
interface:
  display_name: "YouTube Transcript Collector"
  short_description: "先列 YouTube 總表，再逐支抓繁中字幕"
  default_prompt: "Use $youtube-transcript-collector to build a YouTube video summary table first, then fetch Traditional Chinese subtitle Markdown files one by one."
policy:
  allow_implicit_invocation: true
CODEX_LAZYPACK_YOUTUBE_TRANSCRIPT_COLLECTOR_OPENAI_YAML

# youtube-transcript-collector/scripts/fetch_zh_tw_subtitles.py
cat > "{{CODEX_HOME}}/skills/youtube-transcript-collector/scripts/fetch_zh_tw_subtitles.py" <<'CODEX_LAZYPACK_YOUTUBE_TRANSCRIPT_COLLECTOR_SCRIPT'
#!/usr/bin/env python3
from __future__ import annotations

import argparse
import html
import json
import re
import subprocess
import time
from pathlib import Path
from urllib.parse import parse_qs, urlparse


LANG = "zh-TW"


def video_id_from_url(url: str) -> str:
    parsed = urlparse(url)
    if parsed.hostname == "youtu.be":
        return parsed.path.strip("/")
    query = parse_qs(parsed.query)
    if "v" in query:
        return query["v"][0]
    raise ValueError(f"Cannot parse video id from URL: {url}")


def safe_filename_from_title(title: str) -> str:
    title = title.replace("/", "／")
    title = re.sub(r"\s+", " ", title).strip()
    title = title.rstrip(". ")
    return title or "untitled"


def parse_table(table_path: Path) -> list[dict]:
    rows: list[dict] = []
    row_re = re.compile(r"^\| (\d+) \| ([^|]+) \| ([^|]+) \| (https?://[^|]+) \| ([^|]+) \|$")
    for line in table_path.read_text(encoding="utf-8").splitlines():
        match = row_re.match(line)
        if not match:
            continue
        rows.append(
            {
                "index": int(match.group(1)),
                "category": match.group(2).strip(),
                "title": match.group(3).strip(),
                "url": match.group(4).strip(),
                "subtitle": match.group(5).strip(),
            }
        )
    return rows


def load_status(path: Path) -> dict:
    if path.exists():
        return json.loads(path.read_text(encoding="utf-8"))
    return {"successes": {}, "failures": {}, "last_run": None}


def save_status(path: Path, status: dict) -> None:
    path.write_text(json.dumps(status, ensure_ascii=False, indent=2), encoding="utf-8")


def next_index(rows: list[dict], status: dict) -> int:
    done = {int(k) for k in status.get("successes", {})}
    for row in rows:
        if row["index"] not in done:
            return row["index"]
    return 0


def subtitle_label(path: Path, base: str) -> str:
    stem = path.name.removesuffix(".vtt")
    prefix = f"{base}."
    if stem.startswith(prefix):
        return stem.removeprefix(prefix)
    return stem


def strip_vtt(path: Path) -> list[tuple[str, str]]:
    rows: list[tuple[str, str]] = []
    current_time: str | None = None
    current_text: list[str] = []
    timestamp_re = re.compile(r"^(\d{2}:\d{2}:\d{2}\.\d{3}) --> .*$")
    tag_re = re.compile(r"<[^>]+>")

    for raw_line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw_line.strip()
        if not line or line == "WEBVTT" or line.startswith(("Kind:", "Language:", "NOTE")):
            continue
        match = timestamp_re.match(line)
        if match:
            if current_time and current_text:
                text = " ".join(current_text)
                if not rows or rows[-1][1] != text:
                    rows.append((current_time, text))
            current_time = match.group(1).split(".")[0]
            current_text = []
            continue
        if "-->" in line or line.isdigit():
            continue
        cleaned = re.sub(r"<\d{2}:\d{2}:\d{2}\.\d{3}>", "", line)
        cleaned = tag_re.sub("", cleaned)
        cleaned = html.unescape(cleaned)
        cleaned = " ".join(cleaned.split())
        if cleaned:
            current_text.append(cleaned)

    if current_time and current_text:
        text = " ".join(current_text)
        if not rows or rows[-1][1] != text:
            rows.append((current_time, text))
    return rows


def run_yt_dlp(row: dict, raw_dir: Path, cookies: str | None, timeout: int) -> subprocess.CompletedProcess[str]:
    video_id = video_id_from_url(row["url"])
    base = f"{row['index']:02d}-{video_id}"
    output = str(raw_dir / f"{base}.%(ext)s")
    cmd = [
        "yt-dlp",
        "--ignore-errors",
        "--skip-download",
        "--write-subs",
        "--write-auto-subs",
        "--sub-langs",
        LANG,
        "--sub-format",
        "vtt",
        "--sleep-requests",
        "8",
        "--sleep-interval",
        "10",
        "--max-sleep-interval",
        "20",
        "-o",
        output,
        row["url"],
    ]
    if cookies:
        cmd[1:1] = ["--cookies-from-browser", cookies]
    return subprocess.run(cmd, text=True, capture_output=True, timeout=timeout)


def write_markdown(row: dict, vtts: list[Path], out_dir: Path) -> Path:
    video_id = video_id_from_url(row["url"])
    base = f"{row['index']:02d}-{video_id}"
    md = out_dir / f"{safe_filename_from_title(row['title'])}.md"
    lines = [
        f"# {row['title']}",
        "",
        f"- Index: `{row['index']:02d}`",
        f"- Category: {row['category']}",
        f"- YouTube: {row['url']}",
        f"- Video ID: `{video_id}`",
        f"- Subtitle sources: {', '.join(f'`{vtt.name}`' for vtt in vtts)}",
        "",
        "## Transcript",
        "",
    ]
    for vtt in vtts:
        label = subtitle_label(vtt, base)
        lines.extend([f"### {label}", ""])
        for ts, text in strip_vtt(vtt):
            lines.append(f"- `{ts}` {text}")
        lines.append("")
    md.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return md


def update_table(table_path: Path, index: int, value: str) -> None:
    text = table_path.read_text(encoding="utf-8")
    escaped = re.escape(str(index))
    text = re.sub(
        rf"(^\| {escaped} \| [^|]+ \| [^|]+ \| https?://[^|]+ \| )[^|]+( \|$)",
        rf"\1{value}\2",
        text,
        flags=re.MULTILINE,
    )
    table_path.write_text(text, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Fetch one zh-TW YouTube subtitle from a 總表.md table.")
    parser.add_argument("--table", required=True, type=Path, help="Path to 總表.md")
    parser.add_argument("--index", type=int, help="1-based table index to process")
    parser.add_argument("--next", action="store_true", help="Process the first unfinished table row")
    parser.add_argument("--cookies", nargs="?", const="chrome:Profile 1", help="Use browser cookies, default chrome:Profile 1")
    parser.add_argument("--from-existing", action="store_true", help="Use existing VTT files without contacting YouTube")
    parser.add_argument("--sleep-after", type=int, default=120, help="Seconds to sleep after one attempt")
    parser.add_argument("--timeout", type=int, default=180, help="yt-dlp timeout in seconds")
    args = parser.parse_args()

    table_path = args.table.resolve()
    root = table_path.parent
    raw_dir = root / "raw_subtitles"
    out_dir = root / "md"
    status_path = root / "status.json"
    raw_dir.mkdir(parents=True, exist_ok=True)
    out_dir.mkdir(parents=True, exist_ok=True)

    rows = parse_table(table_path)
    status = load_status(status_path)
    index = args.index or (next_index(rows, status) if args.next else 1)
    row = next((item for item in rows if item["index"] == index), None)
    if not row:
        print("No valid table row to process.")
        return 1

    video_id = video_id_from_url(row["url"])
    base = f"{index:02d}-{video_id}"
    started = time.strftime("%Y-%m-%d %H:%M:%S")
    print(f"Processing #{index}: {row['url']}")

    if args.from_existing:
        returncode = 0
        output = "Used existing subtitle files.\n"
    else:
        proc = run_yt_dlp(row, raw_dir, args.cookies, args.timeout)
        returncode = proc.returncode
        output = proc.stdout + "\n" + proc.stderr

    candidates = sorted(raw_dir.glob(f"{base}.{LANG}.vtt"))
    if returncode == 0 and candidates:
        old_md = status.get("successes", {}).get(str(index), {}).get("md")
        if old_md and (root / old_md).exists():
            (root / old_md).unlink()
        md = write_markdown(row, candidates, out_dir)
        rel_md = str(md.relative_to(root))
        status.setdefault("successes", {})[str(index)] = {
            "url": row["url"],
            "video_id": video_id,
            "title": row["title"],
            "vtts": [str(path.relative_to(root)) for path in candidates],
            "md": rel_md,
            "started": started,
            "finished": time.strftime("%Y-%m-%d %H:%M:%S"),
        }
        status.get("failures", {}).pop(str(index), None)
        update_table(table_path, index, f"[{md.name}]({rel_md})")
        print(f"OK: {md}")
    else:
        log_path = raw_dir / f"{base}.error.log"
        log_path.write_text(output, encoding="utf-8")
        status.setdefault("failures", {})[str(index)] = {
            "url": row["url"],
            "video_id": video_id,
            "title": row["title"],
            "error_log": str(log_path.relative_to(root)),
            "returncode": returncode,
            "started": started,
            "finished": time.strftime("%Y-%m-%d %H:%M:%S"),
        }
        update_table(table_path, index, "限流待重試")
        print(f"FAILED: see {log_path}")

    status["last_run"] = time.strftime("%Y-%m-%d %H:%M:%S")
    save_status(status_path, status)

    if args.sleep_after > 0:
        print(f"Sleeping {args.sleep_after}s to avoid rate limits.")
        time.sleep(args.sleep_after)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
CODEX_LAZYPACK_YOUTUBE_TRANSCRIPT_COLLECTOR_SCRIPT
chmod +x "{{CODEX_HOME}}/skills/youtube-transcript-collector/scripts/fetch_zh_tw_subtitles.py"

echo "youtube-transcript-collector installed"
```

<!-- END EMBEDDED_SKILLS -->
