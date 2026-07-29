# 29-Video-Processing-Automation-Skill-安裝

> 版本：2026-07-29 三 Agent 共用版
> 用途：安裝 `video-processing-automation` 全域 skill，把原始影片處理成上架包，包含 Auto-Editor 智能剪輯、FFmpeg Full 字幕／混音、多種本機或雲端 STT、文字稿、標題、封面與 metadata；不預設直式或 9:16 裁切。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `video-tool-evaluation` 與 `video-processing-automation` 兩個共用 Skills。

## 來源與歷史紀錄

- 初次同步日期：2026-06-03。
- 來源 repo：https://github.com/mathruffian-dot/2026-YouTube
- 來源 commit：`a0171ce`。
- 2026-06-04 已補入 Groq Python SDK 安裝、Groq Google 登入建立 API key、安全複製與 `{{SECRETS_DIR}}/groq_api_key` 保存流程。
- 2026-06-29 依實際重跑影片後製流程，補入 `espeakng-loader` 檢查、專案詞彙表 `200_Reference/vocabulary.md`、CFR source 保留、SRT 清理順序與 ffprobe 驗收。
- 2026-07-28 補入官方 Auto-Editor 31.4.0、FFmpeg Full、ImageMagick、
  faster-whisper、whisper.cpp、SenseVoice、MacWhisper、BGM ducking 與
  FFmpeg/libass 字幕 routes；本機模型與 binary 由內建 optional tools
  installer 重建。
- 2026-07-29 新增 `transcribe_preferred.py` 統一入口：正式 STT 固定
  Groq → faster-whisper → MacWhisper，whisper.cpp 只供明確快速預覽，
  SenseVoice 只供中文／粵語、情緒與聲音事件補充分析。
- 2026-07-29 接入 `video-tool-evaluation`：多步驟處理在 smart cut、雲端
  上傳或其他素材異動前，先完成 53-route `TOOL_EVALUATION.md`。
- Codex 全域 skill：`{{SYNC_ROOT}}/skills/video-processing-automation/SKILL.md`。

## Codex 相容化調整

- 保留來源 repo 的影片生產線核心：smart cut、Groq Whisper STT、SRT 重切、字幕清理、標題候選、封面提示、metadata、短片候選與切片腳本；另加入 faster-whisper、whisper.cpp、SenseVoice、MacWhisper、FFmpeg Full 字幕與混音選項。
- 將來源工具專屬入口、設定資料夾、handoff 狀態與 agent 路由改寫為共用工作流與 Codex／Claude／AntiGravity adapter；個人頻道範例與品牌素材改為專案輸入。
- 封面圖預設使用當前 Agent 的原生影像生成能力、已核准 API／CLI fallback，或使用者提供的圖像流程，不依賴來源 repo 的本機生圖腳本。
- 頻道名稱、人物照、色票、專有詞彙與輸出路徑都改成專案輸入，不寫死在全域 skill。
- 不內嵌 API key、OAuth token、影片素材、成品影片或個人圖片。

## 前置條件

- LazyPack Item 34 的共用 Python 3.12 runtime、Auto-Editor 31.4.0、
  FFmpeg Full、ImageMagick、Groq／ElevenLabs／OpenCC packages。
- 執行本 Skill 的
  `scripts/install_optional_video_tools.sh`，安裝 whisper.cpp 模型、
  SenseVoice native runtime／模型與選用 MacWhisper。
- 若使用 faster-whisper，另安裝 Item 33 `audio-to-md` runtime。
- Groq STT 路線需要 `GROQ_API_KEY` 或 `{{SECRETS_DIR}}/groq_api_key`。
- Pexels 與 ElevenLabs 是 creation-side optional adapters；Pexels API
  免費但需要 key，ElevenLabs 有免費 credits 且超額／特定功能付費。
- Codex sandbox 若在 Python 語法檢查時擋住 `~/Library/Caches/com.apple.python`，將該路徑加入 writable roots；本機已補入 `{{HOME}}/Library/Caches/com.apple.python`。

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
mkdir -p {{SECRETS_DIR}}
chmod 700 {{SECRETS_DIR}}
pbpaste > {{SECRETS_DIR}}/groq_api_key
chmod 600 {{SECRETS_DIR}}/groq_api_key
```

若 key 曾貼到對話、log、截圖或 repo，先到 Groq Console revoke，再重新建立新 key。

## 驗證

```bash
test -f "{{SYNC_ROOT}}/skills/video-tool-evaluation/SKILL.md" && echo "video-tool-evaluation SKILL.md ok"
python3 "{{SYNC_ROOT}}/skills/video-tool-evaluation/scripts/validate_tool_evaluation.py" --self-test
python-tools-python --version
ffmpeg -version
ffprobe -version
auto-editor --version
magick -version
python-tools-python -c "import groq, elevenlabs, opencc; print('provider adapters ok')"
ffmpeg -hide_banner -filters | grep -E 'subtitles|ass|drawtext'
whisper-cli --help
sensevoice-cli --help
macwhisper-cli --help
python3 -c "import os, pathlib; p=pathlib.Path('{{SECRETS_DIR}}/groq_api_key').expanduser(); print('Groq key:', 'ok' if os.getenv('GROQ_API_KEY') or p.exists() else 'missing')"
test -f "{{SYNC_ROOT}}/skills/video-processing-automation/SKILL.md" && echo "video-processing-automation SKILL.md ok"
test -d "{{SYNC_ROOT}}/skills/video-processing-automation/references" && echo "references ok"
test -d "{{SYNC_ROOT}}/skills/video-processing-automation/scripts" && echo "scripts ok"
```

## 使用方式

- 「使用 video-processing-automation 處理這支影片」
- 「幫我把 raw 裡的新影片做成 YouTube 上架包」
- 「幫我自動剪口播、轉字幕、寫 metadata」
- 「從這支長片剪 3 個 short 候選」
- 「幫我產 YouTube 標題、封面 prompt、SEO 標籤」
- 「保留原比例，用 Groq-first 共用路由產字幕／逐字稿」
- 「用 FFmpeg Full 硬燒字幕並做背景音樂 ducking」

## 踩坑

- 先剪片再轉字幕；不要先對 raw 影片轉字幕，否則時間碼會錯位。
- Groq 會上傳音訊到第三方服務；敏感素材要先確認使用者同意或改本地路線。
- Groq API key 只顯示一次；建立後讓使用者自行複製保存，或只按 Copy 不讀取內容。
- 若 Groq API key 曾外洩到對話或文件，必須 revoke 後重建。
- 正式 STT 一律先用 Groq；缺少或無效 key、API／網路／額度／模型／上傳
  失敗，或素材要求 local-only 時，改用 faster-whisper。明確要求快速
  預覽時用 whisper.cpp；MacWhisper 列為 Whisper 最後選項。
- SenseVoice 用於中文／粵語校對、情緒與聲音事件，其 pinned native
  runtime 目前只交付 TXT，不在 Whisper 優先序內，也不冒充可輸出時間碼
  的 SRT route。
- 官方 Python `openai-whisper` 與 faster-whisper 功能重複，且會加入
  PyTorch 與另一份大型模型，已從本工作流移除。
- Arry 本機 MacWhisper 14.4.1 的 `mw` CLI 已實測可用；不同安裝版本或
  授權需先驗證 `macwhisper-cli --help`，其 SRT 仍要做繁中與時間碼驗證。
- Homebrew `ffmpeg-full` 是 keg-only；必須經 Item 34 共用 wrapper，
  不能只看 `/opt/homebrew/bin/ffmpeg`。
- `resegment.py` 需要 word-level JSON；本地 Whisper segment-only SRT 不適合重切。
- 清理 SRT 時只能改文字，不能改段號、時間碼或段落數。
- `apply_vocab.py` 必須等 `resegment.py` 產出 raw SRT 後再跑；不要把兩步平行化。
- 專有名詞誤辨不要只靠手動記憶，應寫入專案 `200_Reference/vocabulary.md`，格式為 `錯誤辨識=>正確詞彙`。
- 若原始 `.mov` 不在 repo，但已有保留的 normalized CFR source，例如 `100_Todo/drafts/<name>/input_cfr.mp4`，可用它重跑並在駕駛艙註明來源。
- 最終交付前用 `ffprobe` 檢查 MP4 影音 stream、解析度、duration 與 codec。
- 影片素材與輸出成品通常不進 git。

## 最終檢查清單

- [ ] `video-tool-evaluation` 已安裝，且 53-route validator self-test 通過。
- [ ] 多步驟處理在 smart cut 或雲端上傳前已有通過驗證的 `TOOL_EVALUATION.md`。
- [ ] `{{SYNC_ROOT}}/skills/video-processing-automation/SKILL.md` 存在。
- [ ] references / scripts 依本文內嵌 package 完整安裝。
- [ ] 若使用 Groq STT，`python-tools-python -c "import groq"` 可執行，且 `GROQ_API_KEY` 或 `{{SECRETS_DIR}}/groq_api_key` 存在。
- [ ] 若使用本機 STT，選定 route 已實際產出 SRT／TXT；繁中 SRT 已
  經 OpenCC adapter 或後續字幕清理。
- [ ] FFmpeg Full 已列出 `subtitles`、`ass`、`drawtext`，且字幕硬燒後
  解析度與來源一致。
- [ ] 若專案有專有名詞，`200_Reference/vocabulary.md` 已建立並已用 `apply_vocab.py --vocab` 套用。
- [ ] 最終 MP4 已用 `ffprobe` 驗證影音 stream；字幕已用 `validate_srt.py` 驗證。
- [ ] 沒有把 API key、OAuth token、影片素材、個人照片或成品影片寫進 repo。
- [ ] Codex、Claude、AntiGravity 重載後，都可用 `video-processing-automation` 或影片自動化相關語句觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`video-tool-evaluation`、`video-processing-automation`。

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

# ---- video-processing-automation ----
mkdir -p "{{SYNC_ROOT}}/skills/video-processing-automation"
# video-processing-automation/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/SKILL.md" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SKILL_MD_0E95F5A366'
---
name: video-processing-automation
description: >
  Use when the user asks Codex, Claude, or AntiGravity to process raw video into a YouTube-ready or
  social-video-ready package: smart cut, silence removal, local/cloud
  speech-to-subtitle, transcript cleanup, BGM ducking, title candidates, cover
  prompt/image generation, metadata, short highlight clips, and final output packaging. Adapted into a
  portable cross-agent workflow from mathruffian-dot/2026-YouTube.
metadata:
  short-description: YouTube/video processing automation workflow
---

# Video Processing Automation

Use this skill to turn raw talking-head or tutorial video into a packaged video
deliverable with edited video, subtitles, transcript, cover image, metadata, SEO
tags, optional background-music mixing, and optional short highlight versions.
Preserve the source aspect ratio and framing unless the user explicitly asks
for another format; this workflow does not default to vertical cropping.

This is a cross-agent global skill adapted from `mathruffian-dot/2026-YouTube`.
It keeps the useful production logic and scripts while replacing source-specific
entrypoints, local paths, and personal examples with one shared workflow and
native Codex, Claude, and AntiGravity adapters.

## Output Contract

In a standard four-box project that has `100_Todo/`, use the project structure
as the source of truth:

- Process files and temporary subtitles go in `100_Todo/drafts/<video-id>/`.
- Final packages go directly in `100_Todo/projects/<video-id>/`.
- Do not create project-root `working/` or `output/` folders when those
  `100_Todo/` routes exist.

For a long-form video, produce or prepare these files under the routed draft and
project folders:

- `100_Todo/drafts/<video-id>/TOOL_EVALUATION.md`
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

0. Evaluate the complete shared video tool catalog:
   - invoke `video-tool-evaluation` and read its
     `references/tool-catalog.md`;
   - create `100_Todo/drafts/<video-id>/TOOL_EVALUATION.md` when the project
     has `100_Todo/`, otherwise place it in the routed project-local draft
     folder;
   - assess every shared route, including tools that are not needed for this
     processing job, with a project-specific reason and real fallback;
   - run
     `video-tool-evaluation/scripts/validate_tool_evaluation.py` and fix every
     missing or placeholder row;
   - perform read-only readiness checks only at this stage. Do not smart-cut,
     upload media, download a model/asset, spend credits, or generate output
     before the evaluation is valid;
   - if the user asked only for a processing plan, stop after delivering the
     validated evaluation and workflow plan.
1. Check environment and Groq readiness:
   - read `references/setup.md`;
   - verify `ffmpeg`, `ffprobe`, `auto-editor --version`, and
     `python-tools-python -c "import groq"`;
   - if the Groq key is missing or invalid, do not block the current job:
     fallback to faster-whisper and offer Groq key setup separately.
2. Inspect input:
   - locate `raw/<video-id>/` or the user-provided video path;
   - create `100_Todo/drafts/<video-id>/` when `100_Todo/` exists;
   - honor an existing user/project Groq upload decision; if none exists,
     confirm once before the first cloud upload.
3. Smart cut:
   - read `references/smart-cut.md`;
   - run `scripts/smart_cut.py` on the raw video;
   - default threshold is `0.04`; raise toward `0.06` for noisy footage.
4. Subtitle and transcript:
   - extract 16 kHz mono audio from the cut video with `ffmpeg`;
   - read `references/audio-subtitle.md`;
   - read `references/stt-route-guide.md` when choosing or explaining a local
     speech-to-text route;
   - use Groq `whisper-large-v3-turbo` for formal transcription whenever the
     user/project has accepted cloud upload and the key is usable;
   - if the key is missing/invalid, the API/network/quota/model/upload fails, or
     the media requires local-only handling, immediately fallback to
     faster-whisper (`transcribe_local.py`) for the final SRT;
   - when the user explicitly asks for a fast preview, use whisper.cpp
     (`transcribe_whisper_cli.py`) instead of the formal route;
   - use SenseVoice (`transcribe_sensevoice.py`) only as a Chinese/Cantonese
     cross-check or for emotion/audio-event tags;
   - keep MacWhisper (`transcribe_macwhisper.py`) as the last Whisper option or
     GUI/manual comparison after Groq, faster-whisper, and whisper.cpp;
   - do not download a local model without confirming the roughly 1.5 GB first
     download;
   - report the actual engine used and any Groq fallback reason.
5. Clean transcript:
   - preserve every SRT timecode and block boundary;
   - apply project vocabulary mechanically first, using
     `200_Reference/vocabulary.md` when the project has one, then edit only
     subtitle text;
   - validate with `scripts/validate_srt.py`;
   - convert clean SRT to TXT with `scripts/srt_to_txt.py`.
6. Title selection:
   - generate 10 long-form title candidates in Traditional Chinese unless the
     user requests another language;
   - write them to `100_Todo/drafts/<video-id>/titles.md` when `100_Todo/`
     exists;
   - stop and ask the user to pick one.
7. Package final output:
   - sanitize the chosen title for filenames;
   - copy/rename the cut video, clean SRT, and TXT into
     `100_Todo/projects/<video-id>/` when `100_Todo/` exists.
8. Cover:
   - read `references/cover-style.md`;
   - use `image-generator` with the active Agent adapter or the user-provided image workflow;
   - if image generation cannot use a reference image, state the limitation and
     provide a strong `cover-prompt.md`.
9. Metadata:
   - read `references/metadata-template.md`;
   - create YouTube description, chapters, social posts, SEO keywords, copyable
     tag field, and upload checklist.
10. Optional enhancement:
   - read `references/optional-tools.md`;
   - use `scripts/mix_audio.py` for BGM ducking without changing framing;
   - use `scripts/burn_subtitles_ffmpeg.py` for the preferred FFmpeg Full/libass
     subtitle route; keep the OpenCV/Pillow burner as a fallback;
   - prepare local title cards, gender-gated narration through `voice-reply`,
     or Pexels stock media when requested;
   - female narration uses Anna Su → HsiaoChen → macOS `say`; male narration
     skips ElevenLabs and uses YunJhe → macOS `say`.
11. Optional short highlight:
   - read `references/short-video.md`;
   - produce 3 highlight candidates, pause for selection, then run
     `scripts/clip_cut.py`;
   - keep the source aspect ratio unless the user explicitly requests another
     output format.

## Safety And Portability

- Do not commit or print API keys, OAuth tokens, model credentials, or auth
  files.
- If a Groq API key appears in chat, screenshots, logs, or a repo file, tell the
  user to revoke it in Groq Console and create a new key before continuing.
- When creating a Groq key through the browser, leave the one-time key display
  open for the user or copy it to the user's clipboard without reading it back.
  Store it only in a local secret location such as `~/.codex/secrets/groq_api_key` with mode
  `600`, or use a shell session variable for the current run.
- Do not upload audio/video to cloud STT services unless the user has accepted
  that route or the user/project already documents Groq-first. If no decision
  exists, confirm once before the first upload.
- The standing female route may attempt Anna Su when the local key is usable.
  Reconfirm before an unexpectedly large paid batch; male narration must never
  call ElevenLabs. Pexels API is free but still requires a key and source
  tracking.
- Do not crop or reframe source footage by default.
- Do not skip or shorten the shared full-catalog evaluation before a multi-step
  processing run. `not-needed` is valid only with a project-specific reason.
- Keep raw videos and final rendered media out of git unless the user explicitly
  requests otherwise.
- Keep this global skill portable: all reusable instructions live in this skill
  package; project-specific channel names, persona photos, brand palettes,
  vocabulary, and output folders belong in the project.
- Use `image-generator` and its native Agent adapter for covers by default. Do
  not enable a paid or key-based route without user approval.
- Avoid copying source repo sample outputs, personal channel assets, or
  project-local handoff files into new projects.

## When To Read References

- Read `references/source-adaptation.md` before modifying this skill.
- Read `references/setup.md` for prerequisites and environment checks.
- Read `references/smart-cut.md` before silence removal.
- Read `references/audio-subtitle.md` before transcription or SRT cleanup.
- Read `references/optional-tools.md` before BGM mixing, local Whisper, title
  cards, cloud TTS, or stock-media acquisition.
- Read `references/short-video.md` before creating short highlight versions.
- Read `references/cover-style.md` before cover image prompting.
- Read `references/metadata-template.md` before writing metadata.

## Common Commands

```bash
python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/smart_cut.py" \
  "raw/<video-id>/input.mp4" \
  --out "100_Todo/drafts/<video-id>/<video-id>.cut.mp4"

