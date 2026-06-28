# 32-VoxCPM2-Voice-Cloner-Skill-安裝

> 來源：`mathruffian-dot/voxcpm2-voice-cloner`，稽核 commit `3d151de3ce5e51762af4f28756ac47e00a867257`。本版已轉為 Codex App、macOS Apple Silicon、CUDA 與 CPU 相容的全域 Skill。

## 用途

這個 Skill 讓 Codex 以自然語言協助：

- 建立本機 VoxCPM2 Python 3.12 隔離環境。
- 錄製或匯入已授權的聲音參考檔與精確逐字稿。
- 使用已授權聲音生成語音。
- 使用文字描述設計不對應真實人物的合成聲音。
- 用 JSON 腳本生成多角色對話。
- 在 Apple Silicon 使用官方 `auto`／MPS 路徑。

## 安全與隱私

- 只允許克隆使用者自己的聲音，或已取得說話者明確授權的聲音。
- 禁止冒充、詐騙、偽造背書、散布不實資訊或繞過同意檢查。
- 對外分享且可能造成誤認時，明確標示為 AI 生成音訊。
- 聲音參考檔視為類生物辨識個資，不寫入 Git、LazyPack、Obsidian 或同步型 Skill 目錄；若是使用者自己的 reusable profile，放在私有全域助手資料層。
- runtime、`.venv`、uv cache、Hugging Face 模型權重與預設 output 一律放在本機 `{{CODEX_HOME}}/voxcpm2-voice-cloner` 實體資料夾；不要 symlink 到 `{{SYNC_ROOT}}/runtimes/voxcpm2-voice-cloner` 或其他 Google Drive 同步資料夾。
- `uv` 快取固定放在 runtime 內的 `uv-cache/`，不要求開放整個 `~/.cache`。

## 與來源版本的差異

- Windows BAT／PowerShell 安裝改為 `uv`＋Python 3.12 隔離環境。
- 新增 Apple Silicon MPS；不在 macOS 套用來源 repo 的 Intel XPU patch。
- 移除硬編碼人物名稱、XPU 裝置與 repo 內的 `voices/`、`output/` 寫入。
- 新增 Codex `SKILL.md`、`agents/openai.yaml`、trigger、validator 與 LazyPack／Obsidian 同步。
- 新增 `--consent` 強制授權旗標與只綁定 loopback 的 Gradio 錄音介面。
- 新增固定秒數 CLI 錄音 fallback；in-app Browser 無法取得麥克風時，仍可透過固定外部入口錄製授權 profile。
- 對話改用 JSON 輸入，不需要直接編輯 Python 原始碼。

## 系統需求

- macOS Apple Silicon、支援 CUDA 的主機，或 CPU。
- `uv`。
- 約數 GB 的 runtime 與模型空間。
- 模型第一次生成時才下載，安裝 Skill 與 runtime 時不下載模型權重。

官方目前要求 Python 3.10–3.12；本 Skill 固定建立 Python 3.12 環境。官方 VoxCPM2 支援 `auto`、`cpu`、`mps`、`cuda` 等裝置選項。

## 安裝後的固定路徑

```text
{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/
{{CODEX_HOME}}/voxcpm2-voice-cloner/.venv/
{{CODEX_HOME}}/voxcpm2-voice-cloner/model-cache/
{{SYNC_ROOT}}/assets/arry-voice-profiles/Arry/
{{CODEX_HOME}}/voxcpm2-voice-cloner/output/
```

只有第一個路徑是可攜 Skill package；runtime、模型快取與預設生成輸出放在本機 `{{CODEX_HOME}}/voxcpm2-voice-cloner`，reusable voice profile 放全域助手資產。

## 沙盒設定

在 `{{CODEX_CONFIG}}` 的 `[sandbox_workspace_write]` 中只加入窄路徑：

```toml
writable_roots = [
  "{{CODEX_HOME}}/voxcpm2-voice-cloner",
]
```

實際使用時合併進既有 `writable_roots`，不要覆蓋其他項目，也不要直接開放整個 `{{CODEX_HOME}}`。

在 `{{CODEX_HOME}}/rules/default.rules` 加入固定入口：

```text
prefix_rule(pattern=["bash", "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/setup_runtime.sh"], decision="allow")
prefix_rule(pattern=["{{CODEX_HOME}}/voxcpm2-voice-cloner/.venv/bin/python", "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/voice_cloner.py"], decision="allow")
prefix_rule(pattern=["{{CODEX_HOME}}/voxcpm2-voice-cloner/.venv/bin/python", "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/record_ui.py"], decision="allow")
prefix_rule(pattern=["{{CODEX_HOME}}/voxcpm2-voice-cloner/.venv/bin/python", "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/record_cli.py"], decision="allow")
```

Apple Silicon 的 Metal 裝置可能在一般 workspace sandbox 內被隱藏，造成 `mps=False`。後續 `doctor` 與生成動作應走上述固定外部入口；不要改成允許任意 Python。

## 安裝 runtime

Arry 不使用跨電腦共享 runtime；先確認本機 runtime 是實體資料夾：

```bash
mkdir -p "{{CODEX_HOME}}/voxcpm2-voice-cloner"
test ! -L "{{CODEX_HOME}}/voxcpm2-voice-cloner"
```

若 `{{CODEX_HOME}}/voxcpm2-voice-cloner/model-cache/` 已由另一台電腦同步完成，下一步不應重新下載模型；若 `.venv` 因平台或 Python 路徑不相容，可重跑 setup，但保留 `model-cache/`。

```bash
bash "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/setup_runtime.sh"
```

驗證：

```bash
"{{CODEX_HOME}}/voxcpm2-voice-cloner/.venv/bin/python" \
  "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/voice_cloner.py" doctor
```

Apple Silicon 應在外部固定入口看到 `mps=True`。

若 MPS 因記憶體不足無法載入，可用極短文字搭配 `--device cpu --steps 1 --max-len 8` 做 smoke test；此設定只驗證執行能力，使用者實測可能是無意義雜音，不代表正式音質。

