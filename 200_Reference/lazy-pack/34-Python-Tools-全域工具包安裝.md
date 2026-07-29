# 34-Python-Tools-全域工具包安裝

> 來源：`mathruffian-dot/ai-agent-ep03`。本版將來源檔案 `EP03 教學檔案處理工具列表｜老師的 Python 神器清單` 改名為 `Python 工具列表`，並把安裝流程整理成可重建的全域 Python runtime。

## 用途

這個安裝包讓 Codex、Claude Code、AntiGravity／Gemini 與所有專案共用同一套 Python 檔案處理工具，而不是每個 Agent 或每個 repo 各自建立一份 `.venv`。

已涵蓋：

- Word：`python-docx`、`docxcompose`
- Excel：`openpyxl`、`xlsxwriter`、`pandas`
- PowerPoint：`python-pptx`
- PDF：`pypdf`、`PyMuPDF`、`pdfplumber`、`pdf2image`、`reportlab`、`fpdf2`、`ocrmypdf`
- 圖片與圖表：`pillow`、`matplotlib`、`qrcode`
- 轉檔與 AI 前處理：`markitdown[pdf,docx,pptx,xlsx]`
- 影音輔助：`edge-tts`、`yt-dlp`、`youtube-transcript-api`、Groq SDK
  `1.6.0`、ElevenLabs SDK `2.59.0`、OpenCC
  `opencc-python-reimplemented 0.1.7`
- 影片共用命令：官方 Auto-Editor `31.4.0` standalone、FFmpeg Full
  `ffmpeg` / `ffprobe` wrappers；FFmpeg Full 含 `subtitles`、`ass`、
  `drawtext` 與 libass
- Windows Office 自動化項：`pywin32`。這是 Windows-only；安裝腳本只會在 Windows native bash (`MINGW` / `MSYS` / `CYGWIN`) 環境加入，不安裝到 macOS / Linux / WSL runtime。
- 常用技能 runtime wrapper：`audio-to-md`、`voxcpm2-voice-cloner`、`doc-to-md`、`vlm-to-md`

工具用途頁面見同資料夾：

```text
Python 工具列表.md
```

## 建議安裝位置

```text
{{CODEX_HOME}}/python-tools/
{{CODEX_HOME}}/python-tools/teaching-file-tools/.venv/
{{CODEX_HOME}}/python-tools/bin/
```

這個資料夾應放在本機，不要放進 Google Drive / iCloud / Dropbox 同步資料夾。它只放通用教學檔案處理 venv、共用 wrapper 與少量工具快取；大型或技能專屬 runtime 不放進 `python-tools`。

固定邊界：

- 通用 Python 檔案處理 venv：`{{CODEX_HOME}}/python-tools/teaching-file-tools/.venv`
- 共用 wrapper：`{{CODEX_HOME}}/python-tools/bin`
- 三 Agent 中立入口：`{{HOME}}/.local/share/agent-tools/python-tools`，由 LazyPack Item 16 的 chezmoi template 指向本機 `python-tools` runtime
- shell loader：`{{HOME}}/.config/agent-tools/python-tools.env`，由 Item 16 安全載入 `.zshenv`、`.zprofile`、`.profile` 與 `.bash_profile`
- 技能專屬 runtime：`{{CODEX_HOME}}/audio-to-md`、`{{CODEX_HOME}}/voxcpm2-voice-cloner`、`{{CODEX_HOME}}/doc-to-md`、`{{CODEX_HOME}}/vlm-to-md`
- uv 套件快取：維持 `{{HOME}}/.cache/uv`，不要搬進 `python-tools`
- uv tool 安裝清單與工具環境：維持 `{{HOME}}/.local/share/uv`，不要搬進 `python-tools`
- 其他 `{{HOME}}/.cache/` 模型或工具快取：維持原位，除非單一 skill 文件明確指定自己的本機 runtime cache

每個專案要使用時，呼叫：

```bash
{{CODEX_HOME}}/python-tools/bin/python-tools-python -c "import pandas; print('ok')"
```

安裝 Item 16 後，三個 Agent 都可以直接呼叫同一個指令：

```bash
python-tools-python -c "import pandas; print('ok')"
```

| 執行端 | 共用入口 | 執行方式 |
| --- | --- | --- |
| Codex App / Codex CLI | `{{HOME}}/.local/share/agent-tools/python-tools/bin` | 由 Agent terminal 直接呼叫 wrapper；若 sandbox 限制寫入，依任務加入最小 writable root |
| Claude Code | 同一個中立 `bin` | 由 Claude terminal 直接呼叫相同 wrapper 名稱 |
| AntiGravity / Gemini CLI | 同一個中立 `bin` | 由 Gemini terminal 直接呼叫相同 wrapper 名稱 |

三個 adapter 的工具行為、參數與輸出完全相同，不需要三份腳本。若某個 Agent 的非互動 shell 沒有載入 profile，執行：

```bash
. "{{HOME}}/.config/agent-tools/python-tools.env"
```

