# 29-Video-Processing-Automation-Skill-安裝

> 版本：2026-06-03 Codex App 版
> 用途：安裝 `video-processing-automation` 全域 skill，把原始影片處理成 YouTube / 社群影片上架包，包含智能剪口播、字幕、文字稿、標題、封面、metadata 與短片亮點流程。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/video-processing-automation/`。

## 來源與歷史紀錄

- 初次同步日期：2026-06-03。
- 來源 repo：https://github.com/mathruffian-dot/2026-YouTube
- 來源 commit：`a0171ce`。
- 2026-06-04 已補入 Groq Python SDK 安裝、Groq Google 登入建立 API key、安全複製與 `~/.codex/secrets/groq_api_key` 保存流程。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/video-processing-automation/SKILL.md`。

## Codex 相容化調整

- 保留來源 repo 的影片生產線核心：smart cut、Groq Whisper STT、SRT 重切、字幕清理、標題候選、封面提示、metadata、短片候選與切片腳本。
- 排除來源工具專屬入口、設定資料夾、handoff 狀態、個人頻道輸出範例、個人品牌素材與非 Codex 路由。
- 封面圖預設使用 Codex 影像生成能力或使用者提供的圖像流程，不依賴來源 repo 的本機生圖腳本。
- 頻道名稱、人物照、色票、專有詞彙與輸出路徑都改成專案輸入，不寫死在全域 skill。
- 不內嵌 API key、OAuth token、影片素材、成品影片或個人圖片。

## 前置條件

- Python 3.9+。
- `ffmpeg` / `ffprobe`。
- `auto-editor`：`python3 -m pip install --user auto-editor`。
- Groq Python SDK：`python3 -m pip install --user groq`。
- Groq STT 路線需要 `GROQ_API_KEY` 或 `~/.codex/secrets/groq_api_key`。
- Local Whisper 保留為可選 fallback；Groq STT 可用且使用者同意雲端轉錄時，預設不檢查、安裝或下載 Local Whisper。
- 若 Groq 方案或模型可用性改變、Groq 不可用，或使用者明確要求本地處理，再考慮 Local Whisper fallback。
- Codex sandbox 若在 Python 語法檢查時擋住 `~/Library/Caches/com.apple.python`，將該路徑加入 writable roots；本機已補入 `/Users/arrywu/Library/Caches/com.apple.python`。

## Groq 帳號與 API key

Groq Whisper STT 會把音訊送到 Groq。只有在使用者同意雲端 STT 路線時才建立或使用 API key。

建立流程：

1. 開啟 `https://console.groq.com/keys`。
2. 使用 `Continue with Google` 登入或註冊 Groq。
3. Google 帳號選擇、授權、密碼或一次性驗證碼都由使用者本人在瀏覽器完成。
4. 在 API Keys 頁點 `Create API Key`。
5. Display Name 建議使用用途名稱，例如 `codex-video-processing-automation`。
6. 送出後停在一次性 key 顯示畫面；不要把 key 貼進對話、repo、LazyPack、Obsidian 或截圖。
7. 可按頁面 `Copy` 讓 key 進入使用者剪貼簿，但不要讀取或輸出 key。
8. 由使用者保存到本機秘密檔：

```bash
mkdir -p ~/.codex/secrets
chmod 700 ~/.codex/secrets
pbpaste > ~/.codex/secrets/groq_api_key
chmod 600 ~/.codex/secrets/groq_api_key
```

若 key 曾貼到對話、log、截圖或 repo，先到 Groq Console revoke，再重新建立新 key。

## 驗證

```bash
python3 --version
ffmpeg -version
ffprobe -version
python3 -m auto_editor --version
python3 -c "import groq; print('groq ok')"
python3 -c "import os, pathlib; p=pathlib.Path('~/.codex/secrets/groq_api_key').expanduser(); print('Groq key:', 'ok' if os.getenv('GROQ_API_KEY') or p.exists() else 'missing')"
test -f "{{CODEX_HOME}}/skills/video-processing-automation/SKILL.md" && echo "video-processing-automation SKILL.md ok"
test -d "{{CODEX_HOME}}/skills/video-processing-automation/references" && echo "references ok"
test -d "{{CODEX_HOME}}/skills/video-processing-automation/scripts" && echo "scripts ok"
```

## 使用方式

- 「使用 video-processing-automation 處理這支影片」
- 「幫我把 raw 裡的新影片做成 YouTube 上架包」
- 「幫我自動剪口播、轉字幕、寫 metadata」
- 「從這支長片剪 3 個 short 候選」
- 「幫我產 YouTube 標題、封面 prompt、SEO 標籤」

## 踩坑

- 先剪片再轉字幕；不要先對 raw 影片轉字幕，否則時間碼會錯位。
- Groq 會上傳音訊到第三方服務；敏感素材要先確認使用者同意或改本地路線。
- Groq API key 只顯示一次；建立後讓使用者自行複製保存，或只按 Copy 不讀取內容。
- 若 Groq API key 曾外洩到對話或文件，必須 revoke 後重建。
- Local Whisper 保留為 option；Groq cloud route 可用且已被接受時，預設不處理 Local Whisper 模型選擇或下載。
- `resegment.py` 需要 word-level JSON；本地 Whisper segment-only SRT 不適合重切。
- 清理 SRT 時只能改文字，不能改段號、時間碼或段落數。
- 影片素材與輸出成品通常不進 git。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/video-processing-automation/SKILL.md` 存在。
- [ ] references / scripts 依本文內嵌 package 完整安裝。
- [ ] 若使用 Groq STT，`python3 -c "import groq"` 可執行，且 `GROQ_API_KEY` 或 `~/.codex/secrets/groq_api_key` 存在。
- [ ] 沒有把 API key、OAuth token、影片素材、個人照片或成品影片寫進 repo。
- [ ] 開新 Codex 對話後可用 `video-processing-automation` 或影片自動化相關語句觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`video-processing-automation`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

```bash
set -e

# ---- video-processing-automation ----
mkdir -p "{{CODEX_HOME}}/skills/video-processing-automation"

# video-processing-automation/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/SKILL.md" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SKILL_MD'
---
name: video-processing-automation
description: >
  Use when the user asks Codex to process raw video into a YouTube-ready or
  social-video-ready package: smart cut, silence removal, speech-to-subtitle,
  transcript cleanup, title candidates, cover prompt/image generation,
  metadata, short highlight clips, and final output packaging. Adapted into a
  portable Codex App-compatible workflow from mathruffian-dot/2026-YouTube.
metadata:
  short-description: YouTube/video processing automation workflow
---

# Video Processing Automation

Use this skill to turn raw talking-head or tutorial video into a packaged video
deliverable with edited video, subtitles, transcript, cover image, metadata, SEO
tags, and optional short highlight versions.

This is a Codex App-compatible global skill adapted from
`mathruffian-dot/2026-YouTube`. It keeps the useful production logic and scripts,
but excludes source-tool-specific agent files, local paths, handoff files,
example outputs, personal channel identity, and non-Codex routing.

## Output Contract

In a standard four-box project that has `100_Todo/`, use the project structure
as the source of truth:

- Process files and temporary subtitles go in `100_Todo/drafts/<video-id>/`.
- Final packages go directly in `100_Todo/projects/<video-id>/`.
- Do not create project-root `working/` or `output/` folders when those
  `100_Todo/` routes exist.

For a long-form video, produce or prepare these files under the routed draft and
project folders:

- `100_Todo/drafts/<video-id>/<video-id>.cut.mp4`
- `100_Todo/drafts/<video-id>/<video-id>.srt`
- `100_Todo/drafts/<video-id>/<video-id>.txt`
- `100_Todo/drafts/<video-id>/titles.md`
- `100_Todo/projects/<video-id>/`
  - `<chosen-title>.mp4`
  - `<chosen-title>.srt`
  - `<chosen-title>.txt`
  - `cover.png` or `cover-prompt.md`
  - `metadata.md`

For a short highlight version, produce:

- `100_Todo/drafts/<video-id>/shorts-candidates.md`
- `100_Todo/drafts/<video-id>/short-tmp/short.mp4`
- `100_Todo/drafts/<video-id>/short-tmp/short.srt`
- `100_Todo/drafts/<video-id>/short-tmp/short.txt`
- `100_Todo/projects/<video-id>/short/`
  - `<short-title>.mp4`
  - `<short-title>.srt`
  - `<short-title>.txt`
  - `cover.png` or `cover-prompt.md`
  - `metadata.md`

When user choice is needed, pause at title selection and short-candidate
selection instead of guessing silently.

For projects without `100_Todo/`, choose the closest existing project-local
draft and final folders and document the route before writing files.

## Workflow

0. Check environment and Groq readiness:
   - read `references/setup.md`;
   - verify `ffmpeg`, `ffprobe`, `python3 -m auto_editor --version`, and
     `python3 -c "import groq"`;
   - if cloud STT is needed and no key exists, guide the user through Groq
     Google login and API key creation without printing or storing the key in
     repo, notes, screenshots, or chat.