本機實測：4.6 GB 模型完整下載；MPS float32 在約 9.05 GiB 觸及記憶體上限，因此不強行解除安全限制。CPU `--steps 1/2 --max-len 8` 只能證明流程能跑，使用者聽辨為無意義雜音；CPU 生成最低可判斷門檻為 `--steps 4 --max-len 32`，該設定可聽懂但音質仍偏低。

## 使用方式

顯式觸發：

```text
$voxcpm2-voice-cloner
```

自然語句範例：

- 「列出我本機已授權的 VoxCPM2 聲音。」
- 「我已取得這位說話者授權，幫我匯入參考音與逐字稿。」
- 「用我自己的聲音生成這段文字。」
- 「不要模仿真人，設計一個溫暖沉穩的旁白聲音。」

## 驗證清單

- `quick_validate.py` 通過。
- scripts 通過 shell／Python 語法檢查。
- runtime `doctor` 可載入 VoxCPM、PyTorch 與 Gradio。
- Apple Silicon 外部固定入口回報 `mps=True`。
- 未下載模型權重前，`list` 可正常執行。
- 沒有任何聲音、輸出、模型或 `.venv` 進入 Skill package。
- LazyPack 離線重建 package 與全域 Skill 逐檔一致。
- repo LazyPack 與 Obsidian 懶人包鏡像一致。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊，會安裝 `voxcpm2-voice-cloner` Skill package；不會安裝 runtime、模型權重或聲音資料。先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾。

````bash
set -e

mkdir -p "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner"
# voxcpm2-voice-cloner/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/SKILL.md" <<'CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_SKILL_MD'
---
name: voxcpm2-voice-cloner
description: Use when the user asks to install or run VoxCPM2, clone an authorized voice, synthesize speech from a voice reference, design a synthetic voice, record or import a voice profile, list local voice profiles, or generate multi-speaker dialogue. Supports macOS Apple Silicon MPS, CUDA, and CPU through a local Python 3.12 runtime. Require explicit permission for every cloned real-person voice.
metadata:
  short-description: Local authorized VoxCPM2 voice cloning
---

# VoxCPM2 Voice Cloner

Use this skill for local VoxCPM2 speech generation and authorized voice cloning. It adapts `mathruffian-dot/voxcpm2-voice-cloner` to Codex and current OpenBMB VoxCPM2 APIs.

## Safety Gate

Before importing, recording, or cloning a recognizable real-person voice, confirm that the user owns the voice or has explicit permission from the speaker. Do not help impersonate someone, bypass consent, commit fraud, create deceptive endorsements, or produce disinformation. Clearly label externally shared results as AI-generated when confusion is plausible.

The wrapper requires `--consent` for real-voice profile creation and cloning. Do not bypass that flag or weaken the check.

## Local Paths

- Skill package: `{{CODEX_HOME}}/skills/voxcpm2-voice-cloner`
- Runtime data: `${VOXCPM2_HOME:-$HOME/.codex/voxcpm2-voice-cloner}`. For Arry, keep this as a local real folder, not a symlink to Google Drive, so `.venv`, `model-cache`, `uv-cache`, `recordings`, and `output` stay fast on the current machine.
- Python environment: `$VOXCPM2_HOME/.venv`
- Voice profiles: `$VOXCPM2_HOME/voices/<voice-name>/`
- Outputs: `$VOXCPM2_HOME/output/`
- Model cache: `$VOXCPM2_HOME/model-cache/`; first model use downloads several GB
- Optional reusable profile root: `$VOXCPM2_VOICES_DIR/<voice-name>/`
- Optional project output root: `$VOXCPM2_OUTPUT_DIR/`

Never copy model weights, generated audio, or the runtime virtual environment into LazyPack, Obsidian, Git, the global skill package, or Google Drive sync folders. For Arry, the canonical runtime is the local real folder `$HOME/.codex/voxcpm2-voice-cloner`; do not point it at `codex_symlink/runtimes`. Reusable personal voice profiles may live in the user's private assistant asset layer; for Arry, the canonical profile folder is `codex_symlink/knowledge/arry-voice-profiles/Arry/`. Generated outputs default to the local runtime `output/` unless `$VOXCPM2_OUTPUT_DIR` is explicitly set for a project.

- **自適應專案收納 (Adaptive Project Path Routing)**: 當在標準四盒專案（含有 `100_Todo/`）下執行時：
  - **過程素材與工程** 應置於相對路徑 `100_Todo/drafts/voxcpm2-voice-cloner/`。
  - **產出音檔成品** 應直接置於 `100_Todo/projects/voxcpm2-voice-cloner/` 底下，**不得建立額外的 `output/` 中間層**。
  - 執行指令前應自動將輸出變數設定為相對路徑：`export VOXCPM2_OUTPUT_DIR="100_Todo/projects/voxcpm2-voice-cloner"`。

## Setup

Read `references/runtime.md` before installing or repairing the runtime.

Run:

```bash
bash "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/setup_runtime.sh"
```

The setup uses `uv`, creates an isolated Python 3.12 environment, and installs the pinned VoxCPM runtime. It does not download model weights until the first generation request.

## Commands

Set reusable paths:

```bash
SKILL="${CODEX_HOME:-$HOME/.codex}/skills/voxcpm2-voice-cloner"
HOME_DIR="${VOXCPM2_HOME:-$HOME/.codex/voxcpm2-voice-cloner}"
PY="$HOME_DIR/.venv/bin/python"
TOOL="$SKILL/scripts/voice_cloner.py"
```

For Arry's local setup, ensure the runtime path is a real local directory before running setup or generation:

```bash
mkdir -p "$HOME/.codex/voxcpm2-voice-cloner"
test ! -L "$HOME/.codex/voxcpm2-voice-cloner"
```

Route reusable profiles and project outputs when needed:

