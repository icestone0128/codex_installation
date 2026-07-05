# 35-Taigi-Teaching-Agent-安裝

> 來源：`mathruffian-dot/taigi-teaching-agent`，本機驗證 commit：`bf55f6fae291d21a483d30225607435e13b2bb66`。本 LazyPack 把原 repo 的 Windows / PowerShell 上手流程轉成 macOS / Codex 可重建安裝流程。

## 用途

這個工具是臺語教材產生器。安裝後可以用同一個指令入口生成或檢查臺語教材：

- `doctor`：檢查 Python、套件、`ffmpeg`、`config.json`、意傳與萌典連線。
- `piau`：漢字轉臺羅。
- `tts`：臺語語音合成；正式教材仍需本土語教師審聽。
- `check`：檢查教材 JSON 的華語用字與漢字 / 臺羅一致性。
- `generate`：依案例產生講義、考卷、簡報、離線互動網頁與教師審核報告。
- `games` / `abtest`：生成互動遊戲網站與 TTS 審聽包。

## 安裝位置

建議安裝在本機 Codex 工具區，不放進 Google Drive / iCloud / Dropbox：

```text
{{CODEX_HOME}}/python-tools/taigi-teaching-agent
{{CODEX_HOME}}/python-tools/taigi-teaching-agent/.venv
{{CODEX_HOME}}/python-tools/bin/taigi-teaching-agent
```

理由：

- `.venv`、音訊、影片、官方教材下載檔與生成成品可能很大。
- 上游 repo 的 `output/`、`drafts/`、官方教材 `raw/processed/analysis/` 都已被 `.gitignore` 排除。
- public `codex_installation` repo 只保存安裝腳本與踩坑，不保存生成教材或官方教材下載檔。

## 前置條件

必要：

```bash
git --version
uv --version
ffmpeg -version
```

若缺 `uv`，先安裝 `uv`。若缺 `ffmpeg`，macOS 可用：

```bash
brew install ffmpeg
```

選配：

- Ollama + `SARC-Taigi-LLM-12b`：AI 大綱生成用；未啟動時 `doctor` 只會顯示警告，不影響文字類教材生成。
- 官方教材下載與分析資料：上游 repo 不隨附大型官方教材檔與 `data/official_materials/analysis/`，需要時再依上游 `docs/official-materials-workflow.md` 蒐集。

## 安裝腳本

本 repo 提供可重建腳本：

```text
{{SETUP_REPO}}/200_Reference/scripts/taigi-teaching-agent/install_taigi_teaching_agent.sh
```

執行：

```bash
bash "{{SETUP_REPO}}/200_Reference/scripts/taigi-teaching-agent/install_taigi_teaching_agent.sh"
```

安裝器會：

1. clone `mathruffian-dot/taigi-teaching-agent`。
2. checkout 驗證過的 commit `bf55f6fae291d21a483d30225607435e13b2bb66`。
3. 用 `uv venv --python 3.12 --allow-existing` 建立或沿用專用 `.venv`。
4. 安裝 `requirements.txt`。
5. 從 `config.example.json` 建立本機 `config.json`。
6. 補上 macOS 可重跑的 `setup_macos.sh`。
7. 建立 wrapper：`{{CODEX_HOME}}/python-tools/bin/taigi-teaching-agent`。
8. 跑 `doctor`、`piau` 與 dummy TTS smoke test。

## 使用方式

```bash
"{{CODEX_HOME}}/python-tools/bin/taigi-teaching-agent" --help
"{{CODEX_HOME}}/python-tools/bin/taigi-teaching-agent" doctor
"{{CODEX_HOME}}/python-tools/bin/taigi-teaching-agent" piau "今仔日天氣真好"
"{{CODEX_HOME}}/python-tools/bin/taigi-teaching-agent" tts "食飯" -o /tmp/taigi_food.wav --provider dummy
"{{CODEX_HOME}}/python-tools/bin/taigi-teaching-agent" generate --case tests/test_materials/test_case_market_001.json --no-media
```

`check` 回傳 `exit 2` 代表有教材審核警告，不代表程式失敗。例如測試案例會提示「一些 / 跟 / 老闆」建議改成更自然的臺語用詞。

