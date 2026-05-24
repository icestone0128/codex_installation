# 18-Document-to-Markdown-Skill-安裝

> 版本：2026-05-24 Codex App 版
> 用途：把 doc-to-md 文件轉 Markdown 流程安裝成 Codex App 全域 Skill，用於 PDF、EPUB、TXT 轉換、繁體化、章節摘要與 Obsidian-ready Markdown。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/doc-to-md/`，不需要額外的 `skills/` 子目錄。

## 來源與歷史紀錄

- 初次同步日期：2026-05-10。
- 原始來源包：`skill.zip`。
- 重新提供並核對的完整安裝包：`doc-to-md-安裝包_v1.4.6.zip`。
- 完整安裝包外層包含：`README.md`、`USAGE.md`、`install.sh`、`install.bat`、`skill.zip`。
- 後續補齊：`installer-readme.md`、`full-usage.md`、`install.sh`、`install.bat`。
- Codex 全域 skill：`/Users/arrywu/.codex/skills/doc-to-md/SKILL.md`。
- Obsidian 全域索引已記錄用途：將 PDF、EPUB、TXT 轉成帶 YAML frontmatter 與章節摘要 callout 的 Markdown，支援簡轉繁。

## 這版和來源工具文件的差異

| 原始取向 | Codex 版 |
|---|---|
| 可能保留 Claude Desktop / `~/.claude` 範例 | Active skill 以 Codex 全域 skill 路徑為準；來源範例只作參考 |
| 轉換器與 skill 安裝容易混在一起 | 本文同時內嵌 skill package 與本機轉換器安裝腳本 |
| 只安裝 `SKILL.md` 會缺功能 | 必須包含 `references/` 與 `scripts/` |
| PDF 解析可能被誤認為 Codex 內建 PDF plugin | `doc-to-md` 是自訂轉檔 skill，不是系統 PDF plugin |

## 安裝方式

Document to MD 有兩層安裝，兩層都要完成：

1. **Codex Skill 安裝**：使用本文文末「內建 Skill 完整安裝內容」。執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `/Users/alex/.codex`。
2. **本機 Python 轉換器安裝**：安裝 Skill 後，再執行 skill 內的 `scripts/install.sh` 或 `scripts/install.bat`。這一步會在使用者電腦建立 `~/.doc-to-md/` 或 `%USERPROFILE%\.doc-to-md\`，建立 Python venv，安裝 PDF / EPUB / TXT 轉換需要的套件，並建立 `doc-to-md` 啟動器。

### Mac / Linux：外部終端機安裝 Python 轉換器

開啟 Terminal，執行：

```bash
bash "{{CODEX_HOME}}/skills/doc-to-md/scripts/install.sh"
```

如果是提供給完全不熟 Terminal 的使用者，也可以請他在 Terminal 輸入 `bash `，保留後面的空格，接著把 `install.sh` 從 Finder 拖進 Terminal 視窗，再按 Enter。這是原始 `doc-to-md-安裝包_v1.4.6.zip` 的使用方式。

安裝程式會自動：

- 尋找 Python 3.8 以上版本，優先使用 Python 3.13 到 3.9，再退到 `python3`。
- 若找不到 Python 3.8+，提示到 python.org 安裝 Python 3.12 或更新版本。
- 建立 `~/.doc-to-md/venv/`。
- 用 pip 安裝 `PyMuPDF`、`ebooklib`、`beautifulsoup4`、`chardet`、`opencc-python-reimplemented`、`lxml`。
- 複製 `doc_to_md.py` 與 `requirements.txt` 到 `~/.doc-to-md/`。
- 建立 `~/.doc-to-md/doc-to-md` 啟動器，並嘗試把 `~/.doc-to-md` 加入 shell PATH。

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

合理結果是看到 `doc-to-md` 的參數說明。

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/doc-to-md/SKILL.md" && echo "doc-to-md SKILL.md ok"
test -f "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_to_md.py" && echo "converter script ok"
test -f "{{CODEX_HOME}}/skills/doc-to-md/scripts/requirements.txt" && echo "requirements ok"
test -f "{{CODEX_HOME}}/skills/doc-to-md/references/full-usage.md" && echo "full usage ok"
```

合理結果是四行都顯示 `ok`。

## 使用方式

安裝後可用下列語句觸發：