```bash
export VOXCPM2_VOICES_DIR="/path/to/private-assistant/assets/voice-profiles"
export VOXCPM2_OUTPUT_DIR="/path/to/project-local/output"
```

List profiles:

```bash
"$PY" "$TOOL" list
```

Import an authorized reference recording and exact transcript:

```bash
"$PY" "$TOOL" import-voice --voice "my-voice" --audio /path/ref.wav \
  --prompt-file /path/transcript.txt --consent
```

Launch the local-only recording UI:

```bash
"$PY" "$SKILL/scripts/record_ui.py" --host 127.0.0.1 --port 7860
```

The UI is designed for the Codex In-App Browser. Its **開始本機錄音** action captures an explicitly selected microphone through the local Python backend, so it still works when the embedded browser does not expose WebRTC microphone devices. Use a separate authorized profile name for each speaker.

If the in-app Browser cannot access a microphone, use the fixed-duration local recorder through its approved external command rule:

```bash
"$PY" "$SKILL/scripts/record_cli.py" --voice "my-voice" --seconds 20 --delay 15 --consent
```

Clone an authorized voice:

```bash
"$PY" "$TOOL" clone --voice "my-voice" --text "要生成的內容" --consent
```

Design a synthetic voice without cloning a real person:

```bash
"$PY" "$TOOL" design --description "溫暖沉穩、語速自然的成年女性聲音" \
  --text "歡迎收聽今天的內容。"
```

Generate JSON-defined dialogue:

```bash
"$PY" "$TOOL" dialogue --script /path/dialogue.json --consent
```

Read `references/runtime.md` for the JSON schema, device selection, output paths, and troubleshooting.

## Device Rules

- Default to `--device auto`.
- On Apple Silicon, current official VoxCPM uses MPS when available.
- The Codex workspace sandbox may hide Metal and report `mps=False`. Run the fixed runtime Python + `voice_cloner.py` entry through the approved external command rule for `doctor` and generation; do not broaden permission to arbitrary Python.
- Use `--device cpu` only for troubleshooting or unsupported hardware; generation can be slow.
- For a CPU-only smoke test, constrain a short request with `--steps 1 --max-len 8`; these settings verify execution only and can produce meaningless noise.
- For CPU output that the user must judge or use, do not go below `--steps 4 --max-len 32`. Treat this as the minimum floor, not a final-quality recommendation.
- Use CUDA only when the host has a supported NVIDIA environment.
- Do not apply the upstream Intel XPU patch on macOS. It is Windows-specific and remains source context only.

## Verification

After setup:

1. Run `voice_cloner.py doctor`.
   - On Apple Silicon, verify this through the approved external entry and require `mps=True`; a sandboxed `mps=False` result is not a valid hardware verdict.
2. Run `voice_cloner.py list` without downloading the model.
3. Validate one user-owned or explicitly authorized profile before cloning.
4. Treat the first full generation as a separate model-download step; report the expected multi-GB download before starting.
5. Confirm the output file exists and report its absolute path.

## Source And Maintenance

Read `references/upstream.md` before refreshing this skill from upstream. Preserve the consent gate, private local-data boundary, MPS support, current official API compatibility, LazyPack package, and Obsidian index during upgrades.

CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_SKILL_MD

# voxcpm2-voice-cloner/agents/openai.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/agents/openai.yaml")"
cat > "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/agents/openai.yaml" <<'CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_AGENTS_OPENAI_YAML'
interface:
  display_name: "VoxCPM2 Voice Cloner"
  short_description: "Clone authorized voices with local VoxCPM2"
  default_prompt: "Use $voxcpm2-voice-cloner to create speech from an authorized voice reference."
CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_AGENTS_OPENAI_YAML

# voxcpm2-voice-cloner/assets/sample_text.txt
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/assets/sample_text.txt")"
cat > "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/assets/sample_text.txt" <<'CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_ASSETS_SAMPLE_TEXT_TXT'
今天我正在錄製一段授權的參考聲音。這段錄音會用於本機語音合成測試，我會保持自然語速、清楚發音，並完整朗讀與逐字稿相同的內容。
CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_ASSETS_SAMPLE_TEXT_TXT

# voxcpm2-voice-cloner/references/runtime.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/references/runtime.md")"
cat > "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/references/runtime.md" <<'CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_REFERENCES_RUNTIME_MD'
# VoxCPM2 Runtime Guide

## Requirements

- Python 3.10–3.12; this skill uses an isolated Python 3.12 environment.
- `uv` package manager.
- Several GB of free disk space for Python dependencies and model weights.
- Apple Silicon MPS, NVIDIA CUDA, or CPU.
- Microphone permission only when using the local recording UI or CLI recorder.

The source repo's PowerShell, BAT, Intel XPU patch, and hard-coded Windows paths are not used on macOS.

## Runtime Layout

```text
~/.codex/voxcpm2-voice-cloner/
├── .venv/
├── uv-cache/
├── model-cache/
├── voices/
│   └── <voice-name>/
│       ├── ref_voice.wav
│       └── prompt.txt
└── output/
```

Set `VOXCPM2_HOME` to move this local private state. Keep it outside synced repos and notes.

The setup script pins `UV_CACHE_DIR` inside this runtime root, and the generation wrapper pins `HF_HOME` to `model-cache/`. This avoids sandbox writes to the default `~/.cache/uv` and `~/.cache/huggingface` locations while keeping runtime caches under the same narrow writable root.

For Arry, the runtime root must stay on the current machine as a real local folder:

```text
~/.codex/voxcpm2-voice-cloner/
├── .venv/
├── uv-cache/
├── model-cache/
├── recordings/
├── voices/ -> profile symlinks or local fallback
└── output/
```

Do not symlink `~/.codex/voxcpm2-voice-cloner` to `codex_symlink/runtimes` or any Google Drive folder. Syncing `.venv`, model weights, or generated output through Google Drive makes generation and imports slow. On another computer, create that computer's own local runtime and model cache; keep only reusable personal voice profiles in the private assistant asset layer.