或直接使用中立入口的絕對路徑。不要手動在三個 Agent 的設定檔各加一份 PATH。

## 新電腦完整重建順序

1. 依 Item 16 安裝 chezmoi，執行 `bootstrap-agent-sync.sh --dry-run` 後再 `--apply`。這會建立三個 Agent 的規則／skills 入口、Python bridge、env loader 與不覆蓋既有內容的 zsh／bash profile 標記區塊。
2. 執行本 Item 34 的 `install_python_tools.sh`，在本機重建 Python 3.12 runtime 與核心 wrappers。
3. 需要現有完整 wrapper 組合時，再依下表安裝對應 LazyPack 項目；每個項目都把 wrapper 寫進同一個共用 `bin`。
4. 開新終端或新 Agent 對話，或 source 共用 env loader。
5. 執行 Item 16 bootstrap dry-run、`chezmoi status`、Item 34 驗證腳本與 repo `sync-health.sh`。

Item 16 和 Item 34 的先後可互換：若先跑 Item 16，bridge 會先存在並回報 Item 34 尚未安裝；Item 34 完成後該 bridge 會立即生效。venv 必須在每台電腦重建，不放進 chezmoi、Git、Google Drive、LazyPack 或 Obsidian。

### Wrapper 來源與完整功能

| Wrapper | 來源 | 新電腦如何重建 |
| --- | --- | --- |
| `python-tools-python`、`edge-tts`、`markitdown`、`ocrmypdf`、`yt-dlp`、`auto-editor`、FFmpeg Full `ffmpeg` / `ffprobe` | Item 34 | 執行本 Item 安裝腳本 |
| `cli-hub` | Item 12 | 執行外部工具整合工作流內建 installer |
| `doc-to-md`、`vlm-to-md` | Item 18 | 安裝 Document-to-Markdown skill 與 runtime |
| `voxcpm2-python` | Item 32 | 安裝 VoxCPM2 Voice Cloner runtime |
| `audio-to-md`、`audio-to-md-python` | Item 33 + Item 34 | 先安裝 Audio-to-Markdown runtime，再由 Item 34 建立共用 runtime 入口 |
| `whisper-cli`、`sensevoice-cli`、`macwhisper-cli` | Item 29 | 執行 Video Processing Automation 內建 optional video tools installer |
| `taigi-teaching-agent` | Item 35 | 執行 Taigi Teaching Agent installer |
| `voice-reply`、專用 `edge-tts` | Item 37 | 安裝 Voice Reply skill 與 runtime；可取代 Item 34 的通用 `edge-tts` wrapper，但仍使用同一共用入口 |

這張表是「和維護者電腦達到同等功能」的重建清單；缺少選用項目時，bridge 仍正常，只會缺少該項目負責的 wrapper。

## 安裝腳本

本 repo 提供可重建腳本：

```text
{{SETUP_REPO}}/200_Reference/scripts/python-tools/install_python_tools.sh
{{SETUP_REPO}}/200_Reference/scripts/python-tools/verify_python_tools.py
```

執行：

```bash
bash "{{SETUP_REPO}}/200_Reference/scripts/python-tools/install_python_tools.sh"
```

預設會在 macOS + Homebrew 環境安裝必要系統工具：

```text
tesseract
tesseract-lang
ghostscript
poppler
ffmpeg-full
imagemagick
```

若只想安裝 Python venv，不動系統工具：

```bash
INSTALL_SYSTEM_TOOLS=0 bash "{{SETUP_REPO}}/200_Reference/scripts/python-tools/install_python_tools.sh"
```

若也要安裝 LibreOffice，讓 `soffice` 可用於 Office 轉檔：

```bash
INSTALL_OFFICE_TOOLS=1 bash "{{SETUP_REPO}}/200_Reference/scripts/python-tools/install_python_tools.sh"
```

驗證：

```bash
"{{CODEX_HOME}}/python-tools/bin/python-tools-python" \
  "{{SETUP_REPO}}/200_Reference/scripts/python-tools/verify_python_tools.py"
```

## 既有 runtime 歸檔方式

若本機已安裝舊 runtime：

```text
{{CODEX_HOME}}/voxcpm2-voice-cloner/
{{HOME}}/.audio-to-md/
{{HOME}}/.doc-to-md/
{{HOME}}/.vlm-to-md/
```

安裝腳本會在目標不存在時移到：

```text
{{CODEX_HOME}}/voxcpm2-voice-cloner/
{{CODEX_HOME}}/audio-to-md/
{{CODEX_HOME}}/doc-to-md/
{{CODEX_HOME}}/vlm-to-md/
```

然後移除舊入口 symlink。不要在下列路徑保留相容 symlink：

```text
{{HOME}}/.audio-to-md
{{HOME}}/.doc-to-md
{{HOME}}/.vlm-to-md
{{CODEX_HOME}}/python-tools/audio-to-md
{{CODEX_HOME}}/python-tools/voxcpm2-voice-cloner
```