## 本機驗證紀錄

本機安裝位置：

```text
{{CODEX_HOME}}/python-tools/taigi-teaching-agent
```

已完成：

- `uv venv --python 3.12 --allow-existing` 建立 Python 3.12.13 venv。
- `uv pip install -r requirements.txt` 安裝 63 個 packages。
- 新增本機 `setup_macos.sh`。
- 新增 wrapper `{{CODEX_HOME}}/python-tools/bin/taigi-teaching-agent`。
- `doctor` 通過所有必要項目：Python、requests、Jinja2、python-docx、python-pptx、Pillow、ffmpeg、config、output 可寫、意傳、萌典。
- Ollama 未啟動，但屬選配警告。
- `piau "今仔日天氣真好"` 成功輸出臺羅：`Kin-á-ji̍t thinn-khì tsin-hó`。
- `tts "食飯" --provider dummy` 成功產出 WAV。
- `generate --case tests/test_materials/test_case_market_001.json --no-media` 成功產出：
  - `lesson_structure.json`
  - `student_worksheet.docx`
  - `teacher_guide.docx`
  - `exam_paper.docx`
  - `exam_answer_key.docx`
  - `quiz_bank.json`
  - `quiz_teacher_key.md`
  - `teaching_slides.pptx`
  - `interactive_website.html`
  - `teacher_review_report.md`
- 精簡核心測試通過：6 passed。

## 踩坑與修正

- 上游 `setup.ps1` 是 Windows / PowerShell 流程；macOS 上不能直接使用。修正方式是新增 `setup_macos.sh`，用 `uv` 建 Python 3.12 venv。
- `uv venv` 在 `.venv` 已存在時會失敗；安裝包必須使用 `--allow-existing`，讓重跑安裝時只更新依賴與 wrapper，不清掉現有環境。
- 不要直接把依賴裝進既有共用 Python tools venv；臺語產生器有自己的 `fastapi`、`faster-whisper`、`python-docx`、`python-pptx` 等依賴，應使用專用 `.venv`。
- `python -m taigi` 必須在 repo 根目錄執行，否則相對路徑與 `config.json` 容易錯。wrapper 會先 `cd` 到 repo 根目錄再執行。
- `config.json` 是本機設定檔，已被上游 `.gitignore` 排除，不應 commit。
- `output/` 是生成成果，已被上游 `.gitignore` 排除，不應 commit。
- 上游完整 pytest 會期待 `data/official_materials/analysis/` 下的分析索引與官方教材文字資料，但這些大型資料沒有隨 repo 發布，而且也被 `.gitignore` 排除。乾淨 clone 後完整 pytest 會出現缺 `pdf_text_index.json`、`official_material_snippets.json`、`official_material_bank.json` 等失敗。安裝驗證應以 `doctor`、指令入口 smoke tests、`generate --no-media` 與精簡核心測試為準；若要跑官方教材相關測試，先依 `docs/official-materials-workflow.md` 蒐集並建立官方教材分析資料。
- `check` 的 `exit 2` 是「有審核警告」的設計，不要誤判成安裝失敗。
- `doctor` 中 Ollama 是選配；沒有本機 Ollama 或模型時仍可用文字類、檢核與範例生成流程。

## 驗收指令

```bash
"{{CODEX_HOME}}/python-tools/bin/taigi-teaching-agent" doctor
"{{CODEX_HOME}}/python-tools/bin/taigi-teaching-agent" piau "今仔日天氣真好"
"{{CODEX_HOME}}/python-tools/bin/taigi-teaching-agent" tts "食飯" -o /tmp/taigi_food.wav --provider dummy
"{{CODEX_HOME}}/python-tools/bin/taigi-teaching-agent" generate --case tests/test_materials/test_case_market_001.json --no-media

cd "{{CODEX_HOME}}/python-tools/taigi-teaching-agent"
".venv/bin/python" -m pytest \
  tests/test_modules.py::test_tailo_conversion \
  tests/test_modules.py::test_sentence_conversion \
  tests/test_modules.py::test_retriever \
  tests/test_modules.py::test_tts_dummy_synthesize \
  tests/test_modules.py::test_content_checker_flags_and_passes \
  tests/test_modules.py::test_stt_dummy
```

