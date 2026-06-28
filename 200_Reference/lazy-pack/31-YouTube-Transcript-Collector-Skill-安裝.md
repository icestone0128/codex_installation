# 31-YouTube-Transcript-Collector-Skill-安裝

> 版本：2026-06-16 Codex App 版
> 用途：安裝 `youtube-transcript-collector` 全域 skill，固定「先匯入 YouTube 影片總表，再判斷直播/中文字幕狀態，再逐支抓繁體中文字幕 MD」的工作流程。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/youtube-transcript-collector/`。

## 來源與歷史紀錄

- 初次同步日期：2026-06-15。
- 來源：本次 Sense Bar YouTube 字幕整理工作流。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/youtube-transcript-collector/SKILL.md`。
- 本機驗證：`fetch_zh_tw_subtitles.py` 語法檢查通過；已用 6 欄 `總表.md` 驗證解析成功。
- 驗證依賴：若 `quick_validate.py` 缺 `yaml` module，先安裝 `python3 -m pip install --user PyYAML`；本機已驗證 PyYAML 6.0.3 可 import。
- 2026-06-16 補強：非直播影片若 web client 因 PO-token 或字幕列表缺漏抓不到中文字幕，先改用 `yt-dlp --extractor-args "youtube:player_client=android"` 探測與下載，再判斷是否真的沒有字幕。
- 2026-06-16 補強：頻道層級搜尋必須同時抓 `/videos` 與 `/streams`，合併後用 video ID 去重；直播回放常只出現在 `/streams`。

## 這個 Skill 解決什麼

使用者未來提出 YouTube 字幕整理需求時，預設流程固定為：

1. 先搜尋或整理影片清單；頻道層級任務必須同時抓 `/videos` 與 `/streams`，合併去重後再篩關鍵字。
2. 先輸出或更新 `總表.md`，並讓總表成為唯一處理順序。
3. 先用 metadata 判斷直播與直播回放；直播影片只在總表標註，不下載字幕。
4. 先探測中文字幕語言代碼；優先不使用 browser cookie，只有使用者同意且必要時才用 cookies。
5. 依 `總表.md` 的影片順序逐支抓取字幕。
6. 只抓繁體中文字幕候選：優先 `zh-TW`，必要時處理 `zh-Hant`。
7. 若一般 web client 探測不到字幕但影片不是直播，先用 `--player-client android` fallback 重新探測/下載。
8. 每支字幕 MD 的檔名使用總表的「影片標題」。
9. `字幕 MD` 欄只放實際 MD 連結；狀態文字放 `字幕狀態` 欄。
10. 遇到 YouTube `429 Too Many Requests` 時停止，標記 `有 <lang> 字幕／限流待下載`，避免連續請求。

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
| # | 分類 | 影片標題 | YouTube URL | 字幕 MD | 字幕狀態 |
|---:|---|---|---|---|---|
```

逐支抓字幕：

```bash
python3 "{{CODEX_HOME}}/skills/youtube-transcript-collector/scripts/fetch_zh_tw_subtitles.py" --table "<task-folder>/總表.md" --next --cookies
```

指定第 N 支：

```bash
python3 "{{CODEX_HOME}}/skills/youtube-transcript-collector/scripts/fetch_zh_tw_subtitles.py" --table "<task-folder>/總表.md" --index 1 --cookies
```

下載 `zh-Hant` 字幕：

```bash
python3 "{{CODEX_HOME}}/skills/youtube-transcript-collector/scripts/fetch_zh_tw_subtitles.py" --table "<task-folder>/總表.md" --index 34 --lang zh-Hant --cookies
```

PO-token 或 web client 看不到字幕時，改用 android player client：

```bash
python3 "{{CODEX_HOME}}/skills/youtube-transcript-collector/scripts/fetch_zh_tw_subtitles.py" --table "<task-folder>/總表.md" --index 34 --lang zh-Hant --player-client android --sleep-after 0
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
- 不要只抓頻道 `/videos`；YouTube 直播回放常出現在 `/streams`，頻道搜尋要兩邊都抓並用 video ID 去重。
- 不要把狀態文字寫進 `字幕 MD` 欄；該欄只放現有 MD 檔的 Markdown 連結，沒有檔案就留空。
- 直播或直播回放影片標註為 `直播影片`，不下載字幕；若已經有字幕 MD，要刪除 MD 與 raw subtitle，再清空 `字幕 MD`。
- 不要一次抓多部。YouTube 字幕端點容易限流。
- 不要抓所有語言。預設只探測/抓 `zh-TW` 與 `zh-Hant`，否則一支影片可能展開成上百個自動翻譯字幕請求。
- 非直播影片不能只因 web client 看不到字幕就判斷「影片本身無字幕」；若 yt-dlp 出現 PO-token 警告或中文字幕列表缺漏，要先試 `--extractor-args "youtube:player_client=android"`。
- 使用 Chrome cookie 前要取得使用者同意；搜尋與字幕可用性探測盡量先用非 cookie 路徑。
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
description: Build YouTube video URL inventory tables and fetch Traditional Chinese subtitle Markdown files with yt-dlp. Use when the user asks to find videos from a YouTube channel or URL set, create a 總表.md / summary table first, identify livestream replays and Chinese subtitle availability, then download or regenerate zh-TW / zh-Hant subtitle Markdown files one video at a time while avoiding YouTube rate limits.
---

