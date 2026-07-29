# 30-Video-Creation-Automation-Skill-安裝

> 版本：2026-07-29 三 Agent 共用版
> 用途：安裝 `video-creation-automation` 全域 skill，在「沒有現成影片」時，先以 `TOOL_EVALUATION.md` 完整評估所有可用影片工具，再從題目、腳本、設計、素材、旁白與 HTML / HyperFrames composition 開始生成影片；旁白先確認女聲或男聲，再使用對應的 Anna Su／HsiaoChen 或 YunJhe route，另含 ImageMagick、Pexels routes，不預設直式裁切。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `video-tool-evaluation` 與 `video-creation-automation` 兩個共用 Skills。

## 來源與歷史紀錄

- 初次同步日期：2026-06-04。
- 來源：使用者提供的 video specs 來源 repo。
- 來源 commit：`3bcb03f`。
- 2026-06-29 依實際重跑 HyperFrames 生成影片流程，補入離線可重現資源規則、Google Fonts / 遠端 texture 禁用、HyperFrames lint / validate / inspect / render 驗證與 sandbox Chrome route。
- 2026-07-28 新增 ImageMagick 中文字卡、免費 Pexels API 素材 manifest／下載、ElevenLabs credits TTS 與 FFmpeg BGM ducking routes；明確排除預設 vertical-short／9:16 裁切。
- 2026-07-29 旁白路由改為先確認女聲或男聲：女聲 Anna Su → HsiaoChen，男聲跳過 ElevenLabs 使用 YunJhe，macOS `say` 為最終離線備援。
- 2026-07-29 規劃階段新增必填 `TOOL_EVALUATION.md`，並升級成跨影片 Skills 共用的 53-route catalog 與 validator；所有工具都必須留下 selected／fallback／not-needed／unavailable／excluded 決定與理由，再和 `SCRIPT.md` 一起進入既有確認閘門。
- 三 Agent 共用全域 skill：`{{SYNC_ROOT}}/skills/video-creation-automation/SKILL.md`。

## 與 Video Processing Automation 的關係

`video-creation-automation` 與 `video-processing-automation` 都屬於影片工作流，但入口不同：

- `video-processing-automation`：已經有原始影片或成品影片時使用，負責剪輯、字幕、文字稿、metadata、封面與上架包。
- `video-creation-automation`：沒有現成影片時使用，負責先做腳本、設計、素材、旁白與影片 composition，再產出可渲染影片。

唯一必要差異是第一步必問：

> 你是否已經有現成影片檔要處理？

- 若有，改用 `video-processing-automation`。
- 若沒有，才繼續 `video-creation-automation`。

## 三 Agent 相容化調整

- 保留來源 repo 的三種影片規格：活動紀錄影片、教學影片、社群科普影片。
- 保留 script-first 與 design-first 的確認閘門：先產 `SCRIPT.md`，確認後產 `DESIGN.md`，再次確認後才實作。
- 將來源工具專屬入口、安裝路徑、相容性表格與 agent 包裝改寫為共用工作流與三個 Agent adapter。
- 不內嵌 API key、OAuth token、素材檔、成品影片或個人品牌資產。
- 共用核心以 HyperFrames、共用 script／CLI、Playwright／ffmpeg 與可驗證渲染契約為準；影像生成依當前 Agent 原生能力或已核准 fallback 執行。
- Pexels 只下載使用者選定的原始素材並保留來源頁／作者；一般旁白
  透過 `voice-reply` 先確認女聲或男聲，再使用對應固定 route。只有女聲
  route 可直接呼叫 ElevenLabs adapter，且仍須本機 key 與
  `--confirm-cloud`。

## 前置條件

- 當前 Agent 已取得目標專案資料夾的讀寫權限；三 Agent 要各自驗證。
- 需要渲染影片時，建議準備 Node.js、ffmpeg / ffprobe。
- 若使用 HyperFrames，依 `26-HyperFrames-Skill-安裝.md` 安裝與驗證。
- 若使用 ImageMagick／Pexels／ElevenLabs adapters，先安裝 Item 34；
  Pexels 不需要 Python SDK，ElevenLabs SDK 由共用 runtime 提供。
- 若需要雲端 TTS、STT、生圖或 API，API key 一律只放在 `{{CODEX_HOME}}/secrets/`，不寫進 repo、LazyPack 或 Obsidian。

## 使用方式

- 「我沒有影片，幫我做一支教學影片」
- 「幫我從這個主題生成一支社群科普影片」
- 「幫我把活動照片和腳本做成活動紀錄影片」
- 「用 video-creation-automation 幫我從零做影片」
- 「用免費 Pexels API 找原比例 B-roll，先給我 manifest 選」
- 「先問我女聲或男聲，再用對應路由生成旁白」
- 「先完整評估所有影片工具，再把 TOOL_EVALUATION.md 和 SCRIPT.md 一起給我確認」

## 踩坑

- 不要跳過第一個 routing question；如果使用者已有影片，應改用 `video-processing-automation`。
- 不要跳過 `SCRIPT.md` 和 `DESIGN.md` 的使用者確認。
- 不要假設照片、logo、音樂或品牌素材存在；要先列出素材缺口。
- 不要把 Pexels 誤寫成付費 API；它免費但有 request limits。不要把
  ElevenLabs 免費 credits 誤寫成完全免費無上限。
- 不要自動新增 vertical-short 或 9:16 crop；來源素材 framing 預設保留。
- 渲染時不要依賴遠端圖片 URL、Google Fonts、favicon 或裝飾性 texture 服務；需要用的素材應放進專案既有素材路徑，或改成 CSS-only / local asset。
- HyperFrames 成品至少跑 `lint`、`validate`、`inspect`；Google Drive / 慢速媒體可加 `--timeout 30000`。
- 若 sandbox 內 Chrome 無法啟動，改用允許啟動本機瀏覽器的執行路線重跑 `validate` / `inspect`，並記錄這是環境限制，不是 composition 失敗。
- 低記憶體 Mac 上 render 優先單 worker，完成後用 `ffprobe` 驗證 MP4 影音 stream。
- 影片素材與輸出成品通常不進 git。

## 最終檢查清單

- [ ] `{{SYNC_ROOT}}/skills/video-tool-evaluation/SKILL.md` 存在。
- [ ] `{{SYNC_ROOT}}/skills/video-creation-automation/SKILL.md` 存在。
- [ ] `references/source-adaptation.md`、`references/video-types.md`、`references/gotchas.md` 存在。
- [ ] `references/optional-tools.md`、`references/planning-tool-evaluation.md` 與 creation adapter scripts 存在。
- [ ] `TOOL_EVALUATION.md` 已包含 53 個共享 route IDs，且通過 `video-tool-evaluation/scripts/validate_tool_evaluation.py`。
- [ ] 啟動時會先詢問是否有現成影片。
- [ ] 已有影片時會路由到 `video-processing-automation`，沒有影片時才繼續生成影片流程。
- [ ] HTML / CSS / JS 已通過 HyperFrames lint / validate / inspect；最終 MP4 已用 `ffprobe` 驗證。
- [ ] 沒有外部字型、遠端 texture、favicon 或不可重現 URL 依賴。
- [ ] 使用 Pexels 時有來源頁／作者紀錄；旁白已記錄實際使用
  `elevenlabs-file`、`edge-file` 或 `say`，敏感內容只走離線 route。
- [ ] 沒有把 API key、OAuth token、影片素材、個人照片或成品影片寫進 repo。
- [ ] Codex、Claude、AntiGravity 重載後，都可用 `video-creation-automation` 或「沒有影片、從零做影片」相關語句觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`video-tool-evaluation`、`video-creation-automation`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- video-tool-evaluation ----
mkdir -p "{{SYNC_ROOT}}/skills/video-tool-evaluation"
# video-tool-evaluation/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-tool-evaluation/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/video-tool-evaluation/SKILL.md" <<'AGENT_LAZYPACK_VIDEO_TOOL_EVALUATION_SKILL_MD_0E95F5A366'
---
name: video-tool-evaluation
description: Use when Codex, Claude, or AntiGravity plans a video workflow, chooses among video tools/providers, creates or processes a multi-step video, writes a VideoSpec/storyboard, builds a HyperFrames composition, converts a website or Remotion project into video, or needs to confirm that every available video route was considered. Produces and validates TOOL_EVALUATION.md before implementation. Direct one-command execution with an already specified tool may consume an existing approved evaluation instead of creating a new one.
---

# Video Tool Evaluation

Use one shared, full-catalog decision record across every planning-capable video
skill. The purpose is to evaluate every available route, not to force every
tool into one video.

## Trigger Boundary

Run the full workflow when any of these is true:

- the user asks for a plan, storyboard, VideoSpec, tool comparison, provider
  choice, new video, full processing package, website-to-video conversion, or
  Remotion-to-HyperFrames translation;
- the workflow will make multiple tool/provider decisions;
- `video-creation-automation`, `video-processing-automation`,
  `video-spec-builder`, `hyperframes`, `website-to-hyperframes`, or
  `remotion-to-hyperframes` reaches its planning gate.

