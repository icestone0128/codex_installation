# 18-Document-to-Markdown-Skill-安裝

> 版本：2026-05-31 Codex App 版
> 用途：把 doc-to-md 文件轉 Markdown 流程安裝成 Codex App 全域 Skill，用於 PDF、EPUB、TXT、掃描 PDF、圖片型 PDF、圖表、截圖與圖片資料夾轉換，並依情境自動分流純文字轉換或 VLM 視覺解讀。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/doc-to-md/`，不需要額外的 `skills/` 子目錄。

## 來源與歷史紀錄

- 初次同步日期：2026-05-10。
- 原始來源包：`skill.zip`。
- 重新提供並核對的完整安裝包：`doc-to-md-安裝包_v1.4.6.zip`。
- 完整安裝包外層包含：`README.md`、`USAGE.md`、`install.sh`、`install.bat`、`skill.zip`。
- 後續補齊：`installer-readme.md`、`full-usage.md`、`install.sh`、`install.bat`。
- 2026-05-31 補充來源：`vlm-to-md-安裝包_v1.2.0.zip`，已將 `vlm_prep.py`、`package_kb.py`、VLM 使用說明與設計筆記併入 `doc-to-md`。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/doc-to-md/SKILL.md`。
- Obsidian 全域索引已記錄用途：依文件型態自動分流文字轉 Markdown、掃描 PDF 視覺謄寫、圖表/表格/框架圖解讀與 Obsidian-ready Markdown。

## 這版和來源工具文件的差異

| 原始取向 | Codex 版 |
|---|---|
| 舊版來源可能保留非 Codex App 路徑範例 | 本版已改為 Codex App / `{{CODEX_HOME}}/skills/doc-to-md` 路徑與 AI 助手通用語意 |
| 轉換器與 skill 安裝容易混在一起 | 本文同時內嵌 skill package 與本機轉換器安裝腳本 |
| 只安裝 `SKILL.md` 會缺功能 | 必須包含 `references/` 與 `scripts/` |
| PDF 解析可能被誤認為 Codex 內建 PDF plugin | `doc-to-md` 是自訂轉檔 skill，不是系統 PDF plugin |
| `doc-to-md` 與 `vlm-to-md` 原本分成兩包 | 本版合併成同一個 `doc-to-md` skill，由 `doc_md_router.py` 自動判斷是否呼叫 VLM |
| VLM 來源可能被理解成外部 API | 本版只使用本地 Python 前處理與助手內建視覺能力，不需要 API key 或本地大模型 |
| Codex 執行時可能臨時建立 Python 環境 | 本版明定轉檔時優先呼叫使用者已由 Terminal 安裝的固定轉換器：`~/.doc-to-md/doc-to-md` 與 `~/.vlm-to-md/vlm-to-md`；不要為單次轉換建立臨時 venv |

## 安裝方式

Document to MD 有兩層安裝。Codex 實際轉檔時預設直接呼叫使用者已安裝的 Terminal 轉換器；不要為單次轉換建立 `/tmp` 或 `/private/tmp` 的臨時 Python 環境。

1. **Codex Skill 安裝**：使用本文文末「內建 Skill 完整安裝內容」。執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{CODEX_HOME}}`。
2. **固定本機轉換器確認**：確認 `~/.doc-to-md/doc-to-md` 與 `~/.vlm-to-md/vlm-to-md` 已存在且可執行。這兩個是使用者先前用 Terminal 安裝好的文字轉檔與 VLM 前處理工具。
3. **fallback 才用內建腳本**：若固定轉換器不存在，才使用 skill 內建 `scripts/`；不要臨時建立 Python 環境。

### Mac / Linux：固定本機轉換器確認

開啟 Terminal，執行：

```bash
test -x ~/.doc-to-md/doc-to-md && echo "text converter ok"
test -x ~/.vlm-to-md/vlm-to-md && echo "vlm converter ok"
```

Codex 自動路由時，可用已安裝的文字轉檔 Python 執行 router，router 會優先呼叫上述兩個固定轉換器：

```bash
~/.doc-to-md/venv/bin/python3 "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_md_router.py" "input.pdf" -o "output/"
```

### Mac / Linux：固定本機轉換器安裝

若固定轉換器不存在，才執行安裝：

```bash
bash "{{CODEX_HOME}}/skills/doc-to-md/scripts/install.sh"
```

這個安裝程式會自動：

- 尋找 Python 3.8 以上版本，優先使用 Python 3.13 到 3.9，再退到 `python3`。
- 若找不到 Python 3.8+，提示到 python.org 安裝 Python 3.12 或更新版本。
- 建立固定的 `~/.doc-to-md/venv/`。
- 用 pip 安裝 `PyMuPDF`、`ebooklib`、`beautifulsoup4`、`chardet`、`opencc-python-reimplemented`、`lxml`、`Pillow`。
- 複製 `doc_md_router.py`、`doc_to_md.py`、`vlm_prep.py`、`package_kb.py` 與 `requirements.txt` 到 `~/.doc-to-md/`。
- 建立 `~/.doc-to-md/doc-to-md` 文字轉檔啟動器。VLM 若是使用獨立安裝包，固定啟動器位於 `~/.vlm-to-md/vlm-to-md`。

### Windows：安裝 Python 轉換器

在檔案總管中雙擊：

```text
{{CODEX_HOME}}\skills\doc-to-md\scripts\install.bat
```

Windows 若跳出 SmartScreen，選「其他資訊」再選「仍要執行」。若找不到 Python，請到 python.org 安裝 Python 3.12 或更新版本，且安裝時務必勾選 `Add Python to PATH`，安裝完關閉命令提示字元或 PowerShell 後重開。

### 本機轉換器驗證

Mac / Linux：

```bash
~/.doc-to-md/doc-to-md --help
```

Windows：

```text
%USERPROFILE%\.doc-to-md\doc-to-md.bat --help
```

合理結果是看到 `doc_md_router.py` 的自動路由參數說明。

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/doc-to-md/SKILL.md" && echo "doc-to-md SKILL.md ok"
test -f "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_md_router.py" && echo "router script ok"
test -f "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_to_md.py" && echo "converter script ok"
test -f "{{CODEX_HOME}}/skills/doc-to-md/scripts/vlm_prep.py" && echo "vlm prep script ok"
test -f "{{CODEX_HOME}}/skills/doc-to-md/scripts/package_kb.py" && echo "package script ok"
test -f "{{CODEX_HOME}}/skills/doc-to-md/scripts/requirements.txt" && echo "requirements ok"
test -f "{{CODEX_HOME}}/skills/doc-to-md/references/combined-routing-guide.md" && echo "routing guide ok"
test -f "{{CODEX_HOME}}/skills/doc-to-md/references/full-usage.md" && echo "full usage ok"
```

合理結果是每一行都顯示 `ok`。

## 使用方式

安裝後可用下列語句觸發：

- 「使用 doc-to-md 把這個 PDF 轉成 Markdown」
- 「把這本 EPUB 轉成 Obsidian 筆記」
- 「把這份掃描 PDF 轉成 Markdown」
- 「把 PDF 裡面的圖表也解讀成文字」
- 「這份文件請自動判斷需不需要 VLM」
- 「把 TXT 整理成帶 YAML frontmatter 的 Markdown」
- 「轉成繁體中文 Markdown 並加章節摘要」

## 預設工作流程

1. 確認來源格式是 PDF、EPUB、TXT、圖片檔或圖片資料夾。
2. 優先使用 `scripts/doc_md_router.py` 做自動路由。
3. EPUB/TXT 或純文字 PDF：使用 `doc_to_md.py` 轉出文字 Markdown。
4. 掃描 PDF、圖片型 PDF、圖片檔或圖片資料夾：使用 `vlm_prep.py` 產出 VLM 待解讀 Markdown 與 assets。
5. 文字 PDF 但含嵌入圖表、向量圖表頁或 Exhibit/Figure caption：先跑 `doc_to_md.py`，再跑 `vlm_prep.py --mode figures`。
6. 轉出後補 YAML frontmatter、章節摘要 callout、關鍵字、圖像解讀與 Obsidian-friendly 結構。
7. 若交付包含圖片的視覺知識庫，使用 `package_kb.py` 打包 Markdown 與 assets，避免圖片斷鏈。

## 踩坑紀錄

### 1. 只裝 SKILL.md 不夠

`doc-to-md` 必須包含 `scripts/doc_md_router.py`、`scripts/doc_to_md.py`、`scripts/vlm_prep.py`、`scripts/package_kb.py`、`requirements.txt`、`install.sh`、`install.bat` 與 `references/`。缺任何一段都可能造成自動分流、文字轉換、VLM 前處理或打包失敗。

### 2. 轉換器安裝位置和 Codex skill 位置不同

Codex skill 放在 `{{CODEX_HOME}}/skills/doc-to-md/`；本機轉換器預設安裝到 `~/.doc-to-md/` 或 Windows 的 `%USERPROFILE%\.doc-to-md\`。不要混成同一個概念。

### 2.1 外層安裝包和內嵌 Skill 路徑不同

原始 `doc-to-md-安裝包_v1.4.6.zip` 的 `install.sh` / `install.bat` 假設旁邊有 `skill.zip`。本懶人包改成自含式有序號文件後，installer 會被放在 `{{CODEX_HOME}}/skills/doc-to-md/scripts/`，所以內嵌版本已調整為：優先讀取上一層 `{{CODEX_HOME}}/skills/doc-to-md/scripts/requirements.txt` 與 `doc_to_md.py`；若找不到，才退回原始安裝包的 `skill.zip` 模式。

### 3. PDF 系統能力和 doc-to-md 不同

Codex 的文件 / PDF 系統能力可用於解析或視覺 QA；`doc-to-md` 是自訂轉 Markdown workflow。不要把它當成系統 PDF plugin 的替代品。

### 4. 掃描版 PDF 不再只提示 OCR

如果 PDF 沒有文字層，`doc_to_md.py` 無法直接抽取內容；但本版 `doc_md_router.py` 會自動改跑 `vlm_prep.py --mode pages`，把每頁渲染成圖片，再由助手視覺能力謄寫與解讀。OCR 仍可作為替代方案，但不是唯一流程。

### 5. 舊來源文件殘留非 Codex App 路徑

部分 reference 內可能保留 `{{CODEX_HOME}}/skills/...` 作為來源範例。正式安裝與使用請以 `{{CODEX_HOME}}/skills/doc-to-md/` 與本文指令為準。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/doc-to-md/SKILL.md` 存在。
- [ ] `references/full-usage.md`、`references/installer-readme.md`、`references/usage-guide.md`、`references/combined-routing-guide.md`、`references/vlm-usage-guide.md`、`references/vlm-design-notes.md` 存在。
- [ ] `scripts/doc_md_router.py`、`scripts/doc_to_md.py`、`scripts/vlm_prep.py`、`scripts/package_kb.py`、`scripts/requirements.txt`、`scripts/install.sh`、`scripts/install.bat` 存在。
- [ ] 固定文字轉檔器 `~/.doc-to-md/doc-to-md --help` 可正常顯示。
- [ ] 固定 VLM 轉檔器 `~/.vlm-to-md/vlm-to-md --help` 可正常顯示。
- [ ] 若需要自動路由 PDF，`~/.doc-to-md/venv/bin/python3 "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_md_router.py" --help` 可正常顯示。
- [ ] 開新 Codex 對話後，可用「doc-to-md」、「PDF 轉 Markdown」、「掃描 PDF 轉 Markdown」、「VLM to MD」或「圖表解讀」觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`doc-to-md`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

```bash
set -e

# ---- doc-to-md ----
mkdir -p "{{CODEX_HOME}}/skills/doc-to-md"
# doc-to-md/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/SKILL.md" <<'CODEX_LAZYPACK_DOC_TO_MD_SKILL_MD'
---
name: doc-to-md
description: Convert PDF, TXT, EPUB, scanned PDF, image-heavy PDF, screenshots, or image folders to clean Markdown. Use this skill when the user wants document-to-Markdown conversion, Obsidian-ready notes, text extraction, Simplified→Traditional Chinese conversion, scanned/OCR-like visual transcription, chart/table/diagram explanation, or an automatic Doc/VLM routing decision. The skill uses doc_to_md.py for text-first conversion and vlm_prep.py for visual content when needed.
---

# doc-to-md Skill

Convert PDF / TXT / EPUB / scanned PDFs / image-heavy PDFs / images to clean
Markdown. The skill combines the original text-first `doc-to-md` workflow with
the VLM-to-MD visual workflow.

**Routing model:**
- `doc_to_md.py` handles text-first PDFs, EPUB, and TXT.
- `vlm_prep.py` handles scanned PDFs, screenshots/photos, and visual content
  such as charts, tables, framework diagrams, vector exhibits, and image-only
  pages.
- `doc_md_router.py` is the default entrypoint. It inspects the input and calls
  the right script automatically.
- `package_kb.py` packages a final visual knowledge base Markdown file together
  with its `assets/` folder when VLM images are included.

**Works in Codex App and local CLI environments:**
- Use bundled scripts in this skill folder when the skill is copied into
  `$CODEX_HOME/skills/doc-to-md`.
- If the user has already installed the Terminal converters, prefer those fixed
  installed programs:
  - Text converter: `~/.doc-to-md/doc-to-md`
  - VLM converter: `~/.vlm-to-md/vlm-to-md`
- Do not create a temporary virtual environment during document conversion.
- Use bundled scripts only as fallback when fixed installed programs are not
  available.

**Cross-platform** — Mac and Windows. No external vision API, no Ollama, and no
API key. The visual phase relies on the assistant's own image-reading ability
after `vlm_prep.py` renders pages or images into `assets/`.

> **IMPORTANT — Do NOT decline only because a local install is missing.** The
> scripts are bundled inside the skill folder at `scripts/`. If bundled scripts
> exist and fixed installed programs are unavailable, run from the bundled path
> with an available Python that already has the required dependencies.

---

## Step 1 — Choose the Entry Point

### Default: automatic router

Use `scripts/doc_md_router.py` first for normal user requests. It decides:

- EPUB/TXT: run `doc_to_md.py` only.
- PDF with low text density: run `vlm_prep.py --mode pages`.
- Text PDF with charts/images/vector exhibits: run `doc_to_md.py`, then
  `vlm_prep.py --mode figures`.
- Text PDF without visual signals: run `doc_to_md.py` only.
- Image file or image folder: run `vlm_prep.py`.

```bash
# 1. Prefer the user's fixed Terminal installs when available
test -x ~/.doc-to-md/doc-to-md && echo "text converter ok"
test -x ~/.vlm-to-md/vlm-to-md && echo "vlm converter ok"