# YouTube Transcript Collector

## Default Workflow

Use this skill when a task involves YouTube videos, `yt-dlp`, subtitle downloads, transcript Markdown, or a request such as "先列出總表 MD，再抓繁體中文字幕 MD".

Default sequence:

1. Verify or install `yt-dlp`.
2. Search or collect the requested YouTube videos, then import the complete result set into `總表.md` before downloading subtitles. For channel-level jobs, collect both the channel `/videos` and `/streams` tabs, merge by video ID, and deduplicate before filtering keywords.
3. Use `總表.md` as the source of truth for processing order, video titles, filenames, and row status.
4. Identify livestreams or livestream replays before subtitle downloads. If `yt-dlp --dump-single-json` reports `live_status=was_live`, `is_live=true`, or `was_live=true`, mark the row as `直播影片` and do not download subtitles.
5. Probe Chinese subtitle availability before downloading. Prefer non-cookie metadata/subtitle probes first; use browser cookies only when the user agrees and the non-cookie route cannot determine availability or access the needed subtitles. If the normal YouTube web client cannot see subtitles or reports PO-token related subtitle warnings, retry the probe with `--extractor-args "youtube:player_client=android"` before deciding that a non-live video has no subtitles.
6. Fetch only Chinese subtitles (`zh-TW` first, `zh-Hant` when available) unless the user explicitly asks otherwise.
7. Process videos one by one; do not run subtitle downloads in parallel.
8. Name each subtitle Markdown file from the exact video title in `總表.md`; only replace `/` with `／` if needed for file paths.
9. Update `總表.md` after each success, livestream finding, missing-subtitle finding, or rate-limit failure.

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
| # | 分類 | 影片標題 | YouTube URL | 字幕 MD | 字幕狀態 |
|---:|---|---|---|---|---|
```

For channel research:

- For channel-level jobs, always fetch both channel tabs because non-live edited videos and livestream replays can appear in different inventories:

```bash
yt-dlp --flat-playlist --dump-json "https://www.youtube.com/@channel/videos"
yt-dlp --flat-playlist --dump-json "https://www.youtube.com/@channel/streams"
```

- Merge the `/videos` and `/streams` results by video ID before keyword filtering and table updates.
- Use playlist URLs as an additional source when the user supplies one.
- Cross-check with YouTube search or browser inspection when a channel mixes videos, streams, and Shorts.
- Filter by the user's keywords, such as Claude AI, Claude Code, Codex, AntiGravity, OpenCode, AI Agent.
- Keep the list stable in `總表.md`; use it as the source of truth for titles and processing order.
- Keep `字幕 MD` empty until an actual Markdown subtitle file exists.
- Put status text only in `字幕狀態`, never in `字幕 MD`.
- When a subtitle MD exists, `字幕 MD` must be a Markdown link to the file under `md/`, and `字幕狀態` should be `已下載`.

When building file outputs, use this folder shape:

```text
<task-folder>/
├── 總表.md
├── md/
├── raw_subtitles/
├── live_status_report.json
└── status.json
```

## Detect Livestream Videos

Before subtitle downloads, check video metadata:

```bash
yt-dlp --skip-download --dump-single-json "<youtube-url>"
```

Use cookies only if the user agrees and public metadata access fails:

```bash
yt-dlp --cookies-from-browser "chrome:Profile 1" --skip-download --dump-single-json "<youtube-url>"
```

Rules:

- Treat `live_status=was_live`, `was_live=true`, or `is_live=true` as a livestream/livestream replay.
- Mark `字幕狀態` as `直播影片`.
- Do not download subtitles for livestream rows.
- If a livestream row already has a subtitle MD, remove that MD and matching raw subtitle files, clear `字幕 MD`, and keep only `直播影片` in `字幕狀態`.
- Store the metadata audit in `live_status_report.json` when processing many videos.

## Probe Chinese Subtitle Availability

Probe before downloading, so rows without usable Chinese subtitles are documented instead of producing avoidable failed downloads.

Preferred non-cookie probe:

```bash
yt-dlp --skip-download --write-auto-subs --write-subs --sub-langs "zh-TW,zh-Hant" --sub-format vtt --print "%(requested_subtitles)j" "<youtube-url>"
```

Android player-client fallback for PO-token or missing-subtitle cases:

```bash
yt-dlp --extractor-args "youtube:player_client=android" --skip-download --write-auto-subs --write-subs --sub-langs "zh-TW,zh-Hant" --sub-format vtt --print "%(requested_subtitles)j" "<youtube-url>"
```

Cookie fallback, only with user agreement:

```bash
yt-dlp --cookies-from-browser "chrome:Profile 1" --skip-download --write-auto-subs --write-subs --sub-langs "zh-TW,zh-Hant" --sub-format vtt --print "%(requested_subtitles)j" "<youtube-url>"
```

Status mapping:

- `zh-TW` exists: `有 zh-TW 字幕／待下載` or `有 zh-TW 字幕／限流待下載` after a 429.
- `zh-Hant` exists: `有 zh-Hant 中文字幕／待下載`.
- Other subtitles exist but no Chinese subtitle exists: `有其他語言字幕／無中文字幕`.
- No automatic captions and no subtitles: `影片本身無字幕`.
- Probe inconclusive: `字幕探測失敗`.

Avoid broad `--sub-langs all` probes by default because they can return huge translated subtitle maps. Use it only when distinguishing "no Chinese subtitles" from "no subtitles at all" matters for the task.

## Android Player Client Fallback

Use this route when all of these are true:

- The row is not a livestream or livestream replay.
- The normal web-client probe/download cannot see `zh-TW` or `zh-Hant`, or yt-dlp warns that some YouTube clients need PO tokens.
- The user expects non-live replay videos to have subtitles.

Recommended sequence:

1. Probe with `--extractor-args "youtube:player_client=android"` and the narrow Chinese subtitle list.
2. If the probe exposes `zh-TW` or `zh-Hant`, download one language only with the same player client.
3. Convert the resulting VTT through the helper, or run the helper directly with `--player-client android`.
4. Record the chosen language in `status.json` through the generated VTT/MD source list; keep `總表.md` status as `已下載`.

Direct yt-dlp download example:

```bash
yt-dlp --extractor-args "youtube:player_client=android" --skip-download --write-auto-subs --write-subs --sub-langs "zh-Hant" --sub-format vtt -o "raw_subtitles/34-h8l5gNvrStE.%(ext)s" "<youtube-url>"
```

Helper example:

```bash
python3 <skill-dir>/scripts/fetch_zh_tw_subtitles.py --table <task-folder>/總表.md --index 34 --lang zh-Hant --player-client android --sleep-after 0
```

Do not mark a non-live row as `影片本身無字幕` until the normal route and the Android player-client route have both failed to expose any subtitle list.

## Fetch Traditional Chinese Subtitles

Use the bundled helper when the task already has a `總表.md` in the expected table format. The helper supports both the legacy 5-column table and the preferred 6-column table with `字幕狀態`.

```bash
python3 <skill-dir>/scripts/fetch_zh_tw_subtitles.py --table <task-folder>/總表.md --next --cookies
```

Useful options:

```bash
python3 <skill-dir>/scripts/fetch_zh_tw_subtitles.py --table <task-folder>/總表.md --index 1 --cookies
python3 <skill-dir>/scripts/fetch_zh_tw_subtitles.py --table <task-folder>/總表.md --next --cookies --sleep-after 180
python3 <skill-dir>/scripts/fetch_zh_tw_subtitles.py --table <task-folder>/總表.md --index 1 --from-existing --sleep-after 0
python3 <skill-dir>/scripts/fetch_zh_tw_subtitles.py --table <task-folder>/總表.md --index 34 --lang zh-Hant --cookies
python3 <skill-dir>/scripts/fetch_zh_tw_subtitles.py --table <task-folder>/總表.md --index 34 --lang zh-Hant --player-client android --sleep-after 0
```

Cookie rule:

- Avoid browser cookies for search and subtitle availability probing when public metadata is enough.
- Use `--cookies-from-browser` only with user agreement, usually for actual subtitle download attempts or when public probing fails.
- If the user says their YouTube is logged in with their Google account, use the relevant browser profile, commonly `chrome:Profile 1` in this user's environment.
- Do not reveal private account identifiers from cookie extraction logs.

Rate-limit rule:

- Process a single video per command.
- If one video returns `429`, mark `字幕狀態` as `有 <lang> 字幕／限流待下載`, stop, and retry later.
- Do not skip ahead unless the user explicitly says to continue with later videos.

## Table Update Rules

- `字幕 MD` contains only a Markdown link to an existing subtitle MD, or is blank.
- `字幕狀態` contains status text such as `已下載`, `直播影片`, `有 zh-TW 字幕／限流待下載`, `有 zh-Hant 中文字幕／待下載`, `有其他語言字幕／無中文字幕`, or `影片本身無字幕`.
- Do not put status text in `字幕 MD`.
- When a subtitle MD is deleted, clear `字幕 MD` and update `字幕狀態`.

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
- Each successful row links to an MD file under `md/` from `字幕 MD`.
- `字幕 MD` cells are either blank or Markdown links; all descriptive text is in `字幕狀態`.
- Each subtitle MD title matches the `影片標題` from `總表.md`.
- Raw subtitle files under `raw_subtitles/` are only for non-livestream rows and selected Chinese languages.
- Livestream rows are marked `直播影片` and have no subtitle MD/raw subtitle residue.
- `status.json` records successes, failures, subtitle probe results, and livestream findings when available.
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


DEFAULT_LANG = "zh-TW"


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
    for line in table_path.read_text(encoding="utf-8").splitlines():
        if not line.startswith("|") or "YouTube URL" in line or "---" in line:
            continue
        cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
        if len(cells) not in {5, 6} or not cells[0].isdigit() or not cells[3].startswith(("http://", "https://")):
            continue
        rows.append(
            {
                "index": int(cells[0]),
                "category": cells[1],
                "title": cells[2],
                "url": cells[3],
                "subtitle": cells[4],
                "status": cells[5] if len(cells) == 6 else "",
                "column_count": len(cells),
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


def run_yt_dlp(
    row: dict,
    raw_dir: Path,
    cookies: str | None,
    timeout: int,
    lang: str,
    player_client: str | None,
) -> subprocess.CompletedProcess[str]:
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
        lang,
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
    if player_client:
        cmd[1:1] = ["--extractor-args", f"youtube:player_client={player_client}"]
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


def update_table(table_path: Path, index: int, md_value: str | None = None, status_value: str | None = None) -> None:
    lines = table_path.read_text(encoding="utf-8").splitlines()
    out: list[str] = []
    for line in lines:
        if not line.startswith("|"):
            out.append(line)
            continue
        cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
        if len(cells) not in {5, 6} or not cells[0].isdigit() or int(cells[0]) != index:
            out.append(line)
            continue
        if md_value is not None:
            cells[4] = md_value
        if len(cells) == 6 and status_value is not None:
            cells[5] = status_value
        elif len(cells) == 5 and status_value is not None and md_value is None:
            cells[4] = status_value
        out.append("| " + " | ".join(cells) + " |")
    table_path.write_text("\n".join(out) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Fetch one zh-TW YouTube subtitle from a 總表.md table.")
    parser.add_argument("--table", required=True, type=Path, help="Path to 總表.md")
    parser.add_argument("--index", type=int, help="1-based table index to process")
    parser.add_argument("--next", action="store_true", help="Process the first unfinished table row")
    parser.add_argument("--cookies", nargs="?", const="chrome:Profile 1", help="Use browser cookies, default chrome:Profile 1")
    parser.add_argument("--from-existing", action="store_true", help="Use existing VTT files without contacting YouTube")
    parser.add_argument("--lang", default=DEFAULT_LANG, help="Subtitle language to fetch, default zh-TW; use zh-Hant when the table probe found that code")
    parser.add_argument("--player-client", help="Optional yt-dlp YouTube player client, e.g. android, for PO-token or missing-subtitle fallback")
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
        proc = run_yt_dlp(row, raw_dir, args.cookies, args.timeout, args.lang, args.player_client)
        returncode = proc.returncode
        output = proc.stdout + "\n" + proc.stderr

    candidates = sorted(raw_dir.glob(f"{base}.{args.lang}.vtt"))
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
        update_table(table_path, index, f"[{md.name}]({rel_md})", "已下載")
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
        failure_status = f"有 {args.lang} 字幕／限流待下載" if "429" in output or "Too Many Requests" in output else "字幕下載失敗"
        update_table(table_path, index, None, failure_status)
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