技能本身直接呼叫 `{{CODEX_HOME}}/<skill-name>/...`；`{{CODEX_HOME}}/python-tools/bin` 只保留方便跨專案使用的 wrapper。

## 系統相依

Python 套件之外，部分功能需要系統工具：

| 工具 | 用途 | macOS |
| --- | --- | --- |
| Tesseract + language data | `ocrmypdf` OCR，繁中需 `chi_tra` | `brew install tesseract tesseract-lang` |
| Ghostscript / `gs` | `ocrmypdf` 產生 PDF/A 或處理部分 PDF 流程 | `brew install ghostscript` |
| Poppler / `pdftoppm` | `pdf2image` PDF 轉圖 | `brew install poppler` |
| FFmpeg Full | `yt-dlp` 合併影音、libass 字幕、`drawtext`、影片混音 | `brew install ffmpeg-full` |
| ImageMagick | 本機標題卡與圖片前處理 | `brew install imagemagick` |
| Microsoft Word 或 LibreOffice | `docx2pdf` / Office 轉 PDF | 安裝 Office 或 LibreOffice |

安裝腳本預設會在 macOS + Homebrew 上安裝 `tesseract`、`tesseract-lang`、`ghostscript`、`poppler`、`ffmpeg-full` 與 `imagemagick`，並把 keg-only 的 FFmpeg Full 經共用 wrapper 放到三 Agent 的中立命令入口。LibreOffice / Microsoft Office 屬大型 GUI app 或商業軟體，預設不安裝；需要 `soffice` 時用 `INSTALL_OFFICE_TOOLS=1` 跑腳本，或自行安裝 Microsoft Office / LibreOffice。安裝完系統工具後，通常要重開終端，並對 Codex、Claude、AntiGravity 分別開新對話或重載環境，PATH 才會刷新。

### Tesseract 安裝與 Homebrew 權限修復

先安裝 OCR 主程式、語言包與 Ghostscript：

```bash
brew install tesseract tesseract-lang ghostscript
```

如果安裝長時間停在 `Fetching downloads`、依賴安裝前無進展，或 `brew doctor` 顯示 Homebrew 目錄不可寫，先檢查：

```bash
brew doctor
ls -ld /opt/homebrew "{{HOME}}/Library/Caches/Homebrew" "{{HOME}}/Library/Logs/Homebrew"
```

若 `brew doctor` 顯示下列路徑不可寫：

```text
/opt/homebrew
{{HOME}}/Library/Caches/Homebrew
{{HOME}}/Library/Logs/Homebrew
```

先嘗試不用 sudo 的寫入權限修復：

```bash
chmod -R u+w /opt/homebrew "{{HOME}}/Library/Caches/Homebrew" "{{HOME}}/Library/Logs/Homebrew"
brew doctor
```

若 `brew doctor` 仍顯示 owner 不是目前使用者，才用 sudo 修擁有者：

```bash
sudo chown -R "$(whoami)" /opt/homebrew "{{HOME}}/Library/Caches/Homebrew" "{{HOME}}/Library/Logs/Homebrew"
chmod -R u+w /opt/homebrew "{{HOME}}/Library/Caches/Homebrew" "{{HOME}}/Library/Logs/Homebrew"
brew doctor
```

`brew doctor` 看到 `Your system is ready to brew.` 後，再重跑：

```bash
brew install tesseract tesseract-lang ghostscript
```

驗證 OCR 與繁中語言包：

```bash
tesseract --version
gs --version
tesseract --list-langs | grep -E '^(chi_tra|chi_sim|eng|osd)$'
```

## 本機實作紀錄

本機已完成：

- 建立 `{{CODEX_HOME}}/python-tools/teaching-file-tools/.venv`
- 使用 `uv` 建立 Python 3.12.13 venv，避開系統 Python 3.14.6 的套件相容風險
- 安裝來源工具包指定的核心 Python 套件與影音選用套件；`markitdown` 改用 `markitdown[pdf,docx,pptx,xlsx]`，確保 PDF / Word / PowerPoint / Excel 轉 Markdown 依賴完整
- 影音共用工具更新為 Auto-Editor `31.4.0`、FFmpeg Full `8.1.2_1`、
  ImageMagick `7.1.2-29`、Groq SDK `1.6.0`、ElevenLabs SDK `2.59.0`
  與 OpenCC `0.1.7`
- FFmpeg Full 已驗證 `subtitles`、`ass`、`drawtext`、`loudnorm` 與
  `sidechaincompress`；一般 Homebrew FFmpeg 可並存，但三 Agent PATH
  優先使用共用 Full wrapper