## Profile And Output Routing

By default, profiles and outputs live under the private local runtime. For reusable personal profiles, route the voice profile folder to the user's private assistant asset layer:

```bash
export VOXCPM2_VOICES_DIR="/path/to/private-assistant/assets/voice-profiles"
```

For Arry, the canonical reusable profile is:

```text
codex_symlink/knowledge/arry-voice-profiles/Arry/
├── ref_voice.wav
├── prompt.txt
└── profile.md
```

Generated audio belongs to the project where generation was requested:

```bash
export VOXCPM2_OUTPUT_DIR="/path/to/project-local/output"
```

Keep generated audio and biometric voice material out of public Git repos, LazyPack, and Obsidian. Use `.gitignore` for project output folders unless the user explicitly wants to publish a generated audio artifact.

## Dialogue JSON

```json
[
  {"voice": "speaker-a", "text": "第一句內容。"},
  {"voice": "speaker-b", "text": "第二句內容。"}
]
```

Every listed voice must already exist as a complete authorized profile.

## Device Selection

- `auto`: preferred; Apple Silicon uses MPS when available.
- `mps`: force Apple Metal acceleration.
- `cuda`: supported NVIDIA runtime.
- `cpu`: slow fallback.
- `xpu`: retained for compatible Intel environments; the source repo's Windows patch is not bundled into the Codex macOS path.

Codex workspace sandboxing can hide Metal and make `torch.backends.mps.is_available()` return false. This setup adds narrow command rules for the fixed VoxCPM2 runtime interpreter and wrapper scripts. Run `doctor` and model generation through that approved external entry; do not allow arbitrary Python executables or the whole `~/.codex` tree.

## Troubleshooting

- Wrong Python: rerun `scripts/setup_runtime.sh`; do not use the system Python or Python 3.14 for this runtime.
- `uv` cache permission error: use the setup script, which routes `UV_CACHE_DIR` into the runtime root; do not widen sandbox access to the whole `~/.cache` directory.
- Missing model: the first synthesis downloads `openbmb/VoxCPM2`; obtain approval before starting the multi-GB network operation.
- MPS failure: retry one short request with `--device cpu` and report the performance tradeoff.
- CPU smoke test: use a very short text plus `--steps 1 --max-len 8` to limit validation time; this only proves the pipeline can produce a non-silent WAV and may produce meaningless noise.
- CPU minimum for judgment-worthy output: do not go below `--steps 4 --max-len 32`. This was user-audited as understandable but low quality; it is a floor, not a recommended final-quality setting.
- Sandbox reports MPS false: rerun `doctor` through the approved external VoxCPM2 command prefix before treating MPS as unavailable.
- Microphone unavailable: grant microphone permission to Codex/Terminal, then use **重新抓取麥克風** in the local UI or upload an existing authorized recording.
- In-app Browser has no WebRTC microphone: use **開始本機錄音** in the UI. It records through the local Python backend and returns the result to the browser for preview and profile storage. `scripts/record_cli.py` remains the terminal fallback.
- Port 7860 occupied: choose another loopback port with `--port`.
- PyTorch or VoxCPM update: refresh in the isolated environment, then run `doctor` and one authorized short synthesis before updating the pinned version.

## Validated Apple Silicon Result

On the tested Mac, the complete 4.6 GB model cache downloaded successfully. MPS was detected, but float32 model transfer reached the Metal allocation ceiling at about 9.05 GiB and raised `MPS backend out of memory`. Do not disable the MPS high-watermark safety limit.

The initial CPU smoke test with `--steps 1 --max-len 8` produced a 48 kHz, 1.28 second non-silent WAV, but user listening confirmed it was meaningless noise. Do not call this an audio-quality success. A later synthetic CPU test with `--steps 4 --max-len 32` produced understandable but low-quality speech and is the current minimum floor for CPU generation that a user must judge.

## Privacy And Safety

- Voice profiles are biometric-like personal data. Do not sync or commit them.
- Require exact reference transcripts for Ultimate Cloning.
- Do not use public Gradio shares.
- Do not clone celebrities, coworkers, clients, family, or any third party without explicit permission.
- Label externally distributed synthetic audio when listeners could reasonably mistake it for authentic speech.

CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_REFERENCES_RUNTIME_MD

# voxcpm2-voice-cloner/references/upstream.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/references/upstream.md")"
cat > "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/references/upstream.md" <<'CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_REFERENCES_UPSTREAM_MD'
# Upstream Adaptation Record

## Sources

- Requested source: `https://github.com/mathruffian-dot/voxcpm2-voice-cloner`
- Audited source commit: `3d151de3ce5e51762af4f28756ac47e00a867257`
- Official runtime: `https://github.com/OpenBMB/VoxCPM`
- Official package: `voxcpm==2.0.3`

The source README states that its scripts are MIT-licensed and VoxCPM2 is Apache-2.0. The requested source snapshot does not contain a standalone LICENSE file, so preserve attribution and re-check licensing before redistributing source-derived code outside this personal LazyPack.

## Codex Conversion

- Replaced Windows BAT/PowerShell setup with `uv` and an isolated Python 3.12 runtime.
- Replaced hard-coded project-relative voices and outputs with private local runtime state under `~/.codex/voxcpm2-voice-cloner`.
- Replaced CUDA/XPU/CPU-only detection with official `auto` device routing, including Apple Silicon MPS.
- Replaced hard-coded dialogue speakers and XPU device with JSON-defined dialogue and device selection.
- Added `agents/openai.yaml`, Codex metadata triggers, deterministic wrappers, validation, and LazyPack/Obsidian synchronization.
- Removed alternate AI-editor rule files and slash-command assumptions.
- Added explicit speaker-consent gates and local-only Gradio binding.

## Refresh Checklist