## 內建安裝腳本內容

以下內容與 repo 腳本 `200_Reference/scripts/taigi-teaching-agent/install_taigi_teaching_agent.sh` 等價。

````bash
#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PYTHON_TOOLS_HOME="${PYTHON_TOOLS_HOME:-$CODEX_HOME/python-tools}"
TAIGI_HOME="${TAIGI_HOME:-$PYTHON_TOOLS_HOME/taigi-teaching-agent}"
BIN_DIR="${BIN_DIR:-$PYTHON_TOOLS_HOME/bin}"
SOURCE_REPO="${SOURCE_REPO:-https://github.com/mathruffian-dot/taigi-teaching-agent.git}"
SOURCE_COMMIT="${SOURCE_COMMIT:-bf55f6fae291d21a483d30225607435e13b2bb66}"
PYTHON_VERSION="${PYTHON_VERSION:-3.12}"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required." >&2
  exit 1
fi

if ! command -v uv >/dev/null 2>&1; then
  echo "uv is required. Install uv first, then rerun this script." >&2
  exit 1
fi

mkdir -p "$PYTHON_TOOLS_HOME" "$BIN_DIR"

if [ -d "$TAIGI_HOME/.git" ]; then
  echo "Using existing repo: $TAIGI_HOME"
elif [ -e "$TAIGI_HOME" ]; then
  echo "Target exists but is not a git repo: $TAIGI_HOME" >&2
  echo "Move it aside or set TAIGI_HOME to another path." >&2
  exit 1
else
  git clone "$SOURCE_REPO" "$TAIGI_HOME"
  git -C "$TAIGI_HOME" checkout --detach "$SOURCE_COMMIT"
fi

cd "$TAIGI_HOME"

uv venv --python "$PYTHON_VERSION" --allow-existing .venv
uv pip install -r requirements.txt --python "$TAIGI_HOME/.venv/bin/python"

if [ ! -f "$TAIGI_HOME/config.json" ]; then
  cp "$TAIGI_HOME/config.example.json" "$TAIGI_HOME/config.json"
fi

cat > "$TAIGI_HOME/setup_macos.sh" <<'TAIGI_SETUP_MACOS'
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_VERSION="${PYTHON_VERSION:-3.12}"

if ! command -v uv >/dev/null 2>&1; then
  echo "uv is required. Install it first, then rerun this script." >&2
  exit 1
fi

cd "$ROOT"
uv venv --python "$PYTHON_VERSION" --allow-existing .venv
uv pip install -r requirements.txt --python "$ROOT/.venv/bin/python"

if [ ! -f "$ROOT/config.json" ]; then
  cp "$ROOT/config.example.json" "$ROOT/config.json"
fi

echo "Taigi Teaching Agent is ready."
echo "Run: $ROOT/.venv/bin/python -m taigi doctor"
TAIGI_SETUP_MACOS
chmod +x "$TAIGI_HOME/setup_macos.sh"

cat > "$BIN_DIR/taigi-teaching-agent" <<TAIGI_WRAPPER
#!/usr/bin/env bash
set -euo pipefail

ROOT="\${TAIGI_TEACHING_AGENT_ROOT:-$TAIGI_HOME}"
PYTHON="\$ROOT/.venv/bin/python"

if [ ! -x "\$PYTHON" ]; then
  echo "Taigi Teaching Agent venv is missing. Run: \$ROOT/setup_macos.sh" >&2
  exit 1
fi

cd "\$ROOT"
exec "\$PYTHON" -m taigi "\$@"
TAIGI_WRAPPER
chmod +x "$BIN_DIR/taigi-teaching-agent"

"$BIN_DIR/taigi-teaching-agent" doctor
"$BIN_DIR/taigi-teaching-agent" piau "今仔日天氣真好" >/dev/null
"$BIN_DIR/taigi-teaching-agent" tts "食飯" -o /tmp/taigi_dummy.wav --provider dummy >/dev/null

echo "Taigi Teaching Agent installed."
echo "Command: $BIN_DIR/taigi-teaching-agent --help"
````