- 安裝 `tesseract 5.5.2`、`tesseract-lang 4.1.0` 與 `ghostscript 10.07.1`，並確認 `poppler` / `pdftoppm`、`ffmpeg`、`soffice` 可用；語言包包含 `chi_tra`、`chi_sim`、`eng`、`osd`
- 保留 `{{HOME}}/.cache/uv` 與 `{{HOME}}/.local/share/uv` 原位，不移入 `python-tools`
- 將技能 runtime 整理為本機實體資料夾：`{{CODEX_HOME}}/audio-to-md`、`{{CODEX_HOME}}/voxcpm2-voice-cloner`、`{{CODEX_HOME}}/doc-to-md`、`{{CODEX_HOME}}/vlm-to-md`
- 移除舊路徑 symlink，並把實際入口改成對應的 `{{CODEX_HOME}}/<skill-name>` 路徑
- 建立 wrapper：
  - `python-tools-python`
  - `auto-editor`
  - `ffmpeg`
  - `ffprobe`
  - `edge-tts`
  - `cli-hub`
  - `audio-to-md`
  - `audio-to-md-python`
  - `whisper-cli`
  - `sensevoice-cli`
  - `macwhisper-cli`
  - `voxcpm2-python`
  - `doc-to-md`
  - `vlm-to-md`
  - `taigi-teaching-agent`
  - `voice-reply`
- 使用 Item 16 建立 `{{HOME}}/.local/share/agent-tools/python-tools` 中立 bridge 與 `{{HOME}}/.config/agent-tools/python-tools.env`，並確認 Codex、Claude、AntiGravity 的新 shell 都能找到相同 wrapper

本機驗證：

```text
python-tools-python import 驗證：通過，包含 markitdown extras 的 `mammoth`
verify_python_tools.py 系統工具驗證：tesseract / gs / pdftoppm / FFmpeg Full / ffprobe / ImageMagick / soffice 全部 OK
audio-to-md --help：通過
doc-to-md --help：通過
vlm-to-md --help：通過
NotebookLM MCP --help：通過，仍使用 {{HOME}}/.local/share/uv tool 環境
VoxCPM2 doctor：通過，mps=True
```

目前本機 `{{CODEX_HOME}}/python-tools` 只保留通用 venv 與 wrapper；VoxCPM2、Whisper、doc-to-md、vlm-to-md 等技能 runtime 各自放在 `{{CODEX_HOME}}/<skill-name>`。

## 踩坑與修正

- `python3` 是 3.14.6 時，不適合直接當教學工具 runtime 基準；改用 `uv venv --python 3.12`。
- `uv` venv 不一定內建 `pip`，不要用 `python -m pip freeze` 當唯一驗證；可用 `uv pip` 或 `importlib.metadata`。
- `markitdown` 只裝裸套件時不一定包含所有文件格式依賴；安裝腳本固定使用 `markitdown[pdf,docx,pptx,xlsx]`，驗證腳本另外檢查 `mammoth`，避免 Word 轉 Markdown 依賴缺漏。
- `{{HOME}}/.cache/uv` 是 uv cache，維持原位；`{{HOME}}/.local/share/uv` 是 uv tool 安裝清單與工具環境，也維持原位。
- `{{HOME}}/.local/share/uv` 不是和 `{{HOME}}/.cache/uv` 重複的快取；它可能包含 `notebooklm-mcp` 這類 uv tool 的可執行環境。若誤移，venv 內的 shebang 與 `bin/python` symlink 會斷，應還原到 `{{HOME}}/.local/share/uv` 或重裝該 uv tool。
- Codex 沙盒不一定能寫 `{{CODEX_HOME}}/python-tools/matplotlib-cache`；wrapper 需在不可寫時 fallback 到 `TMPDIR`。
- Codex sandbox writable roots 是持久安全設定。不要在 LazyPack 安裝腳本中自動改 `{{CODEX_CONFIG}}`；若使用者要讓 Codex 直接寫入 `{{CODEX_HOME}}/audio-to-md`、`{{CODEX_HOME}}/doc-to-md`、`{{CODEX_HOME}}/vlm-to-md` 或 `{{CODEX_HOME}}/python-tools`，應由使用者明確批准後再加入窄範圍 writable roots。
- `brew install tesseract tesseract-lang` 可能長時間卡住；這次實際原因是 Homebrew 目錄權限不可寫。先跑 `brew doctor`，必要時修 `/opt/homebrew`、`{{HOME}}/Library/Caches/Homebrew`、`{{HOME}}/Library/Logs/Homebrew` 的 owner / user write 權限，再重跑安裝。
- Tesseract 主程式、繁中語言包與 Ghostscript 是 OCR 能力的關鍵；只安裝 `ocrmypdf` Python 套件不等於掃描 PDF OCR 可用。
- `pywin32` 只用於 Windows Office COM 自動化；macOS / Linux / WSL runtime 不安裝。若安裝腳本偵測到 Windows native bash (`MINGW` / `MSYS` / `CYGWIN`)，會把 `pywin32` 加進同一個 Windows venv。
- 搬移或跨機同步 `.venv` 會受到作業系統、CPU、Python ABI 與絕對路徑影響；每台電腦都應重建 runtime。只對 runtime 根目錄建立中立 bridge，不對 venv 內部檔案建立相容 symlink。
- 直接把整份 `.zshenv`、`.zprofile`、`.profile` 或 `.bash_profile` 收進 chezmoi 會覆蓋使用者既有 API key loader、Homebrew 或 alias；Item 16 使用 `modify_` scripts，只維護 `agent-python-tools` 標記區塊，遇到不完整或重複標記會停止。
- Agent 對話在啟動時取得 PATH；安裝完成後既有對話可能看不到新 wrapper。開新對話／終端，或 source `{{HOME}}/.config/agent-tools/python-tools.env`。
- Homebrew `ffmpeg-full` 是 keg-only，不能假設 `/opt/homebrew/bin/ffmpeg`
  會自動變成 Full build；Item 34 固定建立共用 `ffmpeg` / `ffprobe`
  wrapper，避免 `subtitles` / `drawtext` 因 PATH 又落回精簡版。