For an exact one-command operation such as “lint this HyperFrames project”,
“burn this SRT with FFmpeg”, or “render this approved composition”, do not
create 53 rows solely for ceremony. Consume the existing approved
`TOOL_EVALUATION.md` when present. If the operation would select a provider,
change framing, upload data, incur cost, or expand scope, run the full
evaluation first.

## Output Contract

Create `TOOL_EVALUATION.md` in the same draft/project folder as the plan,
`video-spec.md`, `SCRIPT.md`, or composition. Read
[references/tool-catalog.md](references/tool-catalog.md) and include every
required route ID exactly once. Use
[references/example-processing-evaluation.md](references/example-processing-evaluation.md)
as a complete processing example, not as reusable project reasoning.

Use exactly these columns:

```markdown
| route_id | tool_or_route | status | project_reason | boundary_and_fallback |
|---|---|---|---|---|
```

Allowed statuses:

- `selected`
- `fallback`
- `not-needed`
- `unavailable`
- `excluded`

`not-needed` is a valid result. It must explain why that route adds no value to
this project. Never leave a route pending, silently omit it, or treat
installation as authorization to use it.

## Workflow

1. Identify the calling video skill and project output folder.
2. Inspect existing assets, project rules, prior approved evaluation, and
   non-secret local availability.
3. Evaluate all route IDs in `references/tool-catalog.md`.
4. Record project-specific reasoning plus the real privacy, cost, credential,
   attribution, framing, timing, timestamp, quality, and fallback boundaries
   that apply.
5. Run:

   ```bash
   python3 "{{SYNC_ROOT}}/skills/video-tool-evaluation/scripts/validate_tool_evaluation.py" \
     "<project-path>/TOOL_EVALUATION.md"
   ```

6. Fix every missing, duplicate, invalid, or placeholder row.
7. Carry only `selected` and `fallback` routes into the downstream plan. Keep
   all other rows in the evaluation as the audit trail.
8. If the chosen route changes during execution, update the row with the
   actual route and fallback reason before delivery.

## Planning Safety

Planning authorizes read-only checks such as `--version`, `--help`, filter
inventory, key-file existence/permission, and API health checks that do not
expose the key.

Planning does not authorize:

- installing software or downloading models;
- spending paid credits or starting a large paid batch;
- uploading private audio, video, images, text, or source code;
- downloading stock assets;
- rendering or publishing;
- automatic vertical reframing, 9:16 crop, or source-media crop.

Ask only when a selected route crosses a cost, privacy, licensing, download,
upload, or material output boundary not already approved by the user/project.

## Shared Preferences

- STT formal order: Groq `whisper-large-v3-turbo` → faster-whisper
  `large-v3-turbo` → MacWhisper. whisper.cpp is explicit quick preview only.
  SenseVoice is supplementary analysis, not the timed final transcript.
- TTS first resolves female or male. Female: ElevenLabs Anna Su → Edge-TTS
  HsiaoChen → macOS `say`. Male: skip ElevenLabs → Edge-TTS YunJhe → macOS
  `say`. Sensitive content starts with local `say`.
- Pexels requires a usable local key, quota check, source/creator tracking, and
  an approved download route.
- Use FFmpeg Full when `subtitles`, `ass`, or `drawtext` is selected.
- Kokoro stays removed. Python `openai-whisper`, the OpenAI Whisper API, and
  direct HyperFrames TTS/STT are not default speech routes.
- Preserve source aspect ratio and framing unless the user explicitly requests
  a change.

## Integration Rules

- `video-creation-automation`: validate before the SCRIPT approval gate.
- `video-processing-automation`: validate before smart cut, cloud upload, or
  any other mutation.
- `video-spec-builder`: create/update the evaluation beside `video-spec.md` and
  validate both before handoff.
- `hyperframes`: validate before composition HTML is written, unless this is a
  small direct edit using an already approved evaluation.
- `website-to-hyperframes`: validate after strategy is locked and before the
  storyboard/script gate.
- `remotion-to-hyperframes`: validate during translation planning and before
  generating HTML.
- `hyperframes-media` and `hyperframes-cli`: consume the approved evaluation for
  direct operations; invoke this skill if they must choose a route/provider.

## Agent Execution Notes

- Shared steps: all three Agents use this same catalog, statuses, output shape,
  safety boundary, validator, and downstream handoff.
- Codex adapter: use available terminal/browser/native media tools for
  read-only checks and shared scripts for validation.
- Claude adapter: use the same package through the shared skills entrypoint and
  the available terminal/native adapters.
- AntiGravity adapter: use the same package through the shared skills
  entrypoint and the available terminal/native adapters.
- Fallback: if an Agent lacks a native capability, record it as unavailable or
  use the approved shared CLI/API/browser route; do not delete the route.
- Verification: every adapter must produce a validator-passing
  `TOOL_EVALUATION.md` with the same required route IDs.

## Verification

- `python3 scripts/validate_tool_evaluation.py --self-test` passes.
- A complete realistic evaluation passes.
- Removing one required route makes validation fail.
- The calling video skill names this shared package rather than maintaining a
  private copy of the catalog.
- All three native skill entrypoints resolve to the same global package.
AGENT_LAZYPACK_VIDEO_TOOL_EVALUATION_SKILL_MD_0E95F5A366

# video-tool-evaluation/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-tool-evaluation/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/video-tool-evaluation/agents/openai.yaml" <<'AGENT_LAZYPACK_VIDEO_TOOL_EVALUATION_AGENTS_OPENAI_YAML_DEB9755D27'
interface:
  display_name: "Video Tool Evaluation"
  short_description: "Evaluate every video tool before choosing a workflow"
  default_prompt: "Use $video-tool-evaluation to assess every available video tool before selecting a video workflow."
AGENT_LAZYPACK_VIDEO_TOOL_EVALUATION_AGENTS_OPENAI_YAML_DEB9755D27

# video-tool-evaluation/references/example-processing-evaluation.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-tool-evaluation/references/example-processing-evaluation.md")"
cat > "{{SYNC_ROOT}}/skills/video-tool-evaluation/references/example-processing-evaluation.md" <<'AGENT_LAZYPACK_VIDEO_TOOL_EVALUATION_REFERENCES_EXAMPLE_PROCESSING_EVALUATION_MD_4DB522276E'
# Example: 16:9 Talking-Head Processing Evaluation

Scenario: an existing 16:9 talking-head recording needs silence cleanup,
Traditional Chinese subtitles, BGM ducking, a cover, metadata, and a final
upload package. The speaker's original human voice is retained.

