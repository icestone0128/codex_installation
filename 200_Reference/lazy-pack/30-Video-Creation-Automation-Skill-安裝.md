# 30-Video-Creation-Automation-Skill-安裝

> 版本：2026-06-04 Codex App 版
> 用途：安裝 `video-creation-automation` 全域 skill，在「沒有現成影片」時，從題目、腳本、設計、素材、旁白與 HTML / HyperFrames composition 開始生成影片。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/video-creation-automation/`。

## 來源與歷史紀錄

- 初次同步日期：2026-06-04。
- 來源：使用者提供的 video specs 來源 repo。
- 來源 commit：`3bcb03f`。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/video-creation-automation/SKILL.md`。

## 與 Video Processing Automation 的關係

`video-creation-automation` 與 `video-processing-automation` 都屬於影片工作流，但入口不同：

- `video-processing-automation`：已經有原始影片或成品影片時使用，負責剪輯、字幕、文字稿、metadata、封面與上架包。
- `video-creation-automation`：沒有現成影片時使用，負責先做腳本、設計、素材、旁白與影片 composition，再產出可渲染影片。

唯一必要差異是第一步必問：

> 你是否已經有現成影片檔要處理？

- 若有，改用 `video-processing-automation`。
- 若沒有，才繼續 `video-creation-automation`。

## Codex 相容化調整

- 保留來源 repo 的三種影片規格：活動紀錄影片、教學影片、社群科普影片。
- 保留 script-first 與 design-first 的確認閘門：先產 `SCRIPT.md`，確認後產 `DESIGN.md`，再次確認後才實作。
- 排除來源工具專屬入口、安裝路徑、相容性表格與非 Codex agent 包裝。
- 不內嵌 API key、OAuth token、素材檔、成品影片或個人品牌資產。
- 以 Codex App 可用能力為準：HyperFrames、Codex 影像生成、本機 CLI、Playwright / ffmpeg 或使用者指定的渲染路線。

## 前置條件

- Codex App 可讀寫目標專案資料夾。
- 需要渲染影片時，建議準備 Node.js、ffmpeg / ffprobe。
- 若使用 HyperFrames，依 `26-HyperFrames-Skill-安裝.md` 安裝與驗證。
- 若需要雲端 TTS、STT、生圖或 API，API key 一律只放在 `{{CODEX_HOME}}/secrets/`，不寫進 repo、LazyPack 或 Obsidian。

## 使用方式

- 「我沒有影片，幫我做一支教學影片」
- 「幫我從這個主題生成一支社群科普影片」
- 「幫我把活動照片和腳本做成活動紀錄影片」
- 「用 video-creation-automation 幫我從零做影片」

## 踩坑

- 不要跳過第一個 routing question；如果使用者已有影片，應改用 `video-processing-automation`。
- 不要跳過 `SCRIPT.md` 和 `DESIGN.md` 的使用者確認。
- 不要假設照片、logo、音樂或品牌素材存在；要先列出素材缺口。
- 渲染時不要依賴遠端圖片 URL；需要用的素材應放進專案 `assets/`。
- 影片素材與輸出成品通常不進 git。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/video-creation-automation/SKILL.md` 存在。
- [ ] `references/source-adaptation.md`、`references/video-types.md`、`references/gotchas.md` 存在。
- [ ] 啟動時會先詢問是否有現成影片。
- [ ] 已有影片時會路由到 `video-processing-automation`，沒有影片時才繼續生成影片流程。
- [ ] 沒有把 API key、OAuth token、影片素材、個人照片或成品影片寫進 repo。
- [ ] 開新 Codex 對話後可用 `video-creation-automation` 或「沒有影片、從零做影片」相關語句觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`video-creation-automation`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

```bash
set -e

# ---- video-creation-automation ----
mkdir -p "{{CODEX_HOME}}/skills/video-creation-automation/references"

