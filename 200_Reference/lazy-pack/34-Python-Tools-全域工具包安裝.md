# 34-Python-Tools-全域工具包安裝

> 來源：`mathruffian-dot/ai-agent-ep03`。本版將來源檔案 `EP03 教學檔案處理工具列表｜老師的 Python 神器清單` 改名為 `Python 工具列表`，並把安裝流程整理成可重建的全域 Python runtime。

## 用途

這個安裝包讓每個專案都能共用同一套 Python 檔案處理工具，而不是每個 repo 各自建立一份 `.venv`。

已涵蓋：

- Word：`python-docx`、`docxcompose`
- Excel：`openpyxl`、`xlsxwriter`、`pandas`
- PowerPoint：`python-pptx`
- PDF：`pypdf`、`PyMuPDF`、`pdfplumber`、`pdf2image`、`reportlab`、`fpdf2`、`ocrmypdf`
- 圖片與圖表：`pillow`、`matplotlib`、`qrcode`
- 轉檔與 AI 前處理：`markitdown`
- 影音輔助：`edge-tts`、`yt-dlp`、`youtube-transcript-api`
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
- 技能專屬 runtime：`{{CODEX_HOME}}/audio-to-md`、`{{CODEX_HOME}}/voxcpm2-voice-cloner`、`{{CODEX_HOME}}/doc-to-md`、`{{CODEX_HOME}}/vlm-to-md`
- uv 套件快取：維持 `{{HOME}}/.cache/uv`，不要搬進 `python-tools`
- uv tool 安裝清單與工具環境：維持 `{{HOME}}/.local/share/uv`，不要搬進 `python-tools`
- 其他 `{{HOME}}/.cache/` 模型或工具快取：維持原位，除非單一 skill 文件明確指定自己的本機 runtime cache

每個專案要使用時，呼叫：

```bash
{{CODEX_HOME}}/python-tools/bin/python-tools-python -c "import pandas; print('ok')"
```

也可以把 `{{CODEX_HOME}}/python-tools/bin` 加進 PATH。

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
| Poppler / `pdftoppm` | `pdf2image` PDF 轉圖 | `brew install poppler` |
| ffmpeg | `yt-dlp` 下載合併影音 | `brew install ffmpeg` |
| Microsoft Word 或 LibreOffice | `docx2pdf` / Office 轉 PDF | 安裝 Office 或 LibreOffice |

安裝完系統工具後，通常要重開終端機或重啟 Codex 對話，PATH 才會刷新。

## 本機實作紀錄

本機已完成：

- 建立 `{{CODEX_HOME}}/python-tools/teaching-file-tools/.venv`
- 使用 `uv` 建立 Python 3.12.13 venv，避開系統 Python 3.14.6 的套件相容風險
- 安裝來源工具包指定的核心 Python 套件與影音選用套件
- 保留 `{{HOME}}/.cache/uv` 與 `{{HOME}}/.local/share/uv` 原位，不移入 `python-tools`
- 將技能 runtime 整理為本機實體資料夾：`{{CODEX_HOME}}/audio-to-md`、`{{CODEX_HOME}}/voxcpm2-voice-cloner`、`{{CODEX_HOME}}/doc-to-md`、`{{CODEX_HOME}}/vlm-to-md`
- 移除舊路徑 symlink，並把實際入口改成對應的 `{{CODEX_HOME}}/<skill-name>` 路徑
- 建立 wrapper：
  - `python-tools-python`
  - `audio-to-md`
  - `voxcpm2-python`
  - `doc-to-md`
  - `vlm-to-md`

本機驗證：

```text
python-tools-python import 驗證：通過
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
- `{{HOME}}/.cache/uv` 是 uv cache，維持原位；`{{HOME}}/.local/share/uv` 是 uv tool 安裝清單與工具環境，也維持原位。
- `{{HOME}}/.local/share/uv` 不是和 `{{HOME}}/.cache/uv` 重複的快取；它可能包含 `notebooklm-mcp` 這類 uv tool 的可執行環境。若誤移，venv 內的 shebang 與 `bin/python` symlink 會斷，應還原到 `{{HOME}}/.local/share/uv` 或重裝該 uv tool。
- Codex 沙盒不一定能寫 `{{CODEX_HOME}}/python-tools/matplotlib-cache`；wrapper 需在不可寫時 fallback 到 `TMPDIR`。
- Codex sandbox writable roots 是持久安全設定。不要在 LazyPack 安裝腳本中自動改 `{{CODEX_CONFIG}}`；若使用者要讓 Codex 直接寫入 `{{CODEX_HOME}}/audio-to-md`、`{{CODEX_HOME}}/doc-to-md`、`{{CODEX_HOME}}/vlm-to-md` 或 `{{CODEX_HOME}}/python-tools`，應由使用者明確批准後再加入窄範圍 writable roots。
- `brew install tesseract tesseract-lang` 可能長時間卡住；若中途卡住，先保留 Python runtime，之後再重跑系統相依安裝。
- Tesseract 主程式與繁中語言包是 OCR 能力的關鍵；只安裝 `ocrmypdf` Python 套件不等於掃描 PDF OCR 可用。
- 搬移 `.venv` 可能受絕對路徑影響，所以必須同步修改 wrapper、skill scripts 與文件入口，不用 symlink 做相容層。
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

"{{CODEX_HOME}}/python-tools/bin/python-tools-python" \
  "{{SETUP_REPO}}/200_Reference/scripts/python-tools/verify_python_tools.py"
"{{CODEX_HOME}}/audio-to-md/audio-to-md" --help
"{{CODEX_HOME}}/doc-to-md/doc-to-md" --help
"{{CODEX_HOME}}/vlm-to-md/vlm-to-md" --help
"{{CODEX_HOME}}/voxcpm2-voice-cloner/.venv/bin/python" \
  "{{CODEX_HOME}}/skills/voxcpm2-voice-cloner/scripts/voice_cloner.py" doctor
"{{HOME}}/.local/bin/notebooklm-mcp" --help
```