ffmpeg -y -i "100_Todo/drafts/<video-id>/<video-id>.cut.mp4" \
  -vn -ac 1 -ar 16000 "100_Todo/drafts/<video-id>/<video-id>.wav"

python-tools-python \
  "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_preferred.py" \
  "100_Todo/drafts/<video-id>/<video-id>.wav" \
  --out "100_Todo/drafts/<video-id>/_subtitles/<video-id>.raw.srt" \
  --raw-json "100_Todo/drafts/<video-id>/_subtitles/<video-id>.groq.json" \
  --allow-cloud --language auto --traditional

python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/apply_vocab.py" \
  "100_Todo/drafts/<video-id>/_subtitles/<video-id>.raw.srt" \
  --out "100_Todo/drafts/<video-id>/_subtitles/<video-id>.vocab.srt" \
  --vocab "200_Reference/vocabulary.md"

python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/validate_srt.py" \
  --raw "100_Todo/drafts/<video-id>/_subtitles/<video-id>.vocab.srt" \
  --clean "100_Todo/drafts/<video-id>/_subtitles/<video-id>.clean.srt"

python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/mix_audio.py" \
  "100_Todo/drafts/<video-id>/<video-id>.cut.mp4" \
  "100_Todo/drafts/<video-id>/assets/background-music.mp3" \
  --out "100_Todo/drafts/<video-id>/<video-id>.mixed.mp4"
```

## Agent Execution Notes

- Shared steps: all three Agents run the same scripts, folder routes, title
  selection gates, shared tool catalog/validator, subtitle rules, metadata
  templates, and ffprobe checks.
- Codex adapter: use the available terminal and native image tool; Codex sandbox
  permission differences belong in the execution note, not a separate workflow.
- Claude adapter: run the same scripts through the available terminal and use
  the native image tool or approved shared cover route.
- AntiGravity adapter: run the same scripts through the available terminal and
  use the native image tool or approved shared cover route.
- Fallback: if a native image tool is absent, use the authorized shared
  CLI/API/browser route from `image-generator`; STT provider choice remains the
  same explicit privacy/cost decision in every Agent.
- Verification: require the same SRT validation, ffprobe media checks, package
  file list, and user-selected title/short candidate.

## Verification

- `TOOL_EVALUATION.md` contains every shared route ID and passes
  `video-tool-evaluation/scripts/validate_tool_evaluation.py` before smart cut
  or cloud upload.
- `ffmpeg -version` works.
- `ffprobe -version` works.
- `auto-editor --version` reports the maintained shared binary.
- `python-tools-python -c "import groq"` works when using Groq STT.
- `audio-to-md-python -c "import faster_whisper"` works for faster-whisper.
- `whisper-cli` and its local model work for whisper.cpp SRT.
- `sensevoice-cli` and its two local GGUF models work for fast Chinese-focused
  transcripts.
- `macwhisper-cli --help` works when MacWhisper is installed with CLI access.
- FFmpeg reports `subtitles`, `ass`, and `drawtext` filters.
- `GROQ_API_KEY` or `~/.codex/secrets/groq_api_key` exists before cloud STT.
- Run the cross-agent exclusion-word audit before packaging or syncing; the scan
  should have no hits.
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SKILL_MD_0E95F5A366

# video-processing-automation/references/audio-subtitle.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/references/audio-subtitle.md")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/references/audio-subtitle.md" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_AUDIO_SUBTITLE_MD_CBD5910BE8'
# Audio To Subtitle

Use this reference to create clean SRT and TXT transcripts.

## Core Rule

During cleanup, never change:

- SRT block count
- block indexes
- timecode lines
- timecode order

Only subtitle text may be edited.

## Routing Priority

1. Formal transcription uses Groq Whisper first.
2. If Groq is unavailable because the key is missing or invalid, the API,
   network, quota, model, or upload fails, or the source is explicitly
   local-only, fall back immediately to faster-whisper.
3. Use whisper.cpp when the user explicitly asks for a fast preview.
4. MacWhisper is the last Whisper option and its timestamps must be validated.
5. SenseVoice is a supplementary language, emotion, and sound-event check. It
   is not part of the Whisper fallback order and its TXT must not be presented
   as a timed SRT.

Reuse an existing user or project decision that permits Groq uploads. If no
cloud-upload decision exists, confirm once before the first Groq run. Do not
repeatedly retry Groq after a qualifying failure; report the reason and the
engine actually used.

For normal execution, call the shared router instead of manually selecting one
of the adapters below:

```bash
python-tools-python \
  "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_preferred.py" \
  "<audio-or-video>" \
  --out "<subtitle.srt>" \
  --raw-json "<subtitle.groq.json>" \
  --allow-cloud --language auto --traditional
```

The provider-specific sections below are for diagnostics, explicit comparison,
or maintenance only.

## Groq Route

1. Extract audio from the cut video:

```bash
ffmpeg -y -i "100_Todo/drafts/<video-id>/<video-id>.cut.mp4" \
  -vn -ac 1 -ar 16000 "100_Todo/drafts/<video-id>/<video-id>.wav"
```

2. Transcribe:

```bash
mkdir -p "100_Todo/drafts/<video-id>/_subtitles"
python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_groq.py" \
  "100_Todo/drafts/<video-id>/<video-id>.wav" \
  --out "100_Todo/drafts/<video-id>/_subtitles/<video-id>.groq.json" \
  --language zh
```

Use `--language en` for English, or `--language auto` when the source language
is not known. The 2026-07-29 benchmark verified that `auto` handled the fixed
Traditional Chinese, English, and mixed-language samples. Explicit language
remains preferable when it is already known.

3. Resegment:

```bash
python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/resegment.py" \
  "100_Todo/drafts/<video-id>/_subtitles/<video-id>.groq.json" \
  --out "100_Todo/drafts/<video-id>/_subtitles/<video-id>.raw.srt"
```

4. Apply vocabulary:

```bash
python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/apply_vocab.py" \
  "100_Todo/drafts/<video-id>/_subtitles/<video-id>.raw.srt" \
  --out "100_Todo/drafts/<video-id>/_subtitles/<video-id>.vocab.srt" \
  --vocab "200_Reference/vocabulary.md"