1. Inspect the latest requested-source commit and official VoxCPM release.
2. Re-check Python and PyTorch version constraints.
3. Review official device support, especially MPS and XPU.
4. Diff upstream Python behavior against `scripts/voice_cloner.py` and `scripts/record_ui.py`.
5. Preserve local private-data boundaries and consent checks.
6. Run syntax checks, official Skill validation, runtime doctor, LazyPack offline reconstruction, and Obsidian mirror diff.
CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_REFERENCES_UPSTREAM_MD

# voxcpm2-voice-cloner/scripts/setup_runtime.sh
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/setup_runtime.sh")"
cat > "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/setup_runtime.sh" <<'CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_SCRIPTS_SETUP_RUNTIME_SH'
#!/usr/bin/env bash
set -euo pipefail

RUNTIME_HOME="${VOXCPM2_HOME:-$HOME/.codex/voxcpm2-voice-cloner}"
VENV="$RUNTIME_HOME/.venv"
export UV_CACHE_DIR="${UV_CACHE_DIR:-$RUNTIME_HOME/uv-cache}"

if ! command -v uv >/dev/null 2>&1; then
  echo "uv is required. On macOS install it with: brew install uv" >&2
  exit 1
fi

mkdir -p "$RUNTIME_HOME/voices" "$RUNTIME_HOME/output" "$UV_CACHE_DIR"

if [ ! -x "$VENV/bin/python" ]; then
  uv venv --python 3.12 "$VENV"
fi

uv pip install --python "$VENV/bin/python" \
  "voxcpm==2.0.3" \
  "gradio>=5,<7" \
  "sounddevice>=0.5,<1" \
  "soundfile>=0.13,<1" \
  "resampy>=0.4,<1"

uv pip check --python "$VENV/bin/python"

"$VENV/bin/python" -c 'import gradio, soundfile, torch, voxcpm; print("runtime_ok"); print("torch", torch.__version__); print("mps", bool(getattr(torch.backends, "mps", None) and torch.backends.mps.is_available()))'

echo "runtime_home=$RUNTIME_HOME"
echo "python=$VENV/bin/python"
echo "Model weights are downloaded only when generation first runs."
CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_SCRIPTS_SETUP_RUNTIME_SH

# voxcpm2-voice-cloner/scripts/voice_cloner.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/voice_cloner.py")"
cat > "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/voice_cloner.py" <<'CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_SCRIPTS_VOICE_CLONER_PY'
#!/usr/bin/env python3
"""Codex-compatible VoxCPM2 voice profile and synthesis wrapper."""

from __future__ import annotations