1. Inspect input:
   - locate `raw/<video-id>/` or the user-provided video path;
   - create `100_Todo/drafts/<video-id>/` when `100_Todo/` exists;
   - confirm whether the project may use cloud STT through Groq.
2. Smart cut:
   - read `references/smart-cut.md`;
   - run `scripts/smart_cut.py` on the raw video;
   - default threshold is `0.04`; raise toward `0.06` for noisy footage.
3. Subtitle and transcript:
   - extract 16 kHz mono audio from the cut video with `ffmpeg`;
   - read `references/audio-subtitle.md`;
   - use Groq Whisper when `GROQ_API_KEY` or `~/.codex/secrets/groq_api_key` is available and
     the user accepts cloud transcription;
   - keep Local Whisper as an option, but do not install or download a model by
     default;
   - consider Local Whisper when Groq pricing/model availability changes, Groq
     is unavailable, or the user explicitly requires local-only processing.
4. Clean transcript:
   - preserve every SRT timecode and block boundary;
   - apply project vocabulary mechanically first, then edit only subtitle text;
   - validate with `scripts/validate_srt.py`;
   - convert clean SRT to TXT with `scripts/srt_to_txt.py`.
5. Title selection:
   - generate 10 long-form title candidates in Traditional Chinese unless the
     user requests another language;
   - write them to `100_Todo/drafts/<video-id>/titles.md` when `100_Todo/`
     exists;
   - stop and ask the user to pick one.
6. Package final output:
   - sanitize the chosen title for filenames;
   - copy/rename the cut video, clean SRT, and TXT into
     `100_Todo/projects/<video-id>/` when `100_Todo/` exists.
7. Cover:
   - read `references/cover-style.md`;
   - use Codex image generation or the user-provided image workflow;
   - if image generation cannot use a reference image, state the limitation and
     provide a strong `cover-prompt.md`.
8. Metadata:
   - read `references/metadata-template.md`;
   - create YouTube description, chapters, social posts, SEO keywords, copyable
     tag field, and upload checklist.
9. Optional short version:
   - read `references/short-video.md`;
   - produce 3 highlight candidates, pause for selection, then run
     `scripts/clip_cut.py`.

## Safety And Portability

- Do not commit or print API keys, OAuth tokens, model credentials, or auth
  files.
- If a Groq API key appears in chat, screenshots, logs, or a repo file, tell the
  user to revoke it in Groq Console and create a new key before continuing.
- When creating a Groq key through the browser, leave the one-time key display
  open for the user or copy it to the user's clipboard without reading it back.
  Store it only in a local secret location such as `~/.codex/secrets/groq_api_key` with mode
  `600`, or use a shell session variable for the current run.
- Do not upload audio/video to cloud STT services unless the user accepts that
  route or the project already documents that route.
- Keep raw videos and final rendered media out of git unless the user explicitly
  requests otherwise.
- Keep this global skill portable: all reusable instructions live in this skill
  package; project-specific channel names, persona photos, brand palettes,
  vocabulary, and output folders belong in the project.
- Use Codex image generation for covers by default. Do not depend on source
  repository image scripts or API-key-specific cover routes.
- Avoid copying source repo sample outputs, personal channel assets, or
  project-local handoff files into new projects.

## When To Read References

- Read `references/source-adaptation.md` before modifying this skill.
- Read `references/setup.md` for prerequisites and environment checks.
- Read `references/smart-cut.md` before silence removal.
- Read `references/audio-subtitle.md` before transcription or SRT cleanup.
- Read `references/short-video.md` before creating short highlight versions.
- Read `references/cover-style.md` before cover image prompting.
- Read `references/metadata-template.md` before writing metadata.

## Common Commands

```bash
python3 -m pip install --user auto-editor groq

python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/smart_cut.py" \
  "raw/<video-id>/input.mp4" \
  --out "working/<video-id>/<video-id>.cut.mp4"

ffmpeg -y -i "working/<video-id>/<video-id>.cut.mp4" \
  -vn -ac 1 -ar 16000 "working/<video-id>/<video-id>.wav"

python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/transcribe_groq.py" \
  "working/<video-id>/<video-id>.wav" \
  --out "working/<video-id>/_subtitles/<video-id>.groq.json"

python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/resegment.py" \
  "working/<video-id>/_subtitles/<video-id>.groq.json" \
  --out "working/<video-id>/_subtitles/<video-id>.raw.srt"

python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/apply_vocab.py" \
  "working/<video-id>/_subtitles/<video-id>.raw.srt" \
  --out "working/<video-id>/_subtitles/<video-id>.vocab.srt"

python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/validate_srt.py" \
  --raw "working/<video-id>/_subtitles/<video-id>.vocab.srt" \
  --clean "working/<video-id>/_subtitles/<video-id>.clean.srt"
```

## Verification

- `ffmpeg -version` works.
- `ffprobe -version` works.
- `python3 -m auto_editor --version` works or `auto-editor` is in PATH.
- `python3 -c "import groq"` works when using Groq STT.
- `GROQ_API_KEY` or `~/.codex/secrets/groq_api_key` exists before cloud STT.
- Scan the package for excluded source-tool terms before packaging or syncing;
  the scan should have no hits.
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SKILL_MD

# video-processing-automation/references/audio-subtitle.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/references/audio-subtitle.md")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/references/audio-subtitle.md" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_AUDIO_SUBTITLE_MD'
# Audio To Subtitle

Use this reference to create clean SRT and TXT transcripts.

## Core Rule

During cleanup, never change:

- SRT block count
- block indexes
- timecode lines
- timecode order

Only subtitle text may be edited.

## Groq Route

1. Extract audio from the cut video:

```bash
ffmpeg -y -i "working/<video-id>/<video-id>.cut.mp4" \
  -vn -ac 1 -ar 16000 "working/<video-id>/<video-id>.wav"
```

2. Transcribe:

```bash
mkdir -p "working/<video-id>/_subtitles"
python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/transcribe_groq.py" \
  "working/<video-id>/<video-id>.wav" \
  --out "working/<video-id>/_subtitles/<video-id>.groq.json"
```

3. Resegment:

```bash
python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/resegment.py" \
  "working/<video-id>/_subtitles/<video-id>.groq.json" \
  --out "working/<video-id>/_subtitles/<video-id>.raw.srt"
```

4. Apply vocabulary:

```bash
python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/apply_vocab.py" \
  "working/<video-id>/_subtitles/<video-id>.raw.srt" \
  --out "working/<video-id>/_subtitles/<video-id>.vocab.srt"
```

5. Clean text manually or with Codex, preserving all SRT structure.
6. Validate:

```bash
python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/validate_srt.py" \
  --raw "working/<video-id>/_subtitles/<video-id>.vocab.srt" \
  --clean "working/<video-id>/_subtitles/<video-id>.clean.srt"
```

7. Convert to TXT:

```bash
python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/srt_to_txt.py" \
  "working/<video-id>/_subtitles/<video-id>.clean.srt" \
  --out "working/<video-id>/<video-id>.txt"
```

Copy the clean SRT to `working/<video-id>/<video-id>.srt`.

## Vocabulary

The bundled `apply_vocab.py` has only generic defaults. For a real project,
extend replacements with:

- channel name
- speaker names
- product names
- recurring technical terms
- common ASR mistakes found in the first transcript

Keep vocabulary mechanical. Do not change meaning.

## Local Route

Consider Local Whisper when Groq pricing or model availability changes, Groq is
unavailable, or the user explicitly requires local-only processing. If Local
Whisper is used, local segment-level timestamps may be less precise than Groq
word-level timestamps, so do not run `resegment.py` unless the JSON includes
word timestamps.

---

## 🎬 Subtitle Burning (硬燒錄中文字幕)

當使用者的系統環境中，`ffmpeg` 由於缺少編譯依賴而沒有內建 `subtitles` 濾鏡或 `drawtext` 濾鏡時，可以使用 OpenCV + Pillow 的跨平台 Python 方案將 SRT 字幕硬燒錄至影片中。

### 依賴安裝
```bash
python3 -m pip install opencv-python pillow --break-system-packages
```

### 執行燒錄
```bash
python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/burn_subtitles.py" \
  "working/<video-id>/<video-id>.cut.mp4" \
  "working/<video-id>/<video-id>.srt" \
  "output/<chosen-title>/<chosen-title>.mp4"
```

### 設計細節與自訂
- **字型**：預設會優先讀取 macOS 系統的蘋方字型 (`PingFang.ttc`)，若在 Windows 或 Linux 上會自動 fallback 到 Arial 或是 Pillow 的預設字型。
- **樣式**：在影片底部 12% 高度處，以 75% 不透明度的深灰色背景圓角卡片包覆暖白色文字，以確保不論背景明暗皆具備極高的可讀性。
- **音軌保留**：腳本會自動將原影片的音軌以 `copy` 模式無損打包回最終輸出檔，畫質與音軌均保持一致。
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_AUDIO_SUBTITLE_MD

# video-processing-automation/references/cover-style.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/references/cover-style.md")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/references/cover-style.md" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_COVER_STYLE_MD'
# Cover Style

This is a portable cover-prompt checklist. Replace project-specific brand,
persona, and palette details with the user's actual channel style.

## Inputs To Request Or Locate