若 `verify_python_tools.py` 顯示 `MISSING tesseract`，代表 Python 套件已裝好，但掃描 PDF OCR 還缺系統工具；安裝 `tesseract` 與語言包後再重跑驗證。

## 內建安裝腳本內容

以下內容與 repo 腳本 `200_Reference/scripts/python-tools/install_python_tools.sh` 等價；下載者也可以直接使用 repo 腳本。

````bash
#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PYTHON_TOOLS_HOME="${PYTHON_TOOLS_HOME:-$CODEX_HOME/python-tools}"
PYTHON_TOOLS_VENV="$PYTHON_TOOLS_HOME/teaching-file-tools/.venv"
UV_BIN="${UV_BIN:-}"

if [ -z "$UV_BIN" ]; then
  if command -v uv >/dev/null 2>&1; then
    UV_BIN="$(command -v uv)"
  elif [ -x /opt/homebrew/bin/uv ]; then
    UV_BIN=/opt/homebrew/bin/uv
  else
    echo "uv is required. Install uv first, then rerun this script." >&2
    exit 1
  fi
fi

mkdir -p "$PYTHON_TOOLS_HOME/bin" "$PYTHON_TOOLS_HOME/matplotlib-cache"

"$UV_BIN" venv --python 3.12 "$PYTHON_TOOLS_VENV"

"$UV_BIN" pip install \
  --python "$PYTHON_TOOLS_VENV/bin/python" \
  python-docx docxcompose openpyxl xlsxwriter pandas python-pptx \
  pypdf PyMuPDF pdfplumber pdf2image reportlab fpdf2 pillow matplotlib \
  qrcode markitdown ocrmypdf docx2pdf edge-tts yt-dlp youtube-transcript-api

cat > "$PYTHON_TOOLS_HOME/bin/python-tools-python" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
CACHE_ROOT="${MPLCONFIGDIR:-$HOME/.codex/python-tools/matplotlib-cache}"
if [ ! -d "$CACHE_ROOT" ] || [ ! -w "$CACHE_ROOT" ]; then
  CACHE_ROOT="${TMPDIR:-/tmp}/codex-python-tools-matplotlib-cache"
  mkdir -p "$CACHE_ROOT"
fi
export MPLCONFIGDIR="$CACHE_ROOT"
exec "$HOME/.codex/python-tools/teaching-file-tools/.venv/bin/python" "$@"
SH
chmod +x "$PYTHON_TOOLS_HOME/bin/python-tools-python"

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
  cat > "$PYTHON_TOOLS_HOME/bin/audio-to-md" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
exec "$HOME/.codex/audio-to-md/audio-to-md" "$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/audio-to-md"
fi

if [ -d "$CODEX_HOME/voxcpm2-voice-cloner/.venv" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/voxcpm2-python" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
exec "$HOME/.codex/voxcpm2-voice-cloner/.venv/bin/python" "$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/voxcpm2-python"
fi

if [ -d "$CODEX_HOME/doc-to-md" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/doc-to-md" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
exec "$HOME/.codex/doc-to-md/doc-to-md" "$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/doc-to-md"
fi

if [ -d "$CODEX_HOME/vlm-to-md" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/vlm-to-md" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
exec "$HOME/.codex/vlm-to-md/vlm-to-md" "$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/vlm-to-md"
fi

"$PYTHON_TOOLS_HOME/bin/python-tools-python" -c "import docx, docxcompose, openpyxl, xlsxwriter, pandas, pptx, pypdf, fitz, pdfplumber, pdf2image, reportlab, fpdf, PIL, matplotlib, qrcode, markitdown, ocrmypdf; import edge_tts, yt_dlp, youtube_transcript_api; print('python teaching file tools ok')"

echo "Python tools installed at: $PYTHON_TOOLS_HOME"
echo "Add this to PATH when desired: $PYTHON_TOOLS_HOME/bin"
````

## 內建驗證腳本內容

以下內容與 repo 腳本 `200_Reference/scripts/python-tools/verify_python_tools.py` 等價。

````python
from importlib import import_module
from importlib.metadata import distributions
import shutil

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
    "ocrmypdf",
    "edge_tts",
    "yt_dlp",
    "youtube_transcript_api",
]


def main() -> int:
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

    print("\nSystem tools:")
    for tool in ["tesseract", "pdftoppm", "ffmpeg", "soffice"]:
        path = shutil.which(tool)
        print(f"  {'OK' if path else 'MISSING'} {tool}: {path or '-'}")

    names = sorted(dist.metadata["Name"] for dist in distributions())
    print(f"\nInstalled distributions: {len(names)}")
    for name in names:
        print(f"  {name}")

    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
````

## 安全邊界

- 不把 `.venv`、模型、Whisper cache、VoxCPM2 模型、聲音 profile 或生成音訊放進 Git、LazyPack、Obsidian 或 Google Drive 同步資料夾。
- LazyPack 只保存可重建腳本、工具列表、安裝說明與踩坑紀錄。
- 任何 API key 仍放 `{{CODEX_HOME}}/secrets/`，不寫進 runtime、repo 或筆記。