# 2. Run automatic routing. The router calls the fixed installed converters
#    first, then falls back to bundled scripts.
python3 scripts/doc_md_router.py "/mnt/user-data/uploads/<file>.pdf" -o "/mnt/user-data/outputs/"
```

If the current system `python3` cannot import PyMuPDF for PDF routing, run the
router with the Python from the fixed text converter install:

```bash
~/.doc-to-md/venv/bin/python3 scripts/doc_md_router.py "<file>.pdf" -o "<out>"
```

This uses the already installed Terminal environment. Do not create a one-off
`/tmp` or `/private/tmp` Python environment just to run this skill.

If `scripts/doc_md_router.py` is not at the expected relative path, search the
Skill folder:
```bash
find . -name doc_md_router.py 2>/dev/null | head -3
```

### Manual override

Use direct scripts only when the user explicitly asks for a specific path:

- Text only: `python3 scripts/doc_to_md.py --auto "<input>" -o "<out>"`
- Visual only: `python3 scripts/vlm_prep.py --mode auto "<input>" -o "<out>"`
- Force visual on a text PDF: `python3 scripts/doc_md_router.py "<input.pdf>" -o "<out>" --visual force`
- Disable visual pass: `python3 scripts/doc_md_router.py "<input.pdf>" -o "<out>" --visual off`
- Higher visual DPI: `python3 scripts/doc_md_router.py "<input.pdf>" -o "<out>" --dpi 200`

### Fixed Terminal installs

If the user already ran the Terminal installers, prefer these fixed programs:

- **Text:** `~/.doc-to-md/doc-to-md`
- **VLM:** `~/.vlm-to-md/vlm-to-md`
- **Router Python when needed:** `~/.doc-to-md/venv/bin/python3 scripts/doc_md_router.py`

These are stable user-level tools, not temporary environments. Use them before
attempting dependency installation.

Detect OS:
```bash
python3 -c "import platform; print(platform.system())"
```

If neither Option A nor Option B is available, instruct the user to install using the bundled local installers:

- Mac/Linux installer: `scripts/install.sh`
- Windows installer: `scripts/install.bat`
- Full installation guide: `references/installer-readme.md`
- Text usage guide: `references/full-usage.md`
- VLM usage guide: `references/vlm-usage-guide.md`

The local installers create `~/.doc-to-md/` (Mac/Linux) or
`%USERPROFILE%\.doc-to-md\` (Windows), install Python dependencies in a venv,
copy all Python scripts, and create command-line launchers.

---

## Step 2 — Interpret the Routing Result

The router prints `[ROUTE]` lines before running scripts. Use them to explain
what happened:

| Signal | Meaning | Route |
|--------|---------|-------|
| `scanned: true` | PDF has too little extractable text | VLM pages only |
| `embedded_figures_sample > 0` | Text PDF contains extractable figures | Text + VLM figures |
| `vector_pages_sample > 0` | Text PDF likely has vector charts | Text + VLM figures |
| `caption_pages_sample > 0` | Text PDF has Exhibit/Figure labels | Text + VLM figures |
| no visual signals | Mostly text | Text only |

**Common router flags:**
| Flag | Effect |
|------|--------|
| `--visual auto` | Auto-detect VLM need |
| `--visual force` | Run VLM wherever supported |
| `--visual off` | Skip VLM for PDFs |
| `--vlm-mode pages` | Render full pages |
| `--vlm-mode figures` | Extract figures/charts |
| `--vlm-mode both` | Full pages plus figures |
| `--dpi 200` | Increase visual render quality |
| `--no-convert-chinese` | Skip Simplified→Traditional conversion |
| `-o DIR` | Output directory (default: same folder as input) |

**Supported formats:** `.pdf` `.epub` `.txt` plus images
(`.png`, `.jpg`, `.jpeg`, `.webp`, `.bmp`, `.tif`, `.tiff`, `.gif`) and image
folders.

After running:

- Text output path is printed as `[DONE] Markdown saved to: ...`.
- VLM scaffold path is printed as `[DONE] scaffold saved to: ...`.

---

## Step 3 — Fill Text Summaries and Visual Placeholders

### Text output from `doc_to_md.py`

Read the output Markdown file and fill every `> [!note] 章節摘要` callout block.
Each placeholder looks like:

```
> [!note] 章節摘要
> **摘要**：（AI 助手將在此填入本節摘要）
> **關鍵字**：（AI 助手將在此填入關鍵字）
```

Replace with real content based on the section text below each heading, e.g.:

```
> [!note] 章節摘要
> **摘要**：本章探討習慣的神經學基礎，說明「提示—慣性—獎勵」迴路如何在大腦中形成…
> **關鍵字**：習慣迴路、基底核、自動化行為、獎勵系統
```

**Annotation rules:**
- 摘要：2–4 句話，涵蓋本節核心論點（繁體中文）
- 關鍵字：4–8 個詞，逗號分隔
- Do NOT change any other content — only replace the placeholder lines inside the callout
- Keep all `^anchor-id` tags intact
- If a section is very short (<200 chars), write 摘要：「本節內容過短，請參閱原文。」

**Reading large files:** Use offset+limit to read in 300-line chunks. Process all `> [!note]` blocks across the entire file.

### Visual output from `vlm_prep.py`

The VLM scaffold file is named `*_VLM待解讀.md` and contains `assets/.../*.png`
links. For each image item:

- Open the referenced PNG before writing any description.
- For charts, tables, framework diagrams, and vector exhibits, read title,
  labels, axes, numbers, and source lines from the image. If unreadable, write
  `圖中未能辨識`; do not invent values or sources.
- For scanned/image-only PDF pages, transcribe visible page text into Markdown
  and add a short visual description when useful.
- For decorative photos, write a concise one-sentence description.
- Replace only the placeholder block. Do not change image links, headings, or
  anchors.
- Process large visual sets in batches of 5-10 images.

If final delivery needs to preserve images, run:

```bash
python3 scripts/package_kb.py "<final_visual.md>"
```

This creates a zip containing the Markdown and its `assets/` folder so image
links do not break.

---

## Step 4 — Save and Merge When Both Pipelines Run

After filling text callouts and VLM placeholders, overwrite the generated files
in place.

When both pipelines run on the same PDF:

1. Keep the `doc_to_md.py` Markdown as the main text knowledge base.
2. Use the VLM scaffold as a visual companion knowledge base, or paste each
   chart/table description back near the corresponding chapter or page in the
   text Markdown when the location is clear.
3. If exact placement is uncertain, keep a separate `視覺知識庫` section instead
   of guessing.
4. Package visual Markdown with `assets/` when delivering or moving the file.

**Text final filename format:** `{Author}_{Title}_知識庫.md`

**Visual final filename format:** `{Title}_視覺知識庫.md`

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `No module named 'fitz'` with system Python | Run router with `~/.doc-to-md/venv/bin/python3`; this uses the existing fixed Terminal install |
| Fixed text converter missing | Re-run the `doc-to-md` Terminal installer |
| Fixed VLM converter missing | Re-run the `vlm-to-md` Terminal installer |
| Garbled characters | Try `--no-convert-chinese`; if still garbled, file may need OCR |
| Scanned PDF warning | Use the router or `vlm_prep.py --mode pages`; OCR is optional, not required |
| Text PDF has charts not in Markdown | Use the router default or `--visual force --vlm-mode figures` |
| VLM scaffold has many images | Fill in batches of 5-10 images |
| Image links break after moving Markdown | Run `package_kb.py` and move the resulting zip |
| 0 sections detected | Unusual headings — output still usable, no chapter splits |
| EPUB shows empty chapters | Some DRM-protected EPUBs block extraction; remove DRM first |
| Skill tries to create a temporary venv | **Wrong** — call the fixed Terminal installs first; use bundled scripts only as fallback |
| Skill says "this requires local install" | **Wrong** — prefer fixed installs when present, but bundled scripts are still a fallback |
CODEX_LAZYPACK_DOC_TO_MD_SKILL_MD

# doc-to-md/references/full-usage.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/references/full-usage.md")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/references/full-usage.md" <<'CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_FULL_USAGE_MD'
# doc-to-md 使用說明

> 把 PDF / EPUB / TXT 轉成 Markdown 知識庫，搭配 AI 助手自動寫章節摘要

---

## 運作原理

doc-to-md 分成兩個階段，各自負責不同的事：

```
┌─────────────────────────────┐     ┌─────────────────────────────┐
│  Phase 1：本地轉換（免費）    │     │  Phase 2：AI 助手摘要        │
│  ─────────────────────────  │     │  ─────────────────────────  │
│  你的電腦上執行              │ ──→ │  Codex App 執行         │
│  不花任何 token              │     │  消耗 模型 token           │
│  不需要網路                  │     │  需要 AI 助手帳號            │
│                             │     │                             │
│  • PDF/EPUB/TXT 文字提取     │     │  • 讀取轉好的 Markdown       │
│  • 章節結構偵測              │     │  • 為每個章節寫摘要           │
│  • 簡體→繁體中文轉換         │     │  • 填入關鍵字                │
│  • 頁首頁尾去除              │     │  • 存檔                     │
│  • 斷行合併                  │     │                             │
│  • YAML frontmatter 生成     │     │                             │
│  • Obsidian 錨點標記         │     │                             │
└─────────────────────────────┘     └─────────────────────────────┘
      Python 腳本（本地）                  AI 助手（雲端）
```

**重點：Phase 1 完全免費、離線、不花 token。** 即使你沒有 AI 助手帳號，Phase 1 產出的 Markdown 也已經是可用的知識庫——只是少了章節摘要。

---

## 哪些功能在本地運行（不花 token）

| 功能 | 在哪裡執行 | 花 token 嗎 |
|------|-----------|------------|
| PDF 文字提取 | 本地（PyMuPDF） | 不花 |
| EPUB 內容提取 | 本地（ebooklib） | 不花 |
| TXT 編碼偵測 | 本地（chardet） | 不花 |
| 簡體→繁體轉換 | 本地（OpenCC） | 不花 |
| 章節標題偵測 | 本地（正則比對） | 不花 |
| 頁首頁尾去除 | 本地（統計分析） | 不花 |
| 斷行合併 | 本地（規則判斷） | 不花 |
| YAML frontmatter | 本地（自動生成） | 不花 |
| Obsidian 錨點 | 本地（自動編號） | 不花 |
| **章節摘要撰寫** | **AI 助手** | **花 token** |
| **關鍵字提取** | **AI 助手** | **花 token** |

**結論：90% 的工作在本地完成，只有「寫摘要」這一步用到 AI 助手。**

---

## Token 消耗估算

AI 助手在 Phase 2 需要讀取整份 Markdown 並填寫摘要。消耗量取決於檔案大小：

| 原始檔案大小 | 轉換後 Markdown | 模型 token 估算 | 免費帳號夠用嗎 |
|------------|----------------|-------------------|--------------|
| < 1 MB（短文/報告） | ~50 KB | ~20K tokens | 輕鬆夠用 |
| 1-5 MB（一般書籍） | 100-300 KB | 50-100K tokens | 夠用 |
| 5-20 MB（大部頭）| 300 KB - 1 MB | 100-300K tokens | 可能需分次 |
| > 20 MB（超大檔） | > 1 MB | > 300K tokens | 需要 Pro 帳號或分次處理 |

> **省 token 技巧**：Phase 1 轉換完之後，你可以只讓 AI 助手處理「你需要的章節」，不必一次處理整本書。

---

## Context 限制與解決方案

### 什麼是 Context 限制？

AI 助手每次對話能處理的文字量有上限（稱為 context window）。如果你的 Markdown 檔案太大，AI 助手可能無法一次讀完。

### 會遇到限制嗎？

| 情境 | 會遇到嗎 | 說明 |
|------|---------|------|
| 一般書籍（200-400 頁） | 通常不會 | 轉換後約 100-200 KB，AI 助手可以處理 |
| 大部頭（500+ 頁） | 可能會 | 轉換後可能超過 300 KB |
| 多本書一次處理 | 一定會 | 請一本一本處理 |

### 如果遇到了怎麼辦？

**方法 1：分段處理（推薦）**

跟 AI 助手說：
```
幫我處理這個 Markdown 的前 300 行摘要：/path/to/file.md
```
完成後再說：
```
繼續處理第 301 行到第 600 行
```

**方法 2：只處理需要的章節**

跟 AI 助手說：
```
幫我只寫第 3 章到第 5 章的摘要：/path/to/file.md
```

**方法 3：跳過 Phase 2**

Phase 1 的輸出本身就是完整的 Markdown 知識庫，只是沒有摘要。如果你只需要全文搜尋，Phase 1 就夠了。

---

## 使用方式

### 方式 A：跟 AI 助手說（最簡單）

打開 Codex App，直接說：

**Mac：**
```
幫我把這個 PDF 轉成 Markdown：{{HOME}}/Desktop/書名.pdf
```

**Windows：**
```
幫我把這個 PDF 轉成 Markdown：C:\Users\你的名字\Desktop\書名.pdf
```

AI 助手會自動執行 Phase 1 + Phase 2。

**其他說法也行：**
- 「轉換這個 EPUB 成知識庫」
- 「把這份 TXT 轉成 Markdown 格式」
- 「幫我處理這本電子書」

### 方式 B：自己跑 Phase 1，AI 助手跑 Phase 2

適合大檔案或想省 token 的情境：

**Step 1**：在 Terminal / PowerShell 手動執行轉換

Mac：
```bash
~/.doc-to-md/doc-to-md --auto ~/Desktop/書名.pdf -o ~/Desktop/
```

Windows：
```
%USERPROFILE%\.doc-to-md\doc-to-md.bat --auto C:\Users\你的名字\Desktop\書名.pdf -o C:\Users\你的名字\Desktop\
```

**Step 2**：把轉好的 .md 檔案路徑給 AI 助手
```
幫我為這個 Markdown 填寫章節摘要：{{HOME}}/Desktop/作者_書名_知識庫.md
```

### 方式 C：純本地使用（完全不花 token）

只跑 Phase 1，不讓 AI 助手寫摘要：

Mac：
```bash
~/.doc-to-md/doc-to-md --auto ~/Desktop/書名.pdf -o ~/Desktop/
```

Windows：
```
%USERPROFILE%\.doc-to-md\doc-to-md.bat --auto C:\Users\你的名字\Desktop\書名.pdf -o C:\Users\你的名字\Desktop\
```

輸出的 Markdown 有完整的章節結構、錨點、YAML metadata，只是摘要欄位是空的 placeholder。你可以：
- 直接丟進 Obsidian 使用
- 自己手動填摘要
- 之後有空再讓 AI 助手補

---

## 輸出檔案說明

轉換後的 Markdown 結構：

```markdown
---
title: "原子習慣"          ← 書名（自動從 PDF metadata 提取）
author: "James Clear"       ← 作者
format: PDF                 ← 原始格式
pages: 320                  ← 頁數
converted_at: "2026-04-25"  ← 轉換日期
---

# 原子習慣

## 第1章 微小習慣的驚人力量 ^ch-01    ← 章節標題 + Obsidian 錨點

> [!note] 章節摘要                    ← AI 助手會填寫這裡
> **摘要**：本章說明每天進步 1% 的複利效應…
> **關鍵字**：複利效應、1% 法則、習慣系統

英國自行車隊在 Dave Brailsford…       ← 原文內容（完整保留）
```

**檔名格式**：`{作者}_{書名}_知識庫.md`

**Obsidian 友善**：
- `^ch-01` 錨點可在 Obsidian 中跨檔案連結
- `> [!note]` callout 在 Obsidian 中會顯示為美觀的摘要卡片
- YAML frontmatter 可被 Obsidian Dataview 查詢

---

## 支援的檔案格式

| 格式 | 副檔名 | 適合 | 注意事項 |
|------|--------|------|---------|
| PDF | `.pdf` | 電子書、報告、論文 | 掃描版 PDF 需先 OCR |
| EPUB | `.epub` | 電子書 | 有 DRM 的需先移除 |
| TXT | `.txt` | 逐字稿、純文字 | 自動偵測編碼 |

### 不支援（需要先轉檔）

| 格式 | 建議做法 |
|------|---------|
| Word (.docx) | 先「另存為 PDF」 |
| Google Docs | 先「下載為 PDF」 |
| 網頁 | 先「列印為 PDF」或用瀏覽器存成 PDF |
| 掃描圖片 PDF | 先用 Adobe Acrobat 或 tesseract 做 OCR |

---

## 常用參數

| 參數 | 效果 | 什麼時候用 |
|------|------|-----------|
| `--auto` | 自動偵測檔案格式 | 永遠都加（預設行為） |
| `--no-convert-chinese` | 不做簡→繁轉換 | 原文就是繁體、或轉換後亂碼時 |
| `-o 目錄` | 指定輸出位置 | 想存到特定資料夾時 |

---

## 常見問題

| 問題 | 原因 | 解法 |
|------|------|------|
| 「Python 3.8+ required」 | Python 太舊 | 到 python.org 下載 3.12 |
| Windows 顯示「已保護您的電腦」 | Windows SmartScreen | 點「其他資訊」→「仍要執行」 |
| 「No module named fitz」 | 沒裝好依賴 | 重跑安裝程式 |
| 轉出來是亂碼 | OpenCC 轉換問題 | 加 `--no-convert-chinese` |
| 「0 sections detected」 | 書的標題格式特殊 | 仍可使用，只是沒有章節分割 |
| AI 助手說檔案太大 | 超過 context 限制 | 分段處理（見上方說明） |
| EPUB 章節是空的 | DRM 保護 | 需先移除 DRM |
| PDF 只有圖片沒有文字 | 掃描版 PDF | 需先 OCR |
| AI 助手沒有自動執行 | Skill 沒裝好 | 確認 Codex App Skills 列表有 doc-to-md |
| Windows 找不到 Python | 安裝時沒勾 PATH | 重新安裝 Python，勾選「Add Python to PATH」 |

---

## 解除安裝

**Mac：**
```bash
rm -rf ~/.doc-to-md
```

**Windows（PowerShell）：**
```powershell
Remove-Item -Recurse -Force "$env:USERPROFILE\.doc-to-md"
```

然後在 Codex App → Settings → Skills 中移除 `doc-to-md`。
CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_FULL_USAGE_MD

# doc-to-md/references/installer-readme.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/references/installer-readme.md")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/references/installer-readme.md" <<'CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_INSTALLER_README_MD'
# doc-to-md 安裝與使用說明

> 把 PDF / EPUB / TXT 檔案轉成乾淨的 Markdown 知識庫，搭配 AI 助手自動寫章節摘要

---

## 安裝（只需做一次，約 2 分鐘）

### Step 1：解壓縮

雙擊下載的 `doc-to-md-安裝包.zip`，解壓縮到任意資料夾。

### Step 2：執行安裝程式

#### Mac 用戶

按 `⌘ + 空白鍵` → 輸入 `Terminal` → 按 Enter。

在 Terminal 中輸入 `bash `（注意 bash 後面有一個空格），然後**把 `install.sh` 檔案拖進 Terminal 視窗**，按 Enter：

```
bash {{CODEX_HOME}}/skills/doc-to-md/scripts/install.sh
```

> 不用手動打路徑！直接從 Finder 拖檔案進 Terminal 就好。

#### Windows 用戶

在解壓縮的資料夾中，**雙擊 `install.bat`** 即可自動安裝。

> 如果出現「Windows 已保護您的電腦」提示，點「其他資訊」→「仍要執行」。

安裝程式會自動：
- 檢查你的 Python 版本
- 建立獨立的虛擬環境（不影響你電腦其他程式）
- 安裝所有需要的套件
- 驗證安裝是否成功

**如果出現「找不到 Python 3.8+」**：
1. 安裝程式會自動打開 Python 下載頁面
2. 下載安裝 Python 3.12（點網頁上的大黃色按鈕）
3. **Windows 用戶：安裝時務必勾選「Add Python to PATH」**
4. 安裝完成後，**關閉 Terminal / 命令提示字元 重新開啟**
5. 再次執行安裝程式

### Step 3：在 Codex App 加入技能

1. 打開 **Codex App**
2. 點左上方 **Customize** → **Skills** → **+** 號 → **Create Skill** → **Upload a skill**
3. 選擇安裝包裡的 **skill.zip** 上傳
4. 確認 `doc-to-md` 出現在 Skills 列表中

---

## 使用方式

### 方式 A：直接跟 AI 助手說（推薦）

在 Codex App 的對話框中輸入：

**Mac：**
```
幫我把這個 PDF 轉成 Markdown：{{HOME}}/Desktop/書名.pdf
```

**Windows：**
```
幫我把這個 PDF 轉成 Markdown：C:\Users\你的名字\Desktop\書名.pdf
```

AI 助手會自動：
1. 執行轉換腳本
2. 讀取輸出的 Markdown
3. 為每個章節填寫摘要和關鍵字
4. 儲存完成的知識庫

### 方式 B：手動在 Terminal 執行

**Mac：**
```bash
~/.doc-to-md/doc-to-md --auto ~/Desktop/書名.pdf -o ~/Desktop/
```

**Windows（PowerShell 或命令提示字元）：**
```
%USERPROFILE%\.doc-to-md\doc-to-md.bat --auto C:\Users\你的名字\Desktop\書名.pdf -o C:\Users\你的名字\Desktop\
```

轉換完成後，把輸出的 `.md` 檔案丟給 AI 助手填寫摘要。

---

## 輸出範例

轉換後的 Markdown 長這樣：

```markdown
---
title: "原子習慣"
author: "James Clear"
format: PDF
pages: 320
converted_at: "2026-04-25 17:00"
---

# 原子習慣

## 第1章 微小習慣的驚人力量 ^ch-01

> [!note] 章節摘要
> **摘要**：本章說明為什麼每天進步 1% 的複利效應遠超預期…
> **關鍵字**：複利效應、1% 法則、習慣系統、長期思維

英國自行車隊在 Dave Brailsford 的帶領下，採用了「邊際增益」策略…
```

---

## 常見問題

| 問題 | 解法 |
|------|------|
| 安裝時說「Python 版本太舊」 | 到 python.org 下載 Python 3.12，安裝後重開 Terminal 再試 |
| Windows 顯示「已保護您的電腦」 | 點「其他資訊」→「仍要執行」 |
| AI 助手說找不到轉換器 | 確認有執行過安裝程式，Mac 試 `~/.doc-to-md/doc-to-md --help`，Windows 試 `%USERPROFILE%\.doc-to-md\doc-to-md.bat --help` |
| 轉出來是亂碼 | 加上 `--no-convert-chinese` 參數再試一次 |
| PDF 內容是掃描圖片 | 這種 PDF 需要先用 OCR 軟體處理（如 Adobe Acrobat） |
| EPUB 章節是空的 | 可能有 DRM 保護，需先移除 |
| Windows 安裝 Python 後仍找不到 | 確認安裝時有勾選「Add Python to PATH」，若沒勾要重新安裝 |

---

## 解除安裝

**Mac：**
```bash
rm -rf ~/.doc-to-md
```

**Windows（PowerShell）：**
```powershell
Remove-Item -Recurse -Force "$env:USERPROFILE\.doc-to-md"
```

然後在 Codex App → Skills 中移除 `doc-to-md`。

---

## 技術資訊（給老師看的）

| 項目 | Mac | Windows |
|------|-----|---------|
| 安裝位置 | `~/.doc-to-md/` | `%USERPROFILE%\.doc-to-md\` |
| 虛擬環境 | `~/.doc-to-md/venv/` | `%USERPROFILE%\.doc-to-md\venv\` |
| 啟動器 | `~/.doc-to-md/doc-to-md`（bash） | `%USERPROFILE%\.doc-to-md\doc-to-md.bat` |
| Python 需求 | 3.8+（建議 3.12） | 3.8+（建議 3.12） |
| 套件依賴 | PyMuPDF, ebooklib, beautifulsoup4, chardet, opencc-python-reimplemented, lxml | 同左 |
| 支援格式 | PDF, EPUB, TXT | PDF, EPUB, TXT |
| 輸出格式 | Markdown + YAML frontmatter + Obsidian callout blocks | 同左 |
CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_INSTALLER_README_MD

# doc-to-md/references/usage-guide.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/references/usage-guide.md")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/references/usage-guide.md" <<'CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_USAGE_GUIDE_MD'
# doc-to-md Usage Guide

Detailed examples, edge cases, and advanced usage for the `doc-to-md` skill.

---

## Installation Walkthrough

### Codex default: fixed Terminal installs

For Codex document-conversion runs, use the converters the user already
installed from Terminal. Do not create a temporary virtual environment for a
one-off conversion.

```bash
test -x ~/.doc-to-md/doc-to-md && echo "text converter ok"
test -x ~/.vlm-to-md/vlm-to-md && echo "vlm converter ok"
~/.doc-to-md/venv/bin/python3 {{CODEX_HOME}}/skills/doc-to-md/scripts/doc_md_router.py "book.pdf" -o ./output/
```

The router calls `~/.doc-to-md/doc-to-md` and `~/.vlm-to-md/vlm-to-md` first,
then falls back to bundled scripts only when those fixed installs are missing.

### macOS fixed converter check
```bash
~/.doc-to-md/doc-to-md --help
~/.vlm-to-md/vlm-to-md --help
```

### Windows fixed converter check
```powershell
%USERPROFILE%\.doc-to-md\doc-to-md.bat --help
%USERPROFILE%\.vlm-to-md\vlm-to-md.bat --help
```

### Linux fixed converter check
```bash
~/.doc-to-md/doc-to-md --help
~/.vlm-to-md/vlm-to-md --help
```

### Persistent virtual environment (optional)

Use this only for a deliberate, persistent user-level install. It is not the
default Codex workflow and should not be created temporarily per conversion.

```bash
python3 -m venv doc-env
source doc-env/bin/activate        # macOS/Linux
# doc-env\Scripts\activate.bat     # Windows
pip install PyMuPDF ebooklib beautifulsoup4 chardet opencc-python-reimplemented lxml
python3 {{CODEX_HOME}}/skills/doc-to-md/scripts/doc_to_md.py book.pdf
```

---

## Usage Examples

### Automatic routing (recommended)
```bash
python3 {{CODEX_HOME}}/skills/doc-to-md/scripts/doc_md_router.py \
  "report.pdf" \
  -o ~/Documents/output/
```

The router decides whether to run text conversion, VLM visual preparation, or
both. Use this for ordinary `doc-to-md` requests.

### Force visual pass for a text PDF with charts
```bash
python3 {{CODEX_HOME}}/skills/doc-to-md/scripts/doc_md_router.py \
  "consulting_report.pdf" \
  -o ~/Documents/output/ \
  --visual force \
  --vlm-mode figures
```

### Basic PDF conversion
```bash
python3 {{CODEX_HOME}}/skills/doc-to-md/scripts/doc_to_md.py "Atomic Habits.pdf"
# Output: Atomic_Habits_知識庫.md  (same folder)
```

### PDF to specific output folder
```bash
python3 {{CODEX_HOME}}/skills/doc-to-md/scripts/doc_to_md.py \
  "第一性原理.pdf" \
  -o ~/Documents/Obsidian/original/ebook/
```

### EPUB book
```bash
python3 {{CODEX_HOME}}/skills/doc-to-md/scripts/doc_to_md.py \
  --auto "deep_work.epub" \
  -o ~/Documents/output/
```

### TXT transcript (no Chinese conversion)
```bash
python3 {{CODEX_HOME}}/skills/doc-to-md/scripts/doc_to_md.py \
  --auto "lecture_transcript.txt" \
  --no-convert-chinese \
  -o ~/Documents/output/
```

---

## Output Format

### YAML Frontmatter
```yaml
---
title: "原子習慣"
author: "詹姆斯·克利爾"
source: "atomic-habits-zh.pdf"
format: PDF
pages: 320
converted_at: "2026-04-14 10:30"
---
```

### Section Heading with Anchor
```markdown
## 第1章 微小改變帶來的驚人力量 ^ch-01
```

### Section Placeholder (before AI 助手fills it)
```markdown
> [!note] 章節摘要
> **摘要**：（AI 助手將在此填入本節摘要）
> **關鍵字**：（AI 助手將在此填入關鍵字）
```

### After AI 助手Annotation
```markdown
> [!note] 章節摘要
> **摘要**：本章介紹「1%法則」——每天微小的改善，一年後會帶來37倍的複利效果。作者以英國自行車隊為例，說明累積優勢如何創造非凡成果。
> **關鍵字**：1%法則、複利效應、累積優勢、邊際增益、習慣系統
```

---

## Section Detection Patterns

The script detects sections matching these patterns (auto-detected):

### Books
| Pattern | Example | Type |
|---------|---------|------|
| `第N章 Title` | `第三章 習慣的科學` | chapter |
| `Chapter N: Title` | `Chapter 3: The Science of Habits` | chapter |
| `第N部 Title` | `第二部 行為改變的四個法則` | part |
| `Part N: Title` | `Part II: The Four Laws` | part |
| `N. Title` | `3. Building Better Habits` | numbered |

### Transcripts / Lectures
| Pattern | Example | Type |
|---------|---------|------|
| `第N講 Title` | `第五講 決策思考框架` | lecture |
| `第N課 Title` | `第一課 課程介紹` | lesson |
| `Lecture N: Title` | `Lecture 5: Decision Frameworks` | lecture |
| `HH:MM:SS Text` | `00:32:15 今天我們來談...` | timestamp |

---

## Handling Problematic Files

### Scanned / Image-only PDFs

**Symptom:** Script warns `Low text density (X chars/page avg)`

**Recommended solution:** Use the combined router or VLM preprocessor:
```bash
python3 {{CODEX_HOME}}/skills/doc-to-md/scripts/doc_md_router.py \
  "scan.pdf" \
  -o ~/Documents/output/
```

The router will choose `vlm_prep.py --mode pages` when the PDF has too little
extractable text. Then the assistant opens the generated PNG pages and
transcribes visible text into Markdown.

**Alternative:** Pre-process with OCR first:
```bash
# Using tesseract (free)
tesseract input.pdf output_base pdf

# Using ocrmypdf (recommended)
pip install ocrmypdf
ocrmypdf input.pdf input_ocr.pdf
python3 doc_to_md.py input_ocr.pdf
```

### Garbled Chinese Text

**Symptom:** Output shows `□□□` or `???` characters

**Cause:** Encoding mismatch (Big5, GB2312, etc.)

**Solution 1:** Script auto-detects encoding for TXT files. Try:
```bash
python3 doc_to_md.py file.txt  # chardet handles it automatically
```

**Solution 2:** Manually specify by converting file first:
```bash
iconv -f big5 -t utf-8 input.txt > input_utf8.txt
python3 doc_to_md.py input_utf8.txt
```

### No Sections Detected

**Symptom:** Output has no `## Chapter` headings, only one big block

**Cause:** File uses non-standard heading format

**Solution:** After conversion, manually add headings in the Markdown, or ask AI 助手to detect and insert headings based on content flow.

### DRM-Protected EPUBs

**Symptom:** EPUB extracts but chapters are empty

**Cause:** Adobe DRM or other encryption

**Solution:** Use Calibre to remove DRM (only for books you own), then reconvert.

---

## Chinese Conversion Details

The script uses `opencc` with `s2twp` profile (Simplified → Traditional Taiwan):

| Input | Output |
|-------|--------|
| 软件 | 軟體 |
| 程序 | 程式 |
| 互联网 | 網際網路 |
| 视频 | 影片 |
| 文件 | 檔案 |

To skip conversion (e.g., book is already Traditional):
```bash
python3 doc_to_md.py book.pdf --no-convert-chinese
```

---

## AI 助手Annotation — Prompt Template

When AI 助手fills in the summaries, it uses this internal logic:

```
For each section in the Markdown file:
1. Read the heading and all body text until the next ## heading
2. Write a 2-4 sentence 摘要 in Traditional Chinese (Taiwan terms)
3. Extract 4-8 關鍵字 (single words or 2-4 char phrases)
4. Replace only the placeholder lines inside the > [!note] callout
5. Preserve all ^anchor tags and other content unchanged
```

**Example sections AI 助手handles well:**
- Dense academic text: extracts core arguments
- Narrative examples: identifies the principle being illustrated  
- Step-by-step instructions: summarizes the procedure
- Timestamp-based transcripts: captures main topic discussed

---

## File Naming Convention

| Condition | Output Filename |
|-----------|----------------|
| Author known | `{Author}_{Title}_知識庫.md` |
| Author unknown | `{Title}_知識庫.md` |
| Title has special chars | Special chars stripped, spaces → underscores |
| Title > 50 chars | Truncated to 50 chars |

**Examples:**
- `詹姆斯_克利爾_原子習慣_知識庫.md`
- `Cal_Newport_Deep_Work_知識庫.md`
- `第一性原理思考_知識庫.md`

---

## Integration with Obsidian

For direct Obsidian Vault integration:

```bash
python3 doc_to_md.py "book.pdf" -o ~/Documents/Obsidian/original/ebook/
```

The `^anchor-id` tags on headings are Obsidian block references, enabling:
```markdown
[[書名_知識庫#^ch-03|查看第3章]]
```

---

## Limitations

| Limitation | Details |
|-----------|---------|
| Scanned PDFs | No OCR — must pre-process |
| Images/charts | Not extracted (text-only output) |
| Complex PDF layouts | Tables, columns may merge incorrectly |
| DRM EPUB | Cannot decrypt |
| Very long TXT | No page count in metadata |
| Timestamp sections | Only detected if format is `HH:MM:SS` or `MM:SS` |

The limitations above apply to `doc_to_md.py` alone. The combined skill now
bundles `vlm_prep.py` for scanned PDFs, images, charts, tables, and diagrams.
See `references/combined-routing-guide.md` and `references/vlm-usage-guide.md`.
CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_USAGE_GUIDE_MD

# doc-to-md/references/combined-routing-guide.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/references/combined-routing-guide.md")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/references/combined-routing-guide.md" <<'CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_COMBINED_ROUTING_GUIDE_MD'
# doc-to-md Combined Routing Guide

This guide explains how the unified `doc-to-md` skill chooses between the
text-first converter and the visual VLM converter.

## Bundled Scripts

| Script | Role |
|---|---|
| `scripts/doc_md_router.py` | Default entrypoint. Detects input type and calls the right converter. |
| `scripts/doc_to_md.py` | Text-first converter for PDF / EPUB / TXT. |
| `scripts/vlm_prep.py` | Visual preprocessor for scanned PDFs, images, charts, tables, diagrams, and vector exhibits. |
| `scripts/package_kb.py` | Packages final visual Markdown with its `assets/` folder into a portable zip. |

## Default Decision Rules

1. EPUB or TXT:
   - Run `doc_to_md.py`.
   - No VLM pass.
2. Image file or image folder:
   - Run `vlm_prep.py`.
   - The assistant must open images and fill visual placeholders.
3. PDF with low extractable text density:
   - Treat as scanned/image PDF.
   - Run `vlm_prep.py --mode pages`.
   - Do not run `doc_to_md.py` unless the user explicitly wants the weak text layer too.
4. Text PDF with embedded figures, vector-heavy pages, or Exhibit/Figure captions:
   - Run `doc_to_md.py` for text.
   - Run `vlm_prep.py --mode figures` for visual content.
5. Text PDF without visual signals:
   - Run `doc_to_md.py`.
   - Skip VLM.

## Commands

Use the user's fixed Terminal installs first. Do not create a temporary virtual
environment for a single conversion.

```bash
test -x ~/.doc-to-md/doc-to-md && echo "text converter ok"
test -x ~/.vlm-to-md/vlm-to-md && echo "vlm converter ok"
```

If the current system `python3` lacks PyMuPDF for PDF routing, run the bundled
router with the already installed text-converter Python:

```bash
~/.doc-to-md/venv/bin/python3 scripts/doc_md_router.py "input.pdf" -o "output/"
```

Automatic:

```bash
python3 scripts/doc_md_router.py "input.pdf" -o "output/"
```

Force VLM for a text PDF:

```bash
python3 scripts/doc_md_router.py "input.pdf" -o "output/" --visual force
```

Text only:

```bash
python3 scripts/doc_md_router.py "input.pdf" -o "output/" --visual off
```

Visual only:

```bash
python3 scripts/vlm_prep.py --mode auto "input.pdf" -o "output/"
```

Package final visual knowledge base:

```bash
python3 scripts/package_kb.py "output/input_視覺知識庫.md"
```

## VLM Accuracy Rules

- Open every referenced PNG before writing visual descriptions.
- Read numbers, labels, titles, and sources directly from the image.
- If unreadable, write `圖中未能辨識`.
- Do not invent sources, country lists, axes, or values.
- For scanned pages, transcribe visible text into Markdown.
- For decorative photos, keep the description short.
- Preserve image links and headings.

## Merge Rules

When text and VLM outputs both exist:

1. Treat the text Markdown as the main knowledge base.
2. Place visual descriptions near the corresponding chapter or page only when
   the location is obvious.
3. If placement is uncertain, keep a separate `視覺知識庫` section or companion
   file.
4. Package visual Markdown with `assets/` before moving or sharing it.
CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_COMBINED_ROUTING_GUIDE_MD

# doc-to-md/references/vlm-usage-guide.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/references/vlm-usage-guide.md")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/references/vlm-usage-guide.md" <<'CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_VLM_USAGE_GUIDE_MD'
# vlm-to-md 使用說明

> 用 AI 助手自己的眼睛，把「看得到、抽不出文字」的內容變成知識庫。

---

## 運作原理：AI 助手就是那個 VLM

很多人以為「VLM（視覺語言模型）」一定要接 GPT-4o、Gemini，要 API key、要付費。
其實 **Codex App 本身就是一個 VLM**——它看得懂圖。所以這個工具的設計很簡單：

```
┌─────────────────────────────┐     ┌─────────────────────────────┐
│  Phase 1：本地渲染（免費）    │     │  Phase 2：AI 助手看圖填字     │
│  ─────────────────────────  │     │  ─────────────────────────  │
│  你的電腦上執行              │ ──→ │  Codex App 執行         │
│  不花任何 token              │     │  用 AI 助手內建視覺          │
│  不需要網路、不需 API key     │     │  不需要 API key              │
│                             │     │                             │
│  • PDF 整頁渲染成 PNG        │     │  • 逐張開圖                  │
│  • 智能提取嵌入圖表          │     │  • 判斷類型（表格/圖表…）     │
│  • 圖片資料夾整理            │     │  • 寫 2-3 句內容描述         │
│  • 產出 Markdown 骨架        │     │  • 補可檢索關鍵字            │
│  • 掃描 PDF 偵測             │     │  • 掃描頁→逐字謄寫           │
└─────────────────────────────┘     └─────────────────────────────┘
      Python（本地）                      AI 助手（你的訂閱內）
```

**重點：Phase 1 只是「把圖準備好」，完全不做 AI 判讀。** 真正的「看圖說話」是 AI 助手在 Phase 2 做的，用的是你現有的 AI 助手（免費版也能用）。

---

## 哪些在本地、哪些用 AI 助手

| 功能 | 在哪裡 | 花 token 嗎 |
|------|--------|------------|
| PDF 整頁渲染 PNG | 本地（PyMuPDF） | 不花 |
| 嵌入圖表提取 + 篩選 | 本地（PyMuPDF） | 不花 |
| 掃描 PDF 偵測 | 本地（文字密度） | 不花 |
| 圖片資料夾整理 | 本地（Pillow） | 不花 |
| Markdown 骨架生成 | 本地 | 不花 |
| **看圖、寫描述** | **AI 助手視覺** | **花 token** |
| **掃描頁逐字謄寫** | **AI 助手視覺** | **花 token** |

---

## 三種典型情境

### 情境 1：掃描版 PDF（doc-to-md 處理不了的那種）

doc-to-md 的 README 寫得很清楚：掃描版 PDF「需要先 OCR」。vlm-to-md 就是來補這個洞。

```
auto 模式會偵測到「抽不出文字」→ 自動整頁渲染 → AI 助手逐頁謄寫
```

跟 AI 助手說：「幫我把這份掃描 PDF 轉成文字知識庫：/path/scan.pdf」

### 情境 2：文字型 PDF 裡的圖表

文字交給 doc-to-md，圖表交給這裡：

```bash
vlm-to-md --mode figures /path/report.pdf -o /path/out/
```

AI 助手會把每張圖表寫成「類型 + 內容 + 關鍵字」，貼回知識庫對應位置。

### 情境 3：一疊截圖／照片／手寫筆記

把它們丟進一個資料夾，指向那個資料夾即可：

```bash
vlm-to-md /path/screenshots_folder/ -o /path/out/
```

---

## 使用方式

### 方式 A：跟 AI 助手說（最簡單）

打開 Codex App：

```
幫我把這個 PDF 用視覺轉成 Markdown：/Users/你的名字/Desktop/掃描檔.pdf
```

AI 助手會自動跑 Phase 1 + Phase 2。

### 方式 B：自己跑 Phase 1，AI 助手跑 Phase 2（省 token / 大檔）

```bash
# Mac
~/.vlm-to-md/vlm-to-md --auto ~/Desktop/掃描檔.pdf -o ~/Desktop/
# Windows
%USERPROFILE%\.vlm-to-md\vlm-to-md.bat --auto C:\Users\你\Desktop\掃描檔.pdf -o C:\Users\你\Desktop\
```

然後把 `*_VLM待解讀.md` 路徑給 AI 助手：「幫我用視覺完成這份待解讀檔」。

### 方式 C：純本地（完全不花 token）

只跑 Phase 1，得到圖檔 + 骨架。骨架的 placeholder 留著空，之後有空再讓 AI 助手補，或自己手填。

---

## 常用參數

| 參數 | 效果 | 什麼時候用 |
|------|------|-----------|
| `--auto` | 自動判定掃描/文字 | 預設、最省事 |
| `--mode pages` | 每頁渲染成圖 | 掃描版、投影片、資訊圖 |
| `--mode figures` | 只抽嵌入圖表 | 文字 PDF（搭 doc-to-md） |
| `--mode both` | 整頁 + 圖表 | 要最完整視覺備份 |
| `--dpi 200` | 提高渲染解析度 | 圖太糊、字看不清 |
| `-o 目錄` | 指定輸出位置 | 想存到特定資料夾 |

---

## 支援格式

| 輸入 | 說明 |
|------|------|
| PDF | 掃描版、圖文混排、純文字皆可（auto 自動分流） |
| 圖片 | png, jpg, jpeg, webp, bmp, tif, gif |
| 圖片資料夾 | 整個資料夾批次處理 |

---

## 常見問題

| 問題 | 原因 | 解法 |
|------|------|------|
| 「Python 3.8+ required」 | Python 太舊 | 到 python.org 下載 3.12 |
| Windows「已保護您的電腦」 | SmartScreen | 點「其他資訊」→「仍要執行」 |
| 「No module named fitz」 | 沒裝好依賴 | 重跑安裝程式 |
| 文字 PDF 抽不到圖 | 本來沒嵌圖／圖被濾掉 | 文字改用 doc-to-md |
| 渲染出來糊 | DPI 太低 | 加 `--dpi 200` |
| 圖太多很慢 | 一次太多 | Phase 2 分批，每次 5-10 張 |
| AI 助手說不能看圖 | 誤會 | Codex App 用 Read 直接讀 PNG |

---

## 解除安裝

```bash
# Mac
rm -rf ~/.vlm-to-md
# Windows (PowerShell)
Remove-Item -Recurse -Force "$env:USERPROFILE\.vlm-to-md"
```

然後在 Codex App → Skills 移除 `vlm-to-md`。
CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_VLM_USAGE_GUIDE_MD

# doc-to-md/references/vlm-design-notes.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/references/vlm-design-notes.md")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/references/vlm-design-notes.md" <<'CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_VLM_DESIGN_NOTES_MD'
# vlm-to-md 設計思考筆記

> 這份筆記不是教你「怎麼用」，而是記錄「我是怎麼想的」。
> 每一個設計決策，背後都先問了一個對的問題。這也是社群直播要帶大家練的事。

來源思考習慣：密涅瓦 76 個 Habits of Mind，本案主用 #問對問題（#rightproblem）。

---

## 決策 1：先問「真正的問題是什麼？」而不是「VLM 怎麼接？」

**直覺答案**：要做 VLM，就去接 GPT-4o / Gemini 的視覺 API。
**問對問題**：使用者真正卡住的是什麼？

退一步用 5 Whys：
- 為什麼要 VLM？→ 因為 doc-to-md 處理不了掃描 PDF 和圖表。
- 為什麼處理不了？→ 因為那些內容是「圖」，抽不出文字。
- 為什麼一定要外部 VLM？→ ……其實不一定。**AI 助手本身就看得懂圖。**

**根本洞察**：問題不是「去哪找 VLM」，而是「怎麼把圖餵到一個我們已經有的 VLM 面前」。
那個 VLM 就是 Codex App。

→ 對應思考題：**你是在解決問題，還是在重複別人的解法？**

---

## 決策 2：限制 vs 障礙——分清楚才不會做白工

用「100 倍資源測試」拆解：

| 項目 | 100 倍資源能解決嗎？ | 結論 |
|------|---------------------|------|
| 新手不會設定 API key | 能（給錢請人代設） | 障礙 → 可繞過 |
| 新手不想付費 | 不能（這是前提） | **限制 → 必須遵守** |
| 沒有顯卡跑本地模型 | 能（買硬體） | 障礙，但對新手＝限制 |

「免費」是**限制**，不是障礙。所以不能用付費 API、也不能要新手裝 Ollama。
唯一同時滿足「免費 + 不裝模型 + 視覺」的，就是 Codex App 內建視覺。

→ 對應思考題：**這條路上，哪些是搬得動的石頭，哪些是搬不動的牆？**

---

## 決策 3：沿用「兩階段」而不是重新發明

doc-to-md 已經驗證過一個好用的分工：本地做粗活（免費、0 token），AI 助手做細活。
VLM 直接套同一個骨架——本地渲染圖，AI 助手看圖。

好處：學過 doc-to-md 的人，心智模型直接遷移，學習成本接近零。

→ 對應思考題：**新東西能不能掛在大家已經懂的舊東西上？**

---

## 決策 4：保留 v7.0 已驗證的細節，丟掉用不到的

v7.0 經 14 個 HBS/Ivey/IMD/INSEAD 案例實測過。哪些值得留？

留下（已被驗證有效）：
- 圖片篩選門檻（250x200px、80K area、aspect<8）→ 濾掉 logo 與裝飾條
- blockquote 描述格式（類型 + 2-3 句內容）→ 對 RAG 檢索友善

丟掉（這次的限制下用不到）：
- OpenRouter / Kimi / Qwen fallback → 要 API key，違反「免費」限制
- 拒絕重試機制 → AI 助手自己不會拒絕描述自己看的圖

→ 對應思考題：**哪些是「驗證過的資產」值得繼承，哪些是「為了舊限制」該放掉？**

---

## 決策 5：怎麼知道「做對了」？——先想驗證，再寫程式

動手前先定義成功標準（可量測，不是「效果好」）：
- 掃描 PDF：每頁都渲染成圖、骨架頁數 = PDF 頁數
- 文字 PDF：只抽出符合尺寸的圖表，不混入 logo
- 圖片資料夾：每張都進 assets、骨架條目數 = 圖片數
- 全程不需要任何 API key 或網路

→ 對應思考題：**在你動手之前，你能說出「怎樣才算成功」嗎？**

---

## 一句話總結

> 最好的 VLM 工具，可能不是「再接一個 VLM」，
> 而是「想清楚你手上已經有一個，只是還沒把圖餵給它」。
CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_VLM_DESIGN_NOTES_MD

# doc-to-md/scripts/doc_md_router.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_md_router.py")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_md_router.py" <<'CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_DOC_MD_ROUTER_PY'
#!/usr/bin/env python3
"""
doc_md_router.py — unified Doc/VLM to Markdown router.

This script does not replace doc_to_md.py or vlm_prep.py. It decides which
pipeline is appropriate for an input file and calls the bundled scripts:

- doc_to_md.py for text-first PDF / EPUB / TXT conversion.
- vlm_prep.py for scanned PDFs, visual PDFs, images, and chart extraction.
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Optional


IMG_EXTS = {".png", ".jpg", ".jpeg", ".webp", ".bmp", ".tif", ".tiff", ".gif"}
SCANNED_CHARS_PER_PAGE = 80
VECTOR_DRAW_THRESHOLD = 25
MIN_IMG_WIDTH = 250
MIN_IMG_HEIGHT = 200
MIN_IMG_AREA = 80000
MAX_ASPECT_RATIO = 8
INSTALLED_DOC_TO_MD = Path.home() / ".doc-to-md" / "doc-to-md"
INSTALLED_VLM_TO_MD = Path.home() / ".vlm-to-md" / "vlm-to-md"


def script_dir() -> Path:
    return Path(__file__).resolve().parent


def run(cmd: list[str]) -> int:
    print("[RUN] " + " ".join(str(x) for x in cmd), flush=True)
    return subprocess.call(cmd)


def installed_or_script(installed: Path, script: Path) -> Optional[list[str]]:
    """Prefer user's fixed Terminal install, fall back to bundled script."""
    if installed.exists() and os.access(installed, os.X_OK):
        return [str(installed)]
    if script.exists():
        return [sys.executable, str(script)]
    return None


def import_fitz():
    try:
        import fitz  # type: ignore
        return fitz
    except ImportError:
        try:
            import pymupdf as fitz  # type: ignore
            return fitz
        except ImportError:
            print(
                "[ERROR] PyMuPDF is required for PDF routing. "
                "Run this router with the fixed install Python, for example: "
                "~/.doc-to-md/venv/bin/python3 scripts/doc_md_router.py",
                file=sys.stderr,
            )
            return None


def pdf_signals(path: Path) -> dict:
    fitz = import_fitz()
    if fitz is None:
        return {"error": "missing_pymupdf"}

    doc = fitz.open(str(path))
    sample = min(len(doc), 10)
    total_chars = 0
    embedded_figures = 0
    vector_pages = 0
    caption_pages = 0
    caption_re = re.compile(r"^(exhibit|figure|圖表?|表)\s*\w", re.IGNORECASE)

    for i in range(sample):
        page = doc[i]
        text = page.get_text("text").strip()
        total_chars += len(text)

        for img_info in page.get_images(full=True):
            try:
                width, height = int(img_info[2]), int(img_info[3])
            except Exception:
                continue
            area = width * height
            aspect = max(width, height) / max(min(width, height), 1)
            if (
                width >= MIN_IMG_WIDTH
                and height >= MIN_IMG_HEIGHT
                and area >= MIN_IMG_AREA
                and aspect <= MAX_ASPECT_RATIO
            ):
                embedded_figures += 1

        try:
            if len(page.get_drawings()) >= VECTOR_DRAW_THRESHOLD:
                vector_pages += 1
        except Exception:
            pass

        if any(caption_re.match(line.strip()) for line in text.splitlines()):
            caption_pages += 1

    pages = len(doc)
    doc.close()
    avg_chars = total_chars / max(sample, 1)
    scanned = avg_chars < SCANNED_CHARS_PER_PAGE
    visual = scanned or embedded_figures > 0 or vector_pages > 0 or caption_pages > 0

    return {
        "pages": pages,
        "sample_pages": sample,
        "avg_chars_per_sample_page": round(avg_chars, 1),
        "scanned": scanned,
        "embedded_figures_sample": embedded_figures,
        "vector_pages_sample": vector_pages,
        "caption_pages_sample": caption_pages,
        "visual_needed": visual,
    }


def print_signals(signals: dict) -> None:
    print("[ROUTE] PDF signals:", flush=True)
    for key, value in signals.items():
        print(f"  - {key}: {value}", flush=True)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Auto-route PDF/EPUB/TXT/images to doc_to_md.py and/or vlm_prep.py."
    )
    parser.add_argument("input", help="PDF, EPUB, TXT, image file, or image folder")
    parser.add_argument("-o", "--output", default=None, help="Output directory")
    parser.add_argument(
        "--visual",
        choices=["auto", "force", "off"],
        default="auto",
        help="auto=detect VLM need; force=always run VLM where supported; off=text only",
    )
    parser.add_argument(
        "--vlm-mode",
        choices=["auto", "pages", "figures", "both"],
        default=None,
        help="Override VLM mode when VLM is used",
    )
    parser.add_argument("--dpi", type=int, default=150, help="VLM page render DPI")
    parser.add_argument(
        "--no-convert-chinese",
        action="store_true",
        help="Pass through to doc_to_md.py",
    )
    parser.add_argument(
        "--bundled-only",
        action="store_true",
        help="Ignore fixed Terminal installs and run bundled scripts with the current Python.",
    )
    args = parser.parse_args()

    input_path = Path(args.input).expanduser().resolve()
    if not input_path.exists():
        print(f"[ERROR] Input not found: {input_path}", file=sys.stderr)
        return 1

    out_dir = Path(args.output).expanduser().resolve() if args.output else (
        input_path if input_path.is_dir() else input_path.parent
    )
    out_dir.mkdir(parents=True, exist_ok=True)

    scripts = script_dir()
    doc_script = scripts / "doc_to_md.py"
    vlm_script = scripts / "vlm_prep.py"
    doc_base = [sys.executable, str(doc_script)] if args.bundled_only else installed_or_script(INSTALLED_DOC_TO_MD, doc_script)
    vlm_base = [sys.executable, str(vlm_script)] if args.bundled_only else installed_or_script(INSTALLED_VLM_TO_MD, vlm_script)

    ext = input_path.suffix.lower()
    is_image_input = input_path.is_dir() or ext in IMG_EXTS
    is_pdf = ext == ".pdf"
    is_text_doc = ext in {".epub", ".txt"}

    exit_codes: list[int] = []

    if is_image_input:
        if args.visual == "off":
            print("[ERROR] Image inputs require visual routing; remove --visual off.", file=sys.stderr)
            return 2
        if not vlm_base:
            print(f"[ERROR] Missing VLM converter. Checked {INSTALLED_VLM_TO_MD} and {vlm_script}", file=sys.stderr)
            return 1
        mode = args.vlm_mode or "auto"
        exit_codes.append(run(vlm_base + ["--mode", mode, "--dpi", str(args.dpi), str(input_path), "-o", str(out_dir)]))
        return max(exit_codes)

    if is_text_doc:
        if not doc_base:
            print(f"[ERROR] Missing text converter. Checked {INSTALLED_DOC_TO_MD} and {doc_script}", file=sys.stderr)
            return 1
        cmd = doc_base + ["--auto", str(input_path), "-o", str(out_dir)]
        if args.no_convert_chinese:
            cmd.insert(1, "--no-convert-chinese")
        exit_codes.append(run(cmd))
        return max(exit_codes)

    if not is_pdf:
        print(f"[ERROR] Unsupported input format: {ext or '(none)'}", file=sys.stderr)
        return 2

    signals = pdf_signals(input_path)
    if signals.get("error"):
        return 1
    print_signals(signals)

    scanned = bool(signals["scanned"])
    visual_needed = bool(signals["visual_needed"])
    if args.visual == "force":
        visual_needed = True
    elif args.visual == "off":
        visual_needed = False

    if scanned:
        print("[ROUTE] Scanned/image PDF detected: VLM pages pipeline only.", flush=True)
        if not vlm_base:
            print(f"[ERROR] Missing VLM converter. Checked {INSTALLED_VLM_TO_MD} and {vlm_script}", file=sys.stderr)
            return 1
        mode = args.vlm_mode or "pages"
        exit_codes.append(run(vlm_base + ["--mode", mode, "--dpi", str(args.dpi), str(input_path), "-o", str(out_dir)]))
        return max(exit_codes)

    if not doc_base:
        print(f"[ERROR] Missing text converter. Checked {INSTALLED_DOC_TO_MD} and {doc_script}", file=sys.stderr)
        return 1
    print("[ROUTE] Text PDF detected: running doc_to_md.py.", flush=True)
    doc_cmd = doc_base + ["--auto", str(input_path), "-o", str(out_dir)]
    if args.no_convert_chinese:
        doc_cmd.insert(1, "--no-convert-chinese")
    exit_codes.append(run(doc_cmd))

    if visual_needed:
        if not vlm_base:
            print(f"[ERROR] Missing VLM converter. Checked {INSTALLED_VLM_TO_MD} and {vlm_script}", file=sys.stderr)
            return 1
        mode = args.vlm_mode or "figures"
        print(f"[ROUTE] Visual/chart signals detected: running vlm_prep.py --mode {mode}.", flush=True)
        exit_codes.append(run(vlm_base + ["--mode", mode, "--dpi", str(args.dpi), str(input_path), "-o", str(out_dir)]))
    else:
        print("[ROUTE] No visual/chart signals detected: VLM skipped.", flush=True)

    return max(exit_codes) if exit_codes else 0


if __name__ == "__main__":
    raise SystemExit(main())
CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_DOC_MD_ROUTER_PY

# doc-to-md/scripts/doc_to_md.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_to_md.py")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_to_md.py" <<'CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_DOC_TO_MD_PY'
#!/usr/bin/env python3
"""
doc_to_md.py — Student-friendly document to Markdown converter
Supports: PDF, EPUB, TXT
Output: Clean Markdown with YAML frontmatter + section anchors for AI 助手to annotate
"""

import sys
import os
import re
import argparse
import datetime
from pathlib import Path
from collections import Counter

# ── Dependency checks ──────────────────────────────────────────────────────────

def check_deps():
    missing = []
    for pkg, import_name in [
        ("PyMuPDF", "fitz"),
        ("ebooklib", "ebooklib"),
        ("beautifulsoup4", "bs4"),
        ("chardet", "chardet"),
        ("opencc-python-reimplemented", "opencc"),
    ]:
        try:
            __import__(import_name)
        except ImportError:
            missing.append(pkg)
    if missing:
        print(f"[ERROR] Missing packages: {', '.join(missing)}")
        print("Install with:")
        print(f"  pip install {' '.join(missing)} --break-system-packages")
        sys.exit(1)

check_deps()

import chardet
import fitz  # PyMuPDF
import ebooklib
from ebooklib import epub
from bs4 import BeautifulSoup

try:
    import opencc
    OPENCC_AVAILABLE = True
except ImportError:
    OPENCC_AVAILABLE = False

# ── Section detection patterns ─────────────────────────────────────────────────

BOOK_SECTION_PATTERNS = [
    # Chinese book chapters (both Traditional 節 and Simplified 节 forms)
    (r'^第\s*([零一二三四五六七八九十百千\d]+)\s*章\s*(.{0,60})', 'chapter'),
    (r'^第\s*([零一二三四五六七八九十百千\d]+)\s*部\s*(.{0,60})', 'part'),
    (r'^第\s*([零一二三四五六七八九十百千\d]+)\s*[節节]\s*(.{0,60})', 'section'),
    # English book chapters
    (r'^Chapter\s+(\d+|[IVXLCDM]+)[:\.\s]\s*(.{0,60})', 'chapter'),
    (r'^Part\s+(\d+|[IVXLCDM]+)[:\.\s]\s*(.{0,60})', 'part'),
    (r'^Section\s+(\d+\.?\d*)[:\.\s]\s*(.{0,60})', 'section'),
    # Numbered headings like "1. Introduction" or "1.1 Overview"
    (r'^(\d+)\.\s+([A-Z\u4e00-\u9fff].{0,60})', 'numbered'),
]

TRANSCRIPT_SECTION_PATTERNS = [
    # Chinese lecture/course (both Traditional 講/課 and Simplified 讲/课 forms)
    (r'^第\s*([零一二三四五六七八九十百千\d]+)\s*[講讲]\s*(.{0,60})', 'lecture'),
    (r'^第\s*([零一二三四五六七八九十百千\d]+)\s*[課课]\s*(.{0,60})', 'lesson'),
    (r'^第\s*([零一二三四五六七八九十百千\d]+)\s*單元\s*(.{0,60})', 'unit'),
    (r'^第\s*([零一二三四五六七八九十百千\d]+)\s*单元\s*(.{0,60})', 'unit'),
    # English lecture
    (r'^Lecture\s+(\d+)[:\.\s]\s*(.{0,60})', 'lecture'),
    (r'^Lesson\s+(\d+)[:\.\s]\s*(.{0,60})', 'lesson'),
    (r'^Module\s+(\d+)[:\.\s]\s*(.{0,60})', 'module'),
    # Timestamps (transcript style)
    (r'^(\d{1,2}:\d{2}(?::\d{2})?)\s+(.{0,80})', 'timestamp'),
]

ALL_SECTION_PATTERNS = BOOK_SECTION_PATTERNS + TRANSCRIPT_SECTION_PATTERNS

# ── Chinese number conversion ──────────────────────────────────────────────────

ZH_DIGITS = {'零':0,'一':1,'二':2,'三':3,'四':4,'五':5,'六':6,'七':7,'八':8,'九':9,'十':10,'百':100,'千':1000}

def zh_num_to_int(s):
    """Convert Chinese number string to integer (best-effort)."""
    if s.isdigit():
        return int(s)
    result, current = 0, 0
    for ch in s:
        if ch in ZH_DIGITS:
            val = ZH_DIGITS[ch]
            if val >= 10:
                if current == 0:
                    current = 1
                result += current * val
                current = 0
            else:
                current = val
    return result + current

# ── OpenCC conversion ──────────────────────────────────────────────────────────

_converter = None

def get_converter():
    global _converter
    if _converter is None and OPENCC_AVAILABLE:
        try:
            _converter = opencc.OpenCC('s2twp')
        except Exception:
            _converter = None
    return _converter

def convert_to_tw(text: str) -> str:
    conv = get_converter()
    if conv is None:
        return text
    try:
        return conv.convert(text)
    except Exception:
        return text

# ── Text cleaning utilities ────────────────────────────────────────────────────

def detect_encoding(raw: bytes) -> str:
    result = chardet.detect(raw)
    enc = result.get('encoding') or 'utf-8'
    # Normalize common aliases
    enc = enc.lower().replace('-', '').replace('_', '')
    mapping = {'big5hkscs': 'big5', 'gb2312': 'gb18030', 'gbk': 'gb18030', 'gb18030': 'gb18030'}
    return mapping.get(enc, enc)

def clean_text_block(text: str) -> str:
    """Remove common PDF artifacts and normalize whitespace."""
    lines = text.splitlines()
    cleaned = []
    for line in lines:
        # Strip leading/trailing whitespace
        line = line.strip()
        # Skip very short lines that are likely page numbers or artifacts
        if re.match(r'^\d+$', line) and len(line) <= 4:
            continue
        # Skip lines that are only punctuation/symbols (common PDF artifacts)
        if line and all(c in '─━—–-=~·•◆▪□■○●※★☆†‡§¶' for c in line):
            continue
        cleaned.append(line)
    return '\n'.join(cleaned)

def merge_broken_paragraphs(text: str) -> str:
    """
    Merge lines that were broken mid-sentence (soft line breaks in PDFs).
    Heuristic: if a line does NOT end with sentence-ending punctuation
    and the next line does NOT start with a capital letter or Chinese char at start of sentence,
    merge them.
    """
    lines = text.splitlines()
    result = []
    i = 0
    while i < len(lines):
        line = lines[i]
        # Check if this line should be merged with next
        while (i + 1 < len(lines)
               and line
               and lines[i + 1]
               and not re.search(r'[。！？!?\.…]\s*$', line)
               and not re.match(r'^[A-Z\u4e00-\u9fff#\-\*]', lines[i + 1])
               and not re.match(r'^\s*$', lines[i + 1])
               and len(line) > 40):  # Only merge reasonably long lines
            i += 1
            line = line.rstrip() + ' ' + lines[i].lstrip()
        result.append(line)
        i += 1
    return '\n'.join(result)

def strip_repeated_headers_footers(pages_text: list[str]) -> list[str]:
    """
    Detect lines appearing on >50% of pages and remove them
    (these are likely headers/footers).
    """
    if len(pages_text) < 4:
        return pages_text

    # Count line frequency across pages
    all_lines = []
    for page in pages_text:
        # Only check first 3 and last 3 lines of each page
        lines = [l.strip() for l in page.splitlines() if l.strip()]
        all_lines.extend(lines[:3] + lines[-3:])

    line_counts = Counter(all_lines)
    threshold = max(3, len(pages_text) * 0.5)
    repeated = {line for line, count in line_counts.items() if count >= threshold and len(line) > 3}

    if not repeated:
        return pages_text

    cleaned = []
    for page in pages_text:
        lines = page.splitlines()
        filtered = [l for l in lines if l.strip() not in repeated]
        cleaned.append('\n'.join(filtered))
    return cleaned

# ── PDF extraction ─────────────────────────────────────────────────────────────

def extract_pdf(path: str) -> tuple[dict, list[str]]:
    """Returns (metadata, pages_text_list)."""
    doc = fitz.open(path)
    meta = doc.metadata or {}

    # Check for image-only PDF
    total_chars = sum(len(page.get_text()) for page in doc)
    avg_chars = total_chars / max(len(doc), 1)
    if avg_chars < 80:
        print(f"[WARN] Low text density ({avg_chars:.0f} chars/page avg). This may be a scanned PDF.")
        print("[WARN] OCR not included — consider using Adobe Acrobat, tesseract, or MinerU first.")

    pages = []
    for page in doc:
        text = page.get_text("text")
        pages.append(text)

    doc.close()
    return meta, pages

def pdf_meta_to_dict(raw_meta: dict, path: str) -> dict:
    title = raw_meta.get('title') or Path(path).stem
    author = raw_meta.get('author') or 'Unknown'
    total_pages = raw_meta.get('page_count') or 0
    return {
        'title': title.strip(),
        'author': author.strip(),
        'source': Path(path).name,
        'pages': total_pages,
        'format': 'PDF',
    }

# ── EPUB extraction ────────────────────────────────────────────────────────────

def extract_epub(path: str) -> tuple[dict, list[str]]:
    """Returns (metadata, chapters_text_list)."""
    book = epub.read_epub(path)

    meta = {}
    for key in ['title', 'creator', 'language', 'identifier']:
        items = book.get_metadata('DC', key)
        if items:
            meta[key] = items[0][0] if isinstance(items[0], tuple) else str(items[0])

    chapters = []
    for item in book.get_items_of_type(ebooklib.ITEM_DOCUMENT):
        try:
            content = item.get_content()
            soup = BeautifulSoup(content, 'lxml')
            # Remove script, style, nav
            for tag in soup(['script', 'style', 'nav', 'head']):
                tag.decompose()
            text = soup.get_text(separator='\n')
            text = re.sub(r'\n{3,}', '\n\n', text)
            if text.strip():
                chapters.append(text.strip())
        except Exception:
            continue

    return meta, chapters

def epub_meta_to_dict(raw_meta: dict, path: str) -> dict:
    return {
        'title': (raw_meta.get('title') or Path(path).stem).strip(),
        'author': (raw_meta.get('creator') or 'Unknown').strip(),
        'source': Path(path).name,
        'pages': len([]),  # Will be updated later
        'format': 'EPUB',
    }

# ── TXT extraction ─────────────────────────────────────────────────────────────

def extract_txt(path: str) -> tuple[dict, list[str]]:
    """Returns (metadata, [full_text])."""
    raw = Path(path).read_bytes()
    enc = detect_encoding(raw)
    try:
        text = raw.decode(enc, errors='replace')
    except (LookupError, UnicodeDecodeError):
        text = raw.decode('utf-8', errors='replace')

    meta = {'title': Path(path).stem, 'author': 'Unknown', 'format': 'TXT'}
    return meta, [text]

def txt_meta_to_dict(raw_meta: dict, path: str) -> dict:
    return {
        'title': raw_meta.get('title', Path(path).stem).strip(),
        'author': raw_meta.get('author', 'Unknown').strip(),
        'source': Path(path).name,
        'pages': 0,
        'format': 'TXT',
    }

# ── Section detection ──────────────────────────────────────────────────────────

def detect_sections(text: str) -> list[dict]:
    """
    Detect section boundaries. Returns list of:
    {'index': int, 'level': 'chapter'|'part'|..., 'num': str, 'title': str, 'line': str}
    """
    sections = []
    lines = text.splitlines()

    for i, line in enumerate(lines):
        stripped = line.strip()
        if not stripped or len(stripped) < 2:
            continue
        for pattern, level in ALL_SECTION_PATTERNS:
            m = re.match(pattern, stripped, re.IGNORECASE)
            if m:
                num_raw = m.group(1)
                title_raw = m.group(2).strip() if len(m.groups()) >= 2 else ''
                # Clean title (remove trailing punctuation)
                title_raw = re.sub(r'[：:。\s]+$', '', title_raw)
                sections.append({
                    'line_index': i,
                    'level': level,
                    'num': num_raw,
                    'title': title_raw,
                    'original_line': stripped,
                })
                break  # Only match first pattern per line

    return sections

def assign_anchors(sections: list[dict]) -> list[dict]:
    """Assign Obsidian-compatible anchor IDs to each section."""
    chapter_count = 0
    for sec in sections:
        level = sec['level']
        if level in ('chapter', 'lecture', 'lesson', 'unit', 'module', 'numbered'):
            chapter_count += 1
            sec['anchor'] = f"ch-{chapter_count:02d}"
        elif level == 'part':
            sec['anchor'] = f"part-{sec['num']}"
        elif level == 'timestamp':
            sec['anchor'] = f"ts-{sec['num'].replace(':', '-')}"
        else:
            sec['anchor'] = f"sec-{sec['num']}"
    return sections

# ── Markdown assembly ──────────────────────────────────────────────────────────

def make_yaml_frontmatter(meta: dict) -> str:
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
    lines = [
        '---',
        f"title: \"{meta.get('title', 'Unknown').replace(chr(34), chr(39))}\"",
        f"author: \"{meta.get('author', 'Unknown').replace(chr(34), chr(39))}\"",
        f"source: \"{meta.get('source', '')}\"",
        f"format: {meta.get('format', 'Unknown')}",
        f"pages: {meta.get('pages', 0)}",
        f"converted_at: \"{now}\"",
        '---',
    ]
    return '\n'.join(lines)

def make_section_heading(sec: dict) -> str:
    """Generate heading with anchor for a detected section."""
    level = sec['level']
    num = sec['num']
    title = sec['title']
    anchor = sec.get('anchor', '')

    if level in ('chapter',):
        prefix = f"第{num}章"
        if title:
            heading = f"## {prefix} {title}"
        else:
            heading = f"## {prefix}"
    elif level == 'part':
        prefix = f"第{num}部"
        heading = f"# {prefix} {title}" if title else f"# {prefix}"
    elif level in ('lecture',):
        prefix = f"第{num}講"
        heading = f"## {prefix} {title}" if title else f"## {prefix}"
    elif level in ('lesson',):
        prefix = f"第{num}課"
        heading = f"## {prefix} {title}" if title else f"## {prefix}"
    elif level == 'unit':
        prefix = f"第{num}單元"
        heading = f"## {prefix} {title}" if title else f"## {prefix}"
    elif level == 'timestamp':
        heading = f"### {num} {title}" if title else f"### {num}"
    elif level == 'numbered':
        heading = f"## {num}. {title}"
    else:
        # Fallback: use original line as heading
        heading = f"## {sec['original_line']}"

    if anchor:
        heading += f" ^{anchor}"
    return heading

def section_placeholder(anchor: str) -> str:
    """Generate the placeholder callout block AI 助手will fill in."""
    return (
        f"> [!note] 章節摘要\n"
        f"> **摘要**：（AI 助手將在此填入本節摘要）\n"
        f"> **關鍵字**：（AI 助手將在此填入關鍵字）"
    )

def build_markdown(meta: dict, full_text: str, sections: list[dict], convert_chinese: bool) -> str:
    """Assemble the final Markdown document."""
    if convert_chinese and OPENCC_AVAILABLE:
        full_text = convert_to_tw(full_text)
        for sec in sections:
            sec['title'] = convert_to_tw(sec['title'])

    frontmatter = make_yaml_frontmatter(meta)
    lines = full_text.splitlines()

    # Build a map: line_index → section
    sec_map = {sec['line_index']: sec for sec in sections}

    output_parts = [frontmatter, '']

    # If no sections detected, add a single placeholder
    if not sections:
        # Add a generic document intro callout
        output_parts.append(f"# {meta.get('title', 'Document')}")
        output_parts.append('')
        output_parts.append(section_placeholder('doc-main'))
        output_parts.append('')
        output_parts.append(full_text)
        return '\n'.join(output_parts)

    # Add document title
    output_parts.append(f"# {meta.get('title', 'Document')}")
    output_parts.append('')

    current_section_lines = []
    current_anchor = None
    in_section = False

    for i, line in enumerate(lines):
        if i in sec_map:
            # Flush previous section content
            if in_section and current_section_lines:
                content = '\n'.join(current_section_lines).strip()
                if content:
                    output_parts.append(content)
                output_parts.append('')

            # Emit new section heading
            sec = sec_map[i]
            output_parts.append(make_section_heading(sec))
            output_parts.append('')
            output_parts.append(section_placeholder(sec.get('anchor', '')))
            output_parts.append('')

            current_section_lines = []
            current_anchor = sec.get('anchor')
            in_section = True
        else:
            if in_section:
                current_section_lines.append(line)
            else:
                # Pre-section content (intro, preface, etc.)
                output_parts.append(line)

    # Flush last section
    if in_section and current_section_lines:
        content = '\n'.join(current_section_lines).strip()
        if content:
            output_parts.append(content)

    return '\n'.join(output_parts)

# ── Main pipeline ──────────────────────────────────────────────────────────────

def process_file(input_path: str, output_dir: str, convert_chinese: bool) -> str:
    """Full pipeline. Returns path to output Markdown file."""
    path = Path(input_path)
    ext = path.suffix.lower()

    print(f"[INFO] Processing: {path.name} ({ext.upper()[1:]})")

    # 1. Extract text and metadata
    if ext == '.pdf':
        raw_meta, pages = extract_pdf(input_path)
        meta = pdf_meta_to_dict(raw_meta, input_path)
        meta['pages'] = len(pages)
        pages = strip_repeated_headers_footers(pages)
        full_text = '\n'.join(pages)
    elif ext == '.epub':
        raw_meta, chapters = extract_epub(input_path)
        meta = epub_meta_to_dict(raw_meta, input_path)
        meta['pages'] = len(chapters)
        full_text = '\n\n'.join(chapters)
    elif ext == '.txt':
        raw_meta, parts = extract_txt(input_path)
        meta = txt_meta_to_dict(raw_meta, input_path)
        full_text = parts[0]
    else:
        print(f"[ERROR] Unsupported format: {ext}")
        sys.exit(1)

    print(f"[INFO] Extracted ~{len(full_text):,} characters")

    # 2. Clean text
    full_text = clean_text_block(full_text)
    full_text = merge_broken_paragraphs(full_text)

    # 3. Detect sections
    sections = detect_sections(full_text)
    sections = assign_anchors(sections)
    print(f"[INFO] Detected {len(sections)} sections")

    # 4. Build Markdown
    md_content = build_markdown(meta, full_text, sections, convert_chinese)

    # 5. Determine output filename (also apply opencc to title/author)
    raw_title = meta.get('title', path.stem)
    raw_author = meta.get('author', 'Unknown')
    if convert_chinese and OPENCC_AVAILABLE:
        raw_title = convert_to_tw(raw_title)
        raw_author = convert_to_tw(raw_author)
        # Also fix YAML frontmatter inside md_content
        md_content = md_content.replace(
            f'title: "{meta.get("title", "")}"',
            f'title: "{raw_title}"', 1)
        md_content = md_content.replace(
            f'author: "{meta.get("author", "")}"',
            f'author: "{raw_author}"', 1)
        # Fix H1 line
        md_content = md_content.replace(
            f'# {meta.get("title", "")}',
            f'# {raw_title}', 1)
    title = re.sub(r'[^\w\s\u4e00-\u9fff-]', '', raw_title)
    title = re.sub(r'\s+', '_', title.strip())[:50]
    author = re.sub(r'[^\w\s\u4e00-\u9fff-]', '', raw_author)
    author = re.sub(r'\s+', '_', author.strip())[:20]

    if author and author != 'Unknown':
        out_name = f"{author}_{title}_知識庫.md"
    else:
        out_name = f"{title}_知識庫.md"

    out_path = Path(output_dir) / out_name
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(md_content, encoding='utf-8')

    print(f"[INFO] Output: {out_path}")
    print(f"[INFO] Size: {out_path.stat().st_size:,} bytes")
    print(f"[INFO] Sections with placeholders: {len(sections)}")

    return str(out_path)

# ── CLI ────────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description='Convert PDF/EPUB/TXT to clean Markdown with section anchors',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python3 doc_to_md.py book.pdf
  python3 doc_to_md.py --auto lecture.txt -o ~/Documents/output/
  python3 doc_to_md.py --no-convert-chinese ebook.epub -o ./output/
        """
    )
    parser.add_argument('input', help='Input file (PDF, EPUB, or TXT)')
    parser.add_argument('--auto', action='store_true',
                        help='Auto-detect format (default behavior, kept for compatibility)')
    parser.add_argument('--no-convert-chinese', action='store_true',
                        help='Skip Simplified → Traditional Chinese conversion')
    parser.add_argument('-o', '--output-dir', default=None,
                        help='Output directory (default: same directory as input file)')

    args = parser.parse_args()

    # Resolve paths
    input_path = os.path.expanduser(args.input)
    if not os.path.isfile(input_path):
        print(f"[ERROR] File not found: {input_path}")
        sys.exit(1)

    if args.output_dir:
        output_dir = os.path.expanduser(args.output_dir)
    else:
        output_dir = str(Path(input_path).parent)

    convert_chinese = not args.no_convert_chinese
    if convert_chinese and not OPENCC_AVAILABLE:
        print("[WARN] opencc not available, skipping Chinese conversion")
        convert_chinese = False

    # Run pipeline
    out_path = process_file(input_path, output_dir, convert_chinese)
    print(f"\n[DONE] Markdown saved to:\n  {out_path}")
    print("\nNext step: Ask AI 助手to read this file and fill in the 章節摘要 callouts.")

if __name__ == '__main__':
    main()
CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_DOC_TO_MD_PY

# doc-to-md/scripts/vlm_prep.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/scripts/vlm_prep.py")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/scripts/vlm_prep.py" <<'CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_VLM_PREP_PY'
#!/usr/bin/env python3
"""
vlm_prep.py  v1.0.3
─────────────────────────────────────────────────────────────────────────────
VLM-to-MD｜Phase 1：本地視覺前處理（免費、離線、0 token）

這支腳本「不做 AI 判讀」。它只負責一件事：
把任何視覺輸入（掃描 PDF / 圖表 PDF / 一疊圖片 / 單張截圖）
變成「AI 助手看得懂的圖檔」＋「一份留好空格的 Markdown 骨架」。

真正的「看圖說話」交給 Codex App 內建視覺能力（Phase 2），不需要 API key。

設計沿襲使用者 v7.0 RAG 流程的兩個核心：
  1. 智能圖片篩選（MIN 250x200px, 80K area, aspect<8）— 濾掉 logo / 裝飾條
  2. blockquote 圖表描述格式（類型 + 2-3 句內容）

v1.0.1 變更（重要）：
  修正「向量圖表被漏掉」的破口。get_images() 只抓得到「嵌入的點陣圖」，
  但麥肯錫／顧問報告的 Exhibit 多是「用向量畫出來」的圖表，會被靜默漏掉。
  新增 extract_vector_chart_pages()：用 get_drawings() 的向量物件數偵測「圖表頁」，
  整頁渲染補回。figures / auto(文字型) 模式預設啟用；--no-vector-pages 可關閉。

v1.0.2 變更（重要）：
  修正「圖變黑底」的破口。透明 PNG 被 PDF flatten 成黑底，舊的 extract_image() 照單全收。
  extract_figures() 預設改用 page.get_image_rects(xref)+get_pixmap(clip=rect) 白底渲染
  （模擬 PDF viewer，黑底/alpha 問題消失，解析度可調）；需原始 bitmap 用 --raw-figures。

與 doc-to-md 的分工：
  • doc-to-md  → 文字型 PDF/EPUB/TXT 的「文字」
  • vlm-to-md  → 掃描 PDF / 圖片 / 圖表 的「視覺」
  兩者合起來＝完整的 RAG 知識庫進料管線。
─────────────────────────────────────────────────────────────────────────────
"""

import argparse
import datetime
import json
import os
import re
import sys

# === Windows 中文輸出修正（v: cp1252 fix）===
# Windows 預設 stdout 編碼為 cp1252，輸出中文（argparse --help / log 進度）會 UnicodeEncodeError。
# 強制 stdout/stderr 改 UTF-8（被導向 >/dev/null 或檔案時尤其重要）。
for _stream in (sys.stdout, sys.stderr):
    try:
        _stream.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

# ── PyMuPDF（PDF 渲染與圖片提取）──────────────────────────────────────────────
try:
    import fitz  # PyMuPDF
    HAS_FITZ = True
except ImportError:
    try:
        import pymupdf as fitz
        HAS_FITZ = True
    except ImportError:
        HAS_FITZ = False

# ── Pillow（讀取獨立圖片尺寸，選用）────────────────────────────────────────────
try:
    from PIL import Image
    HAS_PIL = True
except ImportError:
    HAS_PIL = False


# ════════════════════════════════════════════════════════════════════════════
#  常數（沿襲 v7.0 圖片篩選門檻）
# ════════════════════════════════════════════════════════════════════════════
MIN_IMG_WIDTH = 250
MIN_IMG_HEIGHT = 200
MIN_IMG_AREA = 80000
MAX_ASPECT_RATIO = 8          # 過濾極端長寬比（橫幅 / 分隔線 / logo）

PAGE_RENDER_DPI = 150         # 整頁渲染解析度（掃描頁 / 投影片 / 資訊圖）
SCANNED_CHARS_PER_PAGE = 60   # 平均每頁可抽取文字 < 此值 → 判定為掃描/圖像 PDF
VECTOR_DRAW_THRESHOLD = 25    # v1.2.0：40→25，補回較簡單的向量圖表（實測麥肯錫漏抽 6 張靠 25 補回）

IMG_EXTS = {".png", ".jpg", ".jpeg", ".webp", ".bmp", ".tif", ".tiff", ".gif"}


# ════════════════════════════════════════════════════════════════════════════
#  小工具
# ════════════════════════════════════════════════════════════════════════════
def safe_stem(path: str) -> str:
    """檔名 → 檔案系統安全字串（給 assets 子資料夾用）"""
    stem = os.path.splitext(os.path.basename(path))[0]
    stem = re.sub(r"[^\w一-鿿\-]+", "_", stem).strip("_")
    return stem or "vlm"


def log(msg: str):
    print(msg, flush=True)


# ════════════════════════════════════════════════════════════════════════════
#  PDF：判斷掃描 vs 文字
# ════════════════════════════════════════════════════════════════════════════
def is_scanned_pdf(doc) -> tuple:
    """回傳 (是否掃描, 平均每頁字數)。
    掃描/圖像 PDF 抽不出文字 → 走整頁渲染；文字 PDF → 只抽圖表。"""
    total_chars = 0
    sample = min(len(doc), 10)
    for i in range(sample):
        total_chars += len(doc[i].get_text("text").strip())
    avg = total_chars / max(sample, 1)
    return avg < SCANNED_CHARS_PER_PAGE, avg


# ════════════════════════════════════════════════════════════════════════════
#  PDF：整頁渲染成 PNG（掃描頁 / 投影片 / 資訊圖）
# ════════════════════════════════════════════════════════════════════════════
def render_pages(doc, stem: str, assets_dir: str, dpi: int) -> list:
    out_dir = os.path.join(assets_dir, stem)
    os.makedirs(out_dir, exist_ok=True)
    items = []
    zoom = dpi / 72.0
    matrix = fitz.Matrix(zoom, zoom)
    for i in range(len(doc)):
        pix = doc[i].get_pixmap(matrix=matrix)
        fn = f"page_{i + 1:03d}.png"
        fp = os.path.join(out_dir, fn)
        pix.save(fp)
        items.append({
            "kind": "page",
            "page": i + 1,
            "filename": fn,
            "img_path": fp,
            "rel_path": f"assets/{stem}/{fn}",
            "size": f"{pix.width}x{pix.height}",
        })
        log(f"   🖼️  渲染第 {i + 1}/{len(doc)} 頁 → {fn}")
    return items


# ════════════════════════════════════════════════════════════════════════════
#  PDF：智能提取嵌入圖表（沿襲 v7.0 extract_figures）
# ════════════════════════════════════════════════════════════════════════════
def extract_figures(doc, stem: str, assets_dir: str,
                    raw: bool = False, render_scale: float = 2.0) -> list:
    """抽嵌入圖表。
    預設（raw=False，v1.0.2 新做法）：用 page.get_image_rects(xref) 找到圖在頁面上的位置，
      再 page.get_pixmap(clip=rect) **渲染該區域**——頁面白底會一起合成，修正
      「透明 PNG 被 PDF flatten 成黑底（alpha 損壞）」的問題，呈現與 Preview/Adobe Reader 一致；
      解析度可由 render_scale 調（如 2x）。
    raw=True（舊做法）：直接取原始內嵌 bitmap（可能黑底），用於需要原始圖檔時。
    篩選一律用內嵌圖的原始尺寸（濾掉 logo / 裝飾條）。"""
    out_dir = os.path.join(assets_dir, stem)
    os.makedirs(out_dir, exist_ok=True)
    figures = []
    count = 0
    for page_num in range(len(doc)):
        page = doc[page_num]
        for img_info in page.get_images(full=True):
            xref = img_info[0]
            try:
                # 用內嵌圖原始尺寸做篩選（get_images full=True：index 2,3 = width,height）
                w0, h0 = int(img_info[2]), int(img_info[3])
                if w0 < MIN_IMG_WIDTH or h0 < MIN_IMG_HEIGHT or w0 * h0 < MIN_IMG_AREA:
                    continue
                if max(w0, h0) / max(min(w0, h0), 1) > MAX_ASPECT_RATIO:
                    continue
                count += 1
                fn = f"fig_{count:02d}_p{page_num + 1}.png"
                fp = os.path.join(out_dir, fn)

                rects = [] if raw else page.get_image_rects(xref)
                if rects:
                    # 白底渲染：模擬 PDF viewer，透明/alpha 損壞的黑底問題消失
                    pix = page.get_pixmap(matrix=fitz.Matrix(render_scale, render_scale),
                                          clip=rects[0])
                    note = "，白底渲染"
                else:
                    # raw 或找不到圖在頁面的位置 → 退回直接取內嵌 bitmap
                    pix = fitz.Pixmap(doc, xref)
                    if pix.colorspace and pix.colorspace.n > 3:   # CMYK → RGB
                        pix = fitz.Pixmap(fitz.csRGB, pix)
                    note = ""
                pix.save(fp)
                size = f"{pix.width}x{pix.height}"
                figures.append({
                    "kind": "figure",
                    "page": page_num + 1,
                    "filename": fn,
                    "img_path": fp,
                    "rel_path": f"assets/{stem}/{fn}",
                    "size": size,
                })
                log(f"   📊 提取圖表 {fn}（{size}{note}）")
            except Exception:
                pass
    if not figures:
        try:
            os.rmdir(out_dir)
        except OSError:
            pass
    return figures


# ════════════════════════════════════════════════════════════════════════════
#  PDF：偵測「向量圖表頁」並整頁渲染（v1.0.1 新增）
#  ── get_images() 只抓得到「嵌入的點陣圖」；像麥肯錫 Exhibit 這種「用向量畫出來」
#     的圖表（線、面積、長條…）會被漏掉。這裡用 get_drawings() 的向量物件數偵測
#     「圖表頁」，把整頁渲染補回，讓真正的數據圖表不會在 figures 模式下消失。
# ════════════════════════════════════════════════════════════════════════════
def extract_vector_chart_pages(doc, stem: str, assets_dir: str, dpi: int,
                               threshold: int, skip_pages: set) -> list:
    out_dir = os.path.join(assets_dir, stem)
    os.makedirs(out_dir, exist_ok=True)
    items = []
    zoom = dpi / 72.0
    matrix = fitz.Matrix(zoom, zoom)
    for i in range(len(doc)):
        if i in skip_pages:               # 已被 extract_figures 以點陣圖抓走的頁，不重複
            continue
        try:
            n_draw = len(doc[i].get_drawings())
        except Exception:
            n_draw = 0
        if n_draw < threshold:            # 向量物件太少 → 多半是純文字頁，跳過
            continue
        try:
            pix = doc[i].get_pixmap(matrix=matrix)
        except Exception:
            continue
        fn = f"chart_p{i + 1:03d}.png"
        fp = os.path.join(out_dir, fn)
        pix.save(fp)
        items.append({
            "kind": "chart_page",
            "page": i + 1,
            "filename": fn,
            "img_path": fp,
            "rel_path": f"assets/{stem}/{fn}",
            "size": f"{pix.width}x{pix.height}",
            "drawings": n_draw,
        })
        log(f"   📈 偵測到向量圖表頁 第 {i + 1} 頁（向量物件 {n_draw}）→ {fn}")
    return items


# ════════════════════════════════════════════════════════════════════════════
#  v1.2.0：caption 驅動補抓 — 確保每個「Exhibit／Figure／圖表」標題頁都有圖
#  （向量物件數低於門檻、但內文有 Exhibit 標題的頁，也整頁渲染，避免「有描述沒圖」）
# ════════════════════════════════════════════════════════════════════════════
_EXHIBIT_HEAD = re.compile(r"^(exhibit|figure|圖表?|表)\s*\w", re.IGNORECASE)


def exhibit_caption_pages(doc) -> set:
    """回傳『文字含 Exhibit/Figure/圖表 標題行』的頁索引（0-based）。"""
    pages = set()
    for i in range(len(doc)):
        try:
            for line in doc[i].get_text("text").splitlines():
                if _EXHIBIT_HEAD.match(line.strip()):
                    pages.add(i)
                    break
        except Exception:
            pass
    return pages


def render_caption_pages(doc, stem: str, assets_dir: str, dpi: int,
                         pages: set, skip_pages: set) -> list:
    """把『有 Exhibit 標題但尚未被抽到圖』的頁整頁渲染補回。"""
    out_dir = os.path.join(assets_dir, stem)
    os.makedirs(out_dir, exist_ok=True)
    items = []
    zoom = dpi / 72.0
    matrix = fitz.Matrix(zoom, zoom)
    for i in sorted(pages):
        if i in skip_pages:
            continue
        try:
            pix = doc[i].get_pixmap(matrix=matrix)
        except Exception:
            continue
        fn = f"chart_p{i + 1:03d}.png"
        fp = os.path.join(out_dir, fn)
        pix.save(fp)
        items.append({
            "kind": "chart_page",
            "page": i + 1,
            "filename": fn,
            "img_path": fp,
            "rel_path": f"assets/{stem}/{fn}",
            "size": f"{pix.width}x{pix.height}",
            "via": "caption",
        })
        log(f"   📑 caption 補抓 Exhibit 頁 第 {i + 1} 頁 → {fn}")
    return items


# ════════════════════════════════════════════════════════════════════════════
#  圖片資料夾 / 單張圖片
# ════════════════════════════════════════════════════════════════════════════
def collect_images(input_path: str, stem: str, assets_dir: str) -> list:
    """把一張圖或一個資料夾的圖整理進 assets，回傳清單。"""
    import shutil
    out_dir = os.path.join(assets_dir, stem)
    os.makedirs(out_dir, exist_ok=True)

    srcs = []
    if os.path.isdir(input_path):
        for name in sorted(os.listdir(input_path)):
            if os.path.splitext(name)[1].lower() in IMG_EXTS:
                srcs.append(os.path.join(input_path, name))
    else:
        srcs = [input_path]

    items = []
    for idx, src in enumerate(srcs, 1):
        ext = os.path.splitext(src)[1].lower()
        fn = f"img_{idx:03d}{ext}"
        fp = os.path.join(out_dir, fn)
        shutil.copy2(src, fp)
        size = "?"
        if HAS_PIL:
            try:
                with Image.open(fp) as im:
                    size = f"{im.width}x{im.height}"
            except Exception:
                pass
        items.append({
            "kind": "image",
            "page": idx,
            "filename": fn,
            "img_path": fp,
            "rel_path": f"assets/{stem}/{fn}",
            "size": size,
            "orig_name": os.path.basename(src),
        })
        log(f"   🖼️  收錄圖片 {os.path.basename(src)} → {fn}")
    return items


# ════════════════════════════════════════════════════════════════════════════
#  產出 Markdown 骨架（留好 placeholder，給 AI 助手視覺填寫）
# ════════════════════════════════════════════════════════════════════════════
PLACEHOLDER = (
    "> **🖼 圖像解讀**　｜　檢視狀態：⬜ 未檢視（實際開圖看過後改成 ✅ 已檢視）\n"
    "> - **類型**：（表格／圖表／流程圖／框架圖／截圖／照片／文字頁）\n"
    "> - **內容**：（2-3 句：顯示什麼、關鍵數據、主要結論。數字一律從圖上讀，勿憑印象）\n"
    "> - **原文出處（逐字）**：（把圖上印的標題與 Source／來源 行逐字抄下；看不清寫「圖中未能辨識」，**禁止杜撰來源或數據**）\n"
    "> - **可檢索關鍵字**：（4-8 個詞，逗號分隔）"
)


def build_scaffold(title: str, source: str, kind_label: str,
                   items: list, scanned: bool) -> str:
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    yaml = (
        "---\n"
        f'title: "{title}"\n'
        f'source: "{source}"\n'
        "type: VLM-pending\n"
        f"items: {len(items)}\n"
        f"mode: {kind_label}\n"
        f'generated_at: "{now}"\n'
        "language: zh-TW\n"
        "---\n\n"
    )

    head = f"# {title}｜視覺知識庫\n\n"
    head += (
        "> **ℹ️ 這份檔案還沒完成——它在等 AI 助手的眼睛**\n"
        "> 以下每張圖下方都有「圖像解讀」空格。請在 Codex App 讓 AI 助手用內建視覺能力\n"
        "> **逐張開圖**填寫（📊 數據圖表務必細看、抄出處；🖼 裝飾照可簡述）。完全免費、不需 API key。\n\n"
    )
    if scanned:
        head += (
            "> **⚠️ 偵測到掃描／圖像型 PDF**\n"
            "> 這份 PDF 抽不出文字（內容是圖片）。每一頁都已渲染成圖檔，\n"
            "> 請 AI 助手不只描述、還要把整頁的**文字內容逐字謄寫**成 Markdown。\n\n"
        )

    body = ""
    for i, it in enumerate(items, 1):
        if it["kind"] == "chart_page":
            loc = f"第 {it['page']} 頁（向量圖表）"; tag = "📊 數據圖表（必須開圖細看、抄出處）"
        elif it["kind"] in ("page", "figure"):
            loc = f"第 {it['page']} 頁"; tag = "🖼 圖片（開圖判斷：是圖表就細看、是裝飾照可簡述）"
        else:
            loc = it.get("orig_name", f"圖片 {it['page']}"); tag = "🖼 圖片"
        body += f"## 圖像 {i:02d} — {loc}（{it['size']}）｜{tag}\n\n"
        body += f"![圖像 {i:02d}]({it['rel_path']})\n\n"
        body += PLACEHOLDER + "\n\n"

    return yaml + head + body


# ════════════════════════════════════════════════════════════════════════════
#  主流程
# ════════════════════════════════════════════════════════════════════════════
def process(input_path: str, out_dir: str, mode: str, dpi: int,
            detect_vector_pages: bool = True,
            vector_threshold: int = VECTOR_DRAW_THRESHOLD,
            raw_figures: bool = False) -> int:
    if not os.path.exists(input_path):
        log(f"❌ 找不到輸入：{input_path}")
        return 1

    os.makedirs(out_dir, exist_ok=True)
    assets_dir = os.path.join(out_dir, "assets")
    stem = safe_stem(input_path)

    ext = os.path.splitext(input_path)[1].lower()
    is_pdf = ext == ".pdf"
    is_img = ext in IMG_EXTS
    is_dir = os.path.isdir(input_path)

    items = []
    scanned = False
    kind_label = mode

    if is_pdf:
        if not HAS_FITZ:
            log("❌ 需要 PyMuPDF。請使用固定安裝的 VLM 轉換器：~/.vlm-to-md/vlm-to-md")
            return 1
        doc = fitz.open(input_path)
        log(f"📄 開啟 PDF：{os.path.basename(input_path)}（{len(doc)} 頁）")

        scanned, avg = is_scanned_pdf(doc)
        log(f"🔍 平均每頁可抽取文字：{avg:.0f} 字 → "
            f"{'掃描／圖像型 PDF' if scanned else '文字型 PDF'}")

        use_mode = mode
        if mode == "auto":
            use_mode = "pages" if scanned else "figures"
            kind_label = use_mode
            log(f"🧭 auto 模式判定：採用「{use_mode}」")

        if use_mode in ("pages", "both"):
            items += render_pages(doc, stem, assets_dir, dpi)
        if use_mode in ("figures", "both"):
            figs = extract_figures(doc, stem, assets_dir,
                                    raw=raw_figures, render_scale=dpi / 72.0)
            items += figs
            # v1.0.1：補抓「向量圖表頁」（get_images 漏掉的那種，如麥肯錫 Exhibit）
            if use_mode == "figures" and detect_vector_pages and not scanned:
                skip = {it["page"] - 1 for it in figs}
                vpages = extract_vector_chart_pages(
                    doc, stem, assets_dir, dpi, vector_threshold, skip)
                items += vpages
                if vpages:
                    kind_label = "figures+charts"
                    log(f"   ✅ v1.0.1 補抓向量圖表頁 {len(vpages)} 頁"
                        f"（嵌入點陣圖抽不到的數據圖表）")
                # v1.2.0：caption 驅動補抓——確保每個 Exhibit 標題頁都有圖
                captured = {it["page"] - 1 for it in items}
                cpages = render_caption_pages(
                    doc, stem, assets_dir, dpi, exhibit_caption_pages(doc), captured)
                items += cpages
                if cpages:
                    log(f"   ✅ v1.2.0 caption 補抓 Exhibit 頁 {len(cpages)} 頁")
            if not items and use_mode == "figures":
                log("   ⚠ 沒有符合條件的嵌入圖表或向量圖表頁。"
                    "若這是掃描 PDF，請改用 --mode pages")

        if use_mode == "figures" and not scanned:
            log("   💡 這是文字型 PDF：文字部分建議交給 doc-to-md，"
                "本工具只負責其中的圖表視覺解讀（含向量 Exhibit）。")
        doc.close()

    elif is_img or is_dir:
        items = collect_images(input_path, stem, assets_dir)
        kind_label = "images"
    else:
        log(f"❌ 不支援的輸入格式：{ext or '(資料夾?)'}。"
            f"支援：PDF、圖片（{', '.join(sorted(IMG_EXTS))}）、圖片資料夾。")
        return 1

    if not items:
        log("❌ 沒有產生任何圖像，請檢查輸入內容。")
        return 1

    title = stem.replace("_", " ")
    md = build_scaffold(title, os.path.basename(input_path.rstrip("/")),
                        kind_label, items, scanned)

    md_name = f"{stem}_VLM待解讀.md"
    md_path = os.path.join(out_dir, md_name)
    with open(md_path, "w", encoding="utf-8") as f:
        f.write(md)

    # manifest 方便程式化追蹤
    manifest = {
        "source": input_path,
        "mode": kind_label,
        "scanned": scanned,
        "item_count": len(items),
        "md_file": md_name,
        "items": [{k: v for k, v in it.items() if k != "img_path"} for it in items],
    }
    with open(os.path.join(out_dir, f"{stem}_manifest.json"), "w",
              encoding="utf-8") as f:
        json.dump(manifest, f, ensure_ascii=False, indent=2)

    log("")
    log("✅ Phase 1 完成（本地、0 token）")
    log(f"   • 圖像數量：{len(items)}")
    log(f"   • 圖檔位置：{os.path.join(assets_dir, stem)}/")
    log(f"   • 待解讀檔：{md_path}")
    log("")
    log("👉 下一步（Phase 2，免費）：在 Codex App 中說")
    log(f'   「幫我用視覺能力完成這份 VLM 待解讀檔：{md_path}」')
    log(f"[DONE] scaffold saved to: {md_path}")
    return 0


def main():
    ap = argparse.ArgumentParser(
        description="VLM-to-MD Phase 1：把 PDF／圖片轉成圖檔 + Markdown 骨架（本地、免費、0 token）"
    )
    ap.add_argument("input", help="PDF 檔、單張圖片，或圖片資料夾")
    ap.add_argument("-o", "--output", default=None,
                    help="輸出資料夾（預設：輸入檔所在目錄）")
    ap.add_argument("--mode", choices=["auto", "pages", "figures", "both"],
                    default="auto",
                    help="auto=自動判定；pages=整頁渲染；figures=只抽圖表；both=兩者")
    ap.add_argument("--auto", action="store_true",
                    help="等同 --mode auto（與 doc-to-md 一致的便捷旗標）")
    ap.add_argument("--dpi", type=int, default=PAGE_RENDER_DPI,
                    help=f"整頁渲染解析度（預設 {PAGE_RENDER_DPI}）")
    ap.add_argument("--vector-threshold", type=int, default=VECTOR_DRAW_THRESHOLD,
                    help=f"向量圖表頁偵測門檻：單頁向量物件數 ≥ 此值即整頁渲染"
                         f"（預設 {VECTOR_DRAW_THRESHOLD}，v1.0.1）")
    ap.add_argument("--no-vector-pages", action="store_true",
                    help="關閉向量圖表頁偵測（只抽嵌入點陣圖，回到 v1.0.0 行為）")
    ap.add_argument("--raw-figures", action="store_true",
                    help="圖表用『直接取原始內嵌 bitmap』舊法（可能黑底）；"
                         "預設用白底渲染修正透明 PNG 黑底問題（v1.0.2）")
    args = ap.parse_args()

    if args.auto:
        args.mode = "auto"

    out_dir = args.output or (
        os.path.dirname(os.path.abspath(args.input))
        if not os.path.isdir(args.input) else args.input
    )
    sys.exit(process(args.input, out_dir, args.mode, args.dpi,
                     detect_vector_pages=not args.no_vector_pages,
                     vector_threshold=args.vector_threshold,
                     raw_figures=args.raw_figures))


if __name__ == "__main__":
    main()
CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_VLM_PREP_PY

# doc-to-md/scripts/package_kb.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/scripts/package_kb.py")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/scripts/package_kb.py" <<'CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_PACKAGE_KB_PY'
#!/usr/bin/env python3
"""
package_kb.py — 把「最終知識庫 md + assets/」打包成單一 zip，內含一個資料夾。
解壓後打開資料夾裡的 md（如 Typora），縮圖會用標準相對連結自動顯示。

解決「只交付一個 md → 縮圖全斷、學員以為壞掉」的問題：交付這個 zip 即可。

用法：
    python3 package_kb.py <最終.md> [--assets <assets目錄>] [-o <輸出.zip>]

行為：
    - 只打包 md 實際引用到的圖（![](...) 相對連結），順便當「斷鏈檢查」。
    - 任一連結找不到圖檔 → 非 0 退出並列出，提醒你「補圖」或「移除該圖片行」。
"""
import argparse
import os
import re
import sys
import zipfile

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

SUFFIX = re.compile(r"(_完整知識庫|_視覺知識庫|_知識庫)?\.md$")


def main():
    ap = argparse.ArgumentParser(description="把知識庫 md + assets 打包成可攜 zip（縮圖自動連結）")
    ap.add_argument("md", help="最終知識庫 md 路徑")
    ap.add_argument("--assets", default=None, help="assets 目錄（預設：md 同層 assets/）")
    ap.add_argument("-o", "--output", default=None, help="輸出 zip（預設：md 同層 {stem}_知識庫.zip）")
    args = ap.parse_args()

    md = os.path.abspath(args.md)
    if not os.path.isfile(md):
        print(f"❌ 找不到 md：{md}", file=sys.stderr)
        sys.exit(1)
    base = os.path.dirname(md)
    md_name = os.path.basename(md)
    stem = SUFFIX.sub("", md_name)
    folder = f"{stem}_知識庫"
    out_zip = args.output or os.path.join(base, f"{folder}.zip")

    text = open(md, encoding="utf-8").read()
    links = re.findall(r"!\[[^]]*\]\(([^)]+)\)", text)
    rels = [l for l in links if not l.startswith(("http://", "https://", "data:"))]

    missing = []
    packed = 0
    if os.path.exists(out_zip):
        os.remove(out_zip)
    with zipfile.ZipFile(out_zip, "w", zipfile.ZIP_DEFLATED) as zf:
        zf.write(md, f"{folder}/{md_name}")
        for rel in sorted(set(rels)):
            src = os.path.normpath(os.path.join(base, rel))
            if os.path.isfile(src):
                zf.write(src, f"{folder}/{rel}")
                packed += 1
            else:
                missing.append(rel)

    print(f"✅ 已打包：{out_zip}")
    print(f"   結構：{folder}/{md_name} ＋ {packed} 張圖（assets 隨行）")
    if missing:
        print(f"   ❌ 有 {len(missing)} 個圖片連結找不到實體檔（未打包，會斷鏈）：")
        for m in missing[:8]:
            print(f"        {m}")
        print("   → 請確認 assets 在 md 同層，或把這些斷鏈的圖片行移除（只留 VLM 文字）後重打包。")
        sys.exit(2)
    print(f"   📂 解壓後打開 {folder}/{md_name}（Typora 等）縮圖會自動顯示，0 斷鏈。")


if __name__ == "__main__":
    main()
CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_PACKAGE_KB_PY

# doc-to-md/scripts/install.bat
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/scripts/install.bat")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/scripts/install.bat" <<'CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_INSTALL_BAT'
@echo off
chcp 65001 >nul 2>nul
setlocal EnableExtensions EnableDelayedExpansion
title doc-to-md 安裝程式 v1.5.0

echo.
echo ============================================================
echo   doc-to-md 安裝程式 v1.5.0
echo ============================================================
echo.

set "INSTALL_DIR=%USERPROFILE%\.doc-to-md"
set "SCRIPT_DIR=%~dp0"
set "SKILL_SRC=%SCRIPT_DIR%skill"
set "EXTRACT_DIR="
set "VENV_PY=%INSTALL_DIR%\venv\Scripts\python.exe"

:: This installer supports both the original outer installer folder
:: and the LazyPack embedded location: skills\doc-to-md\scripts\install.bat.
if not exist "%SKILL_SRC%\scripts\requirements.txt" (
    for %%I in ("%SCRIPT_DIR%..") do set "SKILL_SRC=%%~fI"
)

:: If the original package only contains skill.zip, extract it first.
if not exist "%SKILL_SRC%\scripts\requirements.txt" (
    if not exist "%SCRIPT_DIR%skill.zip" (
        echo 找不到 requirements.txt 或 skill.zip，請確認安裝包已完整解壓縮，或已先安裝 Codex skill。
        pause
        exit /b 1
    )

    set "EXTRACT_DIR=%TEMP%\doc-to-md-skill-%RANDOM%%RANDOM%"
    set "DOC_TO_MD_SKILL_ZIP=%SCRIPT_DIR%skill.zip"
    set "DOC_TO_MD_EXTRACT_DIR=!EXTRACT_DIR!"

    echo [準備] 解壓縮技能檔...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath $env:DOC_TO_MD_SKILL_ZIP -DestinationPath $env:DOC_TO_MD_EXTRACT_DIR -Force" >nul
    if errorlevel 1 (
        echo 解壓縮 skill.zip 失敗，請先將整個安裝包解壓縮後再執行 install.bat。
        pause
        exit /b 1
    )
    set "SKILL_SRC=!EXTRACT_DIR!\skill"
)

if not exist "%SKILL_SRC%\scripts\requirements.txt" (
    echo 找不到 %SKILL_SRC%\scripts\requirements.txt
    echo 請確認安裝包內容完整，或重新下載安裝包。
    pause
    exit /b 1
)

:: Step 1: Find a real Python 3.8+. Avoid the Microsoft Store WindowsApps alias.
echo [Step 1/3] 檢查 Python 版本...
set "PY_CMD="
set "PY_VER="

call :try_python py -3.13
call :try_python py -3.12
call :try_python py -3.11
call :try_python py -3.10
call :try_python py -3.9
call :try_python py -3.8
call :try_python py -3
call :try_python python
call :try_python python3

if "%PY_CMD%"=="" (
    echo.
    echo 找不到可用的 Python 3.8 以上版本。
    echo.
    echo 請先安裝 Python：
    echo 1. 前往 https://www.python.org/downloads/
    echo 2. 下載安裝 Python 3.12 或更新版本
    echo 3. Windows 安裝時務必勾選 Add Python to PATH
    echo 4. 安裝完成後，關閉此視窗重新執行 install.bat
    echo.
    start https://www.python.org/downloads/
    pause
    exit /b 1
)

echo    找到 Python %PY_VER%：%PY_CMD%

:: Step 2: Create or repair venv.
echo.
echo [Step 2/3] 建立虛擬環境...

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

if exist "%VENV_PY%" (
    "%VENV_PY%" -c "import sys; raise SystemExit(0 if sys.version_info >= (3, 8) else 1)" >nul 2>nul
    if errorlevel 1 (
        echo    偵測到舊的虛擬環境已失效，重新建立...
        rmdir /S /Q "%INSTALL_DIR%\venv" >nul 2>nul
    ) else (
        echo    虛擬環境已存在，跳過建立
    )
)

if not exist "%VENV_PY%" (
    %PY_CMD% -m venv "%INSTALL_DIR%\venv"
    if errorlevel 1 (
        echo    建立虛擬環境失敗，請截圖回報老師。
        pause
        exit /b 1
    )
    echo    虛擬環境建立在 %INSTALL_DIR%\venv
)

:: Step 3: Install dependencies and copy scripts.
echo.
echo [Step 3/3] 安裝 Python 套件（可能需要 1-2 分鐘）...

"%VENV_PY%" -m pip install --upgrade pip --quiet
"%VENV_PY%" -m pip install -r "%SKILL_SRC%\scripts\requirements.txt" --quiet

if errorlevel 1 (
    echo    安裝失敗，請截圖錯誤訊息回報老師。
    pause
    exit /b 1
)
echo    所有套件安裝完成

copy /Y "%SKILL_SRC%\scripts\doc_to_md.py" "%INSTALL_DIR%\" >nul
if errorlevel 1 (
    echo    複製 doc_to_md.py 失敗。
    echo    來源：%SKILL_SRC%\scripts\doc_to_md.py
    echo    目的：%INSTALL_DIR%\
    pause
    exit /b 1
)
copy /Y "%SKILL_SRC%\scripts\doc_md_router.py" "%INSTALL_DIR%\" >nul
if errorlevel 1 (
    echo    複製 doc_md_router.py 失敗。
    echo    來源：%SKILL_SRC%\scripts\doc_md_router.py
    echo    目的：%INSTALL_DIR%\
    pause
    exit /b 1
)
copy /Y "%SKILL_SRC%\scripts\vlm_prep.py" "%INSTALL_DIR%\" >nul
if errorlevel 1 (
    echo    複製 vlm_prep.py 失敗。
    echo    來源：%SKILL_SRC%\scripts\vlm_prep.py
    echo    目的：%INSTALL_DIR%\
    pause
    exit /b 1
)
copy /Y "%SKILL_SRC%\scripts\package_kb.py" "%INSTALL_DIR%\" >nul
if errorlevel 1 (
    echo    複製 package_kb.py 失敗。
    echo    來源：%SKILL_SRC%\scripts\package_kb.py
    echo    目的：%INSTALL_DIR%\
    pause
    exit /b 1
)
copy /Y "%SKILL_SRC%\scripts\requirements.txt" "%INSTALL_DIR%\" >nul
if errorlevel 1 (
    echo    複製 requirements.txt 失敗。
    echo    來源：%SKILL_SRC%\scripts\requirements.txt
    echo    目的：%INSTALL_DIR%\
    pause
    exit /b 1
)

if not exist "%INSTALL_DIR%\doc_to_md.py" (
    echo    找不到已安裝的 doc_to_md.py，請截圖回報老師。
    pause
    exit /b 1
)
if not exist "%INSTALL_DIR%\doc_md_router.py" (
    echo    找不到已安裝的 doc_md_router.py，請截圖回報老師。
    pause
    exit /b 1
)

(
echo @echo off
echo "%VENV_PY%" "%INSTALL_DIR%\doc_md_router.py" %%*
) > "%INSTALL_DIR%\doc-to-md.bat"

(
echo @echo off
echo "%VENV_PY%" "%INSTALL_DIR%\doc_to_md.py" %%*
) > "%INSTALL_DIR%\doc-to-md-text.bat"

(
echo @echo off
echo "%VENV_PY%" "%INSTALL_DIR%\vlm_prep.py" %%*
) > "%INSTALL_DIR%\vlm-to-md.bat"

(
echo @echo off
echo "%VENV_PY%" "%INSTALL_DIR%\package_kb.py" %%*
) > "%INSTALL_DIR%\doc-to-md-package.bat"

echo.
echo 驗證安裝...
"%VENV_PY%" -c "import sys; print('Python OK:', sys.version.split()[0])"
if errorlevel 1 (
    echo    Python 執行失敗，請截圖回報老師。
    pause
    exit /b 1
)

"%VENV_PY%" -c "import fitz, ebooklib, bs4, chardet, opencc, lxml; print('套件匯入 OK')"
if errorlevel 1 (
    echo.
    echo    套件匯入失敗。上方會顯示真正錯誤原因，請截圖回報老師。
    echo    常見原因：Python 版本/架構不相容，或 Windows 缺少必要執行環境。
    pause
    exit /b 1
)

"%VENV_PY%" "%INSTALL_DIR%\doc_md_router.py" --help
if errorlevel 1 (
    echo.
    echo    doc_md_router.py 驗證失敗。上方會顯示真正錯誤原因，請截圖回報老師。
    pause
    exit /b 1
)

"%VENV_PY%" "%INSTALL_DIR%\doc_to_md.py" --help

if errorlevel 1 (
    echo.
    echo    doc_to_md.py 驗證失敗。上方會顯示真正錯誤原因，請截圖回報老師。
    pause
    exit /b 1
)

if defined EXTRACT_DIR rmdir /S /Q "%EXTRACT_DIR%" >nul 2>nul

echo    驗證通過！
echo.
echo ============================================================
echo   安裝完成！
echo ============================================================
echo.
echo 本機 Python 轉換器已安裝完成。
echo 若你是照 LazyPack 文件操作，Codex skill 應已位於：
echo %SKILL_SRC%
echo 請重新開啟 Codex 對話或重啟 Codex App，讓 skill metadata 重新載入。
echo.
echo 手動使用：
echo "%INSTALL_DIR%\doc-to-md.bat" C:\Users\你的名字\Desktop\mybook.pdf -o C:\Users\你的名字\Desktop\
echo.
pause
exit /b 0

:try_python
if defined PY_CMD exit /b 0
for /f "usebackq tokens=1,2 delims=|" %%v in (`%* -c "import sys; exe=sys.executable; ok=sys.version_info >= (3, 8) and 'WindowsApps' not in exe; print(f'{sys.version_info.major}.{sys.version_info.minor}|{exe}' if ok else '')" 2^>nul`) do (
    set "PY_CMD=%*"
    set "PY_VER=%%v"
)
exit /b 0
CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_INSTALL_BAT

# doc-to-md/scripts/install.sh
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/scripts/install.sh")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/scripts/install.sh" <<'CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_INSTALL_SH'
#!/bin/bash
# ╔════════════════════════════════════════════╗
# ║   doc-to-md 一鍵安裝器（Mac / Linux）      ║
# ║   把 PDF/EPUB/TXT 轉成 Markdown 知識庫     ║
# ╚════════════════════════════════════════════╝
#
# 使用方式：打開 Terminal → 拖入此檔案 → 按 Enter

set -e
trap 'if [ -n "${EXTRACT_DIR:-}" ]; then rm -rf "$EXTRACT_DIR"; fi' EXIT

INSTALL_DIR="$HOME/.doc-to-md"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_SRC="$SCRIPT_DIR/skill"
EXTRACT_DIR=""

# This installer supports both the original outer installer folder
# and the LazyPack embedded location: skills/doc-to-md/scripts/install.sh.
if [ ! -f "$SKILL_SRC/scripts/requirements.txt" ]; then
    SKILL_SRC="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

if [ ! -f "$SKILL_SRC/scripts/requirements.txt" ]; then
    if [ ! -f "$SCRIPT_DIR/skill.zip" ]; then
        echo "找不到 requirements.txt 或 skill.zip，請確認安裝包已完整解壓縮，或已先安裝 Codex skill。"
        exit 1
    fi
    EXTRACT_DIR="$(mktemp -d "${TMPDIR:-/tmp}/doc-to-md-skill.XXXXXX")"
    echo "📦 解壓縮技能檔..."
    unzip -q "$SCRIPT_DIR/skill.zip" -d "$EXTRACT_DIR"
    SKILL_SRC="$EXTRACT_DIR/skill"
fi

if [ ! -f "$SKILL_SRC/scripts/requirements.txt" ]; then
    echo "找不到 $SKILL_SRC/scripts/requirements.txt"
    echo "請確認安裝包內容完整，或重新下載安裝包。"
    exit 1
fi

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║   doc-to-md 安裝程式 v1.5.0                ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# ── Step 1: 找到可用的 Python 3.8+ ──────────────────────────────────────────

echo "🔍 Step 1/3：檢查 Python 版本..."
PY=""
for cmd in python3.13 python3.12 python3.11 python3.10 python3.9 python3; do
    if command -v "$cmd" &>/dev/null; then
        ver=$("$cmd" -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null)
        major=$(echo "$ver" | cut -d. -f1)
        minor=$(echo "$ver" | cut -d. -f2)
        if [ "$major" -ge 3 ] 2>/dev/null && [ "$minor" -ge 8 ] 2>/dev/null; then
            PY="$cmd"
            echo "   ✅ 找到 $cmd (Python $ver)"
            break
        else
            echo "   ⏭️  $cmd 版本 $ver 太舊，跳過"
        fi
    fi
done

if [ -z "$PY" ]; then
    echo ""
    echo "   ❌ 找不到 Python 3.8 以上版本"
    echo ""
    echo "   請先安裝 Python："
    echo "   👉 前往 https://www.python.org/downloads/"
    echo "   👉 下載安裝 Python 3.12（點擊 Download 大按鈕）"
    echo "   👉 安裝完成後，關閉 Terminal 重新開啟"
    echo "   👉 再次拖入此檔案執行"
    echo ""
    open "https://www.python.org/downloads/" 2>/dev/null || true
    exit 1
fi

# ── Step 2: 建立安裝目錄和 venv ─────────────────────────────────────────────

echo ""
echo "📦 Step 2/3：建立虛擬環境..."

mkdir -p "$INSTALL_DIR"

if [ -d "$INSTALL_DIR/venv" ]; then
    echo "   ⏭️  虛擬環境已存在，跳過建立"
else
    "$PY" -m venv "$INSTALL_DIR/venv"
    echo "   ✅ 虛擬環境建立在 $INSTALL_DIR/venv"
fi

# ── Step 3: 安裝 Python 依賴 + 複製腳本 ─────────────────────────────────────

echo ""
echo "📥 Step 3/3：安裝 Python 套件（可能需要 1-2 分鐘）..."

"$INSTALL_DIR/venv/bin/pip" install --upgrade pip --quiet 2>/dev/null
"$INSTALL_DIR/venv/bin/pip" install -r "$SKILL_SRC/scripts/requirements.txt" --quiet

if [ $? -eq 0 ]; then
    echo "   ✅ 所有套件安裝完成"
else
    echo "   ❌ 安裝失敗，請截圖錯誤訊息回報老師"
    exit 1
fi

# 複製轉換腳本到安裝目錄
cp "$SKILL_SRC/scripts/doc_to_md.py" "$INSTALL_DIR/"
cp "$SKILL_SRC/scripts/doc_md_router.py" "$INSTALL_DIR/"
cp "$SKILL_SRC/scripts/vlm_prep.py" "$INSTALL_DIR/"
cp "$SKILL_SRC/scripts/package_kb.py" "$INSTALL_DIR/"
cp "$SKILL_SRC/scripts/requirements.txt" "$INSTALL_DIR/"

# 建立全域啟動器
cat > "$INSTALL_DIR/doc-to-md" << 'LAUNCHER'
#!/bin/bash
DIR="$HOME/.doc-to-md"
"$DIR/venv/bin/python3" "$DIR/doc_md_router.py" "$@"
LAUNCHER
chmod +x "$INSTALL_DIR/doc-to-md"

cat > "$INSTALL_DIR/doc-to-md-text" << 'LAUNCHER'
#!/bin/bash
DIR="$HOME/.doc-to-md"
"$DIR/venv/bin/python3" "$DIR/doc_to_md.py" "$@"
LAUNCHER
chmod +x "$INSTALL_DIR/doc-to-md-text"

cat > "$INSTALL_DIR/vlm-to-md" << 'LAUNCHER'
#!/bin/bash
DIR="$HOME/.doc-to-md"
"$DIR/venv/bin/python3" "$DIR/vlm_prep.py" "$@"
LAUNCHER
chmod +x "$INSTALL_DIR/vlm-to-md"

cat > "$INSTALL_DIR/doc-to-md-package" << 'LAUNCHER'
#!/bin/bash
DIR="$HOME/.doc-to-md"
"$DIR/venv/bin/python3" "$DIR/package_kb.py" "$@"
LAUNCHER
chmod +x "$INSTALL_DIR/doc-to-md-package"

# 加入 PATH
SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_RC="$HOME/.bash_profile"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "doc-to-md" "$SHELL_RC" 2>/dev/null; then
        echo "" >> "$SHELL_RC"
        echo '# doc-to-md converter' >> "$SHELL_RC"
        echo 'export PATH="$HOME/.doc-to-md:$PATH"' >> "$SHELL_RC"
    fi
fi

# ── 驗證 ────────────────────────────────────────────────────────────────────

echo ""
echo "🧪 驗證安裝..."
"$INSTALL_DIR/venv/bin/python3" "$INSTALL_DIR/doc_md_router.py" --help >/dev/null 2>&1
"$INSTALL_DIR/venv/bin/python3" "$INSTALL_DIR/doc_to_md.py" --help >/dev/null 2>&1
"$INSTALL_DIR/venv/bin/python3" "$INSTALL_DIR/vlm_prep.py" --help >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "   ✅ 驗證通過！"
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                      🎉 安裝完成！                          ║"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo "║                                                            ║"
    echo "║  本機 Python 轉換器已安裝完成。                              ║"
    echo "║  若你是照 LazyPack 文件操作，Codex skill 應已位於：           ║"
    echo "║  $SKILL_SRC"
    echo "║  請重新開啟 Codex 對話或重啟 Codex App。                     ║"
    echo "║                                                            ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "  🔧 也可以手動在 Terminal 使用自動路由："
    echo "     $INSTALL_DIR/doc-to-md ~/Desktop/mybook.pdf -o ~/Desktop/"
    echo "     $INSTALL_DIR/doc-to-md ~/Desktop/report.pdf -o ~/Desktop/"
    echo ""
    echo "  ℹ️  重新開啟 Terminal 後也可以直接輸入："
    echo "     doc-to-md ~/Desktop/report.pdf -o ~/Desktop/"
    echo ""
else
    echo "   ❌ 驗證失敗，請截圖回報老師"
    exit 1
fi
CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_INSTALL_SH

# doc-to-md/scripts/requirements.txt
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/scripts/requirements.txt")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/scripts/requirements.txt" <<'CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_REQUIREMENTS_TXT'
PyMuPDF>=1.23.0
ebooklib>=0.18
beautifulsoup4>=4.12.0
chardet>=5.0.0
opencc-python-reimplemented>=0.1.7
lxml>=4.9.0
Pillow>=10.0.0
CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_REQUIREMENTS_TXT

chmod +x "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_md_router.py" \
  "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_to_md.py" \
  "{{CODEX_HOME}}/skills/doc-to-md/scripts/vlm_prep.py" \
  "{{CODEX_HOME}}/skills/doc-to-md/scripts/package_kb.py" \
  "{{CODEX_HOME}}/skills/doc-to-md/scripts/install.sh"

test -f "{{CODEX_HOME}}/skills/doc-to-md/SKILL.md" && echo "doc-to-md installed"
test -f "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_md_router.py" && echo "doc-to-md router installed"
test -f "{{CODEX_HOME}}/skills/doc-to-md/scripts/vlm_prep.py" && echo "doc-to-md vlm installed"

echo "embedded skills installed: doc-to-md"
```

<!-- END EMBEDDED_SKILLS -->