- Channel or series name
- Existing thumbnail references, if any
- Persona/reference photo, if the user wants consistent human likeness
- Brand colors
- Main title and optional subtitle
- Topic visual, such as app UI, workflow, chart, or object

## Prompt Structure

```text
YouTube thumbnail, 16:9, high-contrast educational technology style.

Background: <brand background>, subtle grid/data-flow/light effects.
Main subject: <persona or topic visual>, clear face or clear object silhouette.
Title text: "<short cover title>", huge bold Traditional Chinese, high contrast,
black stroke or shadow, readable on mobile.
Supporting visual: <icons/UI/workflow/object relevant to topic>.
Composition: title occupies left or top area, main subject occupies the opposite
side, no clutter, strong focal hierarchy.
Mood: useful, practical, energetic, not generic stock.
Avoid: tiny text, excessive words, low contrast, random logos, distorted hands,
unrelated background objects.
```

## Rules

- Cover title should be shorter than the YouTube title.
- Use real text in the generated image only when the image model can handle it;
  otherwise generate a text-free background and add title text in a design tool.
- Do not reuse an old generated cover as a likeness source. Use the original
  reference image when a persona must remain consistent.
- If Codex image generation cannot accept a reference image in the current
  session, say so and provide the prompt plus a fallback plan.
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_COVER_STYLE_MD

# video-processing-automation/references/metadata-template.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/references/metadata-template.md")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/references/metadata-template.md" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_METADATA_TEMPLATE_MD'
# Metadata Template

Use this structure for `metadata.md`.

```markdown
# <Video Title>

## YouTube Description

<Hook paragraph>

<What viewers will learn>

## Chapters

00:00 <Chapter 1>
00:00 <Chapter 2>
00:00 <Chapter 3>

## Social Posts

### Facebook

<Post>

### Instagram

<Post>

### Threads

<Post>

## SEO

### Main Keywords

- <keyword>
- <keyword>

### Secondary Keywords

- <keyword>
- <keyword>

### Long-Tail Keywords

- <keyword>
- <keyword>

### YouTube Tag Field

<comma-separated tags, directly copyable>

## Upload Checklist

- [ ] Title chosen
- [ ] Cover readable on mobile
- [ ] SRT uploaded
- [ ] Description and chapters checked
- [ ] Tags copied
- [ ] End screen / cards planned
- [ ] Visibility and publish time confirmed
```

## Title Candidates

Generate candidates in several styles:

- pain point
- curiosity
- concrete promise
- tutorial / how-to
- result-first
- mistake-avoidance
- comparison

For long-form videos, provide 10 candidates and pause. For short videos, provide
3 tighter candidates and pause.
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_METADATA_TEMPLATE_MD

# video-processing-automation/references/setup.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/references/setup.md")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/references/setup.md" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SETUP_MD'
# Setup And Environment

## Required Tools

| Tool | Purpose | Check |
|---|---|---|
| Python 3.9+ | Run scripts | `python3 --version` |
| ffmpeg / ffprobe | Audio/video processing | `ffmpeg -version` |
| auto-editor | Silence removal | `python3 -m auto_editor --version` |
| Groq Python SDK or API access | Cloud Whisper STT | `python3 -c "import groq"` |
| Optional local Whisper | Retained STT option for Groq plan/model changes, outages, or local-only requests | `python3 -m whisper --help` |

Install common dependencies:

```bash
python3 -m pip install --user auto-editor groq
```

## Codex Sandbox Notes

macOS Python may write bytecode caches under
`~/Library/Caches/com.apple.python` during syntax checks such as
`python3 -m py_compile`. If Codex reports `Operation not permitted` for that
path, add this narrow writable root to the Codex sandbox config and open a new
Codex conversation:

```toml
"/Users/arrywu/Library/Caches/com.apple.python",
```

For one-off verification before the new sandbox config is loaded, use a temp
cache path such as `PYTHONPYCACHEPREFIX=/private/tmp/python-pycache`.

## Groq API Key

Cloud transcription uses Groq Whisper. Accept either:

- environment variable: `GROQ_API_KEY`
- local key file: `~/.codex/secrets/groq_api_key`

Do not commit either value.

When Groq is available and the user accepts cloud transcription, do not check,
install, or download Local Whisper models by default. Keep Local Whisper as an
option for Groq plan/model changes, outages, or local-only requests.

### Create A Groq Key With Google Login

Use this route only when the user has asked to set up Groq cloud STT.

1. Open `https://console.groq.com/keys` in the user's browser.
2. Choose `Continue with Google`.
3. Let the user select the Google account and complete any consent, password, or
   verification challenge. Do not type passwords or one-time codes for them.
4. On the API Keys page, click `Create API Key`.
5. Use a purpose-specific display name such as `codex-video-processing-automation`.
6. Submit the form and stop at the one-time key display.
7. Do not read or print the key. Either leave the page open for the user to
   copy, or click the page's `Copy` button without reading clipboard contents.
8. Ask the user to save the copied key locally:

```bash
mkdir -p ~/.codex/secrets
chmod 700 ~/.codex/secrets
pbpaste > ~/.codex/secrets/groq_api_key
chmod 600 ~/.codex/secrets/groq_api_key
```

If the user accidentally pastes the key into chat, logs, screenshots, or a repo
file, tell them to revoke it in Groq Console and create a fresh key. Never write
the real key into this skill, LazyPack, Obsidian, Git, or project documentation.

## Suggested Project Layout

```text
project/
├── raw/
│   └── <video-id>/
│       └── input.mp4
├── working/
│   └── <video-id>/
├── output/
├── assets/
│   ├── persona/
│   └── style/
└── 200_Reference/
    └── vocabulary.md
```

The layout is recommended, not mandatory. Work with the user's existing project
structure when it already exists.

## Environment Checks

```bash
python3 --version
ffmpeg -version
ffprobe -version
python3 -m auto_editor --version
python3 -c "import groq; print('groq ok')"
python3 -c "import os, pathlib; p=pathlib.Path('~/.codex/secrets/groq_api_key').expanduser(); print('Groq key:', 'ok' if os.getenv('GROQ_API_KEY') or p.exists() else 'missing')"
```

`python3 -m auto_editor --version` can return a non-zero code in some versions
after printing the version. Treat printed version output as the useful signal.
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SETUP_MD

# video-processing-automation/references/short-video.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/references/short-video.md")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/references/short-video.md" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SHORT_VIDEO_MD'
# Short Highlight Video

Use this reference after a long video already has:

- `working/<video-id>/<video-id>.cut.mp4`
- `working/<video-id>/<video-id>.srt`

## Candidate Discovery

Scan the SRT for highlight segments:

| Hook type | Signal |
|---|---|
| Pain | "你還在..." / "最麻煩的是..." |
| Curiosity | "沒想到..." / "其實..." |
| Promise | "三步驟..." / "幾分鐘..." / "一鍵..." |
| Reveal | "結果..." / "關鍵是..." |
| Action | "你可以..." / "你只要..." |

Create 3 candidates:

- A: pain hook
- B: curiosity hook
- C: promise hook

Write `working/<video-id>/shorts-candidates.md` and pause for the user to choose
A/B/C, ask for new candidates, or provide direct timecodes.

## Cutting

```bash
python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/clip_cut.py" \
  --input-mp4 "working/<video-id>/<video-id>.cut.mp4" \
  --input-srt "working/<video-id>/<video-id>.srt" \
  --segments "00:00:08.500-00:00:13.200,00:00:45.100-00:01:30.800" \
  --out-dir "working/<video-id>/short-tmp/"
```

Default max duration is 120 seconds. If the user specifically wants YouTube
Shorts feed behavior, target 60 seconds or less.

## Short Metadata

Short metadata differs from long-form metadata:

- short description under 150 Chinese characters when possible;
- include `#Shorts` where relevant;
- provide compact IG Reels / TikTok / Threads copy;
- include a copyable tag list ending with `Shorts,短影片`;
- confirm title length, subtitles, cover, and publishing slot.

## Checks

- Timecodes must align to the cut video, not the raw video.
- Avoid cutting in the middle of a sentence.
- Keep 3-6 segments; too many fragments feel incoherent.
- Verify output duration with `ffprobe`.
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SHORT_VIDEO_MD

# video-processing-automation/references/smart-cut.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/references/smart-cut.md")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/references/smart-cut.md" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SMART_CUT_MD'
# Smart Cut

Use smart cut when the user wants silence removal, talking-head cleanup, or a
first-pass edit before subtitle generation.

## Principle

Cut the raw video first, then transcribe the cut video. If subtitles are made
from the raw video before cutting, timestamps will no longer align.

## ⚠️ 重要踩坑與技術修正 (VFR / Stream Order Caveats)

1. **影格率閃爍與綠屏問題 (VFR vs CFR)**：
   iOS 螢幕錄影或某些直播存檔預設為**變動影格率 (VFR, Variable Frame Rate)**。直接使用 `auto-editor` 裁剪拼接會導致影格時間戳錯亂、播放時畫面嚴重閃爍。
   **解決方法**：在剪輯前，必須先使用 `ffmpeg` 將影片轉檔為**固定影格率 (CFR, Constant Frame Rate)**：
   ```bash
   ffmpeg -y -i "raw/input.mov" -map 0:v -map 0:a -r 30 -vsync cfr "working/input_cfr.mp4"
   ```