```

If the project does not have `200_Reference/vocabulary.md`, omit `--vocab`;
the script will still apply portable built-in replacements.

5. Clean text manually or with Codex, preserving all SRT structure. If Groq
   repeatedly misrecognizes a project term, add the correction to
   `200_Reference/vocabulary.md` before rerunning instead of relying on memory.
6. Validate:

```bash
python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/validate_srt.py" \
  --raw "100_Todo/drafts/<video-id>/_subtitles/<video-id>.vocab.srt" \
  --clean "100_Todo/drafts/<video-id>/_subtitles/<video-id>.clean.srt"
```

7. Convert to TXT:

```bash
python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/srt_to_txt.py" \
  "100_Todo/drafts/<video-id>/_subtitles/<video-id>.clean.srt" \
  --out "100_Todo/drafts/<video-id>/<video-id>.txt"
```

Copy the clean SRT to `100_Todo/drafts/<video-id>/<video-id>.srt`.

## Vocabulary

The bundled `apply_vocab.py` has only generic defaults. For a real project,
extend replacements with:

- channel name
- speaker names
- product names
- recurring technical terms
- common ASR mistakes found in the first transcript

Keep vocabulary mechanical. Do not change meaning.

Project vocabulary file format:

```text
# 200_Reference/vocabulary.md
wrong term=>correct term
wrong term<TAB>correct term
```

Example:

```text
金石學習法=>精實學習法
```

Run `apply_vocab.py` only after `resegment.py` has produced the raw SRT. Do not
start vocabulary replacement in parallel with resegmentation, because the raw
SRT file may not exist yet.

## Local Fallback and Preview Routes

Use faster-whisper when Groq is unavailable or the user requires local-only
processing. Use the other local routes only for their explicit roles below.

### faster-whisper

Reuse the Item 33 `audio-to-md` runtime:

```bash
audio-to-md-python \
  "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_local.py" \
  "100_Todo/drafts/<video-id>/<video-id>.wav" \
  --out "100_Todo/drafts/<video-id>/_subtitles/<video-id>.local.srt"

python-tools-python \
  "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/convert_srt_traditional.py" \
  "100_Todo/drafts/<video-id>/_subtitles/<video-id>.local.srt" \
  --out "100_Todo/drafts/<video-id>/_subtitles/<video-id>.raw.srt"
```

The first `large-v3-turbo` run may download about 1.5 GB; confirm before the
download. The OpenCC adapter changes only recognized text and preserves
indexes, timecodes, and block boundaries. Skip `resegment.py`, then run
`apply_vocab.py`, clean only text, validate, and convert to TXT.

### whisper.cpp CLI

The optional video-tools installer provides `whisper-cli` 1.9.1 and the
`large-v3-turbo-q5_0` model:

```bash
python-tools-python \
  "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_whisper_cli.py" \
  "100_Todo/drafts/<video-id>/<video-id>.wav" \
  --out "100_Todo/drafts/<video-id>/_subtitles/<video-id>.raw.srt" \
  --traditional
```

This is the fast-preview route. It is a local standalone SRT route and does not
use the faster-whisper runtime. It preserves the engine's segments by default.
`--max-chars` is available for previews, but forced character limits can split
a Chinese word across two subtitle blocks, so do not use that output as final
without review.

### SenseVoice

SenseVoice is a fast local choice for Mandarin, Cantonese, English, Japanese,
and Korean, plus emotion/audio-event tags. The current pinned native runtime
does not emit subtitle timestamps, so use it for TXT transcripts or quick
cross-checking, not as the final SRT source:

```bash
python-tools-python \
  "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_sensevoice.py" \
  "100_Todo/drafts/<video-id>/<video-id>.wav" \
  --out "100_Todo/drafts/<video-id>/<video-id>.sensevoice.txt" \
  --traditional
```

### MacWhisper

MacWhisper is the last Whisper option. Arry's installed MacWhisper 14.4.1
exposes a working `mw` CLI. Treat this as an installation-dependent option and
verify it instead of assuming a license tier:

```bash
python-tools-python \
  "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_macwhisper.py" \
  "100_Todo/drafts/<video-id>/<video-id>.wav" \
  --out "100_Todo/drafts/<video-id>/_subtitles/<video-id>.macwhisper.srt" \
  --traditional
```

The 2026-07-28 smoke test found a timestamp gap in MacWhisper's SRT, so always
run `validate_srt.py` and compare segment timing before promoting it to final.

For a plain-language comparison of Whisper, CLI, MacWhisper, and SenseVoice,
plus the measured M2 smoke comparison, read `stt-route-guide.md`.

---

## 🎬 Subtitle Burning (硬燒錄中文字幕)

優先使用共用 `ffmpeg-full`，它包含 `subtitles`、`ass` 與 `drawtext`：

```bash
python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/burn_subtitles_ffmpeg.py" \
  "100_Todo/drafts/<video-id>/<video-id>.cut.mp4" \
  "100_Todo/drafts/<video-id>/<video-id>.srt" \
  --out "100_Todo/projects/<video-id>/<chosen-title>.mp4"
```

這條路徑使用 libass 並保留原始畫面尺寸，不做裁切。只有在其他平台的
`ffmpeg` 仍缺少這些濾鏡時，才使用 OpenCV + Pillow 跨平台 fallback。

### 依賴安裝
```bash
python3 -m pip install opencv-python pillow --break-system-packages
```

### OpenCV Fallback 執行燒錄
```bash
python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/burn_subtitles.py" \
  "100_Todo/drafts/<video-id>/<video-id>.cut.mp4" \
  "100_Todo/drafts/<video-id>/<video-id>.srt" \
  "100_Todo/projects/<video-id>/<chosen-title>.mp4"
```

### 設計細節與自訂
- **字型**：預設會優先讀取 macOS 系統的蘋方字型 (`PingFang.ttc`)，若在 Windows 或 Linux 上會自動 fallback 到 Arial 或是 Pillow 的預設字型。
- **樣式**：在影片底部 12% 高度處，以 75% 不透明度的深灰色背景圓角卡片包覆暖白色文字，以確保不論背景明暗皆具備極高的可讀性。
- **音軌保留**：腳本會自動將原影片的音軌以 `copy` 模式無損打包回最終輸出檔，畫質與音軌均保持一致。
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_AUDIO_SUBTITLE_MD_CBD5910BE8

# video-processing-automation/references/cover-style.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/references/cover-style.md")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/references/cover-style.md" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_COVER_STYLE_MD_4DE92A2DF6'
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
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_COVER_STYLE_MD_4DE92A2DF6

# video-processing-automation/references/metadata-template.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/references/metadata-template.md")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/references/metadata-template.md" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_METADATA_TEMPLATE_MD_645E6628C2'
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
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_METADATA_TEMPLATE_MD_645E6628C2

# video-processing-automation/references/optional-tools.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/references/optional-tools.md")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/references/optional-tools.md" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_OPTIONAL_TOOLS_MD_8D7A91A409'
# Optional Processing Tools

These routes add choices to an existing-video workflow. They do not create a
vertical mode, crop the source, or change its aspect ratio.

## Background Music And Ducking

Use the bundled FFmpeg adapter to loop background music, lower it under speech,
and normalize the final mix:

```bash
python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/mix_audio.py" \
  "100_Todo/drafts/<video-id>/<video-id>.cut.mp4" \
  "100_Todo/drafts/<video-id>/assets/background-music.mp3" \
  --out "100_Todo/drafts/<video-id>/<video-id>.mixed.mp4"
```

The default music level is `0.16`. Add `--no-duck` only when speech ducking is
not wanted. The video stream is copied without scaling, reframing, or cropping.

## Speech-To-Text Routes

| Route | Output | Cost/privacy | Best use |
|---|---|---|---|
| Groq Whisper | JSON with word + segment timestamps | Cloud; API quota/cost; uploads audio | Default formal route after upload consent |
| faster-whisper | SRT | Local; Item 33 runtime | First fallback when Groq is unavailable or local-only |
| whisper.cpp `whisper-cli` | SRT | Local; standalone q5 model | Explicit fast Apple Silicon preview |
| SenseVoice | TXT + optional rich tags | Local; native q8 model | Chinese/Cantonese cross-check, emotion, and audio events |
| MacWhisper 14.4.1 | SRT + manual exports | Local; installed build/license | Last Whisper option and GUI/manual review |

Use the shared router for normal work so a lower-level example cannot invert
the preference:

```bash
python-tools-python \
  "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_preferred.py" \
  "100_Todo/drafts/<video-id>/<video-id>.wav" \
  --out "100_Todo/drafts/<video-id>/_subtitles/<video-id>.raw.srt" \
  --raw-json "100_Todo/drafts/<video-id>/_subtitles/<video-id>.groq.json" \
  --allow-cloud --language auto --traditional
```

The router attempts Groq first, falls back to faster-whisper, and uses
MacWhisper only if both formal engines fail. Pass `--engine faster-whisper`
for approved local-only material. The default local model is about 1.5 GB and
may download on first use; confirm that download before starting it.

For the standalone whisper.cpp route:

```bash
python-tools-python \
  "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_preferred.py" \
  "100_Todo/drafts/<video-id>/<video-id>.wav" \
  --out "100_Todo/drafts/<video-id>/_subtitles/<video-id>.raw.srt" \
  --engine whisper.cpp --language auto --traditional
```

For a fast SenseVoice TXT cross-check:

```bash
python-tools-python \
  "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_sensevoice.py" \
  "100_Todo/drafts/<video-id>/<video-id>.wav" \
  --out "100_Todo/drafts/<video-id>/<video-id>.sensevoice.txt" \
  --traditional
```

Read `stt-route-guide.md` before treating these names as independent models:
CLI means a command-line interface, faster-whisper and whisper.cpp are two
engines for Whisper, and SenseVoice is a separate speech-understanding model.

For the installed MacWhisper CLI route:

```bash
python-tools-python \
  "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_macwhisper.py" \
  "100_Todo/drafts/<video-id>/<video-id>.wav" \
  --out "100_Todo/drafts/<video-id>/_subtitles/<video-id>.macwhisper.srt" \
  --traditional
```

## Title Cards, Voiceover, And Stock Media

The reusable adapters live in `video-creation-automation`:

- `make_title_card.py`: local ImageMagick title card.
- `voice-reply`: ask female/male, then use the selected conditional route.
- `elevenlabs_tts.py`: legacy direct adapter, allowed only as an explicit
  female-route diagnostic; never use it for male narration or as the normal
  entrypoint.
- `pexels_media.py`: free Pexels API photo/video search and source download;
  the free key has usage limits.

Existing-video projects may call those adapters to prepare assets under
`100_Todo/drafts/<video-id>/assets/`. Inserting title cards or B-roll into a
timeline is a composition decision; use HyperFrames or another approved editor
and preserve the source framing unless the user asks for a change.

Before narration, ask female or male unless already specified:

```bash
voice-reply --voice-gender female --file narration.txt --out narration.mp3
voice-reply --voice-gender male --file narration.txt --out narration.mp3
```

Female uses Anna Su → HsiaoChen → macOS `say`; male skips ElevenLabs and uses
YunJhe → macOS `say`.
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_OPTIONAL_TOOLS_MD_8D7A91A409

# video-processing-automation/references/setup.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/references/setup.md")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/references/setup.md" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SETUP_MD_1E0E7D7B42'
# Setup And Environment

## Required Tools

| Tool | Purpose | Check |
|---|---|---|
| Shared Python 3.12 | Run cloud/provider adapters | `python-tools-python --version` |
| ffmpeg / ffprobe | Audio/video processing | `ffmpeg -version` |
| auto-editor 31.4.0+ | Silence removal | `auto-editor --version` |
| Groq Python SDK or API access | Cloud Whisper STT | `python-tools-python -c "import groq"` |
| First fallback faster-whisper | Local-only final SRT through the audio-to-md runtime | `audio-to-md-python -c "import faster_whisper"` |
| whisper.cpp CLI | Fast local preview SRT with a standalone q5 model | `whisper-cli --help` |
| SenseVoice | Chinese/Cantonese cross-check, emotion, and audio tags | `sensevoice-cli --help` |
| MacWhisper | Optional local GUI/CLI comparison; entitlement depends on installed build/license | `macwhisper-cli --help` |
| ImageMagick | Optional local title cards | `magick -version` |
| voice-reply | Gender-gated TTS; Anna/HsiaoChen for female, YunJhe for male | `voice-reply --help` |
| ElevenLabs Python SDK | Legacy female-route diagnostic adapter only | `python-tools-python -c "import elevenlabs"` |

Install or repair the shared tools with LazyPack Item 34. Run
`scripts/install_optional_video_tools.sh` for FFmpeg Full, ImageMagick,
whisper.cpp, SenseVoice, and optional MacWhisper. Install the `audio-to-md`
runtime with Item 33 when faster-whisper is needed. Do not create a
project-local venv for these shared tools.

## Codex Sandbox Notes

macOS Python may write bytecode caches under
`~/Library/Caches/com.apple.python` during syntax checks such as
`python3 -m py_compile`. If Codex reports `Operation not permitted` for that
path, add this narrow writable root to the Codex sandbox config and open a new
Codex conversation:

```toml
"{{HOME}}/Library/Caches/com.apple.python",
```

For one-off verification before the new sandbox config is loaded, use a temp
cache path such as `PYTHONPYCACHEPREFIX=/private/tmp/python-pycache`.

## Groq API Key

Cloud transcription uses Groq Whisper. Accept either:

- environment variable: `GROQ_API_KEY`
- local key file: `~/.codex/secrets/groq_api_key`

Do not commit either value.

Formal transcription is Groq-first after the user/project has accepted cloud
upload. If the key is missing/invalid or the API, network, quota, model, or
upload fails, immediately use faster-whisper. Use whisper.cpp for an explicitly
requested fast preview and keep MacWhisper last. Do not download a missing local
model during fallback without confirming the download size.

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
├── 100_Todo/
│   ├── drafts/<video-id>/     # raw copy, working files, subtitles, transcripts
│   └── projects/<video-id>/   # final package and publishable exports
└── 200_Reference/
    └── vocabulary.md
```