# video-creation-automation/SKILL.md
cat > "{{CODEX_HOME}}/skills/video-creation-automation/SKILL.md" <<'CODEX_LAZYPACK_VIDEO_CREATION_AUTOMATION_SKILL_MD'
---
name: video-creation-automation
description: >
  Use when the user asks Codex to create a video from scratch when there is no
  existing edited video: choose a video type, interview for topic/materials,
  write SCRIPT.md and DESIGN.md, create a HyperFrames-style HTML video plan,
  prepare TTS/assets, render or hand off to rendering tools, and package the
  result. If the user already has a finished or raw video file, route to
  video-processing-automation instead.
metadata:
  short-description: Create videos from scratch when no video exists
---

# Video Creation Automation

Use this skill when the user wants to make a video but does not yet have a
source video file. It is the sibling workflow to `video-processing-automation`.

The only required entry difference is the first routing question:

> Do you already have an existing video file to process?

- If yes, use `video-processing-automation` instead. That skill processes raw or existing
  video into subtitles, transcript, metadata, cover, and final upload package.
- If no, continue here. This skill creates the video from idea, script, design,
  assets, narration, HTML composition, and render plan.

## Output Contract

In a standard four-box project that has `100_Todo/`, use the project structure
as the source of truth:

- Draft composition and process files go in
  `100_Todo/drafts/<video-project-name>/`.
- Final video packages go directly in
  `100_Todo/projects/<video-project-name>/`.
- Do not create project-root `assets/`, `renders/`, or `output/` folders when
  those `100_Todo/` routes exist.

Inside the draft folder, produce or prepare:

- `SCRIPT.md` - narration, captions, beat list, scene purpose, and asset needs.
- `DESIGN.md` - type, aspect ratio, visual system, fonts, colors, layout,
  animation rhythm, audio rules, and render constraints.
- `STORYBOARD.md` - optional for short videos, required for longer or complex
  videos.
- `index.html` or a HyperFrames composition entrypoint.
- `_assets/` or another local subfolder under the draft folder for images,
  audio, fonts, generated files, and downloaded materials.

## Workflow

0. Route first:
   - ask whether an existing video file exists;
   - if the answer is yes, stop this workflow and use `video-processing-automation`;
   - if the answer is no, continue.
1. Read references:
   - read `references/source-adaptation.md`;
   - read `references/video-types.md`;
   - read `references/gotchas.md`.
2. Choose the video type:
   - Type 01: event recap, 60-180 seconds, narration + big title cards + BGM;
   - Type 02: teaching video, 3-8 minutes, SOIL-style explanation + animation
     + TTS;
   - Type 03: social science/popular knowledge video, 2-3 minutes, strong hook
     + varied layouts + visual evidence.
3. Interview for missing inputs:
   - topic and target audience;
   - preferred length and aspect ratio;
   - material state: user photos, screenshots, documents, links, generated
     images, stock photos, or no assets yet;
   - voiceover preference: human recording, Edge-TTS, local TTS, or another
     user-approved route;
   - brand or style constraints.
4. Create `SCRIPT.md` and stop for confirmation:
   - write narration, captions, scene beats, asset list, and timing;
   - keep captions concise and single-line where possible;
   - do not start coding, TTS, asset generation, or rendering before the user
     confirms the script.
5. Create `DESIGN.md` and stop for confirmation:
   - define visual system, layout, typography, palette, transitions, motion,
     subtitle placement, render size, and accessibility checks;
   - do not start implementation until the user approves the design.
6. Build the composition:
   - create or adapt `index.html` / HyperFrames composition;
   - keep media local under the draft folder, usually `_assets/`;
   - if using generated images, use Codex image generation or a user-approved
     image workflow;
   - if using external photos, download local copies and record attribution
     notes when required.
7. Prepare narration/audio:
   - generate or import narration according to the approved route;
   - align captions and beat durations;
   - use ffmpeg for muxing and audio fades when needed.