2. **串流順序問題 (Stream Ordering)**：
   `auto-editor` 預設要求影片的 **Stream 0 為 Video，Stream 1 為 Audio**。若影片為音訊在前的非標準格式，裁剪後會輸出沒有影像的損壞檔案。
   上述 CFR 轉檔指令中的 `-map 0:v -map 0:a` 會自動將 Video 映射至 Stream 0、Audio 映射至 Stream 1，可一併解決此問題。

## Default Command

```bash
# 1. 轉 CFR 固定影格率 (30fps)
ffmpeg -y -i "raw/<video-id>/input.mp4" -map 0:v -map 0:a -r 30 -vsync cfr "working/<video-id>/input_cfr.mp4"

# 2. 進行智慧裁剪 (--no-open 避免伺服器環境自動彈出播放器)
python3 "{{CODEX_HOME}}/skills/video-processing-automation/scripts/smart_cut.py" \
  "working/<video-id>/input_cfr.mp4" \
  --out "working/<video-id>/<video-id>.cut.mp4"
```

## Parameters

| Parameter | Default | Use |
|---|---:|---|
| `--threshold` | `0.04` | Audio volume threshold; higher cuts more |
| `--margin` | `0.2s` | Keep buffer around speech |

Tuning:

- More pauses but natural speaking: `--margin 0.3s`
- Noisy room: raise threshold toward `0.06`
- Over-cut speech: lower threshold toward `0.03` or increase margin

## Checks

- Confirm `ffmpeg` and `ffprobe` are available.
- Confirm the output duration is shorter but still natural.
- Listen to the first 20-30 seconds before continuing to transcription when the
  source is noisy or has music.
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SMART_CUT_MD

# video-processing-automation/references/source-adaptation.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/references/source-adaptation.md")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/references/source-adaptation.md" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SOURCE_ADAPTATION_MD'
# Source Adaptation

Source repo: `https://github.com/mathruffian-dot/2026-YouTube`

Inspected source commit: `a0171ce`

## Kept

- Raw video to YouTube-ready package workflow.
- Smart cut via auto-editor.
- Groq Whisper transcription with word-level timestamps.
- SRT resegmentation, vocabulary replacement, validation, and TXT export.
- Title-selection pause before final output packaging.
- Short highlight workflow with 3 candidate hooks.
- Cover prompt workflow and metadata structure.

## Removed

- Source-tool-specific agent files and folders.
- Source-tool-specific skill routing and command paths.
- Personal channel identity, persona images, sample outputs, and project handoff
  state.
- Source repository scripts that require a non-portable local image-generation
  route.
- Any instruction to depend on another agent's configuration or files.

## Codex Adaptation

- The global skill name is `video-processing-automation`.
- The skill uses Codex App global skill paths through `{{CODEX_HOME}}`.
- Cover images default to Codex image generation or user-supplied assets.
- Project-specific vocabulary, persona references, and brand guides are treated
  as project inputs instead of global defaults.
- Cloud transcription must be confirmed when privacy matters.
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SOURCE_ADAPTATION_MD

# video-processing-automation/scripts/apply_vocab.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/scripts/apply_vocab.py")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/scripts/apply_vocab.py" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_APPLY_VOCAB_PY'
#!/usr/bin/env python3
"""對 SRT 做機械式詞彙替換（只動文字行，時間碼與段號原封不動）。

替換清單內建於此腳本（日後可外移成 JSON）。
用法：
  python3 apply_vocab.py <in.srt> --out <out.srt>
"""
import argparse
import re
import sys
from pathlib import Path

# 順序重要：先替換長詞，避免短詞先吃掉。
# 這份清單是可攜式預設值；專案若有頻道名、人名、產品名，請依該專案另行擴充。
REPLACEMENTS = [
    # Codex / OpenAI 工具常見誤聽
    ("CloudX", "Codex"),
    ("Cloud X", "Codex"),
    ("CodeX", "Codex"),
    ("Code X", "Codex"),
    ("DexDex", "Codex"),
    ("Dex Dex", "Codex"),
    ("dex dex", "Codex"),
    # 其他 AI 工具
    ("Notebook AM", "NotebookLM"),
    ("notebook AM", "NotebookLM"),
    ("Notebook LM", "NotebookLM"),
    ("notebook LM", "NotebookLM"),
    ("NotebookAM", "NotebookLM"),
    ("notebookLM", "NotebookLM"),
    ("ImageR", "Image 2"),
    ("Image R", "Image 2"),
    ("GPT Image 2", "GPT-Image 2"),
    ("GPT-Image2", "GPT-Image 2"),
    # 錯字
    ("斷考", "段考"),
    ("Signard型", "三角形"),
    ("Signard 型", "三角形"),
    ("翻例", "範例"),
    ("原始黑體", "思源黑體"),
    ("烤卷", "考卷"),
    ("宋瑞玮", "宋睿瑋"),
    ("用字按鈕", "用一個按鈕"),
    ("五文字", "無文字"),
    ("全然登地", "飛天遁地"),
    ("飛天遁地啊", "飛天遁地"),
]


def apply(text: str) -> str:
    for old, new in REPLACEMENTS:
        text = text.replace(old, new)
    return text