The layout is recommended, not mandatory. Work with the user's existing project
structure when it already exists. In initialized four-box projects, do not
create project-root `working/`, `output/`, or `assets/` folders; use
`100_Todo/drafts/<video-id>/` for working files and
`100_Todo/projects/<video-id>/` for final packages.

## Environment Checks

```bash
python-tools-python --version
python-tools-python "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_preferred.py" --help
ffmpeg -version
ffprobe -version
auto-editor --version
magick -version
python-tools-python -c "import groq, elevenlabs; print('cloud adapters ok')"
audio-to-md-python -c "import faster_whisper; print('local whisper ok')"  # optional Item 33 route
whisper-cli --help
sensevoice-cli --help
macwhisper-cli --help
ffmpeg -hide_banner -filters | grep -E 'subtitles|drawtext'
python3 -c "import os, pathlib; p=pathlib.Path('~/.codex/secrets/groq_api_key').expanduser(); print('Groq key:', 'ok' if os.getenv('GROQ_API_KEY') or p.exists() else 'missing')"
```

The shared Auto-Editor wrapper uses the official standalone release rather than
the lagging PyPI build. If an older user-level `auto-editor` also exists, source
the Item 16 loader so the shared command directory stays first in `PATH`.

## Reproducible Repo Checklist

For a project that should be downloadable and runnable by another person:

- Keep reusable project vocabulary in `200_Reference/vocabulary.md`, one
  replacement per line, formatted as `wrong=>right` or `wrong<TAB>right`.
- Keep raw or normalized source video in the draft folder. If the original
  `.mov` is not stored, document that the reproducible source starts from the
  retained CFR file such as `input_cfr.mp4`.
- Keep final media ignored by Git unless the repo intentionally versions small
  media outputs. Text artifacts such as SRT/TXT/metadata can be committed when
  they are useful for reproducibility.
- Verify regenerated outputs with `ffprobe` for both video and audio streams
  before considering the package complete.
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SETUP_MD_1E0E7D7B42

# video-processing-automation/references/short-video.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/references/short-video.md")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/references/short-video.md" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SHORT_VIDEO_MD_D964795228'
# Short Highlight Video

Use this reference after a long video already has:

- `100_Todo/drafts/<video-id>/<video-id>.cut.mp4`
- `100_Todo/drafts/<video-id>/<video-id>.srt`

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

Write `100_Todo/drafts/<video-id>/shorts-candidates.md` and pause for the user to choose
A/B/C, ask for new candidates, or provide direct timecodes.

## Cutting

```bash
python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/clip_cut.py" \
  --input-mp4 "100_Todo/drafts/<video-id>/<video-id>.cut.mp4" \
  --input-srt "100_Todo/drafts/<video-id>/<video-id>.srt" \
  --segments "00:00:08.500-00:00:13.200,00:00:45.100-00:01:30.800" \
  --out-dir "100_Todo/drafts/<video-id>/short-tmp/"
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
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SHORT_VIDEO_MD_D964795228

# video-processing-automation/references/smart-cut.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/references/smart-cut.md")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/references/smart-cut.md" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SMART_CUT_MD_CF9770A7B5'
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
   ffmpeg -y -i "raw/input.mov" -map 0:v -map 0:a -r 30 -vsync cfr "100_Todo/drafts/<video-id>/input_cfr.mp4"
   ```
2. **串流順序問題 (Stream Ordering)**：
   `auto-editor` 預設要求影片的 **Stream 0 為 Video，Stream 1 為 Audio**。若影片為音訊在前的非標準格式，裁剪後會輸出沒有影像的損壞檔案。
   上述 CFR 轉檔指令中的 `-map 0:v -map 0:a` 會自動將 Video 映射至 Stream 0、Audio 映射至 Stream 1，可一併解決此問題。

## Default Command

```bash
# 1. 轉 CFR 固定影格率 (30fps)
ffmpeg -y -i "raw/<video-id>/input.mp4" -map 0:v -map 0:a -r 30 -vsync cfr "100_Todo/drafts/<video-id>/input_cfr.mp4"

# 2. 進行智慧裁剪（共用 Auto-Editor 31.4.0+；--no-open 避免彈出播放器）
python3 "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/smart_cut.py" \
  "100_Todo/drafts/<video-id>/input_cfr.mp4" \
  --out "100_Todo/drafts/<video-id>/<video-id>.cut.mp4"
```

When the only retained source is already normalized CFR, for example
`100_Todo/drafts/<video-id>/input_cfr.mp4`, reuse that file as the smart-cut
input instead of looking for the original `.mov`. Record this in the project
cockpit so future runs know the reproducible starting point.

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
- Confirm `auto-editor --version` resolves to the shared maintained release,
  not an older user-level Python installation.
- Confirm the output duration is shorter but still natural.
- Confirm the output still has both video and audio streams:
  `ffprobe -v error -show_entries stream=codec_type,codec_name,width,height,duration <file>`.
- Listen to the first 20-30 seconds before continuing to transcription when the
  source is noisy or has music.
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SMART_CUT_MD_CF9770A7B5

# video-processing-automation/references/source-adaptation.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/references/source-adaptation.md")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/references/source-adaptation.md" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40'
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
- The skill uses `{{SYNC_ROOT}}/skills` as the shared source, with native Codex, Claude, and AntiGravity entrypoints managed by Item 16.
- Cover images default to Codex image generation or user-supplied assets.
- Project-specific vocabulary, persona references, and brand guides are treated
  as project inputs instead of global defaults.
- Cloud transcription must be confirmed when privacy matters.
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40

# video-processing-automation/references/stt-route-guide.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/references/stt-route-guide.md")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/references/stt-route-guide.md" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_STT_ROUTE_GUIDE_MD_34B007D358'
# 語音轉文字路線說明

## 先釐清名稱

- **Whisper** 是 OpenAI 發布的語音辨識模型家族。
- **CLI** 是 command-line interface，意思是從終端機下指令；它不是另一個
  語音模型。
- 官方 Python **openai-whisper** 來自 OpenAI 的 `openai/whisper`；
  **faster-whisper** 來自 SYSTRAN 的 `SYSTRAN/faster-whisper`；
  **whisper.cpp** 來自 `ggml-org/whisper.cpp`。後兩者都是在本機執行
  Whisper 模型的替代引擎，可使用同系列模型，但程式、模型格式、速度與
  記憶體需求不同。
- **MacWhisper** 是包裝 Whisper 的 macOS 應用程式；Arry 目前安裝的
  14.4.1 已實測可使用內建 `mw` CLI，但不同版本或授權需先跑 `mw --help`
  驗證，不由工作流猜測。
- **SenseVoice** 不是 Whisper。它是另一套語音理解模型，除了轉文字，也能
  判斷語言、情緒，以及音樂、笑聲、掌聲、咳嗽等聲音事件。
- **Groq Whisper** 是 Groq 雲端 API 執行的 Whisper，不是 xAI 的 Grok。

## 本工作流的保留路線

| 路線 | 主要輸出 | 優勢 | 限制 | 定位 |
| --- | --- | --- | --- | --- |
| Groq Whisper | JSON／SRT pipeline | 雲端速度快，可取得 word + segment timestamps | 音訊會上傳且受 API 價格／額度影響 | 正式轉錄第一順位 |
| faster-whisper `large-v3-turbo` | SRT | 分段與時間碼適合正式字幕；沿用既有 audio-to-md runtime | 在 Apple M2 CPU 上較慢 | Groq 無法使用時的第一備援 |
| whisper.cpp `large-v3-turbo-q5_0` | SRT | Apple Silicon Metal 加速、啟動快、模型較小 | q5 量化可能有輕微精度損失 | 明確要求快速預覽時使用 |
| SenseVoice Small q8 | TXT + 語言／情緒／事件標籤 | 中文、粵語快，能做 Whisper 沒有的語音理解 | 目前 pinned native runtime 沒有可用的 SRT 時間碼 | 中文校對與內容分析 |
| MacWhisper 14.4.1 | SRT／多種匯出 | GUI 與目前可用的 `mw` CLI | 授權依安裝狀態；本次時間碼需額外驗證 | Whisper 路線最後選項 |

官方 Python `openai-whisper` 經 2026-07-29 實裝與同場測試後沒有保留。
CPU 版與 faster-whisper 在三段測試音訊的文字幾乎相同，但轉錄明顯更慢；
MPS 版另有逐字時間碼失敗、英文空白與混合語言退化問題。它還會增加約
492 MiB PyTorch runtime 與另一份 1.507 GiB 模型，因此由 faster-whisper
取代，不列入正式或備援路線。

## 2026-07-29 官方版替代性實測

測試環境為 MacBook Air M2、8 GB。固定使用三段 macOS `say` 產生的清晰
語音：繁中 11.35 秒、英文 11.40 秒、中英混合 12.56 秒。除自動語言測試
外，正式準確率比較固定繁中／英文語言碼；全部 Whisper 路線使用
`large-v3-turbo` 系列，whisper.cpp 使用 q5_0 量化。繁中先以 OpenCC
轉為台灣繁體再算 CER；英文算 WER；混合語言另檢查五組英文專有詞。

| 路線 | 繁中 CER／耗時 | 英文 WER／耗時 | 混合 CER／英文詞／耗時 | 本機模型大小 |
| --- | ---: | ---: | ---: | ---: |
| Groq `whisper-large-v3-turbo` | 0%／0.93 秒 | 0%／0.68 秒 | 16.2%／80%／0.90 秒 | 0 |
| whisper.cpp 1.9.1 q5_0 | 0%／3.43 秒 | 0%／2.39 秒 | 16.2%／80%／2.49 秒 | 0.535 GiB |
| MacWhisper 14.4.1 WhisperKit large-v3 | 0%／7.54 秒 | 0%／2.11 秒 | 16.2%／80%／2.27 秒 | 1.511 GiB |
| faster-whisper 1.2.1 CPU int8 | 0%／7.27 秒 | 0%／6.82 秒 | 16.2%／80%／7.07 秒 | 1.507 GiB |
| OpenAI 20250625 CPU | 0%／48.31 秒 | 0%／15.90 秒 | 16.2%／80%／21.51 秒 | 1.507 GiB |
| OpenAI 20250625 MPS | 0%／72.50 秒 | 100%／61.55 秒 | 113.2%／0%／77.41 秒 | 1.507 GiB |

完整跑完三段的牆鐘時間（含每次程式啟動與一次模型載入）為：Groq
2.61 秒、whisper.cpp 8.36 秒、MacWhisper 11.96 秒、faster-whisper
25.10 秒、官方 CPU 112.81 秒、官方 MPS 330.41 秒。官方模型首次
下載加載入為 61.88 秒，檔案 1,617,941,637 bytes，SHA-256
`aff26ae408abcba5fbf8813c21e62b0941638c5f6eebfb145be0c9839262a19a`，
與官方下載 URL 內的雜湊一致。