- 「使用 doc-to-md 把這個 PDF 轉成 Markdown」
- 「把這本 EPUB 轉成 Obsidian 筆記」
- 「把 TXT 整理成帶 YAML frontmatter 的 Markdown」
- 「轉成繁體中文 Markdown 並加章節摘要」

## 預設工作流程

1. 確認來源格式是 PDF、EPUB 或 TXT。
2. 檢查本機轉換器是否已安裝；未安裝時執行 skill 內的安裝腳本。
3. 轉出 Markdown。
4. 補 YAML frontmatter、章節摘要 callout、關鍵字與 Obsidian-friendly 結構。
5. 如果來源是掃描版 PDF，先提示需要 OCR。

## 踩坑紀錄

### 1. 只裝 SKILL.md 不夠

`doc-to-md` 必須包含 `scripts/doc_to_md.py`、`requirements.txt`、`install.sh`、`install.bat` 與 `references/`。缺任何一段都可能造成轉檔器找不到或使用說明不完整。

### 2. 轉換器安裝位置和 Codex skill 位置不同

Codex skill 放在 `{{CODEX_HOME}}/skills/doc-to-md/`；本機轉換器預設安裝到 `~/.doc-to-md/` 或 Windows 的 `%USERPROFILE%\.doc-to-md\`。不要混成同一個概念。

### 2.1 外層安裝包和內嵌 Skill 路徑不同

原始 `doc-to-md-安裝包_v1.4.6.zip` 的 `install.sh` / `install.bat` 假設旁邊有 `skill.zip`。本懶人包改成自含式有序號文件後，installer 會被放在 `{{CODEX_HOME}}/skills/doc-to-md/scripts/`，所以內嵌版本已調整為：優先讀取上一層 `{{CODEX_HOME}}/skills/doc-to-md/scripts/requirements.txt` 與 `doc_to_md.py`；若找不到，才退回原始安裝包的 `skill.zip` 模式。

### 3. PDF 系統能力和 doc-to-md 不同

Codex 的文件 / PDF 系統能力可用於解析或視覺 QA；`doc-to-md` 是自訂轉 Markdown workflow。不要把它當成系統 PDF plugin 的替代品。

### 4. 掃描版 PDF 需要 OCR

如果 PDF 沒有文字層，轉換器無法直接抽取內容。要先用 OCR 工具處理，再轉 Markdown。

### 5. 舊來源文件殘留 Claude 路徑

部分 reference 內可能保留 `~/.claude/skills/...` 作為來源範例。正式安裝與使用請以 `{{CODEX_HOME}}/skills/doc-to-md/` 與本文指令為準。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/doc-to-md/SKILL.md` 存在。
- [ ] `references/full-usage.md`、`references/installer-readme.md`、`references/usage-guide.md` 存在。
- [ ] `scripts/doc_to_md.py`、`scripts/requirements.txt`、`scripts/install.sh`、`scripts/install.bat` 存在。
- [ ] 已執行 `scripts/install.sh` 或 `scripts/install.bat`，並建立本機 Python venv。
- [ ] `~/.doc-to-md/doc-to-md --help` 或 `%USERPROFILE%\.doc-to-md\doc-to-md.bat --help` 可正常顯示。
- [ ] 開新 Codex 對話後，可用「doc-to-md」或「PDF 轉 Markdown」觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`doc-to-md`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `/Users/alex/.codex`。

```bash
set -e

# ---- doc-to-md ----
mkdir -p "{{CODEX_HOME}}/skills/doc-to-md"
# doc-to-md/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/SKILL.md" <<'CODEX_LAZYPACK_DOC_TO_MD_SKILL_MD'
---
name: doc-to-md
description: Convert PDF, TXT, or EPUB files to clean Markdown with YAML frontmatter and per-section callout annotations. Use this skill when: (1) a student wants to convert a book or lecture file to Markdown for Obsidian/notes, (2) a user has a PDF/EPUB/TXT and needs structured Markdown output with chapter summaries, (3) someone wants garbled-text-free conversion with Simplified→Traditional Chinese auto-conversion.
---

# doc-to-md Skill

Convert PDF / TXT / EPUB to clean Markdown with per-section summaries.

**Works in Codex App and local CLI environments:**
- Use the bundled script in this skill folder when the skill is copied into `$CODEX_HOME/skills/doc-to-md`.
- Use a local install only when the user already installed the helper script and dependencies.

**Cross-platform** — Mac and Windows. No external APIs, no Ollama. The assistant writes summaries after the converter creates placeholders.

> **IMPORTANT — Do NOT decline only because a local install is missing.** The script is bundled inside the skill folder at `scripts/doc_to_md.py`. If the bundled script exists and dependencies can be installed, run the conversion from the bundled path.

---

## Step 1 — Locate the converter (try in this priority order)

### Option A — Bundled script

The script is shipped inside this Skill at `scripts/doc_to_md.py` (relative to the Skill root).

Use the bundled script directly when you cannot find a local install. Resolve paths relative to the skill root.

```bash
# 1. Install Python deps in the sandbox (one-time per session)
pip install -r scripts/requirements.txt