- Auto-Editor 的 PyPI 版可能落後官方 standalone release；Item 34 使用
  固定版本與 SHA-256 安裝官方 binary，不再從 user-level Python 找舊版。
- 不安裝官方 Python `openai-whisper`：現有 faster-whisper 與
  whisper.cpp 已分別覆蓋本機正式備援與明確快速預覽，避免加入 PyTorch
  與另一份重複的大型模型。正式 STT 的第一順位仍是 Groq
  `whisper-large-v3-turbo`；`whisper-cli` 是 whisper.cpp 的命令，不是
  官方 Python `whisper`。
- `.zprofile`、Homebrew 或 user-level Python 可能在 `.zshenv` 之後再次 prepend PATH，讓舊版同名指令先被找到。Item 16 讓同一 loader 在後續 profile 再執行；loader 會去除重複 bridge 路徑並把它放回最前面。
- 技能專屬 runtime 不應集中到 `python-tools`。`python-tools` 是通用 Python 工具包；`audio-to-md`、`voxcpm2-voice-cloner`、`doc-to-md`、`vlm-to-md` 應保留在 `{{CODEX_HOME}}/<skill-name>`，再由 `{{CODEX_HOME}}/python-tools/bin` 提供跨專案 wrapper。

## 安裝後檢查清單

```bash
test ! -e "{{HOME}}/.audio-to-md"
test ! -e "{{HOME}}/.doc-to-md"
test ! -e "{{HOME}}/.vlm-to-md"
test ! -e "{{CODEX_HOME}}/python-tools/audio-to-md"
test ! -e "{{CODEX_HOME}}/python-tools/voxcpm2-voice-cloner"
test ! -d "{{CODEX_HOME}}/python-tools/uv"
test -d "{{HOME}}/.cache/uv"
test -d "{{HOME}}/.local/share/uv"
test -L "{{HOME}}/.local/share/agent-tools/python-tools"
test "$(readlink "{{HOME}}/.local/share/agent-tools/python-tools")" = "{{CODEX_HOME}}/python-tools"
test -f "{{HOME}}/.config/agent-tools/python-tools.env"
zsh -lc 'command -v python-tools-python'

"{{CODEX_HOME}}/python-tools/bin/python-tools-python" \
  "{{SETUP_REPO}}/200_Reference/scripts/python-tools/verify_python_tools.py"
"{{CODEX_HOME}}/audio-to-md/audio-to-md" --help
"{{CODEX_HOME}}/doc-to-md/doc-to-md" --help
"{{CODEX_HOME}}/vlm-to-md/vlm-to-md" --help
"{{CODEX_HOME}}/voxcpm2-voice-cloner/.venv/bin/python" \
  "{{SYNC_ROOT}}/skills/voxcpm2-voice-cloner/scripts/voice_cloner.py" doctor
"{{HOME}}/.local/bin/notebooklm-mcp" --help
tesseract --list-langs | grep -E '^(chi_tra|chi_sim|eng|osd)$'
gs --version
```

若 `verify_python_tools.py` 顯示 `MISSING tesseract` 或 `MISSING gs`，代表 Python 套件已裝好，但掃描 PDF OCR 還缺系統工具；安裝 `tesseract`、語言包與 `ghostscript` 後再重跑驗證。若已安裝但仍找不到，重開終端機或確認 `/opt/homebrew/bin` 在 PATH 內。

## 內建安裝腳本內容

以下內容與 repo 腳本 `200_Reference/scripts/python-tools/install_python_tools.sh` 等價；下載者也可以直接使用 repo 腳本。

<!-- BEGIN EMBEDDED_SCRIPT:install_python_tools.sh -->