這組乾淨語料中，五條可用 Whisper 路線的文字結果實際上幾乎相同：

- 純繁中經繁體轉換後全對，但所有 Whisper 原始輸出都是簡體，不能省略
  OpenCC 或人工校對。
- 純英文全對。
- 混合語言共同把 `OpenAI Whisper` 聽成 `OpenEye Whisper`，並把中文
  日期轉成阿拉伯數字；五組英文詞命中四組。
- MacWhisper 的混合語言 SRT 再次出現 2.18 秒可疑空隙，內容正確不代表
  時間碼可直接交付。

自動語言判斷也以同一組音訊驗證：

- 官方 CPU：繁中判為 `zh` 99.83%，英文判為 `en` 99.97%；但模型載入
  26.39 秒，兩次判斷另花 9.52／3.17 秒。
- faster-whisper：繁中判為 `zh` 99.85%，英文判為 `en` 99.97%；載入
  2.88 秒，兩次判斷花 5.60／6.00 秒。
- whisper.cpp：`auto` 判繁中為 `zh` 99.85%、英文為 `en` 99.98%，
  且文字維持同樣準確。
- MacWhisper 與 Groq 的 `auto` 模式在三段音訊都轉錄正確；目前 adapter
  不把語言信心值寫入結果。

模型與本機占用補充：

- faster-whisper 模型 1,617,884,929 bytes（1.507 GiB）；既有共享
  `audio-to-md` venv 共約 231 MiB。
- whisper.cpp q5_0 模型 574,041,195 bytes（0.535 GiB）；Homebrew
  `whisper-cpp` 1.9.1 formula 約 8.2 MiB。
- MacWhisper WhisperKit 模型 1,622,295,995 bytes（1.511 GiB）；
  MacWhisper app 約 135 MiB。
- SenseVoice q8 模型 254,208,320 bytes（242.4 MiB），但它不是 Whisper，
  也不參與上表的 SRT 準確率排名。
- Groq 模型在雲端，本機模型占用為 0；代價是上傳音訊與 API 額度／費用。

本次的 CER／WER 是固定乾淨合成語料結果，不是對所有真人口音、噪音、
多人重疊或專有名詞的保證。正式選型仍應再取一段 Arry 的真人素材做回歸測試。

## 2026-07-28 本機 smoke comparison

測試環境為 MacBook Air M2、8 GB；輸入是 macOS `say` 產生的 20.7 秒
台灣中文清晰語音。結果只用來驗證本機執行特性，不代表所有真人、環境噪音與
專有名詞的通用準確率：

| 路線 | 耗時 | 觀察 |
| --- | ---: | --- |
| Groq Whisper API | 1.09 秒 | 繁中完整，2 個原始段落、69 個 word timestamps；既有 `resegment.py` 產出 6 段合理 SRT；音訊會上傳 |
| SenseVoice | 2.09 秒 | 中文與標點完整，並輸出 `zh`、`NEUTRAL`、`Speech` 標籤；沒有字幕時間碼 |
| whisper.cpp | 4.32–4.52 秒 | 內容正確；強制 28 字切段會拆開中文字詞，故預設保留原始長段，只作預覽 |
| MacWhisper 14.4.1 | 冷啟動 37.80 秒；暖啟動 4.54–5.22 秒 | 內容正確但原始輸出為簡中，且本次第二段開始時間多出約 4 秒，正式使用前要驗證 |
| faster-whisper | 11.63–12.74 秒 | 內容正確，原生產生兩個合理時間段，最適合正式 SRT |

同一 Whisper 模型系列的準確率主要受模型大小、量化、音訊品質與解碼參數
影響，不應只用引擎名稱判斷。真正要回答「Arry 的影片哪一個最好」，應取一段
有台灣口音、英文專有名詞與現場噪音的真人素材，建立人工校正稿，再比較錯字、
漏字、專有名詞、時間碼與耗時。

## 選擇規則

1. 正式轉錄一律先用 Groq Whisper；既有使用者／專案雲端上傳同意可沿用，
   沒有既有決定時只確認一次。
2. Groq 因缺少或無效 key、API／網路／額度／模型／上傳失敗而無法使用，
   或素材明確要求 local-only 時，立即改用 faster-whisper，再用
   `convert_srt_traditional.py` 轉繁中；不要反覆重試 Groq。
3. 明確要求快速預覽時使用 whisper.cpp；它不是正式轉錄失敗後取代
   faster-whisper 的一般路線。
4. 要中文／粵語交叉校對、情緒或聲音事件時另跑 SenseVoice；它是補充分析，
   不在 Whisper 優先序內，也不要把其 TXT 冒充 SRT。
5. MacWhisper 是 Whisper 路線的最後選項。使用前驗證本機 `mw --help`，
   輸出仍須做繁中轉換與時間碼驗證。
6. 每次交付都記錄實際引擎；若發生 fallback，同時記錄 Groq 失敗原因。
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_REFERENCES_STT_ROUTE_GUIDE_MD_34B007D358

# video-processing-automation/scripts/apply_vocab.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/apply_vocab.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/apply_vocab.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_APPLY_VOCAB_PY_5FD98DDBE6'
#!/usr/bin/env python3
"""對 SRT 做機械式詞彙替換（只動文字行，時間碼與段號原封不動）。

替換清單包含可攜式預設值，也可讀取專案詞彙表。
用法：
  python3 apply_vocab.py <in.srt> --out <out.srt>
  python3 apply_vocab.py <in.srt> --out <out.srt> --vocab 200_Reference/vocabulary.md
"""
import argparse
import re
import sys
from pathlib import Path