def process_srt(src: Path, dst: Path) -> None:
    content = src.read_text(encoding="utf-8-sig")
    blocks = re.split(r"(\r?\n\r?\n)", content)  # 保留分隔符
    out = []
    n_replaced = 0
    for seg in blocks:
        if not seg.strip() or seg.isspace() or "-->" not in seg:
            out.append(seg)
            continue
        lines = seg.splitlines(keepends=False)
        # 第 0 行段號、第 1 行時間碼 → 不動
        # 第 2 行起 → 清字
        if len(lines) < 3:
            out.append(seg)
            continue
        header = "\n".join(lines[:2])
        body_before = "\n".join(lines[2:])
        body_after = apply(body_before)
        if body_after != body_before:
            n_replaced += 1
        out.append(header + "\n" + body_after)
    dst.write_text("".join(out), encoding="utf-8")
    print(f"[OK] 輸出 {dst}")
    print(f"     {n_replaced} 段有替換")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("src", type=Path)
    ap.add_argument("--out", type=Path, required=True)
    args = ap.parse_args()
    process_srt(args.src, args.out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_APPLY_VOCAB_PY

# video-processing-automation/scripts/clip_cut.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/scripts/clip_cut.py")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/scripts/clip_cut.py" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_CLIP_CUT_PY'
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
clip_cut.py — 從長片切多段 + 組片 + 重編 SRT

用法：
  python3 clip_cut.py \
    --input-mp4 working/<id>/<id>.cut.mp4 \
    --input-srt working/<id>/<id>.srt \
    --segments "00:00:08.500-00:00:13.200,00:00:45.100-00:01:30.800" \
    --out-dir working/<id>/short-tmp/

輸出：
  short.mp4 — ffmpeg trim+concat（重新編碼確保乾淨切點）
  short.srt — 依新時間軸重編
  short.txt — 純文字稿
"""
import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path


def time_to_seconds(t: str) -> float:
    """支援 HH:MM:SS、HH:MM:SS.mmm、HH:MM:SS,mmm、MM:SS、SS."""
    t = t.strip().replace(',', '.')
    parts = t.split(':')
    if len(parts) == 3:
        h, m, s = parts
        return int(h) * 3600 + int(m) * 60 + float(s)
    if len(parts) == 2:
        m, s = parts
        return int(m) * 60 + float(s)
    return float(parts[0])


def seconds_to_srt_time(s: float) -> str:
    if s < 0:
        s = 0
    h = int(s // 3600)
    m = int((s % 3600) // 60)
    sec = s - h * 3600 - m * 60
    return f"{h:02d}:{m:02d}:{sec:06.3f}".replace('.', ',')


def parse_segments(seg_str: str):
    """'A-B,C-D' → [(A_sec, B_sec), (C_sec, D_sec)]，按起始時間排序，並驗證不重疊。"""
    segs = []
    for piece in seg_str.split(','):
        piece = piece.strip()
        if not piece:
            continue
        if '-' not in piece:
            raise ValueError(f"段格式錯誤（缺少 '-'）：{piece}")
        a, b = piece.split('-', 1)
        sa, sb = time_to_seconds(a), time_to_seconds(b)
        if sb <= sa:
            raise ValueError(f"段結束 ≤ 開始：{piece}")
        segs.append((sa, sb))
    segs.sort()
    for i in range(1, len(segs)):
        if segs[i][0] < segs[i - 1][1]:
            raise ValueError(f"段重疊：{segs[i - 1]} 與 {segs[i]}")
    return segs


def check_deps():
    if shutil.which('ffmpeg') is None:
        print("[ERR] 找不到 ffmpeg。", file=sys.stderr)
        sys.exit(1)
    if shutil.which('ffprobe') is None:
        print("[ERR] 找不到 ffprobe。", file=sys.stderr)
        sys.exit(1)


def get_duration(path: Path) -> float:
    out = subprocess.check_output([
        'ffprobe', '-v', 'error',
        '-show_entries', 'format=duration',
        '-of', 'default=noprint_wrappers=1:nokey=1',
        str(path),
    ], text=True).strip()
    return float(out)


def cut_video(input_mp4: Path, segments, out_mp4: Path):
    """以 filter_complex trim+concat，重新編碼。"""
    parts = []
    for i, (a, b) in enumerate(segments):
        parts.append(f"[0:v]trim=start={a}:end={b},setpts=PTS-STARTPTS[v{i}]")
        parts.append(f"[0:a]atrim=start={a}:end={b},asetpts=PTS-STARTPTS[a{i}]")
    concat_inputs = ''.join(f"[v{i}][a{i}]" for i in range(len(segments)))
    parts.append(f"{concat_inputs}concat=n={len(segments)}:v=1:a=1[v][a]")
    filter_complex = '; '.join(parts)

    cmd = [
        'ffmpeg', '-y',
        '-i', str(input_mp4),
        '-filter_complex', filter_complex,
        '-map', '[v]', '-map', '[a]',
        '-c:v', 'libx264', '-preset', 'medium', '-crf', '20',
        '-c:a', 'aac', '-b:a', '192k',
        '-movflags', '+faststart',
        str(out_mp4),
    ]
    print(f"[CMD] ffmpeg trim+concat → {out_mp4}")
    rc = subprocess.call(cmd)
    if rc != 0:
        print(f"[ERR] ffmpeg 失敗，rc={rc}", file=sys.stderr)
        sys.exit(rc)


# ===== SRT 處理 =====
SRT_TIME_RE = re.compile(r'(\d{2}:\d{2}:\d{2},\d{3})\s*-->\s*(\d{2}:\d{2}:\d{2},\d{3})')


def parse_srt(srt_path: Path):
    """回傳 [(idx, start_sec, end_sec, text_lines), ...]"""
    raw = srt_path.read_text(encoding='utf-8').strip()
    blocks = re.split(r'\n\s*\n', raw)
    entries = []
    for block in blocks:
        lines = [ln for ln in block.splitlines() if ln.strip() != '']
        if len(lines) < 2:
            continue
        try:
            idx = int(lines[0].strip())
        except ValueError:
            continue
        m = SRT_TIME_RE.search(lines[1])
        if not m:
            continue
        s_start = time_to_seconds(m.group(1))
        s_end = time_to_seconds(m.group(2))
        text_lines = lines[2:]
        entries.append((idx, s_start, s_end, text_lines))
    return entries


def cut_srt(input_srt: Path, segments, out_srt: Path):
    """把原 SRT 中落在 segments 內的字幕保留，並依新時間軸（cumulative）位移。"""
    entries = parse_srt(input_srt)

    # 計算每段的時間軸偏移（offset on new timeline）
    new_blocks = []
    cumulative = 0.0
    new_idx = 1
    for (a, b) in segments:
        seg_dur = b - a
        for (orig_idx, s, e, txt) in entries:
            # 字幕條目與該段完全沒有交集 → 跳過
            if e <= a or s >= b:
                continue
            # 截到段邊界
            ns = max(s, a) - a + cumulative
            ne = min(e, b) - a + cumulative
            if ne <= ns:
                continue
            new_blocks.append((new_idx, ns, ne, txt))
            new_idx += 1
        cumulative += seg_dur

    out_lines = []
    for (i, s, e, txt) in new_blocks:
        out_lines.append(str(i))
        out_lines.append(f"{seconds_to_srt_time(s)} --> {seconds_to_srt_time(e)}")
        out_lines.extend(txt)
        out_lines.append('')

    out_srt.write_text('\n'.join(out_lines), encoding='utf-8')
    print(f"[OK] {out_srt}（{len(new_blocks)} 段）")


def srt_to_txt(srt_path: Path, txt_path: Path):
    entries = parse_srt(srt_path)
    paragraphs = []
    cur = []
    for (_, _, _, txt) in entries:
        for line in txt:
            line = line.strip()
            if not line:
                continue
            cur.append(line)
            if line.endswith(('。', '！', '？', '.', '!', '?')):
                paragraphs.append(''.join(cur))
                cur = []
    if cur:
        paragraphs.append(''.join(cur))
    txt_path.write_text('\n\n'.join(paragraphs), encoding='utf-8')
    print(f"[OK] {txt_path}（{len(paragraphs)} 段、{sum(len(p) for p in paragraphs)} 字）")


def main():
    ap = argparse.ArgumentParser(description='從長片切多段 + 組片 + SRT 重編')
    ap.add_argument('--input-mp4', type=Path, required=True)
    ap.add_argument('--input-srt', type=Path, required=True)
    ap.add_argument('--segments', required=True,
                    help='例：00:00:05.000-00:00:10.500,00:01:23-00:01:38')
    ap.add_argument('--out-dir', type=Path, required=True)
    ap.add_argument('--max-duration', type=float, default=120.0,
                    help='短片最長秒數（超過會警告但不阻擋）')
    args = ap.parse_args()

    check_deps()

    if not args.input_mp4.exists():
        print(f"[ERR] 找不到 {args.input_mp4}", file=sys.stderr)
        sys.exit(1)
    if not args.input_srt.exists():
        print(f"[ERR] 找不到 {args.input_srt}", file=sys.stderr)
        sys.exit(1)

    segments = parse_segments(args.segments)
    total = sum(b - a for a, b in segments)
    print(f"[INFO] 段數 {len(segments)}、總時長 {total:.2f}s")
    if total > args.max_duration:
        print(f"[WARN] 短片總長 {total:.1f}s > {args.max_duration}s，建議減少段落")

    # 驗證所有時間碼都在影片範圍內
    full_dur = get_duration(args.input_mp4)
    for a, b in segments:
        if b > full_dur + 0.5:
            print(f"[ERR] 段 {a:.2f}-{b:.2f} 超出影片總長 {full_dur:.2f}", file=sys.stderr)
            sys.exit(1)

    args.out_dir.mkdir(parents=True, exist_ok=True)
    out_mp4 = args.out_dir / 'short.mp4'
    out_srt = args.out_dir / 'short.srt'
    out_txt = args.out_dir / 'short.txt'

    cut_video(args.input_mp4, segments, out_mp4)
    cut_srt(args.input_srt, segments, out_srt)
    srt_to_txt(out_srt, out_txt)

    new_dur = get_duration(out_mp4)
    print(f"\n[DONE] 短片時長 {new_dur:.2f}s（{len(segments)} 段）")
    print(f"  - {out_mp4}")
    print(f"  - {out_srt}")
    print(f"  - {out_txt}")


if __name__ == '__main__':
    main()
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_CLIP_CUT_PY

# video-processing-automation/scripts/resegment.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/scripts/resegment.py")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/scripts/resegment.py" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_RESEGMENT_PY'
#!/usr/bin/env python3
"""依 Groq JSON 重新切段，輸出 SRT。

核心策略：
  1. 以 **所有 words** 為基準做單趟掃描（不再按 segment 過濾，避免丟字）。
  2. segment.end 當作「偏好切點」提示（通常是 Whisper 判斷的自然句末）。
  3. 切點優先序：強標點 > segment 邊界 > 弱標點 > 硬切（往回找標點）。
"""
import argparse
import json
import sys
from pathlib import Path

MAX_DUR = 3.0
MIN_DUR = 0.6
MAX_CHARS = 15
SOFT_CHARS = 10
STRONG_PUNCT = set("。！？!?…")
WEAK_PUNCT = set("，、；：,;:")
ALL_PUNCT = STRONG_PUNCT | WEAK_PUNCT


def ms_tc(s: float) -> str:
    ms = int(round(s * 1000))
    h, rem = divmod(ms, 3_600_000)
    m, rem = divmod(rem, 60_000)
    sec, ms = divmod(rem, 1000)
    return f"{h:02d}:{m:02d}:{sec:02d},{ms:03d}"


def char_w(text: str) -> float:
    return sum(0.5 if c.isascii() else 1.0 for c in text if not c.isspace())


def is_cjk(ch: str) -> bool:
    return "\u4e00" <= ch <= "\u9fff"


def last_char(buf) -> str:
    text = "".join(x["word"] for x in buf).strip()
    return text[-1] if text else ""


def char_count(buf) -> float:
    return char_w("".join(x["word"] for x in buf))


def duration(buf) -> float:
    if not buf:
        return 0.0
    return buf[-1]["end"] - buf[0]["start"]


def find_back_punct(buf, max_back: int = 4) -> int:
    """從 buf 尾端往前找標點位置，回傳「含標點那個詞」的 index。找不到回 -1。"""
    start = max(0, len(buf) - max_back)
    for i in range(len(buf) - 1, start - 1, -1):
        word_text = buf[i]["word"].rstrip()
        if word_text and word_text[-1] in ALL_PUNCT:
            return i
    return -1


def near_seg_boundary(word_end: float, seg_ends: list, tol: float = 0.25) -> bool:
    """判斷這個 word 的結尾是否接近任一 segment 的結尾（=自然斷句）。"""
    return any(abs(word_end - se) <= tol for se in seg_ends)


def resegment(words, segments):
    """核心：掃描所有 words，依規則切段。"""
    seg_ends = [float(s["end"]) for s in segments]
    chunks = []
    buf = []

    i = 0
    while i < len(words):
        w = words[i]
        buf.append(w)
        chars = char_count(buf)
        dur = duration(buf)
        last = last_char(buf)
        at_seg_end = near_seg_boundary(w["end"], seg_ends)

        cut_here = False  # 是否在「當前 word 之後」切
        cut_back = -1  # 若 >=0，改在 buf[cut_back] 之後切（剩餘留下一段）

        # 1. 強標點 + 達最小時長 → 斷
        if last in STRONG_PUNCT and dur >= MIN_DUR:
            cut_here = True
        # 2. segment 邊界 + 有一定長度 → 斷（信任 Whisper 判斷的句末）
        elif at_seg_end and dur >= MIN_DUR and chars >= 4:
            cut_here = True
        # 3. 軟上限 + 弱標點 → 斷
        elif chars >= SOFT_CHARS and last in WEAK_PUNCT and dur >= MIN_DUR:
            cut_here = True
        # 4. 超過上限但剛好在標點 → 斷
        elif (chars >= MAX_CHARS or dur >= MAX_DUR) and last in ALL_PUNCT:
            cut_here = True
        # 5. 硬超標 → 先往回找標點，否則只在安全邊界切
        elif dur >= MAX_DUR + 0.8 or chars >= MAX_CHARS + 3:
            back = find_back_punct(buf)
            if back >= 0 and back < len(buf) - 1:
                cut_back = back
            else:
                nxt_raw = words[i + 1]["word"] if i + 1 < len(words) else ""
                nxt_first = nxt_raw.lstrip()[:1] if nxt_raw else ""
                # 安全邊界：標點結尾、接空白、或 CJK↔非CJK 交界
                last_cjk = is_cjk(last) if last else False
                nxt_cjk = is_cjk(nxt_first) if nxt_first else False
                safe = (
                    not last
                    or last in ALL_PUNCT
                    or nxt_raw.startswith(" ")
                    or (last_cjk != nxt_cjk and nxt_first)
                )
                if safe:
                    cut_here = True
                # 極端超標：不得不切（接受可能切斷中文詞）
                elif dur >= MAX_DUR + 2.5 or chars >= MAX_CHARS + 8:
                    cut_here = True

        if cut_back >= 0:
            # 把 buf[:cut_back+1] 當一段；buf[cut_back+1:] 留給下一輪
            chunks.append(buf[: cut_back + 1])
            buf = buf[cut_back + 1:]
            # 注意：i 還在目前這個 word，下次 while 會重新處理它
            # 但因為我們已經 append(w) 了，要避免重複 → 把它留在 buf 繼續處理
        elif cut_here:
            chunks.append(buf)
            buf = []

        i += 1

    # 剩餘
    if buf:
        # 尾巴太短（<3 字）併入前一段
        if chunks and char_count(buf) < 3:
            chunks[-1].extend(buf)
        else:
            chunks.append(buf)
    return chunks


def chunk_to_entry(buf):
    text = "".join(w["word"] for w in buf).strip()
    return buf[0]["start"], buf[-1]["end"], text


def write_srt(entries, out: Path) -> None:
    """寫出 SRT，並對時間碼做單調化（避免段間重疊）。"""
    lines = []
    prev_end = 0.0
    for i, (start, end, text) in enumerate(entries, start=1):
        if start < prev_end:
            start = prev_end
        if end <= start:
            end = start + 0.3
        if end - start < 0.3:
            end = start + 0.3
        lines.append(str(i))
        lines.append(f"{ms_tc(start)} --> {ms_tc(end)}")
        lines.append(text)
        lines.append("")
        prev_end = end
    out.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("json_file", type=Path)
    ap.add_argument("--out", type=Path, required=True)
    args = ap.parse_args()

    data = json.loads(args.json_file.read_text(encoding="utf-8"))
    words = data.get("words") or []
    segments = data.get("segments") or []

    if not words:
        if not segments:
            sys.exit("[ERR] JSON 無 words 也無 segments")
        entries = [
            (float(s["start"]), float(s["end"]), s["text"].strip()) for s in segments
        ]
    else:
        chunks = resegment(words, segments)
        entries = [chunk_to_entry(c) for c in chunks]

    # 驗證字數一致性
    all_text_in = "".join(w["word"] for w in words).replace(" ", "")
    all_text_out = "".join(e[2] for e in entries).replace(" ", "")
    if len(all_text_in) != len(all_text_out):
        print(
            f"[WARN] 字數不一致：輸入 {len(all_text_in)} vs 輸出 {len(all_text_out)}"
        )

    write_srt(entries, args.out)
    durs = [e - s for s, e, _ in entries]
    avg = sum(durs) / len(durs) if durs else 0
    max_d = max(durs) if durs else 0
    print(f"[OK] 輸出 {args.out}")
    print(f"     段數：{len(entries)}，平均 {avg:.2f}s/段，最長 {max_d:.2f}s")
    return 0


if __name__ == "__main__":
    sys.exit(main())
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_RESEGMENT_PY

# video-processing-automation/scripts/smart_cut.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/scripts/smart_cut.py")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/scripts/smart_cut.py" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_SMART_CUT_PY'
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
smart_cut.py — auto-editor 包裝腳本
偵測音量低於閾值的片段並剪掉，輸出只有人聲的影片。
"""
import argparse
import shutil
import subprocess
import sys
from pathlib import Path


def check_deps() -> list[str]:
    """回傳 auto-editor 的呼叫前綴（CLI 或 python3 -m auto_editor）。"""
    if shutil.which("ffmpeg") is None:
        print("[ERR] 找不到 ffmpeg。請先安裝 ffmpeg 並加入 PATH。", file=sys.stderr)
        sys.exit(1)
    if shutil.which("auto-editor") is not None:
        return ["auto-editor"]
    # 退而用 python3 -m auto_editor
    try:
        subprocess.check_output([sys.executable, "-m", "auto_editor", "--version"], stderr=subprocess.STDOUT)
        return [sys.executable, "-m", "auto_editor"]
    except Exception:
        print("[ERR] 找不到 auto-editor。請先安裝：pip install auto-editor", file=sys.stderr)
        sys.exit(1)


def get_duration(path: Path) -> float:
    """用 ffprobe 取得影片秒數。"""
    out = subprocess.check_output([
        "ffprobe", "-v", "error",
        "-show_entries", "format=duration",
        "-of", "default=noprint_wrappers=1:nokey=1",
        str(path),
    ], text=True).strip()
    return float(out)


def fmt(seconds: float) -> str:
    m, s = divmod(int(seconds), 60)
    return f"{m:02d}:{s:02d}"


def main() -> None:
    ap = argparse.ArgumentParser(description="智能剪口播：去除靜音片段")
    ap.add_argument("input", type=Path, help="輸入影片檔")
    ap.add_argument("--out", type=Path, required=True, help="輸出影片檔")
    ap.add_argument("--margin", default="0.2s", help="每段語音前後保留秒數，預設 0.2s")
    ap.add_argument("--threshold", default="0.04", help="音量門檻，預設 0.04")
    args = ap.parse_args()

    ae = check_deps()

    if not args.input.exists():
        print(f"[ERR] 找不到輸入檔：{args.input}", file=sys.stderr)
        sys.exit(1)

    args.out.parent.mkdir(parents=True, exist_ok=True)

    cmd = [
        *ae,
        str(args.input),
        "--margin", args.margin,
        "--edit", f"audio:threshold={args.threshold}",
        "--no-open",
        "-o", str(args.out),
    ]
    print(f"[CMD] {' '.join(cmd)}")
    rc = subprocess.call(cmd)
    if rc != 0:
        print(f"[ERR] auto-editor 失敗，退出碼 {rc}", file=sys.stderr)
        sys.exit(rc)

    try:
        dur_in = get_duration(args.input)
        dur_out = get_duration(args.out)
        cut_pct = (1 - dur_out / dur_in) * 100 if dur_in > 0 else 0
        print(f"[OK] 原長 {fmt(dur_in)} → 新長 {fmt(dur_out)}（剪掉 {cut_pct:.1f}%）")
    except Exception as e:
        print(f"[WARN] 統計時長失敗：{e}")


if __name__ == "__main__":
    main()
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_SMART_CUT_PY

# video-processing-automation/scripts/srt_to_txt.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/scripts/srt_to_txt.py")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/scripts/srt_to_txt.py" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_SRT_TO_TXT_PY'
#!/usr/bin/env python3
"""把清字後的 SRT 轉成可閱讀的純文字檔。

輸出格式：
  - 移除段號與時間碼
  - 同一句子的片段（沒以強標點結尾）會自動串接
  - 強標點（。！？）後換行，形成可讀段落
  - 適合做字幕貼文、影片描述、封面素材

用法：
  python3 srt_to_txt.py <in.srt> --out <out.txt>
"""
import argparse
import re
import sys
from pathlib import Path

STRONG_PUNCT = set("。！？!?…")


def parse_srt(path: Path):
    content = path.read_text(encoding="utf-8-sig")
    blocks = re.split(r"\r?\n\r?\n", content.strip())
    texts = []
    for b in blocks:
        lines = b.strip().splitlines()
        if len(lines) < 3:
            continue
        # lines[0]=段號, lines[1]=時間碼, lines[2:]=文字
        text = " ".join(l.strip() for l in lines[2:] if l.strip())
        if text:
            texts.append(text)
    return texts


def join_to_paragraphs(segments) -> str:
    """把片段串成段落，遇強標點才換行。"""
    out = []
    buf = ""
    for seg in segments:
        # 中文之間直接相接，避免插空白
        if buf and buf[-1].isascii() and seg[:1].isascii():
            buf += " " + seg
        else:
            buf += seg
        if buf and buf[-1] in STRONG_PUNCT:
            out.append(buf)
            buf = ""
    if buf:
        out.append(buf)
    return "\n\n".join(out)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("src", type=Path)
    ap.add_argument("--out", type=Path, required=True)
    args = ap.parse_args()

    segs = parse_srt(args.src)
    text = join_to_paragraphs(segs)
    args.out.write_text(text + "\n", encoding="utf-8")

    n_chars = sum(1 for c in text if not c.isspace())
    n_paras = text.count("\n\n") + 1
    print(f"[OK] 輸出 {args.out}")
    print(f"     {n_paras} 段落，{n_chars} 字")
    return 0


if __name__ == "__main__":
    sys.exit(main())
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_SRT_TO_TXT_PY

# video-processing-automation/scripts/transcribe_groq.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/scripts/transcribe_groq.py")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/scripts/transcribe_groq.py" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_GROQ_PY'
#!/usr/bin/env python3
"""透過 Groq API 做 STT，產出 word-level 時間碼 JSON。

用法：
  python3 transcribe_groq.py <audio_file> [--out raw.json] [--model whisper-large-v3-turbo]

輸出：verbose_json 格式，含 segments 與 words 時間碼。
"""
import argparse
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

import urllib.request
import urllib.error

GROQ_URL = "https://api.groq.com/openai/v1/audio/transcriptions"
SIZE_LIMIT_MB = 24.0  # Groq 上限 25MB，留 1MB 緩衝


def compress_audio(src: Path) -> Path:
    """用 ffmpeg 壓成 16kHz mono 32kbps，存到暫存檔回傳 Path。"""
    if not shutil.which("ffmpeg"):
        sys.exit("[ERR] 檔案太大需要 ffmpeg 壓縮，但找不到 ffmpeg")
    tmp = Path(tempfile.gettempdir()) / f"audio-to-srt-{os.getpid()}.mp3"
    cmd = [
        "ffmpeg", "-i", str(src),
        "-ac", "1", "-ar", "16000", "-b:a", "32k",
        "-y", str(tmp),
    ]
    print(f"[INFO] 壓縮中（16kHz mono 32kbps）...")
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        sys.exit(f"[ERR] ffmpeg 壓縮失敗：\n{result.stderr[-500:]}")
    new_mb = tmp.stat().st_size / 1024 / 1024
    print(f"[INFO] 壓縮完成：{new_mb:.1f} MB")
    return tmp


def load_api_key() -> str:
    env_key = os.environ.get("GROQ_API_KEY")
    if env_key:
        return env_key.strip()
    key_files = [
        Path.home() / ".codex" / "secrets" / "groq_api_key",
    ]
    for key_file in key_files:
        if key_file.exists():
            return key_file.read_text(encoding="utf-8").strip()
    sys.exit(
        "[ERR] 找不到 Groq API Key（環境變數 GROQ_API_KEY 或 "
        "~/.codex/secrets/groq_api_key）"
    )


def build_multipart(audio_path: Path, model: str, prompt: str) -> tuple[bytes, str]:
    """手刻 multipart/form-data，避免依賴 requests。"""
    boundary = "----GroqBoundary7MA4YWxkTrZu0gW"
    crlf = b"\r\n"
    parts: list[bytes] = []

    def add_field(name: str, value: str) -> None:
        parts.append(f"--{boundary}".encode())
        parts.append(
            f'Content-Disposition: form-data; name="{name}"'.encode()
        )
        parts.append(b"")
        parts.append(value.encode("utf-8"))

    add_field("model", model)
    add_field("response_format", "verbose_json")
    add_field("timestamp_granularities[]", "word")
    add_field("timestamp_granularities[]", "segment")
    add_field("language", "zh")
    if prompt:
        add_field("prompt", prompt)

    # Groq 認副檔名必須小寫；也避免中文檔名引發編碼問題
    safe_name = "audio" + audio_path.suffix.lower()
    parts.append(f"--{boundary}".encode())
    parts.append(
        (
            f'Content-Disposition: form-data; name="file"; '
            f'filename="{safe_name}"'
        ).encode("utf-8")
    )
    parts.append(b"Content-Type: audio/mpeg")
    parts.append(b"")
    parts.append(audio_path.read_bytes())

    parts.append(f"--{boundary}--".encode())
    parts.append(b"")

    body = crlf.join(parts)
    content_type = f"multipart/form-data; boundary={boundary}"
    return body, content_type


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("audio", type=Path)
    ap.add_argument("--out", type=Path, default=None)
    ap.add_argument("--model", default="whisper-large-v3-turbo")
    ap.add_argument(
        "--prompt",
        default=(
            "以下為繁體中文口語內容。專有名詞：Codex、ChatGPT、OpenAI、"
            "NotebookLM、Gemini、Groq、Whisper、GitHub、Obsidian、"
            "Firebase、Netlify、Python、JavaScript。"
        ),
    )
    args = ap.parse_args()

    if not args.audio.exists():
        sys.exit(f"[ERR] 找不到音訊檔：{args.audio}")

    out = args.out or args.audio.with_suffix(".groq.json")
    api_key = load_api_key()

    size_mb = args.audio.stat().st_size / 1024 / 1024
    print(f"[INFO] 檔案大小 {size_mb:.1f} MB，模型 {args.model}")

    # 自動壓縮：超過 24 MB 改用低 bitrate 版本（避免 Groq 502/413）
    upload_path = args.audio
    tmp_compressed: Path | None = None
    if size_mb > SIZE_LIMIT_MB:
        tmp_compressed = compress_audio(args.audio)
        upload_path = tmp_compressed
        new_mb = tmp_compressed.stat().st_size / 1024 / 1024
        if new_mb > SIZE_LIMIT_MB:
            sys.exit(
                f"[ERR] 壓縮後仍 {new_mb:.1f} MB，超過 {SIZE_LIMIT_MB} MB 上限。"
                "請手動切段再分批處理。"
            )

    body, content_type = build_multipart(upload_path, args.model, args.prompt)
    req = urllib.request.Request(
        GROQ_URL,
        data=body,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": content_type,
            "User-Agent": "audio-to-srt/1.0 (+python-urllib)",
            "Accept": "application/json",
        },
        method="POST",
    )

    print("[INFO] 上傳中...")
    try:
        with urllib.request.urlopen(req, timeout=600) as resp:
            data = json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        err_body = e.read().decode("utf-8", errors="replace")
        sys.exit(f"[ERR] Groq API 錯誤 {e.code}：{err_body}")
    except urllib.error.URLError as e:
        sys.exit(f"[ERR] 網路錯誤：{e}")

    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(
        json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    n_words = len(data.get("words", []))
    n_segs = len(data.get("segments", []))
    dur = data.get("duration", 0)
    print(f"[OK] 輸出 {out}（{n_words} 詞 / {n_segs} 段 / {dur:.1f}s）")

    # 清掉壓縮暫存檔
    if tmp_compressed is not None and tmp_compressed.exists():
        try:
            tmp_compressed.unlink()
        except OSError:
            pass
    return 0


if __name__ == "__main__":
    sys.exit(main())
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_GROQ_PY

# video-processing-automation/scripts/validate_srt.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/scripts/validate_srt.py")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/scripts/validate_srt.py" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_VALIDATE_SRT_PY'
#!/usr/bin/env python3
"""驗證清洗後的 SRT 與原始 SRT 時間碼完全一致、段落結構不變。

用法：
  python3 validate_srt.py --raw raw.srt --clean clean.srt
"""
import argparse
import re
import sys
from pathlib import Path

TIMECODE_RE = re.compile(
    r"^(\d{2}:\d{2}:\d{2},\d{3})\s*-->\s*(\d{2}:\d{2}:\d{2},\d{3})$"
)


def parse_srt(path: Path):
    """解析 SRT，回傳 [(index, timecode_line, text), ...]"""
    content = path.read_text(encoding="utf-8-sig")
    blocks = re.split(r"\r?\n\r?\n", content.strip())
    parsed = []
    for b in blocks:
        lines = b.strip().splitlines()
        if len(lines) < 2:
            continue
        idx = lines[0].strip()
        tc = lines[1].strip()
        text = "\n".join(lines[2:]).strip()
        parsed.append((idx, tc, text))
    return parsed


def tc_to_ms(tc: str) -> int:
    h, m, rest = tc.split(":")
    s, ms = rest.split(",")
    return ((int(h) * 60 + int(m)) * 60 + int(s)) * 1000 + int(ms)


def validate(raw_path: Path, clean_path: Path) -> int:
    raw = parse_srt(raw_path)
    clean = parse_srt(clean_path)
    errors = []

    # 1. 段數一致
    if len(raw) != len(clean):
        errors.append(f"段數不一致：raw={len(raw)} vs clean={len(clean)}")
        print("\n".join(errors))
        return 1

    # 2. 時間碼逐段吻合、段號吻合
    for i, ((r_idx, r_tc, r_txt), (c_idx, c_tc, c_txt)) in enumerate(
        zip(raw, clean), start=1
    ):
        if r_idx != c_idx:
            errors.append(f"段 {i} 編號不符：raw={r_idx} clean={c_idx}")
        if r_tc != c_tc:
            errors.append(f"段 {i} 時間碼不符：\n  raw  = {r_tc}\n  clean= {c_tc}")
        if not c_txt:
            errors.append(f"段 {i} 文字為空")

    # 3. clean 時間碼單調遞增、不重疊
    prev_end = -1
    for i, (idx, tc, txt) in enumerate(clean, start=1):
        m = TIMECODE_RE.match(tc)
        if not m:
            errors.append(f"段 {i} 時間碼格式錯誤：{tc}")
            continue
        start_ms = tc_to_ms(m.group(1))
        end_ms = tc_to_ms(m.group(2))
        if start_ms > end_ms:
            errors.append(f"段 {i} 起始 > 結束")
        if start_ms < prev_end:
            errors.append(
                f"段 {i} 與前段重疊：prev_end={prev_end} start={start_ms}"
            )
        prev_end = end_ms

    if errors:
        print("[FAIL] 驗證失敗：")
        for e in errors:
            print(f"  - {e}")
        return 1

    print(f"[OK] 驗證通過：共 {len(clean)} 段，時間碼對齊，結構完整。")
    total_ms = tc_to_ms(TIMECODE_RE.match(clean[-1][1]).group(2))
    hh, rem = divmod(total_ms // 1000, 3600)
    mm, ss = divmod(rem, 60)
    print(f"     總時長：{hh:02d}:{mm:02d}:{ss:02d}")
    return 0


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--raw", required=True, type=Path)
    ap.add_argument("--clean", required=True, type=Path)
    args = ap.parse_args()
    sys.exit(validate(args.raw, args.clean))
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_VALIDATE_SRT_PY

# video-processing-automation/scripts/burn_subtitles.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-processing-automation/scripts/burn_subtitles.py")"
cat > "{{CODEX_HOME}}/skills/video-processing-automation/scripts/burn_subtitles.py" <<'CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_BURN_SUBTITLES_PY'
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
burn_subtitles.py — 使用 OpenCV & Pillow 將 SRT 字幕燒錄進影片中。
解決 ffmpeg 沒有 subtitles 濾鏡的問題。
"""
import sys
import re
import cv2
import numpy as np
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont


def parse_time(tc_str: str) -> float:
    # 格式: 00:00:03,820
    h, m, rest = tc_str.split(":")
    s, ms = rest.split(",")
    return int(h) * 3600 + int(m) * 60 + float(s) + float(ms) / 1000.0


def parse_srt(srt_path: Path):
    content = srt_path.read_text(encoding="utf-8-sig")
    # 相容 Windows \r\n 與 \n\n 分隔
    blocks = re.split(r"\r?\n\r?\n", content.strip())
    subs = []
    for b in blocks:
        lines = b.strip().splitlines()
        if len(lines) >= 3:
            time_line = lines[1].strip()
            time_match = re.match(
                r"(\d{2}:\d{2}:\d{2},\d{3})\s*-->\s*(\d{2}:\d{2}:\d{2},\d{3})",
                time_line,
            )
            if time_match:
                start = parse_time(time_match.group(1))
                end = parse_time(time_match.group(2))
                text = "\n".join(lines[2:]).strip()
                # 去除任何 HTML 標記，如 <span> 等
                text = re.sub(r"<[^>]+>", "", text)
                subs.append((start, end, text))
    return subs


def get_system_font() -> str:
    # 優先使用 macOS 蘋方字體，其次是黑體、Arial 等
    candidates = [
        "/System/Library/Fonts/PingFang.ttc",
        "/System/Library/Fonts/Supplemental/Arial Unicode.ttf",
        "/System/Library/Fonts/STHeiti Light.ttc",
        "/Library/Fonts/Microsoft/Arial.ttf",
    ]
    for c in candidates:
        if Path(c).exists():
            return c
    return ""  # 找不到則使用 Pillow 預設字體


def main():
    if len(sys.argv) < 4:
        print("Usage: python3 burn_subtitles.py <input_video> <input_srt> <output_video>")
        sys.exit(1)

    in_video = Path(sys.argv[1])
    in_srt = Path(sys.argv[2])
    out_video = Path(sys.argv[3])

    if not in_video.exists():
        sys.exit(f"Input video not found: {in_video}")
    if not in_srt.exists():
        sys.exit(f"SRT not found: {in_srt}")

    # 解析字幕
    subs = parse_srt(in_srt)
    print(f"[INFO] 載入 {len(subs)} 段字幕。")

    # 開啟視訊
    cap = cv2.VideoCapture(str(in_video))
    if not cap.isOpened():
        sys.exit("Error opening video capture")

    fps = cap.get(cv2.CAP_PROP_FPS)
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    print(f"[INFO] 影片屬性: {width}x{height}, FPS: {fps}, 總幀數: {total_frames}")

    # 設定寫入器 (使用 mp4v 編碼，暫時寫入無聲檔案)
    fourcc = cv2.VideoWriter_fourcc(*"mp4v")
    out_dir = out_video.parent
    out_dir.mkdir(parents=True, exist_ok=True)
    
    tmp_output = out_dir / f"tmp_silent_{out_video.name}"
    writer = cv2.VideoWriter(str(tmp_output), fourcc, fps, (width, height))
    if not writer.isOpened():
        sys.exit("Error opening video writer")

    font_path = get_system_font()
    print(f"[INFO] 使用字體: {font_path or 'Pillow Default'}")

    frame_idx = 0
    font_size = int(height * 0.038) # 根據高度動態計算合適的字體大小 (例如 1080p 下約 41px)

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        timestamp = frame_idx / fps
        
        # 尋找當前時間點的字幕
        current_text = ""
        for start, end, text in subs:
            if start <= timestamp <= end:
                current_text = text
                break

        if current_text:
            # 轉換影像格式 (BGR to RGB)
            img_pil = Image.fromarray(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
            draw = ImageDraw.Draw(img_pil)
            
            # 載入字體
            if font_path:
                font = ImageFont.truetype(font_path, font_size)
            else:
                font = ImageFont.load_default()

            lines = current_text.splitlines()
            
            # 定位距離底部 12% 高度
            bottom_margin = int(height * 0.12)
            y_start = height - bottom_margin - (len(lines) * (font_size + 10))

            for j, line in enumerate(lines):
                # 測量文字大小
                bbox = draw.textbbox((0, 0), line, font=font)
                text_w = bbox[2] - bbox[0]
                text_h = bbox[3] - bbox[1]

                x = (width - text_w) // 2
                y = y_start + j * (font_size + 15)

                # 繪製半透明圓角背景底色卡片
                pad_x = 24
                pad_y = 10
                draw.rounded_rectangle(
                    [x - pad_x, y - pad_y, x + text_w + pad_x, y + text_h + pad_y],
                    radius=12,
                    fill=(42, 42, 42, 192) # 75% 不透明度
                )

                # 繪製暖白文字
                draw.text((x, y - 2), line, font=font, fill=(253, 251, 247))

            frame = cv2.cvtColor(np.array(img_pil), cv2.COLOR_RGB2BGR)

        writer.write(frame)
        frame_idx += 1
        if frame_idx % 100 == 0:
            print(f"[INFO] 處理進度: {frame_idx}/{total_frames} 幀...")

    cap.release()
    writer.release()
    print("[INFO] 影像渲染完成，開始合併音軌...")

    # 使用 ffmpeg 將原始影片的音軌與剛才處理的無聲影片進行無損合併
    import subprocess
    cmd = [
        "ffmpeg", "-y",
        "-i", str(tmp_output),
        "-i", str(in_video),
        "-map", "0:v",
        "-map", "1:a",
        "-c:v", "copy",
        "-c:a", "copy",
        str(out_video)
    ]
    
    print(f"[CMD] {' '.join(cmd)}")
    rc = subprocess.call(cmd)
    
    # 刪除暫存無聲影片
    if tmp_output.exists():
        try:
            tmp_output.unlink()
        except OSError:
            pass

    if rc == 0:
        print(f"[OK] 字幕影片製作完成：{out_video}")
    else:
        sys.exit(f"[ERR] ffmpeg 合併音軌失敗，退出碼 {rc}")


if __name__ == "__main__":
    main()
CODEX_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_BURN_SUBTITLES_PY

```

<!-- END EMBEDDED_SKILLS -->