```bash
#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PYTHON_TOOLS_HOME="${PYTHON_TOOLS_HOME:-$CODEX_HOME/python-tools}"
PYTHON_TOOLS_VENV="$PYTHON_TOOLS_HOME/teaching-file-tools/.venv"
UV_BIN="${UV_BIN:-}"
INSTALL_SYSTEM_TOOLS="${INSTALL_SYSTEM_TOOLS:-1}"
INSTALL_OFFICE_TOOLS="${INSTALL_OFFICE_TOOLS:-0}"
INSTALL_AUTO_EDITOR="${INSTALL_AUTO_EDITOR:-1}"
AUTO_EDITOR_VERSION="${AUTO_EDITOR_VERSION:-31.4.0}"
EXTRA_PIP_PACKAGES=()

log() {
  printf '[python-tools] %s\n' "$*"
}

is_macos() {
  [ "$(uname -s)" = "Darwin" ]
}

install_macos_system_tools() {
  if ! is_macos; then
    log "INSTALL_SYSTEM_TOOLS=1 is currently implemented for macOS/Homebrew only; skipping OS packages."
    return
  fi
  if ! command -v brew >/dev/null 2>&1; then
    printf 'Homebrew is required for macOS system tools. Install Homebrew, then rerun this script.\n' >&2
    exit 1
  fi

  log "installing macOS system tools: tesseract, language data, ghostscript, poppler, ffmpeg-full, ImageMagick"
  brew install tesseract tesseract-lang ghostscript poppler ffmpeg-full imagemagick

  if [ "$INSTALL_OFFICE_TOOLS" = "1" ]; then
    log "installing LibreOffice for soffice/docx conversion support"
    brew install --cask libreoffice
  fi
}

if [ "$INSTALL_SYSTEM_TOOLS" = "1" ]; then
  install_macos_system_tools
fi

if [ -z "$UV_BIN" ]; then
  if command -v uv >/dev/null 2>&1; then
    UV_BIN="$(command -v uv)"
  elif [ -x /opt/homebrew/bin/uv ]; then
    UV_BIN=/opt/homebrew/bin/uv
  elif is_macos && command -v brew >/dev/null 2>&1; then
    log "uv not found; installing uv with Homebrew"
    brew install uv
    UV_BIN="$(command -v uv)"
  else
    echo "uv is required. Install uv first, then rerun this script." >&2
    exit 1
  fi
fi

mkdir -p "$PYTHON_TOOLS_HOME/bin" "$PYTHON_TOOLS_HOME/matplotlib-cache"

"$UV_BIN" venv --python 3.12 "$PYTHON_TOOLS_VENV"

install_auto_editor() {
  os="$(uname -s)"
  arch="$(uname -m)"
  case "$os/$arch" in
    Darwin/arm64)
      asset="auto-editor-macos-arm64"
      digest="14707c80f4fae359c344e160b028366ec7de3b85362df11067ea1c01422ea799"
      ;;
    Darwin/x86_64)
      asset="auto-editor-macos-x86_64"
      digest="de2fa7ab430f5e7252c4b0a495338e10bbcce4537d7d9b0409f43c57aad972ff"
      ;;
    Linux/aarch64|Linux/arm64)
      asset="auto-editor-linux-aarch64"
      digest="83217a9e2117ea628c90b6bb1981c3aa22902cd33a245b743196039b4feb6865"
      ;;
    Linux/x86_64)
      asset="auto-editor-linux-x86_64"
      digest="495aafb6609e2ab8155f2ff854f213907457c84743ad0ed0ce6f5c7123fea670"
      ;;
    *)
      log "No pinned Auto-Editor binary for $os/$arch; install the official release manually."
      return
      ;;
  esac

  temp_dir="$(mktemp -d)"
  archive="$temp_dir/$asset"
  url="https://github.com/WyattBlue/auto-editor/releases/download/$AUTO_EDITOR_VERSION/$asset"
  curl --http1.1 -fL --retry 5 --retry-delay 2 "$url" -o "$archive"
  if command -v shasum >/dev/null 2>&1; then
    printf '%s  %s\n' "$digest" "$archive" | shasum -a 256 -c -
  else
    printf '%s  %s\n' "$digest" "$archive" | sha256sum -c -
  fi
  install -m 755 "$archive" "$PYTHON_TOOLS_HOME/bin/auto-editor"
  rm -rf "$temp_dir"
}

if [ "$INSTALL_AUTO_EDITOR" = "1" ]; then
  install_auto_editor
fi

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    EXTRA_PIP_PACKAGES+=(pywin32)
    ;;
esac

"$UV_BIN" pip install \
  --python "$PYTHON_TOOLS_VENV/bin/python" \
  python-docx docxcompose openpyxl xlsxwriter pandas python-pptx \
  pypdf PyMuPDF pdfplumber pdf2image reportlab fpdf2 pillow matplotlib \
  qrcode 'markitdown[pdf,docx,pptx,xlsx]' ocrmypdf docx2pdf edge-tts yt-dlp youtube-transcript-api \
  'groq==1.6.0' 'elevenlabs==2.59.0' 'opencc-python-reimplemented==0.1.7' \
  "${EXTRA_PIP_PACKAGES[@]}"

cat > "$PYTHON_TOOLS_HOME/bin/python-tools-python" <<SH
#!/usr/bin/env bash
set -euo pipefail
CACHE_ROOT="\${MPLCONFIGDIR:-$PYTHON_TOOLS_HOME/matplotlib-cache}"
if [ ! -d "\$CACHE_ROOT" ] || [ ! -w "\$CACHE_ROOT" ]; then
  CACHE_ROOT="\${TMPDIR:-/tmp}/codex-python-tools-matplotlib-cache"
  mkdir -p "\$CACHE_ROOT"
fi
export MPLCONFIGDIR="\$CACHE_ROOT"
exec "$PYTHON_TOOLS_VENV/bin/python" "\$@"
SH
chmod +x "$PYTHON_TOOLS_HOME/bin/python-tools-python"

write_venv_command_wrapper() {
  command_name="$1"
  if [ ! -x "$PYTHON_TOOLS_VENV/bin/$command_name" ]; then
    return
  fi
  cat > "$PYTHON_TOOLS_HOME/bin/$command_name" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$PYTHON_TOOLS_VENV/bin/$command_name" "\$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/$command_name"
}

for command_name in edge-tts markitdown ocrmypdf yt-dlp; do
  write_venv_command_wrapper "$command_name"
done

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

if [ -d "$HOME/.audio-to-md" ] && [ ! -L "$HOME/.audio-to-md" ]; then
  if [ ! -e "$CODEX_HOME/audio-to-md" ]; then
    mv "$HOME/.audio-to-md" "$CODEX_HOME/audio-to-md"
  fi
fi
if [ -L "$HOME/.audio-to-md" ]; then
  rm "$HOME/.audio-to-md"
fi
if [ -d "$PYTHON_TOOLS_HOME/audio-to-md" ] && [ ! -e "$CODEX_HOME/audio-to-md" ]; then
  mv "$PYTHON_TOOLS_HOME/audio-to-md" "$CODEX_HOME/audio-to-md"
fi

if [ -d "$PYTHON_TOOLS_HOME/voxcpm2-voice-cloner" ] && [ ! -e "$CODEX_HOME/voxcpm2-voice-cloner" ]; then
  mv "$PYTHON_TOOLS_HOME/voxcpm2-voice-cloner" "$CODEX_HOME/voxcpm2-voice-cloner"
fi

if [ -d "$HOME/.doc-to-md" ] && [ ! -L "$HOME/.doc-to-md" ]; then
  if [ ! -e "$CODEX_HOME/doc-to-md" ]; then
    mv "$HOME/.doc-to-md" "$CODEX_HOME/doc-to-md"
  fi
fi
if [ -L "$HOME/.doc-to-md" ]; then
  rm "$HOME/.doc-to-md"
fi

if [ -d "$HOME/.vlm-to-md" ] && [ ! -L "$HOME/.vlm-to-md" ]; then
  if [ ! -e "$CODEX_HOME/vlm-to-md" ]; then
    mv "$HOME/.vlm-to-md" "$CODEX_HOME/vlm-to-md"
  fi
fi
if [ -L "$HOME/.vlm-to-md" ]; then
  rm "$HOME/.vlm-to-md"
fi

if [ -d "$CODEX_HOME/audio-to-md" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/audio-to-md" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$CODEX_HOME/audio-to-md/audio-to-md" "\$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/audio-to-md"
fi

if [ -x "$CODEX_HOME/audio-to-md/venv/bin/python" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/audio-to-md-python" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$CODEX_HOME/audio-to-md/venv/bin/python" "\$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/audio-to-md-python"
elif [ -x "$CODEX_HOME/audio-to-md/.venv/bin/python" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/audio-to-md-python" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$CODEX_HOME/audio-to-md/.venv/bin/python" "\$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/audio-to-md-python"
fi

if [ -d "$CODEX_HOME/voxcpm2-voice-cloner/.venv" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/voxcpm2-python" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$CODEX_HOME/voxcpm2-voice-cloner/.venv/bin/python" "\$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/voxcpm2-python"
fi

if [ -d "$CODEX_HOME/doc-to-md" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/doc-to-md" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$CODEX_HOME/doc-to-md/doc-to-md" "\$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/doc-to-md"
fi

if [ -d "$CODEX_HOME/vlm-to-md" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/vlm-to-md" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$CODEX_HOME/vlm-to-md/vlm-to-md" "\$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/vlm-to-md"
fi

"$PYTHON_TOOLS_HOME/bin/python-tools-python" -c "import docx, docxcompose, openpyxl, xlsxwriter, pandas, pptx, pypdf, fitz, pdfplumber, pdf2image, reportlab, fpdf, PIL, matplotlib, qrcode, markitdown, mammoth, ocrmypdf; import edge_tts, yt_dlp, youtube_transcript_api, groq, elevenlabs, opencc; print('python teaching and video adapter tools ok')"

echo "Python tools installed at: $PYTHON_TOOLS_HOME"
echo "Shared command directory: $PYTHON_TOOLS_HOME/bin"
if [ -L "$HOME/.local/share/agent-tools/python-tools" ]; then
  echo "Three-Agent bridge detected. Start a new Agent conversation or run:"
  echo "  . \"$HOME/.config/agent-tools/python-tools.env\""
else
  echo "Next: run LazyPack Item 16 to create the Codex/Claude/AntiGravity bridge and shell loader."
fi
```