# 順序重要：先替換長詞，避免短詞先吃掉。
# 這份清單是可攜式預設值；專案若有頻道名、人名、產品名，請依該專案另行擴充。
DEFAULT_REPLACEMENTS = [
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


def load_project_replacements(vocab_path: Path | None, src: Path) -> list[tuple[str, str]]:
    candidates: list[Path] = []
    if vocab_path is not None:
        candidates.append(vocab_path)
    else:
        candidates.append(Path("200_Reference/vocabulary.md"))
        candidates.append(src.parent / "vocabulary.md")

    replacements: list[tuple[str, str]] = []
    for candidate in candidates:
        if not candidate.exists():
            continue
        for raw_line in candidate.read_text(encoding="utf-8-sig").splitlines():
            line = raw_line.strip()
            if not line or line.startswith("#"):
                continue
            if "=>" in line:
                old, new = line.split("=>", 1)
            elif "\t" in line:
                old, new = line.split("\t", 1)
            else:
                continue
            old = old.strip()
            new = new.strip()
            if old and new:
                replacements.append((old, new))
    return replacements


def apply(text: str, replacements: list[tuple[str, str]]) -> str:
    for old, new in replacements:
        text = text.replace(old, new)
    return text


def process_srt(src: Path, dst: Path, vocab_path: Path | None = None) -> None:
    replacements = load_project_replacements(vocab_path, src) + DEFAULT_REPLACEMENTS
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
        body_after = apply(body_before, replacements)
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
    ap.add_argument("--vocab", type=Path, default=None, help="專案詞彙表，格式為 old=>new 或 old<TAB>new")
    args = ap.parse_args()
    process_srt(args.src, args.out, args.vocab)
    return 0


if __name__ == "__main__":
    sys.exit(main())
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_APPLY_VOCAB_PY_5FD98DDBE6
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/apply_vocab.py"

# video-processing-automation/scripts/burn_subtitles.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/burn_subtitles.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/burn_subtitles.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_BURN_SUBTITLES_PY_6ECF6BA5FF'
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
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_BURN_SUBTITLES_PY_6ECF6BA5FF
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/burn_subtitles.py"

# video-processing-automation/scripts/burn_subtitles_ffmpeg.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/burn_subtitles_ffmpeg.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/burn_subtitles_ffmpeg.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_BURN_SUBTITLES_FFMPEG_PY_7FBD172C8C'
#!/usr/bin/env python3
"""Burn SRT subtitles with the shared FFmpeg Full/libass build."""

from __future__ import annotations

import argparse
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


def ffmpeg_command() -> str | None:
    candidates = (
        Path.home() / ".codex" / "python-tools" / "bin" / "ffmpeg",
        Path("/opt/homebrew/opt/ffmpeg-full/bin/ffmpeg"),
    )
    for candidate in candidates:
        if candidate.is_file():
            return str(candidate)
    return shutil.which("ffmpeg")


def supports_subtitles(ffmpeg: str) -> bool:
    completed = subprocess.run(
        [ffmpeg, "-hide_banner", "-filters"],
        check=False,
        capture_output=True,
        text=True,
    )
    return any(
        line.split()[1:2] == ["subtitles"]
        for line in completed.stdout.splitlines()
        if line.strip()
    )


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Burn SRT with FFmpeg Full while preserving source dimensions."
    )
    parser.add_argument("video", type=Path)
    parser.add_argument("srt", type=Path)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--font-name", default="PingFang TC")
    parser.add_argument("--font-size", type=int, default=20)
    parser.add_argument("--margin-v", type=int, default=42)
    parser.add_argument("--crf", type=int, default=18)
    parser.add_argument("--preset", default="medium")
    args = parser.parse_args()

    ffmpeg = ffmpeg_command()
    if not ffmpeg:
        print("ffmpeg is unavailable.", file=sys.stderr)
        return 2
    if not supports_subtitles(ffmpeg):
        print(
            "This ffmpeg build lacks the subtitles filter. Run install_optional_video_tools.sh.",
            file=sys.stderr,
        )
        return 2
    for path in (args.video, args.srt):
        if not path.is_file():
            print(f"Input file does not exist: {path}", file=sys.stderr)
            return 2

    args.out.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="subtitle-burn-") as temp_dir:
        subtitle = Path(temp_dir) / "subtitles.srt"
        shutil.copy2(args.srt, subtitle)
        style = (
            f"FontName={args.font_name},FontSize={args.font_size},"
            "PrimaryColour=&H00F9FAFB,OutlineColour=&H80000000,"
            f"BorderStyle=1,Outline=2,Shadow=0,MarginV={args.margin_v},Alignment=2"
        )
        video_filter = f"subtitles={subtitle}:force_style='{style}'"
        command = [
            ffmpeg,
            "-y",
            "-i",
            str(args.video),
            "-vf",
            video_filter,
            "-map",
            "0:v:0",
            "-map",
            "0:a?",
            "-c:v",
            "libx264",
            "-crf",
            str(args.crf),
            "-preset",
            args.preset,
            "-c:a",
            "copy",
            "-movflags",
            "+faststart",
            str(args.out),
        ]
        completed = subprocess.run(command, check=False)
    if completed.returncode:
        return completed.returncode
    print(f"Wrote FFmpeg/libass subtitle burn without cropping: {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_BURN_SUBTITLES_FFMPEG_PY_7FBD172C8C
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/burn_subtitles_ffmpeg.py"

# video-processing-automation/scripts/clip_cut.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/clip_cut.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/clip_cut.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_CLIP_CUT_PY_337F3C1870'
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
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_CLIP_CUT_PY_337F3C1870
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/clip_cut.py"

# video-processing-automation/scripts/convert_json_traditional.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/convert_json_traditional.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/convert_json_traditional.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_CONVERT_JSON_TRADITIONAL_PY_93EFF4494C'
#!/usr/bin/env python3
"""Convert transcript text fields in Whisper-compatible JSON to Traditional Chinese."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

try:
    from opencc import OpenCC
except ImportError as exc:
    raise SystemExit(
        "OpenCC is unavailable. Reinstall LazyPack Item 34 and run with "
        "python-tools-python."
    ) from exc


TEXT_KEYS = {"text", "word"}


def convert_value(value: object, converter: OpenCC) -> object:
    if isinstance(value, dict):
        return {
            key: (
                converter.convert(item)
                if key in TEXT_KEYS and isinstance(item, str)
                else convert_value(item, converter)
            )
            for key, item in value.items()
        }
    if isinstance(value, list):
        return [convert_value(item, converter) for item in value]
    return value


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Convert Whisper/OpenAI-compatible transcript JSON text fields to "
            "Traditional Chinese without changing timestamps."
        )
    )
    parser.add_argument("input", type=Path)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--config", default="s2twp")
    args = parser.parse_args()

    if not args.input.is_file():
        print(f"Input transcript JSON does not exist: {args.input}", file=sys.stderr)
        return 2

    source = json.loads(args.input.read_text(encoding="utf-8"))
    converted = convert_value(source, OpenCC(args.config))
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(
        json.dumps(converted, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Converted transcript JSON to Traditional Chinese: {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_CONVERT_JSON_TRADITIONAL_PY_93EFF4494C
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/convert_json_traditional.py"

# video-processing-automation/scripts/convert_srt_traditional.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/convert_srt_traditional.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/convert_srt_traditional.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_CONVERT_SRT_TRADITIONAL_PY_14C99C9682'
#!/usr/bin/env python3
"""Convert only SRT subtitle text to Traditional Chinese with OpenCC."""

from __future__ import annotations

import argparse
from pathlib import Path
import re
import sys

try:
    from opencc import OpenCC
except ImportError as exc:
    raise SystemExit(
        "OpenCC is unavailable. Reinstall LazyPack Item 34 and run with python-tools-python."
    ) from exc


INDEX_LINE = re.compile(r"^\d+$")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Convert SRT text to Traditional Chinese without changing indexes or timecodes."
    )
    parser.add_argument("input", type=Path)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--config", default="s2twp")
    args = parser.parse_args()

    if not args.input.is_file():
        print(f"Input SRT does not exist: {args.input}", file=sys.stderr)
        return 2

    converter = OpenCC(args.config)
    source_lines = args.input.read_text(encoding="utf-8-sig").splitlines()
    converted_lines = []
    changed = 0
    for line in source_lines:
        if not line or INDEX_LINE.fullmatch(line) or "-->" in line:
            converted_lines.append(line)
            continue
        converted = converter.convert(line)
        converted_lines.append(converted)
        changed += converted != line

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text("\n".join(converted_lines) + "\n", encoding="utf-8")
    print(f"Converted {changed} subtitle line(s) to Traditional Chinese: {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_CONVERT_SRT_TRADITIONAL_PY_14C99C9682
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/convert_srt_traditional.py"

# video-processing-automation/scripts/install_optional_video_tools.sh
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/install_optional_video_tools.sh")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/install_optional_video_tools.sh" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_INSTALL_OPTIONAL_VIDEO_TOOLS_SH_D4398C6F8B'
#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PYTHON_TOOLS_HOME="${PYTHON_TOOLS_HOME:-$CODEX_HOME/python-tools}"
SENSEVOICE_HOME="${SENSEVOICE_HOME:-$CODEX_HOME/sensevoice}"
WHISPER_CPP_HOME="${WHISPER_CPP_HOME:-$CODEX_HOME/whisper-cpp}"
INSTALL_MACWHISPER="${INSTALL_MACWHISPER:-1}"
FORCE_MACWHISPER_UPDATE="${FORCE_MACWHISPER_UPDATE:-0}"
SENSEVOICE_RELEASE="runtime-llamacpp-v0.1.9"
WHISPER_MODEL_NAME="ggml-large-v3-turbo-q5_0.bin"

log() {
  printf '[video-tools] %s\n' "$*"
}

sha256_check() {
  expected="$1"
  file="$2"
  if command -v shasum >/dev/null 2>&1; then
    printf '%s  %s\n' "$expected" "$file" | shasum -a 256 -c -
  elif command -v sha256sum >/dev/null 2>&1; then
    printf '%s  %s\n' "$expected" "$file" | sha256sum -c -
  else
    echo "A SHA-256 tool is required." >&2
    exit 1
  fi
}

download_with_resume() {
  url="$1"
  target="$2"
  mkdir -p "$(dirname "$target")"
  expected_size="$(
    curl --http1.1 -fsIL "$url" \
      | tr -d '\r' \
      | awk 'tolower($1) == "content-length:" { size=$2 } END { print size }'
  )"
  if [ -n "$expected_size" ] && [ -f "$target" ]; then
    actual_size="$(wc -c < "$target" | tr -d ' ')"
    if [ "$actual_size" = "$expected_size" ]; then
      log "download already complete: $target"
      return
    fi
    if [ "$actual_size" -gt "$expected_size" ]; then
      rm "$target"
    fi
  fi
  curl --http1.1 -fL -C - --retry 5 --retry-delay 2 "$url" -o "$target"
}

install_macos_tools() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required on macOS." >&2
    exit 1
  fi
  brew install ffmpeg-full imagemagick
  if [ "$INSTALL_MACWHISPER" = "1" ]; then
    if brew list --cask macwhisper >/dev/null 2>&1; then
      brew upgrade --cask macwhisper || true
    elif [ -d /Applications/MacWhisper.app ] && [ "$FORCE_MACWHISPER_UPDATE" != "1" ]; then
      log "MacWhisper exists outside Homebrew; set FORCE_MACWHISPER_UPDATE=1 to replace it."
    else
      if [ "$FORCE_MACWHISPER_UPDATE" = "1" ]; then
        brew install --cask --force macwhisper
      else
        brew install --cask macwhisper
      fi
    fi
  fi
}

install_sensevoice() {
  os="$(uname -s)"
  arch="$(uname -m)"
  case "$os/$arch" in
    Darwin/arm64)
      asset="funasr-llamacpp-macos-arm64.tar.gz"
      digest="2d5786784ad09d8f4def1d942f678728638fe601d00acf0dad7cf094a9328363"
      ;;
    Linux/aarch64|Linux/arm64)
      asset="funasr-llamacpp-linux-arm64.tar.gz"
      digest="521866e75594e56eb5023b65eb1ecf6ab7c3b5069522b71cd33aa37b8406ed4b"
      ;;
    Linux/x86_64)
      asset="funasr-llamacpp-linux-x64-avx2.tar.gz"
      digest="51f33822a5191f7963d8ceedba2dd76fe7d810a4388b931b25b8be4f1a8e320d"
      ;;
    *)
      log "No pinned SenseVoice binary for $os/$arch; install the official runtime manually."
      return
      ;;
  esac

  temp_dir="$(mktemp -d)"
  trap 'rm -rf "$temp_dir"' EXIT
  archive="$temp_dir/$asset"
  url="https://github.com/QwenAudio/SenseVoice/releases/download/$SENSEVOICE_RELEASE/$asset"
  download_with_resume "$url" "$archive"
  sha256_check "$digest" "$archive"
  tar -xzf "$archive" -C "$temp_dir"
  mkdir -p "$SENSEVOICE_HOME/bin" "$SENSEVOICE_HOME/models"
  install -m 755 "$temp_dir/llama-funasr-sensevoice" "$SENSEVOICE_HOME/bin/sensevoice-cli"

  sensevoice_model="$SENSEVOICE_HOME/models/sensevoice-small-q8.gguf"
  download_with_resume \
    "https://huggingface.co/FunAudioLLM/SenseVoiceSmall-GGUF/resolve/main/sensevoice-small-q8.gguf" \
    "$sensevoice_model"
  sha256_check \
    "4ae45c94422de949b387e2e0fb10d7e14e4c42c69db30c3444ecc7d4b844b7c5" \
    "$sensevoice_model"

  vad_model="$SENSEVOICE_HOME/models/fsmn-vad.gguf"
  download_with_resume \
    "https://huggingface.co/FunAudioLLM/fsmn-vad-GGUF/resolve/main/fsmn-vad.gguf" \
    "$vad_model"
  sha256_check \
    "1270f2559c495f4e7b6e739541151027d360761a3fda43fc147034f5719f5479" \
    "$vad_model"
}

install_whisper_model() {
  model="$WHISPER_CPP_HOME/models/$WHISPER_MODEL_NAME"
  download_with_resume \
    "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/$WHISPER_MODEL_NAME" \
    "$model"
  sha256_check \
    "394221709cd5ad1f40c46e6031ca61bce88931e6e088c188294c6d5a55ffa7e2" \
    "$model"
}

write_wrappers() {
  mkdir -p "$PYTHON_TOOLS_HOME/bin"
  if [ -x /opt/homebrew/opt/ffmpeg-full/bin/ffmpeg ]; then
    for command_name in ffmpeg ffprobe; do
      cat > "$PYTHON_TOOLS_HOME/bin/$command_name" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "/opt/homebrew/opt/ffmpeg-full/bin/$command_name" "\$@"
SH
      chmod +x "$PYTHON_TOOLS_HOME/bin/$command_name"
    done
  fi
  whisper_path=""
  if [ -x /opt/homebrew/opt/whisper-cpp/bin/whisper-cli ]; then
    whisper_path="/opt/homebrew/opt/whisper-cpp/bin/whisper-cli"
  elif command -v whisper-cli >/dev/null 2>&1; then
    candidate="$(command -v whisper-cli)"
    if [ "$candidate" != "$PYTHON_TOOLS_HOME/bin/whisper-cli" ]; then
      whisper_path="$candidate"
    fi
  fi
  if [ -n "$whisper_path" ]; then
    cat > "$PYTHON_TOOLS_HOME/bin/whisper-cli" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$whisper_path" "\$@"
SH
    chmod +x "$PYTHON_TOOLS_HOME/bin/whisper-cli"
  else
    log "whisper-cli binary is unavailable; wrapper not created."
  fi
  if [ -x "$SENSEVOICE_HOME/bin/sensevoice-cli" ]; then
    cat > "$PYTHON_TOOLS_HOME/bin/sensevoice-cli" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$SENSEVOICE_HOME/bin/sensevoice-cli" "\$@"
SH
    chmod +x "$PYTHON_TOOLS_HOME/bin/sensevoice-cli"
  fi
  if [ -x /Applications/MacWhisper.app/Contents/MacOS/mw ]; then
    cat > "$PYTHON_TOOLS_HOME/bin/macwhisper-cli" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "/Applications/MacWhisper.app/Contents/MacOS/mw" "\$@"
SH
    chmod +x "$PYTHON_TOOLS_HOME/bin/macwhisper-cli"
  fi
}

case "$(uname -s)" in
  Darwin)
    install_macos_tools
    ;;
  *)
    log "Install ffmpeg-full/libass, ImageMagick, and whisper.cpp with the OS package manager."
    ;;
esac

install_sensevoice
install_whisper_model
write_wrappers
log "optional video tools installed"
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_INSTALL_OPTIONAL_VIDEO_TOOLS_SH_D4398C6F8B
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/install_optional_video_tools.sh"

# video-processing-automation/scripts/mix_audio.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/mix_audio.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/mix_audio.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_MIX_AUDIO_PY_ED8F86FB64'
#!/usr/bin/env python3
"""Mix background music under an existing video's speech with FFmpeg."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import shutil
import subprocess
import sys


def has_audio(path: Path) -> bool:
    result = subprocess.run(
        [
            "ffprobe",
            "-v",
            "error",
            "-select_streams",
            "a",
            "-show_entries",
            "stream=index",
            "-of",
            "json",
            str(path),
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    return bool(json.loads(result.stdout).get("streams"))


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Mix looping BGM under speech without changing video framing."
    )
    parser.add_argument("video", type=Path)
    parser.add_argument("music", type=Path)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--music-volume", type=float, default=0.16)
    parser.add_argument(
        "--no-duck",
        action="store_true",
        help="Use a constant music level instead of lowering it under speech.",
    )
    parser.add_argument("--target-lufs", type=float, default=-16.0)
    args = parser.parse_args()

    for tool in ("ffmpeg", "ffprobe"):
        if shutil.which(tool) is None:
            print(f"Required command is unavailable: {tool}", file=sys.stderr)
            return 2
    for path in (args.video, args.music):
        if not path.is_file():
            print(f"Input file does not exist: {path}", file=sys.stderr)
            return 2
    if not 0 < args.music_volume <= 1:
        print("--music-volume must be greater than 0 and at most 1.", file=sys.stderr)
        return 2
    if not has_audio(args.video):
        print("The source video has no audio stream to mix with.", file=sys.stderr)
        return 2
    if not has_audio(args.music):
        print("The music input has no audio stream.", file=sys.stderr)
        return 2

    args.out.parent.mkdir(parents=True, exist_ok=True)
    if args.no_duck:
        filter_complex = (
            f"[1:a:0]volume={args.music_volume}[music];"
            "[0:a:0][music]amix=inputs=2:duration=first:dropout_transition=2,"
            f"loudnorm=I={args.target_lufs}:TP=-1.5:LRA=11[mix]"
        )
    else:
        filter_complex = (
            f"[1:a:0]volume={args.music_volume}[music];"
            "[music][0:a:0]sidechaincompress="
            "threshold=0.025:ratio=10:attack=20:release=500[ducked];"
            "[0:a:0][ducked]amix=inputs=2:duration=first:dropout_transition=2,"
            f"loudnorm=I={args.target_lufs}:TP=-1.5:LRA=11[mix]"
        )

    command = [
        "ffmpeg",
        "-y",
        "-i",
        str(args.video),
        "-stream_loop",
        "-1",
        "-i",
        str(args.music),
        "-filter_complex",
        filter_complex,
        "-map",
        "0:v:0",
        "-map",
        "[mix]",
        "-c:v",
        "copy",
        "-c:a",
        "aac",
        "-b:a",
        "192k",
        "-ar",
        "48000",
        "-shortest",
        "-movflags",
        "+faststart",
        str(args.out),
    ]
    completed = subprocess.run(command, check=False)
    if completed.returncode:
        return completed.returncode
    print(f"Wrote mixed video without reframing or cropping: {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_MIX_AUDIO_PY_ED8F86FB64
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/mix_audio.py"

# video-processing-automation/scripts/resegment.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/resegment.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/resegment.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_RESEGMENT_PY_185AC250E4'
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
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_RESEGMENT_PY_185AC250E4
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/resegment.py"

# video-processing-automation/scripts/smart_cut.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/smart_cut.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/smart_cut.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_SMART_CUT_PY_5EC07F3E6C'
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
        if dur_in > 0 and dur_out <= dur_in:
            detail = f"剪掉 {(1 - dur_out / dur_in) * 100:.1f}%"
        elif dur_out > dur_in:
            detail = f"編碼尾幀差 +{dur_out - dur_in:.2f}s"
        else:
            detail = "無可計算的時長差"
        print(f"[OK] 原長 {fmt(dur_in)} → 新長 {fmt(dur_out)}（{detail}）")
    except Exception as e:
        print(f"[WARN] 統計時長失敗：{e}")


if __name__ == "__main__":
    main()
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_SMART_CUT_PY_5EC07F3E6C
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/smart_cut.py"

# video-processing-automation/scripts/srt_to_txt.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/srt_to_txt.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/srt_to_txt.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_SRT_TO_TXT_PY_D1B61E765F'
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
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_SRT_TO_TXT_PY_D1B61E765F
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/srt_to_txt.py"

# video-processing-automation/scripts/transcribe_groq.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_groq.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_groq.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_GROQ_PY_88CE6C2517'
#!/usr/bin/env python3
"""透過 Groq API 做 STT，產出 word-level 時間碼 JSON。

用法：
  python3 transcribe_groq.py <audio_file> [--out raw.json]
    [--model whisper-large-v3-turbo] [--language zh|en|auto]

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


def build_multipart(
    audio_path: Path,
    model: str,
    prompt: str,
    language: str,
) -> tuple[bytes, str]:
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
    if language != "auto":
        add_field("language", language)
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
        "--language",
        default="zh",
        help="ISO-639-1 語言碼；auto 表示交由模型自動判斷（預設：zh）",
    )
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

    body, content_type = build_multipart(
        upload_path,
        args.model,
        args.prompt,
        args.language,
    )
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
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_GROQ_PY_88CE6C2517
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_groq.py"

# video-processing-automation/scripts/transcribe_local.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_local.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_local.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_LOCAL_PY_89ECA62982'
#!/usr/bin/env python3
"""Transcribe audio/video to SRT with the shared faster-whisper runtime."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys

try:
    from faster_whisper import WhisperModel
except ImportError as exc:
    raise SystemExit(
        "faster-whisper is unavailable. Run this script with audio-to-md-python "
        "after installing LazyPack Item 33."
    ) from exc


def srt_timestamp(seconds: float) -> str:
    milliseconds = max(0, round(seconds * 1000))
    hours, remainder = divmod(milliseconds, 3_600_000)
    minutes, remainder = divmod(remainder, 60_000)
    secs, millis = divmod(remainder, 1000)
    return f"{hours:02d}:{minutes:02d}:{secs:02d},{millis:03d}"


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Use the shared faster-whisper runtime to create an SRT file."
    )
    parser.add_argument("input", type=Path, help="Input audio or video file")
    parser.add_argument("--out", type=Path, required=True, help="Output SRT path")
    parser.add_argument("--model", default="large-v3-turbo")
    parser.add_argument("--language", default="zh")
    parser.add_argument("--device", default="cpu")
    parser.add_argument("--compute-type", default="int8")
    parser.add_argument("--beam-size", type=int, default=5)
    parser.add_argument(
        "--no-vad",
        action="store_true",
        help="Disable voice activity detection.",
    )
    args = parser.parse_args()

    if not args.input.is_file():
        print(f"Input file does not exist: {args.input}", file=sys.stderr)
        return 2

    args.out.parent.mkdir(parents=True, exist_ok=True)
    model = WhisperModel(
        args.model,
        device=args.device,
        compute_type=args.compute_type,
    )
    segments, info = model.transcribe(
        str(args.input),
        language=None if args.language == "auto" else args.language,
        beam_size=args.beam_size,
        vad_filter=not args.no_vad,
    )

    block_count = 0
    with args.out.open("w", encoding="utf-8", newline="\n") as handle:
        for segment in segments:
            text = " ".join(segment.text.strip().split())
            if not text:
                continue
            block_count += 1
            handle.write(f"{block_count}\n")
            handle.write(
                f"{srt_timestamp(segment.start)} --> {srt_timestamp(segment.end)}\n"
            )
            handle.write(f"{text}\n\n")

    print(
        f"Wrote {block_count} SRT blocks to {args.out} "
        f"(language={info.language}, probability={info.language_probability:.3f})"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_LOCAL_PY_89ECA62982
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_local.py"

# video-processing-automation/scripts/transcribe_macwhisper.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_macwhisper.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_macwhisper.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_MACWHISPER_PY_E211B88715'
#!/usr/bin/env python3
"""Create SRT with the MacWhisper command-line interface."""

from __future__ import annotations

import argparse
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile


DEFAULT_BINARY = Path("/Applications/MacWhisper.app/Contents/MacOS/mw")
DEFAULT_MODEL = "whisperkit:openai_whisper-large-v3-v20240930"
TIMECODE_LINE = re.compile(
    r"(?m)^(\d{2}:\d{2}:\d{2},\d{3}\s+-->\s+"
    r"\d{2}:\d{2}:\d{2},\d{3})\r?\n\r?\n(?=\S)"
)
TIMECODE_VALUES = re.compile(
    r"(?m)^(\d{2}:\d{2}:\d{2},\d{3})\s+-->\s+"
    r"(\d{2}:\d{2}:\d{2},\d{3})$"
)


def timestamp_seconds(value: str) -> float:
    hours, minutes, remainder = value.split(":")
    seconds, milliseconds = remainder.split(",")
    return (
        int(hours) * 3600
        + int(minutes) * 60
        + int(seconds)
        + int(milliseconds) / 1000
    )


def find_binary() -> str | None:
    shared = Path.home() / ".codex" / "python-tools" / "bin" / "macwhisper-cli"
    for candidate in (shared, DEFAULT_BINARY):
        if candidate.is_file():
            return str(candidate)
    return shutil.which("macwhisper-cli") or shutil.which("mw")


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Create SRT through an installed MacWhisper CLI. Availability can "
            "depend on the installed MacWhisper build and license."
        )
    )
    parser.add_argument("input", type=Path)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--language", default="zh")
    parser.add_argument("--max-chars-per-line", type=int, default=28)
    parser.add_argument(
        "--traditional",
        action="store_true",
        help="Convert recognized Chinese text to Traditional Chinese with OpenCC.",
    )
    args = parser.parse_args()

    binary = find_binary()
    if not binary:
        print(
            "MacWhisper CLI is unavailable. Install MacWhisper and verify "
            "`mw --help` or `macwhisper-cli --help`.",
            file=sys.stderr,
        )
        return 2
    if not args.input.is_file():
        print(f"Input file does not exist: {args.input}", file=sys.stderr)
        return 2

    args.out.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="macwhisper-") as temp_dir:
        generated = Path(temp_dir) / "transcript.srt"
        command = [
            binary,
            "transcribe",
            "--model",
            args.model,
            "--language",
            args.language,
            "--format",
            "srt",
            "--style",
            "subtitles",
            "--max-chars-per-line",
            str(args.max_chars_per_line),
            "--output",
            str(generated),
            "--overwrite",
            str(args.input),
        ]
        completed = subprocess.run(command, check=False)
        if completed.returncode:
            return completed.returncode
        if not generated.is_file():
            print("MacWhisper completed without producing SRT.", file=sys.stderr)
            return 1
        srt_text = generated.read_text(encoding="utf-8")

    srt_text = TIMECODE_LINE.sub(r"\1\n", srt_text)
    timecodes = TIMECODE_VALUES.findall(srt_text)
    for previous, current in zip(timecodes, timecodes[1:]):
        gap = timestamp_seconds(current[0]) - timestamp_seconds(previous[1])
        if gap > 2:
            print(
                f"Warning: MacWhisper SRT contains a {gap:.2f}s segment gap; "
                "compare it with the source before final delivery.",
                file=sys.stderr,
            )
    if args.traditional:
        try:
            from opencc import OpenCC
        except ImportError as exc:
            raise SystemExit(
                "--traditional requires opencc-python-reimplemented."
            ) from exc
        srt_text = OpenCC("s2twp").convert(srt_text)
    args.out.write_text(srt_text.rstrip() + "\n", encoding="utf-8")
    print(f"Wrote local MacWhisper SRT: {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_MACWHISPER_PY_E211B88715
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_macwhisper.py"

# video-processing-automation/scripts/transcribe_preferred.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_preferred.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_preferred.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_PREFERRED_PY_BDE428C623'
#!/usr/bin/env python3
"""Create SRT with Arry's preferred STT route and explicit preview overrides."""

from __future__ import annotations

import argparse
import os
from pathlib import Path
import shlex
import shutil
import subprocess
import sys


SCRIPT_DIR = Path(__file__).resolve().parent


def cloud_is_approved(args: argparse.Namespace) -> bool:
    if args.allow_cloud:
        return True
    if os.environ.get("STT_ALLOW_CLOUD", "").lower() in {"1", "true", "yes"}:
        return True
    approval_files = (
        Path.home() / ".codex" / "audio-to-md" / "cloud-upload-approved",
        Path.home() / ".audio-to-md" / "cloud-upload-approved",
    )
    return any(path.is_file() for path in approval_files)


def available_python(command_name: str, fallback: str) -> str:
    return shutil.which(command_name) or fallback


def run_command(command: list[str], dry_run: bool) -> int:
    if dry_run:
        print("dry-run command=" + shlex.join(command))
        return 0
    return subprocess.run(command, check=False).returncode


def convert_traditional(output: Path, dry_run: bool) -> int:
    python_tools = available_python("python-tools-python", sys.executable)
    return run_command(
        [
            python_tools,
            str(SCRIPT_DIR / "convert_srt_traditional.py"),
            str(output),
            "--out",
            str(output),
        ],
        dry_run,
    )


def convert_json_traditional(output: Path, dry_run: bool) -> int:
    python_tools = available_python("python-tools-python", sys.executable)
    return run_command(
        [
            python_tools,
            str(SCRIPT_DIR / "convert_json_traditional.py"),
            str(output),
            "--out",
            str(output),
        ],
        dry_run,
    )


def groq_route(args: argparse.Namespace) -> int:
    command = [
        sys.executable,
        str(SCRIPT_DIR / "transcribe_groq.py"),
        str(args.input),
        "--out",
        str(args.raw_json),
        "--model",
        args.groq_model,
        "--language",
        args.language,
    ]
    result = run_command(command, args.dry_run)
    if result:
        return result
    if args.traditional:
        result = convert_json_traditional(args.raw_json, args.dry_run)
        if result:
            return result
    result = run_command(
        [
            sys.executable,
            str(SCRIPT_DIR / "resegment.py"),
            str(args.raw_json),
            "--out",
            str(args.out),
        ],
        args.dry_run,
    )
    if result == 0 and args.traditional:
        result = convert_traditional(args.out, args.dry_run)
    return result


def faster_whisper_route(args: argparse.Namespace) -> int:
    local_python = available_python("audio-to-md-python", sys.executable)
    command = [
        local_python,
        str(SCRIPT_DIR / "transcribe_local.py"),
        str(args.input),
        "--out",
        str(args.out),
        "--model",
        args.local_model,
        "--language",
        args.language,
    ]
    result = run_command(command, args.dry_run)
    if result == 0 and args.traditional:
        result = convert_traditional(args.out, args.dry_run)
    return result


def whisper_cpp_route(args: argparse.Namespace) -> int:
    python_tools = available_python("python-tools-python", sys.executable)
    command = [
        python_tools,
        str(SCRIPT_DIR / "transcribe_whisper_cli.py"),
        str(args.input),
        "--out",
        str(args.out),
        "--language",
        args.language,
    ]
    if args.traditional:
        command.append("--traditional")
    return run_command(command, args.dry_run)


def macwhisper_route(args: argparse.Namespace) -> int:
    python_tools = available_python("python-tools-python", sys.executable)
    command = [
        python_tools,
        str(SCRIPT_DIR / "transcribe_macwhisper.py"),
        str(args.input),
        "--out",
        str(args.out),
        "--language",
        args.language,
    ]
    if args.traditional:
        command.append("--traditional")
    return run_command(command, args.dry_run)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Formal STT: Groq first, faster-whisper fallback, MacWhisper last. "
            "Use whisper.cpp only with --engine whisper.cpp for a fast preview."
        )
    )
    parser.add_argument("input", type=Path)
    parser.add_argument("--out", type=Path, required=True, help="Output SRT path")
    parser.add_argument(
        "--raw-json",
        type=Path,
        help="Groq verbose JSON path; defaults beside the SRT.",
    )
    parser.add_argument(
        "--engine",
        choices=("auto", "groq", "faster-whisper", "whisper.cpp", "macwhisper"),
        default="auto",
    )
    parser.add_argument(
        "--allow-cloud",
        action="store_true",
        help="Confirm that this input may be uploaded to Groq.",
    )
    parser.add_argument("--language", default="auto")
    parser.add_argument("--groq-model", default="whisper-large-v3-turbo")
    parser.add_argument("--local-model", default="large-v3-turbo")
    parser.add_argument(
        "--traditional",
        action="store_true",
        help="Normalize subtitle text to Traditional Chinese.",
    )
    parser.add_argument("--dry-run", action="store_true")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    args.raw_json = args.raw_json or args.out.with_suffix(".groq.json")
    if not args.input.is_file() and not args.dry_run:
        print(f"Input file does not exist: {args.input}", file=sys.stderr)
        return 2
    if not args.dry_run:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        if args.raw_json.exists():
            args.raw_json.unlink()

    if args.engine == "whisper.cpp":
        print("route=whisper.cpp purpose=explicit-fast-preview")
        result = whisper_cpp_route(args)
        if result == 0:
            print(
                "engine_planned=whisper.cpp"
                if args.dry_run
                else "engine_used=whisper.cpp"
            )
        return result

    if args.engine == "macwhisper":
        print("route=macwhisper purpose=explicit-last-option")
        result = macwhisper_route(args)
        if result == 0:
            print(
                "engine_planned=macwhisper"
                if args.dry_run
                else "engine_used=macwhisper"
            )
        return result

    if args.engine == "faster-whisper":
        print(f"route=faster-whisper model={args.local_model}")
        result = faster_whisper_route(args)
        if result == 0:
            print(
                "engine_planned=faster-whisper"
                if args.dry_run
                else "engine_used=faster-whisper"
            )
        return result

    if not cloud_is_approved(args):
        if args.engine == "groq":
            print(
                "Cloud upload approval is required. Use --allow-cloud or "
                "STT_ALLOW_CLOUD=1.",
                file=sys.stderr,
            )
            return 2
        print("skip=groq reason=cloud-upload-not-approved")
    else:
        print(f"route=groq model={args.groq_model}")
        result = groq_route(args)
        if result == 0:
            label = "engine_planned" if args.dry_run else "engine_used"
            print(f"{label}=groq import_path={args.raw_json}")
            return 0
        if args.engine == "groq":
            return result
        if not args.dry_run and args.raw_json.exists():
            args.raw_json.unlink()
        print(f"fallback=faster-whisper reason=groq-exit-{result}")

    result = faster_whisper_route(args)
    if result == 0:
        label = "engine_planned" if args.dry_run else "engine_used"
        print(f"{label}=faster-whisper import_path={args.out}")
        return 0
    print(f"fallback=macwhisper reason=faster-whisper-exit-{result}")
    result = macwhisper_route(args)
    if result == 0:
        label = "engine_planned" if args.dry_run else "engine_used"
        print(f"{label}=macwhisper import_path={args.out}")
    return result


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_PREFERRED_PY_BDE428C623
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_preferred.py"