# 2. Run the bundled script
python3 scripts/doc_to_md.py --auto "/mnt/user-data/uploads/<file>.pdf" -o "/mnt/user-data/outputs/"
```

If `scripts/doc_to_md.py` is not at the expected relative path, search the Skill folder:
```bash
find . -name doc_to_md.py 2>/dev/null | head -3
```

### Option B — Local install

If the user already ran `install.sh` / `install.bat`, prefer the local copy because Python deps are already in a venv (no pip install needed):

- **Mac:** `~/.doc-to-md/venv/bin/python3 ~/.doc-to-md/doc_to_md.py`
- **Windows:** `%USERPROFILE%\.doc-to-md\venv\Scripts\python.exe %USERPROFILE%\.doc-to-md\doc_to_md.py`

Detect OS:
```bash
python3 -c "import platform; print(platform.system())"
```

If neither Option A nor Option B is available, instruct the user to install using the bundled local installers:

- Mac/Linux installer: `scripts/install.sh`
- Windows installer: `scripts/install.bat`
- Full installation guide: `references/installer-readme.md`
- Full usage guide: `references/full-usage.md`

The local installers create `~/.doc-to-md/` (Mac/Linux) or `%USERPROFILE%\.doc-to-md\` (Windows), install Python dependencies in a venv, and create a command-line launcher.

---

## Step 2 — Run the Converter

**Common flags:**
| Flag | Effect |
|------|--------|
| `--auto` | Auto-detect format (recommended) |
| `--no-convert-chinese` | Skip Simplified→Traditional conversion |
| `-o DIR` | Output directory (default: same folder as input) |

**Supported formats:** `.pdf` `.epub` `.txt`

After running, note the output path printed as `[DONE] Markdown saved to: ...`.

---

## Step 3 — Assistant Reads and Annotates Sections

After the script finishes, the assistant reads the output Markdown file and fills every `> [!note] 章節摘要` callout block. Each placeholder looks like:

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

---

## Step 4 — Save Annotated File

After filling all callouts, overwrite the file in place.

**Final filename format:** `{Author}_{Title}_知識庫.md`

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `No module named 'fitz'` (sandbox) | `pip install -r scripts/requirements.txt` |
| `No module named 'fitz'` (local) | Re-run `install.sh` / `install.bat` |
| Garbled characters | Try `--no-convert-chinese`; if still garbled, file may need OCR |
| Scanned PDF warning | Use Adobe Acrobat OCR, tesseract, or MinerU before converting |
| 0 sections detected | Unusual headings — output still usable, no chapter splits |
| EPUB shows empty chapters | Some DRM-protected EPUBs block extraction; remove DRM first |
| Skill says "this requires local install" | **Wrong** — re-read Step 1 Option A; the bundled script works in sandbox |
CODEX_LAZYPACK_DOC_TO_MD_SKILL_MD

# doc-to-md/references/full-usage.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/references/full-usage.md")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/references/full-usage.md" <<'CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_FULL_USAGE_MD'
# doc-to-md 使用說明

> 把 PDF / EPUB / TXT 轉成 Markdown 知識庫，搭配 Claude 自動寫章節摘要

---

## 運作原理

doc-to-md 分成兩個階段，各自負責不同的事：

```
┌─────────────────────────────┐     ┌─────────────────────────────┐
│  Phase 1：本地轉換（免費）    │     │  Phase 2：Claude 摘要        │
│  ─────────────────────────  │     │  ─────────────────────────  │
│  你的電腦上執行              │ ──→ │  Claude Desktop 執行         │
│  不花任何 token              │     │  消耗 Claude token           │
│  不需要網路                  │     │  需要 Claude 帳號            │
│                             │     │                             │
│  • PDF/EPUB/TXT 文字提取     │     │  • 讀取轉好的 Markdown       │
│  • 章節結構偵測              │     │  • 為每個章節寫摘要           │
│  • 簡體→繁體中文轉換         │     │  • 填入關鍵字                │
│  • 頁首頁尾去除              │     │  • 存檔                     │
│  • 斷行合併                  │     │                             │
│  • YAML frontmatter 生成     │     │                             │
│  • Obsidian 錨點標記         │     │                             │
└─────────────────────────────┘     └─────────────────────────────┘
      Python 腳本（本地）                  Claude AI（雲端）