# Monkeypatch linecache.getlines to bypass PyTorch/UV virtual environment file loading errors
import linecache
_old_getlines = linecache.getlines
def _patched_getlines(filename, module_globals=None):
    lines = _old_getlines(filename, module_globals)
    if not lines and filename and not filename.startswith('<') and not filename.endswith('>'):
        try:
            with open(filename, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                lines = content.splitlines(keepends=True)
                linecache.cache[filename] = (len(lines), None, lines, filename)
        except Exception:
            pass
    return lines
linecache.getlines = _patched_getlines

import argparse
import json
import os
import sys
import time
from pathlib import Path


def runtime_home() -> Path:
    return Path(os.environ.get("VOXCPM2_HOME", Path.home() / ".codex" / "voxcpm2-voice-cloner")).expanduser()


def voices_root() -> Path:
    return Path(os.environ.get("VOXCPM2_VOICES_DIR", runtime_home() / "voices")).expanduser()


def output_root() -> Path:
    return Path(os.environ.get("VOXCPM2_OUTPUT_DIR", runtime_home() / "output")).expanduser()


def safe_voice_name(value: str) -> str:
    name = value.strip()
    if not name or name in {".", ".."} or "/" in name or "\\" in name or "\x00" in name:
        raise argparse.ArgumentTypeError("voice name must be one directory-safe name")
    return name


def require_consent(args: argparse.Namespace) -> None:
    if not getattr(args, "consent", False):
        raise SystemExit("Refusing real-voice operation without --consent confirming speaker permission.")


def profile_dir(name: str) -> Path:
    return voices_root() / safe_voice_name(name)


def resolve_profile(name: str) -> tuple[Path, str]:
    folder = profile_dir(name)
    audio = folder / "ref_voice.wav"
    prompt = folder / "prompt.txt"
    if not audio.is_file() or not prompt.is_file():
        raise SystemExit(f"Incomplete voice profile: {folder}")
    text = prompt.read_text(encoding="utf-8").strip()
    if not text:
        raise SystemExit(f"Empty transcript: {prompt}")
    return audio, text


def output_path(value: str | None, default_name: str) -> Path:
    path = Path(value).expanduser() if value else output_root() / default_name
    path.parent.mkdir(parents=True, exist_ok=True)
    return path.resolve()


def load_model(device: str):
    model_cache = runtime_home() / "model-cache"
    model_cache.mkdir(parents=True, exist_ok=True)
    os.environ.setdefault("HF_HOME", str(model_cache))
    from voxcpm import VoxCPM

    print(f"Loading openbmb/VoxCPM2 on device={device}; first use may download several GB.")
    start = time.time()
    model = VoxCPM.from_pretrained(
        "openbmb/VoxCPM2",
        load_denoiser=False,
        device=device,
        optimize=False,
    )
    print(f"model_loaded_seconds={time.time() - start:.1f}")
    return model


def cmd_doctor(_: argparse.Namespace) -> None:
    import torch
    import voxcpm

    home = runtime_home()
    home.mkdir(parents=True, exist_ok=True)
    print(f"python={sys.executable}")
    print(f"runtime_home={home}")
    print(f"voices_root={voices_root()}")
    print(f"output_root={output_root()}")
    print(f"voxcpm={getattr(voxcpm, '__version__', 'installed')}")
    print(f"torch={torch.__version__}")
    print(f"cuda={torch.cuda.is_available()}")
    print(f"mps={bool(getattr(torch.backends, 'mps', None) and torch.backends.mps.is_available())}")


def cmd_list(_: argparse.Namespace) -> None:
    root = voices_root()
    if not root.exists():
        print("No voice profiles.")
        return
    names = [p.name for p in root.iterdir() if p.is_dir() and (p / "ref_voice.wav").is_file() and (p / "prompt.txt").is_file()]
    if not names:
        print("No voice profiles.")
        return
    for name in sorted(names):
        print(name)


def cmd_import_voice(args: argparse.Namespace) -> None:
    require_consent(args)
    import numpy as np
    import resampy
    import soundfile as sf

    source = Path(args.audio).expanduser().resolve()
    prompt_source = Path(args.prompt_file).expanduser().resolve()
    if not source.is_file() or not prompt_source.is_file():
        raise SystemExit("audio and prompt file must both exist")
    prompt = prompt_source.read_text(encoding="utf-8").strip()
    if not prompt:
        raise SystemExit("prompt transcript cannot be empty")
    audio, sample_rate = sf.read(source)
    if audio.ndim > 1:
        audio = audio.mean(axis=1)
    if sample_rate != 16000:
        audio = resampy.resample(audio, sample_rate, 16000)
    peak = float(np.abs(audio).max()) if len(audio) else 0.0
    if peak <= 0:
        raise SystemExit("reference audio is empty or silent")
    audio = audio / peak * 0.95
    folder = profile_dir(args.voice)
    folder.mkdir(parents=True, exist_ok=True)
    sf.write(folder / "ref_voice.wav", audio.astype("float32"), 16000)
    (folder / "prompt.txt").write_text(prompt + "\n", encoding="utf-8")
    print(folder.resolve())


def cmd_clone(args: argparse.Namespace) -> None:
    require_consent(args)
    import soundfile as sf

    audio, prompt = resolve_profile(args.voice)
    model = load_model(args.device)
    wav = model.generate(
        text=args.text,
        prompt_wav_path=str(audio),
        prompt_text=prompt,
        reference_wav_path=str(audio),
        cfg_value=args.cfg,
        inference_timesteps=args.steps,
        max_len=args.max_len,
    )
    destination = output_path(args.output, f"{args.voice}-clone.wav")
    sf.write(destination, wav, model.tts_model.sample_rate)
    print(destination)


def cmd_design(args: argparse.Namespace) -> None:
    import soundfile as sf

    model = load_model(args.device)
    text = f"({args.description.strip()}){args.text.strip()}"
    wav = model.generate(
        text=text,
        cfg_value=args.cfg,
        inference_timesteps=args.steps,
        max_len=args.max_len,
    )
    destination = output_path(args.output, "designed-voice.wav")
    sf.write(destination, wav, model.tts_model.sample_rate)
    print(destination)


def cmd_dialogue(args: argparse.Namespace) -> None:
    require_consent(args)
    import numpy as np
    import soundfile as sf

    script_path = Path(args.script).expanduser().resolve()
    rows = json.loads(script_path.read_text(encoding="utf-8"))
    if not isinstance(rows, list) or not rows:
        raise SystemExit("dialogue JSON must be a non-empty list")
    parsed: list[tuple[str, str]] = []
    for index, row in enumerate(rows, 1):
        if not isinstance(row, dict) or not row.get("voice") or not row.get("text"):
            raise SystemExit(f"dialogue row {index} requires voice and text")
        parsed.append((safe_voice_name(str(row["voice"])), str(row["text"]).strip()))
    model = load_model(args.device)
    profiles = {name: resolve_profile(name) for name, _ in parsed}
    clips = []
    sample_rate = model.tts_model.sample_rate
    for index, (name, text) in enumerate(parsed, 1):
        audio, prompt = profiles[name]
        print(f"[{index}/{len(parsed)}] {name}: {text}")
        wav = model.generate(
            text=text,
            prompt_wav_path=str(audio),
            prompt_text=prompt,
            reference_wav_path=str(audio),
            cfg_value=args.cfg,
            inference_timesteps=args.steps,
            max_len=args.max_len,
        )
        clips.extend([wav, np.zeros(int(args.pause * sample_rate), dtype=wav.dtype)])
    destination = output_path(args.output, "dialogue.wav")
    sf.write(destination, np.concatenate(clips), sample_rate)
    print(destination)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Authorized local VoxCPM2 voice cloning")
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("doctor").set_defaults(func=cmd_doctor)
    sub.add_parser("list").set_defaults(func=cmd_list)

    importer = sub.add_parser("import-voice")
    importer.add_argument("--voice", required=True, type=safe_voice_name)
    importer.add_argument("--audio", required=True)
    importer.add_argument("--prompt-file", required=True)
    importer.add_argument("--consent", action="store_true")
    importer.set_defaults(func=cmd_import_voice)

    for name in ("clone", "design", "dialogue"):
        command = sub.add_parser(name)
        command.add_argument("--device", default="auto", choices=["auto", "cpu", "mps", "cuda", "xpu"])
        command.add_argument("--cfg", type=float, default=2.0)
        command.add_argument("--steps", type=int, default=10)
        command.add_argument("--max-len", type=int, default=4096)
        command.add_argument("--output")
        if name == "clone":
            command.add_argument("--voice", required=True, type=safe_voice_name)
            command.add_argument("--text", required=True)
            command.add_argument("--consent", action="store_true")
            command.set_defaults(func=cmd_clone)
        elif name == "design":
            command.add_argument("--description", required=True)
            command.add_argument("--text", required=True)
            command.set_defaults(func=cmd_design)
        else:
            command.add_argument("--script", required=True)
            command.add_argument("--pause", type=float, default=0.4)
            command.add_argument("--consent", action="store_true")
            command.set_defaults(func=cmd_dialogue)
    return parser


def main() -> None:
    args = build_parser().parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_SCRIPTS_VOICE_CLONER_PY

# voxcpm2-voice-cloner/scripts/record_ui.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/record_ui.py")"
cat > "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/record_ui.py" <<'CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_SCRIPTS_RECORD_UI_PY'
#!/usr/bin/env python3
"""Local-only Gradio UI for authorized VoxCPM2 reference recording/import."""

from __future__ import annotations

import argparse
import os
import time
import uuid
from pathlib import Path

import gradio as gr
import numpy as np
import resampy
import sounddevice as sd
import soundfile as sf

SAMPLE_RATE = 16000
SKILL_DIR = Path(__file__).resolve().parent.parent


def runtime_home() -> Path:
    return Path(os.environ.get("VOXCPM2_HOME", Path.home() / ".codex" / "voxcpm2-voice-cloner")).expanduser()


def voices_root() -> Path:
    return Path(os.environ.get("VOXCPM2_VOICES_DIR", runtime_home() / "voices")).expanduser()


def recordings_root() -> Path:
    return Path(os.environ.get("VOXCPM2_RECORDINGS_DIR", runtime_home() / "recordings")).expanduser()


def safe_name(value: str) -> str:
    name = value.strip()
    if not name or name in {".", ".."} or "/" in name or "\\" in name or "\x00" in name:
        raise ValueError("聲音名稱只能是一個安全的資料夾名稱")
    return name


def input_devices() -> list[str]:
    """Return backend-visible microphones for the In-App Browser UI."""
    devices: list[str] = []
    for index, device in enumerate(sd.query_devices()):
        if int(device["max_input_channels"]) > 0:
            devices.append(f"{index}: {device['name']}")
    return devices


def default_input_device(choices: list[str]) -> str | None:
    if not choices:
        return None
    try:
        default_name = str(sd.query_devices(kind="input")["name"])
    except Exception:
        return choices[0]
    return next((choice for choice in choices if choice.split(": ", 1)[-1] == default_name), choices[0])


def refresh_devices():
    choices = input_devices()
    return gr.Dropdown(
        choices=choices,
        value=default_input_device(choices),
        label="本機麥克風",
    ), ("✅ 已重新抓取本機麥克風。" if choices else "❌ 本機後端找不到可用麥克風。")


def record_from_backend(seconds: float, device_choice: str | None, consent: bool):
    """Record through local Python instead of browser media APIs."""
    if not consent:
        yield "❌ 錄音前請先確認你擁有此聲音或已取得說話者明確授權。", None
        return
    if not device_choice:
        yield "❌ 請先按「重新抓取麥克風」並選擇本機麥克風。", None
        return
    try:
        duration = float(seconds)
        if duration < 5 or duration > 120:
            raise ValueError
        device_index = int(device_choice.split(":", 1)[0])
    except (TypeError, ValueError):
        yield "❌ 錄音秒數必須介於 5 到 120 秒，且麥克風選擇必須有效。", None
        return

    for remaining in range(3, 0, -1):
        yield f"🎤 {remaining} 秒後開始錄音，請準備朗讀逐字稿。", None
        time.sleep(1)
    yield f"🔴 錄音中，請朗讀逐字稿（{duration:g} 秒）…", None

    try:
        frames = int(duration * SAMPLE_RATE)
        captured = sd.rec(
            frames,
            samplerate=SAMPLE_RATE,
            channels=1,
            dtype="float32",
            device=device_index,
        )
        sd.wait()
    except Exception as exc:
        yield f"❌ 本機錄音失敗：{type(exc).__name__}: {exc}", None
        return

    captured = np.asarray(captured).reshape(-1)
    peak = float(np.max(np.abs(captured))) if len(captured) else 0.0
    rms = float(np.sqrt(np.mean(np.square(captured)))) if len(captured) else 0.0
    if peak <= 0.001 or rms <= 0.0001:
        yield f"❌ 錄音為靜音或音量過低（peak={peak:.4f}, rms={rms:.4f}）。", None
        return

    temp_dir = recordings_root()
    temp_dir.mkdir(parents=True, exist_ok=True)
    temp_path = temp_dir / f"recording-{uuid.uuid4().hex}.wav"
    sf.write(temp_path, captured.astype("float32"), SAMPLE_RATE)
    yield f"✅ 錄音完成（peak={peak:.4f}, rms={rms:.4f}），請先預覽，再儲存 Profile。", str(temp_path)


def save_recording(audio_path: str | None, voice_name: str, transcript: str, consent: bool):
    if not consent:
        return "❌ 請確認你擁有此聲音或已取得說話者明確授權。", None
    if not audio_path:
        return "❌ 請先錄音或上傳音檔。", None
    try:
        name = safe_name(voice_name)
    except ValueError as exc:
        return f"❌ {exc}", None
    text = transcript.strip()
    if not text:
        return "❌ 逐字稿不可空白，且必須與參考音訊完全相符。", None
    audio, sample_rate = sf.read(audio_path)
    if audio.ndim > 1:
        audio = audio.mean(axis=1)
    if sample_rate != SAMPLE_RATE:
        audio = resampy.resample(audio, sample_rate, SAMPLE_RATE)
    peak = float(np.abs(audio).max()) if len(audio) else 0.0
    if peak <= 0:
        return "❌ 音檔是空白或靜音。", None
    audio = audio / peak * 0.95
    folder = voices_root() / name
    folder.mkdir(parents=True, exist_ok=True)
    wav_path = folder / "ref_voice.wav"
    sf.write(wav_path, audio.astype("float32"), SAMPLE_RATE)
    (folder / "prompt.txt").write_text(text + "\n", encoding="utf-8")
    return f"✅ 已儲存授權聲音：{folder.resolve()}", str(wav_path)


def build_ui():
    default_text = (SKILL_DIR / "assets" / "sample_text.txt").read_text(encoding="utf-8").strip()
    devices = input_devices()
    with gr.Blocks(title="VoxCPM2 授權聲音錄製") as app:
        gr.Markdown("# VoxCPM2 授權聲音錄製\n僅可錄製自己的聲音，或已取得說話者明確授權的聲音。")
        voice = gr.Textbox(label="聲音名稱")
        transcript = gr.Textbox(label="精確逐字稿", value=default_text, lines=6)
        consent = gr.Checkbox(label="我確認擁有此聲音或已取得說話者明確授權")
        gr.Markdown("## In-App Browser 本機錄音\n錄音由本機後端擷取，不依賴瀏覽器的麥克風裝置清單。")
        with gr.Row():
            device = gr.Dropdown(
                choices=devices,
                value=default_input_device(devices),
                label="本機麥克風",
            )
            refresh = gr.Button("重新抓取麥克風")
        seconds = gr.Slider(5, 120, value=20, step=1, label="錄音秒數")
        record = gr.Button("開始本機錄音", variant="secondary")
        audio = gr.Audio(label="錄音預覽／上傳既有音檔", type="filepath", sources=["upload"])
        save = gr.Button("儲存授權聲音", variant="primary")
        result = gr.Textbox(label="結果", interactive=False)
        preview = gr.Audio(label="已儲存 Profile 預覽", interactive=False)
        refresh.click(refresh_devices, [], [device, result])
        record.click(record_from_backend, [seconds, device, consent], [result, audio])
        save.click(save_recording, [audio, voice, transcript, consent], [result, preview])
    return app


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=7860)
    args = parser.parse_args()
    if args.host not in {"127.0.0.1", "localhost", "::1"}:
        raise SystemExit("recording UI must bind to a loopback address")
    home = runtime_home()
    recordings = recordings_root()
    voices = voices_root()
    recordings.mkdir(parents=True, exist_ok=True)
    voices.mkdir(parents=True, exist_ok=True)
    build_ui().launch(
        server_name=args.host,
        server_port=args.port,
        share=False,
        allowed_paths=[str(recordings), str(voices)],
    )