| route_id | tool_or_route | status | project_reason | boundary_and_fallback |
|---|---|---|---|---|
| route-video-creation | Video Creation Automation | not-needed | A complete source recording already exists, so rebuilding the video from an idea would duplicate work. | Keep the existing-video route; switch only if the recording is rejected and a new composition is requested. |
| route-video-processing | Video Processing Automation | selected | The requested smart cut, captions, audio mix, cover, metadata, and package are this workflow's direct outputs. | Preserve the 16:9 source and pause at title or short-candidate choices that require user input. |
| planning-direct | Processing workflow plan | selected | The processing skill already covers the required edit, subtitle, audio, cover, and packaging decisions. | Record the plan here before any cut or upload; escalate only if the creative scope becomes a new video. |
| planning-video-spec-builder | Video Spec Builder | not-needed | No new shot design or animated storyboard is needed for a straightforward talking-head edit. | Invoke VideoSpec only if new scenes, complex motion, or shot-level redesign is added. |
| route-website-to-hyperframes | Website to HyperFrames | not-needed | No website is a source of brand evidence, messaging, or captured media for this recording. | If a product site becomes a required visual source, capture it only after URL and reuse scope are approved. |
| route-remotion-to-hyperframes | Remotion to HyperFrames | not-needed | The project contains video footage rather than a Remotion source-code composition. | Use the migration skill only after explicit Remotion source translation is requested. |
| asset-user-provided | Existing recording and brand assets | selected | The source video, approved logo, vocabulary, and BGM are the authoritative production inputs. | Keep originals unchanged, work from local copies, and verify every referenced path before packaging. |
| asset-image-generator | Shared Image Generator | fallback | A generated cover background may help only if no suitable source frame can support the chosen title. | Do not generate before cover direction is approved; use the active Agent adapter and disclose limitations. |
| asset-pexels | Pexels photo and video search | not-needed | The talking-head package does not require B-roll, and stock media would add attribution and editorial review. | If B-roll is later requested, check key and quota, present a manifest, and download only selected originals. |
| asset-website-capture | Browser website capture | not-needed | No web UI, product page, or live brand surface needs to appear in the final edit. | Capture only a user-approved URL and record whether screenshots may be redistributed. |
| asset-background-removal | HyperFrames u2net remove-background | not-needed | The speaker remains in the original scene, with no transparent overlay or text-behind-subject treatment. | If separation is added, distinguish subject cutout from hole-cut plate and do not claim true inpainting. |
| title-hyperframes-css | HyperFrames live titles | not-needed | The deliverable is a conventional processed video package rather than an HTML motion composition. | Use live titles only if the user adds an animated composition section and approves HyperFrames. |
| title-imagemagick | ImageMagick title card | fallback | A deterministic local title card can replace generated cover text or supply a simple intro if requested. | Verify Chinese font rendering and dimensions; otherwise use a clean cover background plus approved design tool. |
| voice-human | Original speaker recording | selected | Retaining the real speaker preserves identity, emotion, and natural timing without synthesis. | Do not replace or clone the voice; use cleaned original audio and measure the final mix. |
| voice-female-route | Female TTS route | not-needed | The project keeps the recorded speaker and has no missing female narration. | If female narration is added, confirm the choice and use Anna Su, then HsiaoChen, then local say. |
| voice-male-route | Male TTS route | not-needed | The project keeps the recorded speaker and has no missing male narration. | If male narration is added, skip ElevenLabs and use YunJhe, then local say. |
| voice-offline | Local private TTS route | not-needed | No synthetic reading is needed, so private text does not need local speech generation. | If confidential pickup lines are requested, start with local say and do not upload the text. |
| voice-elevenlabs-anna | ElevenLabs Anna Su | not-needed | No female synthetic narration is required for this human-voice edit. | Never call ElevenLabs for male narration; confirm credits before any later large female batch. |
| voice-edge-hsiaochen | Edge-TTS HsiaoChen | not-needed | No female synthetic fallback is required while the original speaker audio is usable. | Edge uploads text; use only after a female TTS need is approved and Anna Su is unavailable. |
| voice-edge-yunjhe | Edge-TTS YunJhe | not-needed | No male synthetic narration is required while the original speaker audio is retained. | Edge uploads text; use only after male TTS is requested, with local say as fallback. |
| voice-macos-say | macOS say | not-needed | The current edit needs no synthetic pickup lines or privacy-only narration. | Keep it as the local fallback if approved TTS providers fail or text must remain offline. |
| voice-voxcpm2 | VoxCPM2 voice cloning | excluded | The user did not request authorized cloning or voice design, and the human source audio is sufficient. | Do not load a cloning profile without explicit scope, consent, and authorized reference audio. |
| stt-groq | Groq whisper-large-v3-turbo | selected | It is the approved first formal STT route and provides strong multilingual transcription with timestamps. | Upload only under the standing project approval; fall back immediately on key, quota, network, model, or upload failure. |
| stt-faster-whisper | faster-whisper large-v3-turbo | fallback | It provides the required local formal transcript when Groq cannot be used. | Confirm the local model footprint before first download and report the fallback reason and elapsed time. |
| stt-whisper-cpp | whisper.cpp preview | not-needed | This job requires a final-quality transcript rather than an explicitly requested rapid preview. | Use only if the user asks for quick preview; never let it replace the formal local fallback silently. |
| stt-macwhisper | MacWhisper | fallback | It remains the final Whisper comparison route if Groq and faster-whisper cannot deliver usable timestamps. | Verify installed CLI entitlement and validate SRT timecodes before accepting its output. |
| stt-sensevoice | SenseVoice supplementary analysis | not-needed | The clear Mandarin talking-head audio needs timed captions, not emotion or sound-event tagging. | Use only as a Chinese or Cantonese cross-check; do not present its untimed text as final SRT. |
| edit-auto-editor | Auto-Editor smart cut | selected | Removing long pauses will tighten the talking-head pacing before transcript timestamps are generated. | Normalize VFR to CFR and verify stream order first; compare duration and inspect cuts for clipped words. |
| edit-ffmpeg-clip | FFmpeg deterministic trims | fallback | Manual trims can repair isolated cut errors or produce an approved highlight without another smart-cut pass. | Preserve source aspect ratio, map video and audio explicitly, and verify boundary frames. |
| compose-hyperframes | HyperFrames composition | not-needed | The requested package does not need new animated scenes or a seekable HTML composition. | Select it only if the scope adds motion graphics or redesigned scenes that cannot be simple overlays. |
| compose-playwright-ffmpeg | Browser capture and FFmpeg | not-needed | No browser-rendered fallback composition is needed for this conventional edit. | Use only if an approved HTML renderer is required and HyperFrames cannot meet the project constraint. |
| translate-remotion | Remotion translation | not-needed | There is no React or Remotion source code in the project. | If source code appears, lint it first and document unsupported patterns before translation. |
| motion-gsap | GSAP motion | not-needed | No new timeline-based motion graphics are required for the approved talking-head package. | If motion graphics are added, use deterministic seekable timelines and validate every scene. |
| motion-animejs | Anime.js motion | not-needed | The project has no animation requirement that benefits from Anime.js over the normal processing path. | Select only with an approved composition and a documented adapter reason. |
| motion-waapi-css | WAAPI or CSS motion | not-needed | A conventional cut and subtitle burn does not require lightweight browser animation. | Use only for an approved HTML overlay or composition with deterministic timing. |
| motion-lottie | Lottie assets | not-needed | No existing After Effects or dotLottie asset is part of the supplied materials. | Add only after licensing, local asset availability, looping, and render behavior are verified. |
| motion-three-webgl | Three.js or WebGL | not-needed | The talking-head edit has no 3D model, product rotation, or shader scene requirement. | Select only after a 3D asset and GPU-supported composition are explicitly approved. |
| motion-typegpu-webgpu | TypeGPU or WebGPU | not-needed | The requested output does not need an experimental GPU-rendered visual effect. | Require runtime support and a deterministic fallback before using WebGPU in a deliverable. |
| motion-audio-reactive | Audio-reactive animation | not-needed | BGM should support speech quietly rather than drive visible rhythmic animation. | If selected later, derive deterministic analysis data and keep captions legible during peaks. |
| audio-ffmpeg | FFmpeg Full audio processing | selected | The final package needs stream mapping, BGM fades, measured levels, and a verified audio stream. | Use FFmpeg Full, state the measurement basis, and remux instead of rerendering when only audio changes. |
| audio-mix-audio | mix_audio.py BGM ducking | selected | The requested background music must lower under speech without changing the approved 16:9 framing. | Record duck timing and target dB, then measure source, music bed, and final mix. |
| caption-srt | Validated Traditional Chinese SRT | selected | A separate, editable timed subtitle file is required for accessibility and platform upload. | Generate after the final cut, apply vocabulary without changing timecodes, and run SRT validation. |
| caption-libass-drawtext | FFmpeg Full subtitles and drawtext | selected | The user wants a readable burned-caption master in addition to the separate SRT. | Confirm FFmpeg Full filters and font rendering; preserve a clean master without burned captions. |
| caption-opencv-pillow | OpenCV and Pillow subtitle fallback | fallback | It provides a cross-platform burner only if the required FFmpeg Full filters are unavailable. | Expect slower processing and verify Chinese fonts, sync, frame rate, audio remux, and output quality. |
| caption-hyperframes-dynamic | HyperFrames animated captions | not-needed | Static burned subtitles meet the brief; word-level animated captions would change the visual style. | Use only with a separately approved HyperFrames composition and verified word timestamps. |
| verify-hyperframes | HyperFrames quality checks | not-needed | No HyperFrames composition is selected for this conventional edit. | If scope changes, require lint, validate, inspect, animation map, contrast, and playback review. |
| verify-ffprobe | ffprobe final media verification | selected | Resolution, aspect ratio, duration, codec, frame rate, and both streams must be confirmed before delivery. | Fail delivery if video or audio is missing, framing changed, or duration differs unexpectedly. |
| verify-remotion-ssim | Remotion SSIM comparison | not-needed | No Remotion baseline or HyperFrames translation exists to compare. | If migration is added, align pixel format and color space before measuring the correct tier threshold. |
| handoff-video-processing | Titles, cover, metadata, highlights, and package | selected | The final request explicitly includes a publish-ready folder beyond the edited video itself. | Pause for title and optional highlight selection, then package only approved artifacts and notes. |
| exclude-kokoro | Kokoro exclusion | excluded | Kokoro was removed from the approved TTS stack and must not reappear through an old example. | Use the gender-gated shared voice route if synthesis is later requested. |
| exclude-openai-whisper | openai-whisper and OpenAI API exclusion | excluded | These routes duplicate the approved Groq and faster-whisper stack without a project benefit. | Use them only for an explicit, separately approved comparison and record the resulting cost or model download. |
| exclude-hyperframes-built-in-speech | HyperFrames built-in speech exclusion | excluded | Direct built-in TTS and raw-audio STT would bypass the shared gender and Groq-first routing rules. | HyperFrames may normalize an approved transcript, but provider selection stays in the shared speech routes. |
| exclude-vertical-short | Automatic 9:16 crop exclusion | excluded | The user requires the original 16:9 composition and did not request reframing or a vertical variant. | Preserve source dimensions and framing; make any later format change an explicit, previewed decision. |
AGENT_LAZYPACK_VIDEO_TOOL_EVALUATION_REFERENCES_EXAMPLE_PROCESSING_EVALUATION_MD_4DB522276E

# video-tool-evaluation/references/tool-catalog.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-tool-evaluation/references/tool-catalog.md")"
cat > "{{SYNC_ROOT}}/skills/video-tool-evaluation/references/tool-catalog.md" <<'AGENT_LAZYPACK_VIDEO_TOOL_EVALUATION_REFERENCES_TOOL_CATALOG_MD_6592FBEAB8'
# Shared Video Tool Catalog