```

**重點：Phase 1 完全免費、離線、不花 token。** 即使你沒有 Claude 帳號，Phase 1 產出的 Markdown 也已經是可用的知識庫——只是少了章節摘要。

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
| **章節摘要撰寫** | **Claude 雲端** | **花 token** |
| **關鍵字提取** | **Claude 雲端** | **花 token** |

**結論：90% 的工作在本地完成，只有「寫摘要」這一步用到 Claude。**

---

## Token 消耗估算

Claude 在 Phase 2 需要讀取整份 Markdown 並填寫摘要。消耗量取決於檔案大小：

| 原始檔案大小 | 轉換後 Markdown | Claude token 估算 | 免費帳號夠用嗎 |
|------------|----------------|-------------------|--------------|
| < 1 MB（短文/報告） | ~50 KB | ~20K tokens | 輕鬆夠用 |
| 1-5 MB（一般書籍） | 100-300 KB | 50-100K tokens | 夠用 |
| 5-20 MB（大部頭）| 300 KB - 1 MB | 100-300K tokens | 可能需分次 |
| > 20 MB（超大檔） | > 1 MB | > 300K tokens | 需要 Pro 帳號或分次處理 |

> **省 token 技巧**：Phase 1 轉換完之後，你可以只讓 Claude 處理「你需要的章節」，不必一次處理整本書。

---

## Context 限制與解決方案

### 什麼是 Context 限制？

Claude 每次對話能處理的文字量有上限（稱為 context window）。如果你的 Markdown 檔案太大，Claude 可能無法一次讀完。

### 會遇到限制嗎？

| 情境 | 會遇到嗎 | 說明 |
|------|---------|------|
| 一般書籍（200-400 頁） | 通常不會 | 轉換後約 100-200 KB，Claude 可以處理 |
| 大部頭（500+ 頁） | 可能會 | 轉換後可能超過 300 KB |
| 多本書一次處理 | 一定會 | 請一本一本處理 |

### 如果遇到了怎麼辦？

**方法 1：分段處理（推薦）**

跟 Claude 說：
```
幫我處理這個 Markdown 的前 300 行摘要：/path/to/file.md
```
完成後再說：
```
繼續處理第 301 行到第 600 行
```

**方法 2：只處理需要的章節**

跟 Claude 說：
```
幫我只寫第 3 章到第 5 章的摘要：/path/to/file.md
```

**方法 3：跳過 Phase 2**

Phase 1 的輸出本身就是完整的 Markdown 知識庫，只是沒有摘要。如果你只需要全文搜尋，Phase 1 就夠了。

---

## 使用方式

### 方式 A：跟 Claude 說（最簡單）

打開 Claude Desktop，直接說：

**Mac：**
```
幫我把這個 PDF 轉成 Markdown：/Users/你的名字/Desktop/書名.pdf
```

**Windows：**
```
幫我把這個 PDF 轉成 Markdown：C:\Users\你的名字\Desktop\書名.pdf
```

Claude 會自動執行 Phase 1 + Phase 2。

**其他說法也行：**
- 「轉換這個 EPUB 成知識庫」
- 「把這份 TXT 轉成 Markdown 格式」
- 「幫我處理這本電子書」

### 方式 B：自己跑 Phase 1，Claude 跑 Phase 2

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

**Step 2**：把轉好的 .md 檔案路徑給 Claude
```
幫我為這個 Markdown 填寫章節摘要：/Users/xxx/Desktop/作者_書名_知識庫.md
```

### 方式 C：純本地使用（完全不花 token）

只跑 Phase 1，不讓 Claude 寫摘要：

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
- 之後有空再讓 Claude 補

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

> [!note] 章節摘要                    ← Claude 會填寫這裡
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
| Claude 說檔案太大 | 超過 context 限制 | 分段處理（見上方說明） |
| EPUB 章節是空的 | DRM 保護 | 需先移除 DRM |
| PDF 只有圖片沒有文字 | 掃描版 PDF | 需先 OCR |
| Claude 沒有自動執行 | Skill 沒裝好 | 確認 Claude Desktop Skills 列表有 doc-to-md |
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

然後在 Claude Desktop → Settings → Skills 中移除 `doc-to-md`。
CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_FULL_USAGE_MD

# doc-to-md/references/installer-readme.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/references/installer-readme.md")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/references/installer-readme.md" <<'CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_INSTALLER_README_MD'
# doc-to-md 安裝與使用說明

> 把 PDF / EPUB / TXT 檔案轉成乾淨的 Markdown 知識庫，搭配 Claude 自動寫章節摘要

---

## 安裝（只需做一次，約 2 分鐘）

### Step 1：解壓縮

雙擊下載的 `doc-to-md-安裝包.zip`，解壓縮到任意資料夾。

### Step 2：執行安裝程式

#### Mac 用戶

按 `⌘ + 空白鍵` → 輸入 `Terminal` → 按 Enter。

在 Terminal 中輸入 `bash `（注意 bash 後面有一個空格），然後**把 `install.sh` 檔案拖進 Terminal 視窗**，按 Enter：

```
bash /Users/你的名字/Downloads/doc-to-md-安裝包/install.sh
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