8. Render or hand off:
   - render with the project-approved toolchain, such as HyperFrames,
     Playwright capture + ffmpeg, or another local renderer;
   - verify output duration, audio presence, subtitle readability, and first /
     last frames.
9. Package final output:
   - place video, captions, transcript, cover prompt/image, metadata, and notes
     in `100_Todo/projects/<video-project-name>/` when the project has
     `100_Todo/`, otherwise in the smallest project-appropriate final package
     folder;
   - if the user wants upload packaging after the render, then hand off to
     `video-processing-automation` for subtitle cleanup, metadata, cover, and upload
     package refinement.

## Guardrails

- Never skip `SCRIPT.md` and `DESIGN.md` approval before implementation.
- Do not assume assets exist. Ask and list asset gaps first.
- Do not upload private materials to cloud services without user approval.
- Do not write API keys, tokens, OAuth files, or credentials into the project,
  LazyPack, Obsidian notes, or logs.
- Keep `video-processing-automation` as the route for existing video processing. This
  skill is for creating the video itself when no video exists yet.

## Verification

- Global skill package exists at `{{CODEX_HOME}}/skills/video-creation-automation`.
- `video-processing-automation` remains installed for existing-video workflows.
- `SCRIPT.md` and `DESIGN.md` are present before any implementation output.
- Referenced local assets exist before rendering.
- Rendered video has audio, readable captions, correct duration, and no
  accidental click overlay in frame 0.
- Scan the package for old tool names or old agent-specific paths before
  syncing.
CODEX_LAZYPACK_VIDEO_CREATION_AUTOMATION_SKILL_MD

# video-creation-automation/references/source-adaptation.md
cat > "{{CODEX_HOME}}/skills/video-creation-automation/references/source-adaptation.md" <<'CODEX_LAZYPACK_VIDEO_CREATION_AUTOMATION_SOURCE_ADAPTATION_MD'
# Source Adaptation

Source repository: user-provided video specs source repo.

Snapshot checked: commit `3bcb03f`.

This Codex skill keeps the useful production ideas:

- three video types;
- environment and render readiness checks;
- script-first and design-first approval gates;
- practical gotchas for subtitles, assets, Playwright, ffmpeg, HTML video, and
  Python path handling;
- repeatable project structure for generated video work.

Converted for Codex:

- global skill path is `{{CODEX_HOME}}/skills/video-creation-automation`;
- no legacy agent install paths, command shims, or agent-specific packaging;
- no assumption that shell install scripts should run automatically;
- HyperFrames / Codex image generation / local CLI routes are preferred when
  available;
- `video-processing-automation` is the sibling route for existing-video processing.

Excluded:

- source install scripts as executable defaults;
- source agent compatibility tables;
- old agent-specific skill packaging;
- binary assets, downloaded fonts, media, or generated outputs.

## Relationship To Video Processing Automation

`video-processing-automation` starts from an existing raw or finished video file and creates
subtitles, transcript, metadata, cover, and upload package.

`video-creation-automation` starts from no video file and creates the video
itself from idea, script, design, assets, narration, HTML composition, and
render plan.

The first routing question decides which skill is correct.
CODEX_LAZYPACK_VIDEO_CREATION_AUTOMATION_SOURCE_ADAPTATION_MD

# video-creation-automation/references/video-types.md
cat > "{{CODEX_HOME}}/skills/video-creation-automation/references/video-types.md" <<'CODEX_LAZYPACK_VIDEO_CREATION_AUTOMATION_VIDEO_TYPES_MD'
# Video Types

Choose one type before writing the script.

## Type 01: Event Recap

Use for a completed activity or event that should become a short emotional recap.

- Typical length: 60-180 seconds.
- Typical scenes: field trip, workshop, ceremony, sports day, community event,
  marathon, graduation, wedding.