Every planning-capable video workflow must assess every route below. Selection
is not required; explicit, project-specific `not-needed`, `unavailable`, and
`excluded` decisions are valid.

## Required Route IDs

### Workflow routing

| route_id | Tool or decision to assess |
|---|---|
| `route-video-creation` | Use `video-creation-automation` when no source video exists and the work starts from an idea, script, or assets. |
| `route-video-processing` | Use `video-processing-automation` when raw or finished video already exists and needs editing, captions, packaging, or enhancement. |
| `planning-direct` | Use the calling skill's direct interview/plan when its existing gate is sufficient. |
| `planning-video-spec-builder` | Use `video-spec-builder` when shot-level requirements, capabilities, or storyboard decisions need deeper clarification. |
| `route-website-to-hyperframes` | Use `website-to-hyperframes` when a live website is the source of brand/product evidence and capture assets. |
| `route-remotion-to-hyperframes` | Use `remotion-to-hyperframes` only for an explicit source-code migration from Remotion. |

### Assets and titles

| route_id | Tool or decision to assess |
|---|---|
| `asset-user-provided` | Existing photos, video, audio, screenshots, documents, logo, brand assets, fonts, music, and reference links. |
| `asset-image-generator` | Current Agent native image generation through the shared `image-generator` route. |
| `asset-pexels` | Pexels photo/video search, live key/quota health, manifest review, source page, creator attribution, and unchanged framing. |
| `asset-website-capture` | Website screenshot/DOM/style capture through the website workflow or approved browser route. |
| `asset-background-removal` | HyperFrames `remove-background`/u2net for transparent subject layers; distinguish cutout, hole-cut plate, and true inpainting. |
| `title-hyperframes-css` | HyperFrames/CSS live title and text treatment. |
| `title-imagemagick` | ImageMagick deterministic PNG title cards through `make_title_card.py`. |

### Voice and TTS

| route_id | Tool or decision to assess |
|---|---|
| `voice-human` | Existing or newly recorded human narration. |
| `voice-female-route` | Female route decision: Anna Su → HsiaoChen → local `say`. |
| `voice-male-route` | Male route decision: skip ElevenLabs → YunJhe → local `say`. |
| `voice-offline` | Sensitive/private narration forced to local macOS `say`. |
| `voice-elevenlabs-anna` | ElevenLabs Anna Su, female only; assess key, quota/credits, cloud text upload, and batch size. |
| `voice-edge-hsiaochen` | Edge-TTS `zh-TW-HsiaoChenNeural`, female fallback/default-quality comparison. |
| `voice-edge-yunjhe` | Edge-TTS `zh-TW-YunJheNeural`, male primary route. |
| `voice-macos-say` | macOS `say` local fallback for either gender and private content. |
| `voice-voxcpm2` | VoxCPM2 only for explicit, authorized voice cloning or voice design. |

### Speech-to-text

| route_id | Tool or decision to assess |
|---|---|
| `stt-groq` | Formal STT first choice: Groq `whisper-large-v3-turbo`; assess upload permission, key, quota, network, and timestamps. |
| `stt-faster-whisper` | Formal local fallback: faster-whisper `large-v3-turbo`; assess local model size, speed, and compute. |
| `stt-whisper-cpp` | Explicit quick preview only; assess the local model and preview-quality tradeoff. |
| `stt-macwhisper` | Final Whisper option or GUI/manual comparison; validate CLI entitlement and timestamp output. |
| `stt-sensevoice` | Supplementary Chinese/Cantonese, emotion, and sound-event analysis only; not the timed final transcript. |

### Editing, composition, and motion

| route_id | Tool or decision to assess |
|---|---|
| `edit-auto-editor` | Auto-Editor through `smart_cut.py` for silence/pace cleanup; assess VFR/CFR and stream-order risk. |
| `edit-ffmpeg-clip` | FFmpeg/`clip_cut.py` for deterministic trims, splices, remuxing, or highlight extraction. |
| `compose-hyperframes` | Preferred seekable HTML composition and render route. |
| `compose-playwright-ffmpeg` | Shared browser capture plus FFmpeg fallback when HyperFrames is not the selected renderer. |
| `translate-remotion` | Remotion source lint, mechanical translation, escape hatch, and gap documentation. |
| `motion-gsap` | GSAP timeline animation and HyperFrames synchronization. |
| `motion-animejs` | Anime.js adapter when its timeline/property model better fits the approved composition. |
| `motion-waapi-css` | Web Animations API or CSS keyframes for lightweight deterministic motion. |
| `motion-lottie` | Lottie/dotLottie when an existing animation asset or lightweight loop is appropriate. |
| `motion-three-webgl` | Three.js/WebGL for 3D models, product rotation, shaders, or GPU scenes. |
| `motion-typegpu-webgpu` | TypeGPU/WebGPU for an approved GPU-rendered effect with supported runtime. |
| `motion-audio-reactive` | Audio analysis mapped to deterministic visual properties when music/voice should drive motion. |

### Audio and captions

| route_id | Tool or decision to assess |
|---|---|
| `audio-ffmpeg` | FFmpeg Full muxing, fades, normalization, ducking filters, stream mapping, and audio-only revision/remux. |
| `audio-mix-audio` | `video-processing-automation/scripts/mix_audio.py` for BGM ducking without reframing. |
| `caption-srt` | Timed SRT derived from the actual narration or human recording, with vocabulary cleanup and validation. |
| `caption-libass-drawtext` | FFmpeg Full `subtitles`/`ass` and `drawtext` burn-in or text overlay. |
| `caption-opencv-pillow` | OpenCV/Pillow subtitle burner only when FFmpeg Full/libass is unavailable. |
| `caption-hyperframes-dynamic` | HyperFrames timed, word-highlighted, karaoke, or other animated captions. |

### Verification and packaging

| route_id | Tool or decision to assess |
|---|---|
| `verify-hyperframes` | HyperFrames lint, validate, inspect, animation map, contrast, first/last-frame, and playback review. |
| `verify-ffprobe` | Final resolution, duration, aspect ratio, frame rate, codec, video stream, and audio stream verification. |
| `verify-remotion-ssim` | Remotion-to-HyperFrames pixel-format alignment, SSIM diff, tier threshold, and frame-strip diagnosis. |
| `handoff-video-processing` | Subtitle cleanup, titles, cover, metadata/SEO, highlight clips, and upload-package handoff. |

### Explicit exclusions and format boundary

| route_id | Tool or decision to assess |
|---|---|
| `exclude-kokoro` | Kokoro is removed and must not return as a TTS route. |
| `exclude-openai-whisper` | Python `openai-whisper` and the OpenAI Whisper API are not defaults because they duplicate the approved STT stack. |
| `exclude-hyperframes-built-in-speech` | Direct HyperFrames built-in TTS/STT commands are not Arry's default speech routes. |
| `exclude-vertical-short` | No automatic vertical-short mode, 9:16 crop, or reframing; only explicit user requests may change format/framing. |

## Required Decision Detail

For each applicable row, record:

- why the tool changes or does not change this project's result;
- installed/runtime/credential readiness without exposing secrets;
- free, paid, quota, model-download, or compute implications;
- local/cloud execution and privacy;
- source, creator, attribution, or license duties;
- framing, crop, resolution, timing, transcript, and timestamp effects;
- the exact fallback or handoff.

Generic reasons such as “not needed”, `TBD`, `N/A`, or empty cells do not pass
validation.
AGENT_LAZYPACK_VIDEO_TOOL_EVALUATION_REFERENCES_TOOL_CATALOG_MD_6592FBEAB8

# video-tool-evaluation/scripts/validate_tool_evaluation.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-tool-evaluation/scripts/validate_tool_evaluation.py")"
cat > "{{SYNC_ROOT}}/skills/video-tool-evaluation/scripts/validate_tool_evaluation.py" <<'AGENT_LAZYPACK_VIDEO_TOOL_EVALUATION_SCRIPTS_VALIDATE_TOOL_EVALUATION_PY_4DEA47693E'
#!/usr/bin/env python3
"""Validate the shared full-catalog video tool evaluation."""

from __future__ import annotations

import argparse
from pathlib import Path
import re
import sys


REQUIRED_ROUTE_IDS = (
    "route-video-creation",
    "route-video-processing",
    "planning-direct",
    "planning-video-spec-builder",
    "route-website-to-hyperframes",
    "route-remotion-to-hyperframes",
    "asset-user-provided",
    "asset-image-generator",
    "asset-pexels",
    "asset-website-capture",
    "asset-background-removal",
    "title-hyperframes-css",
    "title-imagemagick",
    "voice-human",
    "voice-female-route",
    "voice-male-route",
    "voice-offline",
    "voice-elevenlabs-anna",
    "voice-edge-hsiaochen",
    "voice-edge-yunjhe",
    "voice-macos-say",
    "voice-voxcpm2",
    "stt-groq",
    "stt-faster-whisper",
    "stt-whisper-cpp",
    "stt-macwhisper",
    "stt-sensevoice",
    "edit-auto-editor",
    "edit-ffmpeg-clip",
    "compose-hyperframes",
    "compose-playwright-ffmpeg",
    "translate-remotion",
    "motion-gsap",
    "motion-animejs",
    "motion-waapi-css",
    "motion-lottie",
    "motion-three-webgl",
    "motion-typegpu-webgpu",
    "motion-audio-reactive",
    "audio-ffmpeg",
    "audio-mix-audio",
    "caption-srt",
    "caption-libass-drawtext",
    "caption-opencv-pillow",
    "caption-hyperframes-dynamic",
    "verify-hyperframes",
    "verify-ffprobe",
    "verify-remotion-ssim",
    "handoff-video-processing",
    "exclude-kokoro",
    "exclude-openai-whisper",
    "exclude-hyperframes-built-in-speech",
    "exclude-vertical-short",
)
ALLOWED_STATUSES = {
    "selected",
    "fallback",
    "not-needed",
    "unavailable",
    "excluded",
}
PLACEHOLDER_PATTERN = re.compile(
    r"(?:\b(?:pending|tbd|todo|n/?a|fill)\b|待定|待補|稍後|不需要$)",
    re.IGNORECASE,
)