### Step 3：在 Claude Desktop 加入技能

1. 打開 **Claude Desktop**
2. 點左上方 **Customize** → **Skills** → **+** 號 → **Create Skill** → **Upload a skill**
3. 選擇安裝包裡的 **skill.zip** 上傳
4. 確認 `doc-to-md` 出現在 Skills 列表中

---

## 使用方式

### 方式 A：直接跟 Claude 說（推薦）

在 Claude Desktop 的對話框中輸入：

**Mac：**
```
幫我把這個 PDF 轉成 Markdown：/Users/你的名字/Desktop/書名.pdf
```

**Windows：**
```
幫我把這個 PDF 轉成 Markdown：C:\Users\你的名字\Desktop\書名.pdf
```

Claude 會自動：
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

轉換完成後，把輸出的 `.md` 檔案丟給 Claude 填寫摘要。

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
| Claude 說找不到轉換器 | 確認有執行過安裝程式，Mac 試 `~/.doc-to-md/doc-to-md --help`，Windows 試 `%USERPROFILE%\.doc-to-md\doc-to-md.bat --help` |
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

然後在 Claude Desktop → Skills 中移除 `doc-to-md`。

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

### macOS (Homebrew Python)
```bash
pip3 install PyMuPDF ebooklib beautifulsoup4 chardet opencc-python-reimplemented lxml \
  --break-system-packages
```

### Windows (PowerShell)
```powershell
pip install PyMuPDF ebooklib beautifulsoup4 chardet opencc-python-reimplemented lxml
```

### Linux (apt Python)
```bash
pip3 install PyMuPDF ebooklib beautifulsoup4 chardet opencc-python-reimplemented lxml \
  --break-system-packages
```

### Using a Virtual Environment (recommended for students)
```bash
python3 -m venv doc-env
source doc-env/bin/activate        # macOS/Linux
# doc-env\Scripts\activate.bat     # Windows
pip install PyMuPDF ebooklib beautifulsoup4 chardet opencc-python-reimplemented lxml
python3 ~/.claude/skills/doc-to-md/scripts/doc_to_md.py book.pdf
```

---

## Usage Examples

### Basic PDF conversion
```bash
python3 ~/.claude/skills/doc-to-md/scripts/doc_to_md.py "Atomic Habits.pdf"
# Output: Atomic_Habits_知識庫.md  (same folder)
```

### PDF to specific output folder
```bash
python3 ~/.claude/skills/doc-to-md/scripts/doc_to_md.py \
  "第一性原理.pdf" \
  -o ~/Documents/Obsidian/original/ebook/
```

### EPUB book
```bash
python3 ~/.claude/skills/doc-to-md/scripts/doc_to_md.py \
  --auto "deep_work.epub" \
  -o ~/Documents/output/
```