- Core elements: narration, large title cards, BGM, emotional pacing.
- Structure: Hook, Setup, Peak, Turn, Echo.
- Visual rules: 16:9 by default, gentle Ken Burns motion, slow fades, warm
  highlight color, one title-card sentence per page.
- Asset preference: real event photos first, generated fill-in images only when
  gaps are clear and approved.

## Type 02: Teaching Video

Use for explaining a school or knowledge concept so viewers can understand and
apply it.

- Typical length: 3-8 minutes.
- Typical subjects: math, science, social studies, concept explanation.
- Core elements: SOIL-style teaching logic, animated visual explanation, TTS or
  human narration.
- Structure: concept positioning, context positioning, page architecture,
  cognitive clarity, visual style, composition.
- Visual rules: dense but clear information, step-by-step reveals, diagrams,
  formulas where needed, strong alignment and readable subtitles.
- Math rule: verify every formula, calculation, diagram, label, and unit.

## Type 03: Social Knowledge Video

Use for short social, science, AI, health, finance, psychology, or popular
knowledge videos.

- Typical length: 2-3 minutes.
- Core elements: strong first-three-second hook, multiple layouts, photos or
  visual evidence, readable captions for silent viewing.
- Structure: Hook, Analogy, Mechanism, Reversal/Application, Closing.
- Visual rules: at least five layout types across the video, enlarged captions,
  clear contrast, local image copies, attribution notes when required.
- Asset preference: user-provided assets first, then licensed/free stock photos,
  then generated images if approved.

## Type Selection Prompt

Ask:

1. Is this an event recap, a teaching explanation, or a social knowledge video?
2. Who will watch it?
3. Where will it be published?
4. What length and aspect ratio do you want?
5. What assets already exist?
CODEX_LAZYPACK_VIDEO_CREATION_AUTOMATION_VIDEO_TYPES_MD

# video-creation-automation/references/gotchas.md
cat > "{{CODEX_HOME}}/skills/video-creation-automation/references/gotchas.md" <<'CODEX_LAZYPACK_VIDEO_CREATION_AUTOMATION_GOTCHAS_MD'
# Gotchas

Read before implementing any generated video.

## Approval Gates

- Always write `SCRIPT.md` first and show it to the user.
- Always write `DESIGN.md` after script approval and show it to the user.
- Do not generate TTS, code, assets, or renders until both are approved.

## Captions

- Keep captions single-line when possible.
- Use no more than about 25 Chinese characters per caption beat.
- Split long narration into multiple beats instead of wrapping subtitles.

## Assets

- Do not assume photos, logo, music, or brand assets exist.
- Download external images into `assets/`; do not rely on remote URLs at render
  time.
- Record attribution or source notes when needed.
- Avoid private or sensitive media uploads unless the user explicitly approves.

## Playwright And Node

- Large `node_modules/` installs inside Google Drive can be slow or fragile.
- Prefer temp/work cache locations for generated render dependencies when a
  project does not intentionally keep dependencies portable.
- For this user's Social Cards exception, `social-cards/node_modules/` is
  intentionally portable and should not be deleted.

## FFmpeg

- When muxing captured video with generated narration, map streams explicitly:
  `-map 0:v:0 -map 1:a:0`.
- Use `afade` with `st=<seconds>` for time-based fades, not sample-based `ss`.
- Verify audio is present in the final MP4.

## HTML Playback

- If a browser preview needs a click-to-play overlay, hide it fully in render
  mode so frame 0 is clean.
- Freeze the final frame intentionally; do not leave a half-transition state.

## Python

- Write paths relative to the script file or project root explicitly. Do not
  rely on whichever cwd happens to run the command.
- Use UTF-8 for all generated files.
CODEX_LAZYPACK_VIDEO_CREATION_AUTOMATION_GOTCHAS_MD

echo "Installed video-creation-automation skill into {{CODEX_HOME}}/skills/video-creation-automation"
```

<!-- END EMBEDDED_SKILLS -->