# video-processing-automation/scripts/transcribe_sensevoice.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_sensevoice.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_sensevoice.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_SENSEVOICE_PY_3B32319471'
#!/usr/bin/env python3
"""Create a fast local transcript with the native SenseVoice runtime."""

from __future__ import annotations

import argparse
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile


RICH_TAG = re.compile(r"<\|[^|>]+\|>")
DEFAULT_HOME = Path.home() / ".codex" / "sensevoice"


def ffmpeg_command() -> str | None:
    candidates = (
        Path.home() / ".codex" / "python-tools" / "bin" / "ffmpeg",
        Path("/opt/homebrew/opt/ffmpeg-full/bin/ffmpeg"),
    )
    for candidate in candidates:
        if candidate.is_file():
            return str(candidate)
    return shutil.which("ffmpeg")


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Create a local SenseVoice transcript. This native runtime does not "
            "emit subtitle timestamps; use a Whisper route when SRT is required."
        )
    )
    parser.add_argument("input", type=Path)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument(
        "--binary",
        type=Path,
        default=DEFAULT_HOME / "bin" / "sensevoice-cli",
    )
    parser.add_argument(
        "--model",
        type=Path,
        default=DEFAULT_HOME / "models" / "sensevoice-small-q8.gguf",
    )
    parser.add_argument(
        "--vad",
        type=Path,
        default=DEFAULT_HOME / "models" / "fsmn-vad.gguf",
    )
    parser.add_argument("--keep-tags", action="store_true")
    parser.add_argument(
        "--traditional",
        action="store_true",
        help="Convert Simplified Chinese text to Traditional Chinese with OpenCC.",
    )
    args = parser.parse_args()

    ffmpeg = ffmpeg_command()
    required = (args.input, args.binary, args.model, args.vad)
    missing = [str(path) for path in required if not path.is_file()]
    if missing:
        print(f"Missing required file(s): {', '.join(missing)}", file=sys.stderr)
        return 2
    if not ffmpeg:
        print("ffmpeg is unavailable.", file=sys.stderr)
        return 2

    args.out.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="sensevoice-") as temp_dir:
        wav = Path(temp_dir) / "input.wav"
        converted = subprocess.run(
            [
                ffmpeg,
                "-hide_banner",
                "-loglevel",
                "error",
                "-y",
                "-i",
                str(args.input),
                "-vn",
                "-ar",
                "16000",
                "-ac",
                "1",
                "-c:a",
                "pcm_s16le",
                str(wav),
            ],
            check=False,
        )
        if converted.returncode:
            return converted.returncode
        command = [
            str(args.binary),
            "-m",
            str(args.model),
            "-a",
            str(wav),
            "--vad",
            str(args.vad),
        ]
        if args.keep_tags:
            command.append("--keep-tags")
        completed = subprocess.run(
            command,
            check=False,
            capture_output=True,
            text=True,
        )
        if completed.returncode:
            print(completed.stderr, file=sys.stderr)
            return completed.returncode
        text = completed.stdout.strip()

    if not args.keep_tags:
        text = RICH_TAG.sub("", text).strip()
    if args.traditional:
        try:
            from opencc import OpenCC
        except ImportError as exc:
            raise SystemExit(
                "--traditional requires opencc-python-reimplemented from LazyPack Item 34."
            ) from exc
        text = OpenCC("s2twp").convert(text)
    args.out.write_text(text + "\n", encoding="utf-8")
    print(f"Wrote local SenseVoice transcript: {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_SENSEVOICE_PY_3B32319471
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_sensevoice.py"

# video-processing-automation/scripts/transcribe_whisper_cli.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_whisper_cli.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_whisper_cli.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_WHISPER_CLI_PY_DEC400DA34'
#!/usr/bin/env python3
"""Create SRT with whisper.cpp's whisper-cli and the shared local model."""

from __future__ import annotations

import argparse
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


DEFAULT_MODEL = (
    Path.home()
    / ".codex"
    / "whisper-cpp"
    / "models"
    / "ggml-large-v3-turbo-q5_0.bin"
)


def ffmpeg_command() -> str | None:
    candidates = (
        Path.home() / ".codex" / "python-tools" / "bin" / "ffmpeg",
        Path("/opt/homebrew/opt/ffmpeg-full/bin/ffmpeg"),
    )
    for candidate in candidates:
        if candidate.is_file():
            return str(candidate)
    return shutil.which("ffmpeg")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Create SRT locally with whisper.cpp."
    )
    parser.add_argument("input", type=Path)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--model", type=Path, default=DEFAULT_MODEL)
    parser.add_argument("--language", default="zh")
    parser.add_argument("--threads", type=int)
    parser.add_argument(
        "--max-chars",
        type=int,
        default=0,
        help=(
            "Optional maximum segment length. The default 0 preserves engine "
            "segments because forced CJK splits can break a word."
        ),
    )
    parser.add_argument(
        "--traditional",
        action="store_true",
        help="Convert Simplified Chinese subtitle text to Traditional Chinese.",
    )
    args = parser.parse_args()

    whisper = shutil.which("whisper-cli")
    ffmpeg = ffmpeg_command()
    if not whisper:
        print("whisper-cli is unavailable. Run install_optional_video_tools.sh.", file=sys.stderr)
        return 2
    if not ffmpeg:
        print("ffmpeg is unavailable.", file=sys.stderr)
        return 2
    if not args.input.is_file():
        print(f"Input file does not exist: {args.input}", file=sys.stderr)
        return 2
    if not args.model.is_file():
        print(f"Whisper model does not exist: {args.model}", file=sys.stderr)
        return 2

    args.out.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="whisper-cli-") as temp_dir:
        temp = Path(temp_dir)
        wav = temp / "input.wav"
        prefix = temp / "transcript"
        convert = subprocess.run(
            [
                ffmpeg,
                "-hide_banner",
                "-loglevel",
                "error",
                "-y",
                "-i",
                str(args.input),
                "-vn",
                "-ar",
                "16000",
                "-ac",
                "1",
                "-c:a",
                "pcm_s16le",
                str(wav),
            ],
            check=False,
        )
        if convert.returncode:
            return convert.returncode
        command = [
            whisper,
            "-m",
            str(args.model),
            "-f",
            str(wav),
            "-l",
            args.language,
            "-osrt",
            "-of",
            str(prefix),
        ]
        if args.max_chars > 0:
            command.extend(["-ml", str(args.max_chars)])
        if args.threads:
            command.extend(["-t", str(args.threads)])
        completed = subprocess.run(command, check=False)
        if completed.returncode:
            return completed.returncode
        generated = prefix.with_suffix(".srt")
        if not generated.is_file():
            print("whisper-cli completed without producing SRT.", file=sys.stderr)
            return 1
        srt_text = generated.read_text(encoding="utf-8")
        if args.traditional:
            try:
                from opencc import OpenCC
            except ImportError as exc:
                raise SystemExit(
                    "--traditional requires opencc-python-reimplemented from LazyPack Item 34."
                ) from exc
            srt_text = OpenCC("s2twp").convert(srt_text)
        args.out.write_text(srt_text, encoding="utf-8")
    print(f"Wrote local whisper.cpp SRT: {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_TRANSCRIBE_WHISPER_CLI_PY_DEC400DA34
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/transcribe_whisper_cli.py"

# video-processing-automation/scripts/validate_srt.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/validate_srt.py")"
cat > "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/validate_srt.py" <<'AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_VALIDATE_SRT_PY_0A4B3A405E'
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
AGENT_LAZYPACK_VIDEO_PROCESSING_AUTOMATION_SCRIPTS_VALIDATE_SRT_PY_0A4B3A405E
chmod +x "{{SYNC_ROOT}}/skills/video-processing-automation/scripts/validate_srt.py"

test -f "{{SYNC_ROOT}}/skills/video-processing-automation/SKILL.md" && echo "video-processing-automation installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