### TXT transcript (no Chinese conversion)
```bash
python3 ~/.claude/skills/doc-to-md/scripts/doc_to_md.py \
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

### Section Placeholder (before Claude fills it)
```markdown
> [!note] 章節摘要
> **摘要**：（Claude 將在此填入本節摘要）
> **關鍵字**：（Claude 將在此填入關鍵字）
```

### After Claude Annotation
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

**Solution:** Pre-process with OCR first:
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

**Solution:** After conversion, manually add headings in the Markdown, or ask Claude to detect and insert headings based on content flow.

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

## Claude Annotation — Prompt Template

When Claude fills in the summaries, it uses this internal logic:

```
For each section in the Markdown file:
1. Read the heading and all body text until the next ## heading
2. Write a 2-4 sentence 摘要 in Traditional Chinese (Taiwan terms)
3. Extract 4-8 關鍵字 (single words or 2-4 char phrases)
4. Replace only the placeholder lines inside the > [!note] callout
5. Preserve all ^anchor tags and other content unchanged
```

**Example sections Claude handles well:**
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
CODEX_LAZYPACK_DOC_TO_MD_REFERENCES_USAGE_GUIDE_MD

# doc-to-md/scripts/doc_to_md.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_to_md.py")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/scripts/doc_to_md.py" <<'CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_DOC_TO_MD_PY'
#!/usr/bin/env python3
"""
doc_to_md.py — Student-friendly document to Markdown converter
Supports: PDF, EPUB, TXT
Output: Clean Markdown with YAML frontmatter + section anchors for Claude to annotate
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
    """Generate the placeholder callout block Claude will fill in."""
    return (
        f"> [!note] 章節摘要\n"
        f"> **摘要**：（Claude 將在此填入本節摘要）\n"
        f"> **關鍵字**：（Claude 將在此填入關鍵字）"
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
    print("\nNext step: Ask Claude to read this file and fill in the 章節摘要 callouts.")

if __name__ == '__main__':
    main()
CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_DOC_TO_MD_PY

# doc-to-md/scripts/install.bat
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/doc-to-md/scripts/install.bat")"
cat > "{{CODEX_HOME}}/skills/doc-to-md/scripts/install.bat" <<'CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_INSTALL_BAT'
@echo off
chcp 65001 >nul 2>nul
setlocal EnableExtensions EnableDelayedExpansion
title doc-to-md 安裝程式 v1.4.6

echo.
echo ============================================================
echo   doc-to-md 安裝程式 v1.4.6
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

(
echo @echo off
echo "%VENV_PY%" "%INSTALL_DIR%\doc_to_md.py" %%*
) > "%INSTALL_DIR%\doc-to-md.bat"

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
echo "%INSTALL_DIR%\doc-to-md.bat" --auto C:\Users\你的名字\Desktop\mybook.pdf -o C:\Users\你的名字\Desktop\
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
echo "║   doc-to-md 安裝程式 v1.4.6                ║"
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
cp "$SKILL_SRC/scripts/requirements.txt" "$INSTALL_DIR/"

# 建立全域啟動器
cat > "$INSTALL_DIR/doc-to-md" << 'LAUNCHER'
#!/bin/bash
DIR="$HOME/.doc-to-md"
"$DIR/venv/bin/python3" "$DIR/doc_to_md.py" "$@"
LAUNCHER
chmod +x "$INSTALL_DIR/doc-to-md"

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
"$INSTALL_DIR/venv/bin/python3" "$INSTALL_DIR/doc_to_md.py" --help >/dev/null 2>&1

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
    echo "  🔧 也可以手動在 Terminal 使用："
    echo "     $INSTALL_DIR/doc-to-md --auto ~/Desktop/mybook.pdf -o ~/Desktop/"
    echo ""
    echo "  ℹ️  重新開啟 Terminal 後也可以直接輸入："
    echo "     doc-to-md --auto ~/Desktop/mybook.pdf -o ~/Desktop/"
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
CODEX_LAZYPACK_DOC_TO_MD_SCRIPTS_REQUIREMENTS_TXT

test -f "{{CODEX_HOME}}/skills/doc-to-md/SKILL.md" && echo "doc-to-md installed"


# pdf / playwright 系統能力檢查
echo "pdf capability: use Codex system/plugin document tooling when available; do not install duplicate global skill"
echo "playwright capability: use installed MCP/browser tooling when available; do not install duplicate global skill"

echo "embedded skills installed: doc-to-md"
```

<!-- END EMBEDDED_SKILLS -->