def parse_rows(text: str) -> dict[str, tuple[str, str, str, str, int]]:
    rows: dict[str, tuple[str, str, str, str, int]] = {}
    for line_number, line in enumerate(text.splitlines(), start=1):
        if not line.lstrip().startswith("|"):
            continue
        cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
        if len(cells) != 5:
            continue
        route_id, tool, status, reason, boundary = cells
        if route_id not in REQUIRED_ROUTE_IDS:
            continue
        if route_id in rows:
            raise ValueError(
                f"Duplicate route_id `{route_id}` on line {line_number}."
            )
        rows[route_id] = (
            tool,
            status.lower(),
            reason,
            boundary,
            line_number,
        )
    return rows


def validate_rows(
    rows: dict[str, tuple[str, str, str, str, int]],
) -> list[str]:
    errors: list[str] = []
    missing = [route_id for route_id in REQUIRED_ROUTE_IDS if route_id not in rows]
    if missing:
        errors.append("Missing route IDs: " + ", ".join(missing))

    for route_id, (tool, status, reason, boundary, line_number) in rows.items():
        if status not in ALLOWED_STATUSES:
            errors.append(
                f"Line {line_number} `{route_id}` has invalid status `{status}`."
            )
        if len(tool) < 2 or PLACEHOLDER_PATTERN.search(tool):
            errors.append(
                f"Line {line_number} `{route_id}` needs a concrete tool/route."
            )
        if len(reason) < 12 or PLACEHOLDER_PATTERN.search(reason):
            errors.append(
                f"Line {line_number} `{route_id}` needs a project-specific reason."
            )
        if len(boundary) < 12 or PLACEHOLDER_PATTERN.search(boundary):
            errors.append(
                f"Line {line_number} `{route_id}` needs boundary/fallback details."
            )
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Validate a shared video TOOL_EVALUATION.md."
    )
    parser.add_argument("input", type=Path, nargs="?")
    parser.add_argument(
        "--self-test",
        action="store_true",
        help="Run an internal complete-catalog validator smoke test.",
    )
    args = parser.parse_args()

    if args.self_test:
        rows = {
            route_id: (
                "Representative tool or route",
                "selected",
                "Representative project-specific evaluation reason.",
                "Representative privacy, cost, framing, and fallback boundary.",
                index + 2,
            )
            for index, route_id in enumerate(REQUIRED_ROUTE_IDS)
        }
        errors = validate_rows(rows)
        if errors:
            for error in errors:
                print("ERROR: " + error, file=sys.stderr)
            return 1
        incomplete_rows = dict(rows)
        missing_route = REQUIRED_ROUTE_IDS[-1]
        incomplete_rows.pop(missing_route)
        incomplete_errors = validate_rows(incomplete_rows)
        if not any(
            error.startswith("Missing route IDs:") and missing_route in error
            for error in incomplete_errors
        ):
            print(
                "ERROR: self-test did not reject an incomplete catalog.",
                file=sys.stderr,
            )
            return 1
        print(
            "Self-test passed: "
            f"{len(rows)}/{len(REQUIRED_ROUTE_IDS)} routes assessed; "
            "incomplete catalog rejected."
        )
        return 0

    if args.input is None:
        parser.error("input is required unless --self-test is used")
    if not args.input.is_file():
        print(f"Tool evaluation does not exist: {args.input}", file=sys.stderr)
        return 2

    try:
        rows = parse_rows(args.input.read_text(encoding="utf-8"))
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    errors = validate_rows(rows)
    if errors:
        for error in errors:
            print("ERROR: " + error, file=sys.stderr)
        return 1

    print(
        f"Tool evaluation valid: {len(rows)}/{len(REQUIRED_ROUTE_IDS)} routes assessed."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_TOOL_EVALUATION_SCRIPTS_VALIDATE_TOOL_EVALUATION_PY_4DEA47693E

test -f "{{SYNC_ROOT}}/skills/video-tool-evaluation/SKILL.md" && echo "video-tool-evaluation installed for Codex, Claude, and AntiGravity"

# ---- video-creation-automation ----
mkdir -p "{{SYNC_ROOT}}/skills/video-creation-automation"
# video-creation-automation/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-creation-automation/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/video-creation-automation/SKILL.md" <<'AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_SKILL_MD_0E95F5A366'
---
name: video-creation-automation
description: >
  Use when the user asks Codex, Claude, or AntiGravity to create a video from scratch when there is no
  existing edited video: choose a video type, interview for topic/materials,
  evaluate every available video tool in TOOL_EVALUATION.md, write SCRIPT.md
  and DESIGN.md, create a HyperFrames-style HTML video plan, prepare
  TTS/assets, render or hand off to rendering tools, and package the result. If
  the user already has a finished or raw video file, route to
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

Optional local/provider adapters add ImageMagick title cards, Pexels stock
assets, the shared Groq-first STT route, and FFmpeg BGM ducking. Narration
first resolves a female/male gate, then uses the shared conditional TTS route. These tools
expand tool choice without introducing a vertical-short preset or automatic
9:16 cropping.

## Output Contract

In a standard four-box project that has `100_Todo/`, use the project structure
as the source of truth:

- Draft composition and process files go in
  `100_Todo/drafts/<video-project-name>/`.
- Final video packages go directly in
  `100_Todo/projects/<video-project-name>/`.
- Inside that final package, keep source media and final deliverables as
  `00_Source_Media/` and `01_Final_Output/` when the project needs cleaned media
  and rendered outputs. Do not put these folders at the project root.
- Do not create project-root `assets/`, `renders/`, or `output/` folders when
  those `100_Todo/` routes exist.

Inside the draft folder, produce or prepare:

- `TOOL_EVALUATION.md` - mandatory full-catalog assessment of every available
  planning, asset, narration, STT, editing, composition, audio, subtitle,
  verification, and packaging route. Every route must be marked selected,
  fallback, not-needed, unavailable, or excluded with a reason.
- `SCRIPT.md` - narration, captions, beat list, scene purpose, and asset needs.
- `DESIGN.md` - type, aspect ratio, visual system, fonts, colors, layout,
  animation rhythm, audio rules, and render constraints.
- `STORYBOARD.md` - optional for short videos, required for longer or complex
  videos.
- `index.html` or a HyperFrames composition entrypoint.
- `assets/` or another local subfolder under the draft folder for images,
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
   - invoke the shared `video-tool-evaluation` skill and read its
     `references/tool-catalog.md`;
   - read `references/optional-tools.md` during planning, even when no optional
     tool was requested.
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
   - voiceover preference: human recording or the shared TTS route;
   - for TTS, ask female or male unless the user already specified it;
   - brand or style constraints.
4. Create and validate `TOOL_EVALUATION.md`:
   - assess every required route ID from the shared
     `video-tool-evaluation/references/tool-catalog.md`; never silently omit a
     tool because it looks unnecessary;
   - mark each route `selected`, `fallback`, `not-needed`, `unavailable`, or
     `excluded`, and state the project-specific reason;
   - record availability, cost, cloud/privacy boundary, credential or
     installation need, attribution duty, framing impact, and fallback where
     relevant;
   - planning may run read-only availability checks, but must not install
     tools, spend paid credits, upload private material, download assets, or
     render;
   - run
     `video-tool-evaluation/scripts/validate_tool_evaluation.py TOOL_EVALUATION.md`;
     fix every missing route or pending decision before continuing.
5. Create `SCRIPT.md` and stop for confirmation:
   - write narration, captions, scene beats, asset list, and timing;
   - summarize the recommended toolchain and link to `TOOL_EVALUATION.md`;
   - keep captions concise and single-line where possible;
   - do not start coding, TTS, asset generation, or rendering before the user
     confirms the script and tool evaluation.
6. Create `DESIGN.md` and stop for confirmation:
   - define visual system, layout, typography, palette, transitions, motion,
     subtitle placement, render size, and accessibility checks;
   - carry forward only the selected and fallback routes from the approved tool
     evaluation;
   - do not start implementation until the user approves the design.
7. Build the composition:
   - create or adapt `index.html` / HyperFrames composition;
   - keep media local under the draft folder, usually `assets/`;
   - if using generated images, use `image-generator` with the active Agent
     adapter or a user-approved shared image workflow;
   - if using external photos, download local copies and record attribution
     notes when required.
   - use the Pexels adapter only with a local API key and an approved asset
     route; keep the downloaded source framing unless the design explicitly
     calls for a change.
8. Prepare narration/audio:
   - generate or import narration according to the approved route;
   - unless the user supplies a human recording, do not run TTS until voice
     gender is known;
   - for female narration, run `voice-reply --voice-gender female --out ...`
     so Anna Su is attempted first, HsiaoChen is the Edge fallback, and macOS
     `say` is final;
   - for male narration, run `voice-reply --voice-gender male --out ...` so
     ElevenLabs is skipped, YunJhe is used, and macOS `say` is final;
   - use `voice-reply --engine say ...` for content that must remain offline;
   - align captions and beat durations;
   - use ffmpeg for muxing, audio fades, and optional BGM ducking when needed.
9. Render or hand off:
   - render with the project-approved toolchain, such as HyperFrames,
     Playwright capture + ffmpeg, or another local renderer;
   - verify output duration, audio presence, subtitle readability, and first /
     last frames.
10. Package final output:
   - place video, captions, transcript, cover prompt/image, metadata, and notes
     in `100_Todo/projects/<video-project-name>/` when the project has
     `100_Todo/`, otherwise in the smallest project-appropriate final package
     folder;
   - retain the final `TOOL_EVALUATION.md` so the actual provider/engine and
     fallback can be compared with the plan;
   - if the user wants upload packaging after the render, then hand off to
     `video-processing-automation` for subtitle cleanup, metadata, cover, and upload
     package refinement.

## Guardrails

- Never skip `SCRIPT.md` and `DESIGN.md` approval before implementation.
- Never skip, shorten, or silently infer the mandatory full-catalog
  `TOOL_EVALUATION.md`. A `not-needed` or `excluded` decision is valid only
  when it includes a project-specific reason.
- Do not assume assets exist. Ask and list asset gaps first.
- Do not upload private materials to cloud services without user approval.
- Do not write API keys, tokens, OAuth files, or credentials into the project,
  LazyPack, Obsidian notes, or logs.
- The user's standing preference approves the selected female or male route for
  ordinary, non-sensitive narration. Ask again before sending sensitive/private
  text or starting an unexpectedly large paid batch. Pexels is free but still
  requires a local key, source tracking, and an approved asset route.
- Do not introduce vertical reframing or crop source media unless the user
  explicitly requests it.
- Keep `video-processing-automation` as the route for existing video processing. This
  skill is for creating the video itself when no video exists yet.

## Agent Execution Notes

- Shared steps: all three Agents use the same routing question, complete tool
  catalog, validator, approval gates, TOOL_EVALUATION/SCRIPT/DESIGN contracts,
  project folders, render inputs, and final checks.
- Codex adapter: use available native image, browser, terminal, and HyperFrames
  tools while honoring sandbox permissions.
- Claude adapter: use available native tools and the same shared scripts/CLI;
  route image generation through `image-generator`.
- AntiGravity adapter: use available native tools and the same shared scripts/CLI;
  route image generation through `image-generator`.
- Fallback: shared HyperFrames/Playwright/ffmpeg scripts and an approved image or
  TTS route must preserve the same deliverables.
- Verification: apply identical lint, render, ffprobe, audio, caption, first/last
  frame, and package checks.

## Verification

- Global skill package exists at `{{SYNC_ROOT}}/skills/video-creation-automation`.
- `video-processing-automation` remains installed for existing-video workflows.
- `TOOL_EVALUATION.md` contains every shared required route ID and passes
  `video-tool-evaluation/scripts/validate_tool_evaluation.py` before
  `SCRIPT.md` approval.
- `SCRIPT.md` and `DESIGN.md` are present before any implementation output.
- Referenced local assets exist before rendering.
- Rendered video has audio, readable captions, correct duration, and no
  accidental click overlay in frame 0.
- Scan the package for old tool names or old agent-specific paths before
  syncing.
- When optional adapters are used, verify `magick`, the selected provider SDK,
  asset attribution, audio streams, and the preserved source aspect ratio.
AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_SKILL_MD_0E95F5A366

# video-creation-automation/references/gotchas.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-creation-automation/references/gotchas.md")"
cat > "{{SYNC_ROOT}}/skills/video-creation-automation/references/gotchas.md" <<'AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_REFERENCES_GOTCHAS_MD_DE4E8B5CD6'
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
- Download external images into `assets/` under the draft folder; do not rely
  on remote URLs at render time. This is allowed inside
  `100_Todo/drafts/<video-id>/`; do not create a project-root `assets/`
  folder.
- Do not rely on remote decorative textures, Google Fonts links, favicon
  requests, or other external render-time URLs. Prefer local assets, built-in
  HyperFrames font handling, or CSS-only textures so a downloaded repo renders
  the same way offline.
- Record attribution or source notes when needed.
- Avoid private or sensitive media uploads unless the user explicitly approves.
- Pexels downloads are optional provider assets. Keep the source page, creator,
  and license/attribution note alongside the downloaded file.
- Do not use a stock-media download as permission to crop, reframe, or force it
  into 9:16.

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
- For background music under speech, use the processing skill's
  `mix_audio.py`; its default route ducks music and copies the video stream
  without changing framing.

## Paid Cloud TTS

- Use `voice-reply` as the normal entrypoint. The female route may attempt
  ElevenLabs Anna Su and may incur cost; the male route must skip ElevenLabs.
- The legacy direct adapter requires `--confirm-cloud`, a local key, and the
  approved Anna Su voice ID. Do not use it as the normal route.
- Never clone or imitate a voice without the speaker's authorization.

## HyperFrames Rendering

- Run `npx --yes hyperframes@<version> lint`, then `validate`, then `inspect`
  before render. If media loads from Google Drive or a slow local folder, use
  longer timeouts such as `--timeout 30000`.
- If headless Chrome fails inside the Codex sandbox but `hyperframes browser
  ensure` finds system Chrome, rerun validate/inspect/render with an execution
  route that can launch the local browser. This is an environment issue, not a
  composition syntax issue, when lint already passes.
- On low-memory Macs, HyperFrames may activate low-memory profile and pin
  rendering to one worker. Treat this as an expected slow path; do not force
  extra workers unless the machine has enough free RAM.
- After render, verify with `ffprobe` that the MP4 has both a video stream and
  an audio stream, and that the duration matches the composition/narration
  length.

## HTML Playback

- If a browser preview needs a click-to-play overlay, hide it fully in render
  mode so frame 0 is clean.
- Freeze the final frame intentionally; do not leave a half-transition state.

## Python

- Write paths relative to the script file or project root explicitly. Do not
  rely on whichever cwd happens to run the command.
- Use UTF-8 for all generated files.
AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_REFERENCES_GOTCHAS_MD_DE4E8B5CD6

# video-creation-automation/references/optional-tools.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-creation-automation/references/optional-tools.md")"
cat > "{{SYNC_ROOT}}/skills/video-creation-automation/references/optional-tools.md" <<'AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_REFERENCES_OPTIONAL_TOOLS_MD_8D7A91A409'
# Optional Creation Tools

Planning must evaluate every route in `planning-tool-evaluation.md`, even when
most routes will be marked not-needed or excluded. After approval, use only the
tools selected in `TOOL_EVALUATION.md`, `SCRIPT.md`, and `DESIGN.md`. These
adapters expand execution choices; they do not add a vertical-short preset or
crop source media.

## Tool Matrix

| Need | Default / local route | Optional route | Boundary |
|---|---|---|---|
| Title card | CSS / HyperFrames | ImageMagick `make_title_card.py` | Local, deterministic |
| Narration | `voice-reply`: ask female/male, then use the matching conditional route | Human recording or direct `elevenlabs_tts.py` adapter | ElevenLabs/Edge are cloud; `say` is offline |
| Stock photo/video | User-provided or generated asset | Pexels `pexels_media.py` | Free API key with rate limits; retain source page and attribution |
| Music mixing | FFmpeg | Processing skill `mix_audio.py` | Preserves video stream and aspect ratio |
| Speech transcript | Groq Whisper through `transcribe_preferred.py` | faster-whisper fallback; whisper.cpp only for explicit preview | Cloud route requires prior approval; MacWhisper is last |

## ImageMagick Title Card

```bash
python3 "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/make_title_card.py" \
  "主標題" \
  --subtitle "補充說明" \
  --out "100_Todo/drafts/<video-project-name>/assets/title-card.png"
```

Pass `--font /path/to/font.ttf` when automatic CJK font detection cannot find a
suitable font.

## Narration Route

Use the shared entrypoint unless the user provides a human recording:

```bash
voice-reply \
  --voice-gender female \
  --file "100_Todo/drafts/<video-project-name>/narration.txt" \
  --out "100_Todo/drafts/<video-project-name>/assets/narration.mp3"
```

Ask female or male before running the command unless the user already supplied
the gender. Female uses `--voice-gender female`: Anna Su → HsiaoChen → macOS
`say`. Male uses `--voice-gender male`: skip ElevenLabs → YunJhe → macOS
`say`. Use `--engine say` when narration must remain offline. Confirm again
before sensitive content or an unexpectedly large paid batch.

### Direct ElevenLabs adapter

Use this adapter only for the approved female route. The male route must skip
ElevenLabs and use `voice-reply --voice-gender male`.

The adapter accepts `ELEVENLABS_API_KEY` or
`~/.codex/secrets/elevenlabs_api_key`. Never write the key into a project.
The direct adapter keeps `--confirm-cloud` as an execution guard:

```bash
python-tools-python \
  "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/elevenlabs_tts.py" \
  --text-file "100_Todo/drafts/<video-project-name>/narration.txt" \
  --out "100_Todo/drafts/<video-project-name>/assets/narration.mp3" \
  --confirm-cloud
```

The default voice is `Anna Su - Casual, Friendly and Bright`, voice ID
`9lHjugDhwqoxA5MhX0az`, and the default model is
`eleven_multilingual_v2`. Pass `--voice-id` only to override it.

Do not clone or imitate a voice without the speaker's authorization.

## Speech Transcript Route

Use the processing skill's shared router when narration or imported speech
needs timestamps:

```bash
python-tools-python \
  "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_preferred.py" \
  "100_Todo/drafts/<video-project-name>/assets/narration.mp3" \
  --out "100_Todo/drafts/<video-project-name>/assets/narration.srt" \
  --raw-json "100_Todo/drafts/<video-project-name>/assets/narration.groq.json" \
  --allow-cloud --language auto --traditional
```

This runs Groq first, then faster-whisper, with MacWhisper as the final formal
fallback. Use `--engine whisper.cpp` only when the user explicitly requests a
fast preview. Run SenseVoice separately only for Chinese/Cantonese
cross-checks or emotion/sound-event analysis.

## Pexels Stock Media

The Pexels API is free, but quota limits can change by account and time. During
planning, record the current response-header quota or mark it unverified; do
not rely on a historical hard-coded limit. The adapter accepts
`PEXELS_API_KEY` or `~/.codex/secrets/pexels_api_key`.
Search results are written to a manifest before any asset is selected:

```bash
python3 "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/pexels_media.py" \
  "team collaboration" \
  --media-type video \
  --out "100_Todo/drafts/<video-project-name>/assets/pexels-results.json"
```

After reviewing the manifest, repeat with `--download-index <zero-based-index>`
and `--download-dir <assets-folder>`. The selected source is downloaded without
cropping. Keep its `source_page` and creator fields in attribution notes.
AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_REFERENCES_OPTIONAL_TOOLS_MD_8D7A91A409

# video-creation-automation/references/planning-tool-evaluation.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-creation-automation/references/planning-tool-evaluation.md")"
cat > "{{SYNC_ROOT}}/skills/video-creation-automation/references/planning-tool-evaluation.md" <<'AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_REFERENCES_PLANNING_TOOL_EVALUATION_MD_46D16D43BF'
# Planning Tool Evaluation Compatibility Note

The canonical catalog has moved to the shared
`video-tool-evaluation/references/tool-catalog.md` package so Video Creation,
Video Processing, VideoSpec, HyperFrames, website capture, and Remotion
translation cannot drift apart.

During planning:

1. invoke `video-tool-evaluation`;
2. create `TOOL_EVALUATION.md` beside `SCRIPT.md`;
3. assess every shared route ID;
4. validate with:

   ```bash
   python3 "{{SYNC_ROOT}}/skills/video-tool-evaluation/scripts/validate_tool_evaluation.py" \
     "100_Todo/drafts/<video-project-name>/TOOL_EVALUATION.md"
   ```

5. present the validated evaluation with `SCRIPT.md` at the existing approval
   gate.

This compatibility file remains so older prompts that name
`planning-tool-evaluation.md` still reach the shared source of truth.
AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_REFERENCES_PLANNING_TOOL_EVALUATION_MD_46D16D43BF

# video-creation-automation/references/source-adaptation.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-creation-automation/references/source-adaptation.md")"
cat > "{{SYNC_ROOT}}/skills/video-creation-automation/references/source-adaptation.md" <<'AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40'
# Source Adaptation

Source repository: user-provided video specs source repo.

Snapshot checked: commit `3bcb03f`.

This shared Codex／Claude／AntiGravity skill keeps the useful production ideas:

- three video types;
- environment and render readiness checks;
- script-first and design-first approval gates;
- practical gotchas for subtitles, assets, Playwright, ffmpeg, HTML video, and
  Python path handling;
- repeatable project structure for generated video work.

Adapted for all three Agents:

- global skill path is `{{SYNC_ROOT}}/skills/video-creation-automation`;
- no legacy agent install paths, command shims, or agent-specific packaging;
- no assumption that shell install scripts should run automatically;
- HyperFrames / current Agent image generation / local CLI routes are preferred
  when available, with per-Agent adapters documented in `SKILL.md`;
- `video-processing-automation` is the sibling route for existing-video processing.

Excluded:

- source install scripts as executable defaults;
- obsolete source compatibility tables, replaced by the current three-Agent adapter matrix;
- old agent-specific skill packaging;
- binary assets, downloaded fonts, media, or generated outputs.

## Relationship To Video Processing Automation

`video-processing-automation` starts from an existing raw or finished video file and creates
subtitles, transcript, metadata, cover, and upload package.

`video-creation-automation` starts from no video file and creates the video
itself from idea, script, design, assets, narration, HTML composition, and
render plan.

The first routing question decides which skill is correct.
AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40

# video-creation-automation/references/video-types.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-creation-automation/references/video-types.md")"
cat > "{{SYNC_ROOT}}/skills/video-creation-automation/references/video-types.md" <<'AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_REFERENCES_VIDEO_TYPES_MD_E030221008'
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
AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_REFERENCES_VIDEO_TYPES_MD_E030221008

# video-creation-automation/scripts/elevenlabs_tts.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/elevenlabs_tts.py")"
cat > "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/elevenlabs_tts.py" <<'AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_SCRIPTS_ELEVENLABS_TTS_PY_65A47B1E0F'
#!/usr/bin/env python3
"""Generate narration with ElevenLabs after explicit cloud-cost confirmation."""

from __future__ import annotations

import argparse
import os
from pathlib import Path
import sys

try:
    from elevenlabs.client import ElevenLabs
except ImportError as exc:
    raise SystemExit(
        "The ElevenLabs SDK is unavailable. Reinstall LazyPack Item 34."
    ) from exc


DEFAULT_VOICE_ID = "9lHjugDhwqoxA5MhX0az"


def load_secret() -> str | None:
    value = os.environ.get("ELEVENLABS_API_KEY", "").strip()
    if value:
        return value
    secret_path = Path.home() / ".codex" / "secrets" / "elevenlabs_api_key"
    if secret_path.is_file():
        return secret_path.read_text(encoding="utf-8").strip()
    return None


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Create ElevenLabs narration. This is an optional paid cloud route."
    )
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("--text")
    source.add_argument("--text-file", type=Path)
    parser.add_argument(
        "--voice-id",
        default=os.environ.get("ELEVENLABS_VOICE_ID", DEFAULT_VOICE_ID),
    )
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--model", default="eleven_multilingual_v2")
    parser.add_argument("--output-format", default="mp3_44100_128")
    parser.add_argument(
        "--confirm-cloud",
        action="store_true",
        help="Confirm that the text may be sent to ElevenLabs and API usage may cost money.",
    )
    args = parser.parse_args()

    if not args.confirm_cloud:
        print(
            "Refusing cloud TTS without --confirm-cloud. Review privacy and API cost first.",
            file=sys.stderr,
        )
        return 2
    if args.text_file:
        if not args.text_file.is_file():
            print(f"Text file does not exist: {args.text_file}", file=sys.stderr)
            return 2
        text = args.text_file.read_text(encoding="utf-8").strip()
    else:
        text = (args.text or "").strip()
    if not text:
        print("Narration text is empty.", file=sys.stderr)
        return 2

    api_key = load_secret()
    if not api_key:
        print(
            "Missing ELEVENLABS_API_KEY or ~/.codex/secrets/elevenlabs_api_key.",
            file=sys.stderr,
        )
        return 2

    args.out.parent.mkdir(parents=True, exist_ok=True)
    partial = args.out.with_name(f".{args.out.name}.part")
    try:
        client = ElevenLabs(api_key=api_key)
        audio = client.text_to_speech.convert(
            voice_id=args.voice_id,
            model_id=args.model,
            output_format=args.output_format,
            text=text,
        )
        with partial.open("wb") as handle:
            for chunk in audio:
                if chunk:
                    handle.write(chunk)
        partial.replace(args.out)
    except Exception as exc:
        message = " ".join(str(exc).split())
        message = message.replace(api_key, "[redacted]")
        if len(message) > 240:
            message = f"{message[:237]}..."
        print(
            f"ElevenLabs generation failed ({type(exc).__name__}): {message}",
            file=sys.stderr,
        )
        return 1
    finally:
        partial.unlink(missing_ok=True)
    print(f"Wrote ElevenLabs narration: {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_SCRIPTS_ELEVENLABS_TTS_PY_65A47B1E0F
chmod +x "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/elevenlabs_tts.py"

# video-creation-automation/scripts/make_title_card.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/make_title_card.py")"
cat > "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/make_title_card.py" <<'AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_SCRIPTS_MAKE_TITLE_CARD_PY_4BEC9670FC'
#!/usr/bin/env python3
"""Create a local title card with ImageMagick."""

from __future__ import annotations

import argparse
from pathlib import Path
import shutil
import subprocess
import sys


FONT_CANDIDATES = (
    Path("/System/Library/Fonts/PingFang.ttc"),
    Path("/System/Library/Fonts/STHeiti Light.ttc"),
    Path("/Library/Fonts/Arial Unicode.ttf"),
    Path("/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc"),
    Path("C:/Windows/Fonts/msjh.ttc"),
)


def default_font() -> Path | None:
    return next((path for path in FONT_CANDIDATES if path.is_file()), None)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Create a PNG/JPEG title card without changing video framing."
    )
    parser.add_argument("title")
    parser.add_argument("--subtitle", default="")
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--size", default="1920x1080")
    parser.add_argument("--background", default="#111827")
    parser.add_argument("--title-color", default="#F9FAFB")
    parser.add_argument("--subtitle-color", default="#FBBF24")
    parser.add_argument("--font", type=Path)
    parser.add_argument("--title-size", type=int, default=104)
    parser.add_argument("--subtitle-size", type=int, default=44)
    args = parser.parse_args()

    if shutil.which("magick") is None:
        print("ImageMagick is unavailable. Install it with: brew install imagemagick", file=sys.stderr)
        return 2
    try:
        width, height = (int(value) for value in args.size.lower().split("x", 1))
    except (TypeError, ValueError):
        print("--size must use WIDTHxHEIGHT, for example 1920x1080.", file=sys.stderr)
        return 2
    if min(width, height) < 64:
        print("--size is too small.", file=sys.stderr)
        return 2

    font = args.font or default_font()
    if args.font and not args.font.is_file():
        print(f"Font file does not exist: {args.font}", file=sys.stderr)
        return 2

    args.out.parent.mkdir(parents=True, exist_ok=True)
    command = [
        "magick",
        "-size",
        f"{width}x{height}",
        f"xc:{args.background}",
        "-gravity",
        "center",
    ]
    if font:
        command.extend(["-font", str(font)])
    else:
        print("Warning: no CJK font was detected; pass --font for reliable Chinese text.", file=sys.stderr)
    command.extend(
        [
            "-fill",
            args.title_color,
            "-pointsize",
            str(args.title_size),
            "-annotate",
            "+0-55",
            args.title,
        ]
    )
    if args.subtitle:
        command.extend(
            [
                "-fill",
                args.subtitle_color,
                "-pointsize",
                str(args.subtitle_size),
                "-annotate",
                "+0+85",
                args.subtitle,
            ]
        )
    command.append(str(args.out))

    completed = subprocess.run(command, check=False)
    if completed.returncode:
        return completed.returncode
    print(f"Wrote title card: {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_SCRIPTS_MAKE_TITLE_CARD_PY_4BEC9670FC
chmod +x "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/make_title_card.py"

# video-creation-automation/scripts/pexels_media.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/pexels_media.py")"
cat > "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/pexels_media.py" <<'AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_SCRIPTS_PEXELS_MEDIA_PY_F22EF18F26'
#!/usr/bin/env python3
"""Search Pexels and optionally download one unmodified source asset."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import sys
from urllib.parse import urlencode, urlparse
from urllib.request import Request, urlopen


API_ROOT = "https://api.pexels.com"
ALLOWED_DOWNLOAD_HOSTS = {"images.pexels.com", "videos.pexels.com"}


def load_secret() -> str | None:
    value = os.environ.get("PEXELS_API_KEY", "").strip()
    if value:
        return value
    secret_path = Path.home() / ".codex" / "secrets" / "pexels_api_key"
    if secret_path.is_file():
        return secret_path.read_text(encoding="utf-8").strip()
    return None


def fetch_json(url: str, api_key: str) -> dict:
    request = Request(
        url,
        headers={"Authorization": api_key, "User-Agent": "Arry-video-tools/1.0"},
    )
    with urlopen(request, timeout=30) as response:
        return json.load(response)


def normalize_photos(payload: dict) -> list[dict]:
    return [
        {
            "id": item["id"],
            "width": item["width"],
            "height": item["height"],
            "creator": item.get("photographer"),
            "source_page": item.get("url"),
            "download_url": item["src"]["original"],
            "media_type": "photo",
        }
        for item in payload.get("photos", [])
    ]


def normalize_videos(payload: dict) -> list[dict]:
    normalized = []
    for item in payload.get("videos", []):
        candidates = [
            media
            for media in item.get("video_files", [])
            if media.get("file_type") == "video/mp4" and media.get("link")
        ]
        if not candidates:
            continue
        source = max(
            candidates,
            key=lambda media: (media.get("width") or 0) * (media.get("height") or 0),
        )
        normalized.append(
            {
                "id": item["id"],
                "width": source.get("width"),
                "height": source.get("height"),
                "creator": (item.get("user") or {}).get("name"),
                "source_page": item.get("url"),
                "download_url": source["link"],
                "media_type": "video",
            }
        )
    return normalized


def download(item: dict, target_dir: Path) -> Path:
    url = item["download_url"]
    host = (urlparse(url).hostname or "").lower()
    if host not in ALLOWED_DOWNLOAD_HOSTS:
        raise ValueError(f"Unexpected Pexels download host: {host}")
    suffix = ".mp4" if item["media_type"] == "video" else ".jpg"
    target_dir.mkdir(parents=True, exist_ok=True)
    output = target_dir / f"pexels-{item['id']}{suffix}"
    partial = target_dir / f".{output.name}.part"
    request = Request(url, headers={"User-Agent": "Arry-video-tools/1.0"})
    try:
        with urlopen(request, timeout=60) as response, partial.open("wb") as handle:
            while chunk := response.read(1024 * 1024):
                handle.write(chunk)
        partial.replace(output)
    finally:
        partial.unlink(missing_ok=True)
    return output


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Search Pexels photos/videos and preserve the selected asset's source framing."
    )
    parser.add_argument("query")
    parser.add_argument("--media-type", choices=("photo", "video"), default="video")
    parser.add_argument("--per-page", type=int, default=5)
    parser.add_argument("--out", type=Path, required=True, help="JSON search manifest")
    parser.add_argument("--download-index", type=int)
    parser.add_argument("--download-dir", type=Path)
    args = parser.parse_args()

    if not 1 <= args.per_page <= 20:
        print("--per-page must be between 1 and 20.", file=sys.stderr)
        return 2
    if args.download_index is not None and args.download_dir is None:
        print("--download-dir is required with --download-index.", file=sys.stderr)
        return 2
    if args.download_index is not None and args.download_index < 0:
        print("--download-index must be zero or greater.", file=sys.stderr)
        return 2
    api_key = load_secret()
    if not api_key:
        print("Missing PEXELS_API_KEY or ~/.codex/secrets/pexels_api_key.", file=sys.stderr)
        return 2

    route = "/v1/search" if args.media_type == "photo" else "/videos/search"
    url = f"{API_ROOT}{route}?{urlencode({'query': args.query, 'per_page': args.per_page})}"
    payload = fetch_json(url, api_key)
    results = (
        normalize_photos(payload)
        if args.media_type == "photo"
        else normalize_videos(payload)
    )
    manifest = {
        "provider": "Pexels",
        "query": args.query,
        "media_type": args.media_type,
        "results": results,
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Wrote {len(results)} Pexels results to {args.out}")

    if args.download_index is not None:
        if args.download_index >= len(results):
            print("--download-index is outside the result range.", file=sys.stderr)
            return 2
        output = download(results[args.download_index], args.download_dir)
        print(f"Downloaded source asset without cropping: {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_SCRIPTS_PEXELS_MEDIA_PY_F22EF18F26
chmod +x "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/pexels_media.py"

# video-creation-automation/scripts/validate_tool_evaluation.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/validate_tool_evaluation.py")"
cat > "{{SYNC_ROOT}}/skills/video-creation-automation/scripts/validate_tool_evaluation.py" <<'AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_SCRIPTS_VALIDATE_TOOL_EVALUATION_PY_4DEA47693E'
#!/usr/bin/env python3
"""Compatibility entrypoint for the shared video tool evaluator."""

from __future__ import annotations

import os
from pathlib import Path
import sys


SHARED_VALIDATOR = (
    Path(__file__).resolve().parents[2]
    / "video-tool-evaluation"
    / "scripts"
    / "validate_tool_evaluation.py"
)


def main() -> None:
    if not SHARED_VALIDATOR.is_file():
        raise SystemExit(
            "Shared validator is missing. Install the video-tool-evaluation skill."
        )
    os.execv(
        sys.executable,
        [sys.executable, str(SHARED_VALIDATOR), *sys.argv[1:]],
    )


if __name__ == "__main__":
    main()
AGENT_LAZYPACK_VIDEO_CREATION_AUTOMATION_SCRIPTS_VALIDATE_TOOL_EVALUATION_PY_4DEA47693E

test -f "{{SYNC_ROOT}}/skills/video-creation-automation/SKILL.md" && echo "video-creation-automation installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