<!-- END EMBEDDED_SCRIPT:install_python_tools.sh -->

## 內建驗證腳本內容

以下內容與 repo 腳本 `200_Reference/scripts/python-tools/verify_python_tools.py` 等價。

<!-- BEGIN EMBEDDED_SCRIPT:verify_python_tools.py -->

```python
from importlib import import_module
from importlib.metadata import distributions
import os
from pathlib import Path
import shutil
import sys

IMPORTS = [
    "docx",
    "docxcompose",
    "openpyxl",
    "xlsxwriter",
    "pandas",
    "pptx",
    "pypdf",
    "fitz",
    "pdfplumber",
    "pdf2image",
    "reportlab",
    "fpdf",
    "PIL",
    "matplotlib",
    "qrcode",
    "markitdown",
    "mammoth",
    "ocrmypdf",
    "edge_tts",
    "yt_dlp",
    "youtube_transcript_api",
    "groq",
    "elevenlabs",
    "opencc",
]

CORE_WRAPPERS = [
    "python-tools-python",
    "edge-tts",
    "markitdown",
    "ocrmypdf",
    "yt-dlp",
    "auto-editor",
    "ffmpeg",
    "ffprobe",
]


def main() -> int:
    codex_home = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex"))
    runtime_home = Path(os.environ.get("PYTHON_TOOLS_HOME", codex_home / "python-tools"))
    runtime_venv = runtime_home / "teaching-file-tools" / ".venv"
    runtime_wrapper = runtime_home / "bin" / "python-tools-python"

    # The public instructions allow running this verifier with system `python3`.
    # Re-enter through the shared runtime so package imports and distribution
    # inventory describe the environment being verified instead of the caller.
    if (
        runtime_wrapper.is_file()
        and os.access(runtime_wrapper, os.X_OK)
        and Path(sys.prefix).resolve() != runtime_venv.resolve()
    ):
        os.execv(
            str(runtime_wrapper),
            [str(runtime_wrapper), str(Path(__file__).resolve())],
        )

    failed = []
    for name in IMPORTS:
        try:
            import_module(name)
        except Exception as exc:
            failed.append((name, str(exc)))

    print("Python packages:")
    if failed:
        for name, error in failed:
            print(f"  FAIL {name}: {error}")
    else:
        print("  OK all core imports")

    wrapper_failures = []
    print("\nCore wrappers:")
    for name in CORE_WRAPPERS:
        wrapper = runtime_home / "bin" / name
        available = wrapper.is_file() and os.access(wrapper, os.X_OK)
        print(f"  {'OK' if available else 'MISSING'} {name}: {wrapper if available else '-'}")
        if not available:
            wrapper_failures.append(name)

    bridge = Path.home() / ".local" / "share" / "agent-tools" / "python-tools"
    print("\nThree-Agent bridge:")
    if bridge.is_symlink() and bridge.resolve() == runtime_home.resolve():
        print("  OK neutral bridge points to this runtime")
    else:
        print("  PENDING run LazyPack Item 16 to create or repair the neutral bridge")

    print("\nSystem tools:")
    for tool in ["tesseract", "gs", "pdftoppm", "ffmpeg", "ffprobe", "magick", "soffice"]:
        path = shutil.which(tool)
        print(f"  {'OK' if path else 'MISSING'} {tool}: {path or '-'}")

    print("\nOptional video wrappers:")
    for tool in [
        "audio-to-md-python",
        "whisper-cli",
        "sensevoice-cli",
        "macwhisper-cli",
    ]:
        wrapper = runtime_home / "bin" / tool
        available = wrapper.is_file() and os.access(wrapper, os.X_OK)
        print(f"  {'OK' if available else 'OPTIONAL'} {tool}: {wrapper if available else '-'}")

    names = sorted(dist.metadata["Name"] for dist in distributions())
    print(f"\nInstalled distributions: {len(names)}")
    for name in names:
        print(f"  {name}")

    return 1 if failed or wrapper_failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
```

<!-- END EMBEDDED_SCRIPT:verify_python_tools.py -->

## 安全邊界

- 不把 `.venv`、模型、Whisper cache、VoxCPM2 模型、聲音 profile 或生成音訊放進 Git、LazyPack、Obsidian 或 Google Drive 同步資料夾。
- LazyPack 只保存可重建腳本、工具列表、安裝說明與踩坑紀錄。
- chezmoi 只保存 bridge、env loader、profile modifier 與 machine-local path template；不保存 runtime 內容。
- 任何 API key 仍放 `{{CODEX_HOME}}/secrets/`，不寫進 runtime、repo 或筆記。