if __name__ == "__main__":
    main()

CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_SCRIPTS_RECORD_UI_PY

# voxcpm2-voice-cloner/scripts/record_cli.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/record_cli.py")"
cat > "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/record_cli.py" <<'CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_SCRIPTS_RECORD_CLI_PY'
#!/usr/bin/env python3
"""Record an authorized VoxCPM2 voice profile without browser microphone APIs."""

from __future__ import annotations

import argparse
import os
import time
from pathlib import Path

import numpy as np
import sounddevice as sd
import soundfile as sf

SAMPLE_RATE = 16000
SKILL_DIR = Path(__file__).resolve().parent.parent


def runtime_home() -> Path:
    return Path(os.environ.get("VOXCPM2_HOME", Path.home() / ".codex" / "voxcpm2-voice-cloner")).expanduser()


def voices_root() -> Path:
    return Path(os.environ.get("VOXCPM2_VOICES_DIR", runtime_home() / "voices")).expanduser()


def safe_name(value: str) -> str:
    name = value.strip()
    if not name or name in {".", ".."} or "/" in name or "\\" in name or "\x00" in name:
        raise argparse.ArgumentTypeError("voice name must be one directory-safe name")
    return name


def main() -> None:
    parser = argparse.ArgumentParser(description="Record an authorized local VoxCPM2 voice profile")
    parser.add_argument("--voice", required=True, type=safe_name)
    parser.add_argument("--seconds", type=float, default=20.0)
    parser.add_argument("--delay", type=int, default=15)
    parser.add_argument("--device", help="sounddevice input device id or exact name")
    parser.add_argument("--consent", action="store_true")
    args = parser.parse_args()

    if not args.consent:
        raise SystemExit("Refusing real-voice recording without --consent confirming speaker permission.")
    if args.seconds <= 0 or args.seconds > 120:
        raise SystemExit("--seconds must be between 0 and 120")

    transcript = (SKILL_DIR / "assets" / "sample_text.txt").read_text(encoding="utf-8").strip()
    device = int(args.device) if args.device and args.device.isdigit() else args.device
    selected = sd.query_devices(device, "input") if device is not None else sd.query_devices(kind="input")

    print(f"voice={args.voice}")
    print(f"input_device={selected['name']}")
    print(f"record_seconds={args.seconds}")
    print("Read this text exactly:")
    print(transcript)
    for remaining in range(args.delay, 0, -1):
        print(f"recording_starts_in={remaining}", flush=True)
        time.sleep(1)

    print("recording_started", flush=True)
    frames = int(args.seconds * SAMPLE_RATE)
    audio = sd.rec(frames, samplerate=SAMPLE_RATE, channels=1, dtype="float32", device=device)
    sd.wait()
    audio = np.asarray(audio).reshape(-1)
    peak = float(np.max(np.abs(audio))) if len(audio) else 0.0
    rms = float(np.sqrt(np.mean(np.square(audio)))) if len(audio) else 0.0
    if peak <= 0.001 or rms <= 0.0001:
        raise SystemExit(f"Recording is silent or too quiet: peak={peak:.6f} rms={rms:.6f}")
    if peak > 1.0:
        audio = audio / peak

    folder = voices_root() / args.voice
    folder.mkdir(parents=True, exist_ok=True)
    wav_path = folder / "ref_voice.wav"
    sf.write(wav_path, audio.astype("float32"), SAMPLE_RATE)
    (folder / "prompt.txt").write_text(transcript + "\n", encoding="utf-8")

    print("recording_saved")
    print(f"profile={folder.resolve()}")
    print(f"audio={wav_path.resolve()}")
    print(f"peak={peak:.6f}")
    print(f"rms={rms:.6f}")


if __name__ == "__main__":
    main()
CODEX_LAZYPACK_VOXCPM2_VOICE_CLONER_SCRIPTS_RECORD_CLI_PY

chmod +x "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/setup_runtime.sh" "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/voice_cloner.py" "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/record_ui.py" "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/record_cli.py"

test -f "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/SKILL.md" && echo "voxcpm2-voice-cloner installed"
````

<!-- END EMBEDDED_SKILLS -->
