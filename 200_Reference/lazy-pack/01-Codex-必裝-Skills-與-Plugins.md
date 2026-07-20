# 01-Codex-必裝-Skills-與-Plugins

> 2026-07-20 更新：本文件列出三 Agent 共用的 PDF／Playwright 基礎 skill，並以 Codex App 為第一個 plugin／connector adapter 範例。Claude 與 AntiGravity 要依各自原生 connector／MCP 能力做同等驗證；共用 skills 不重複安裝。


## 目標

確認 Codex、Claude、AntiGravity 的基礎工作能力：GitHub、Gmail、Google Calendar、Google Drive、PDF、文件、試算表、簡報、瀏覽器、Playwright CLI、skill 建立與安裝。

## 前置條件

- 三 Agent 中至少一個現在可用；Item 16 會預先準備 Codex、Claude、AntiGravity 的全部入口。
- 每個已安裝 Agent 各自完成帳號登入，不同步 auth／token／cookie。
- 若要使用 Google 類工具，準備自己的 Google 帳號。
- 若要使用 GitHub，準備自己的 GitHub 帳號。

## 三 Agent 共用必裝 Skills

下載者必須先把這兩個 skills 安裝到 `{{SYNC_ROOT}}/skills`，再由 Item 16 提供三 Agent 原生入口：

| Skill | 用途 | 安裝後應看到 |
| --- | --- | --- |
| `pdf` | PDF 讀取、摘要、版面檢查、PDF 產生與渲染驗證 | `{{SYNC_ROOT}}/skills/pdf/SKILL.md` |
| `playwright` | 透過 Playwright CLI 操作真實瀏覽器、截圖、表單互動與 UI flow debug | `{{SYNC_ROOT}}/skills/playwright/SKILL.md` |

安裝完成後，分別對 Codex、Claude、AntiGravity 開新對話或重載 skill 清單。

驗證：

```bash
test -f "{{SYNC_ROOT}}/skills/pdf/SKILL.md" && echo "pdf skill ok"
test -f "{{SYNC_ROOT}}/skills/playwright/SKILL.md" && echo "playwright skill ok"
```

注意：這裡的 `playwright` 是三 Agent 共用 skill／CLI 工作流，不是外部 MCP server 設定。

## 建議啟用的 Plugins / Connectors

依需求啟用，不需要一次全部打開：

- GitHub：repo、PR、issue、CI。
- Gmail：信件搜尋、摘要、草稿。
- Google Calendar：行程、會議準備、空檔查詢。
- Google Drive：Drive、Docs、Sheets、Slides。
- Notion：workspace 搜尋、頁面讀取、database 讀取與明確確認後的頁面建立/更新。此項歸在 01 必裝 plugins/connectors 檢查，不需要建立自訂全域 skill。
- Browser：本機或遠端網頁測試、互動操作、截圖與基本前端檢查。優先當前 Agent 的原生 browser／computer-use 通道；需要 CLI 型真實瀏覽器自動化時，使用上方共用 `playwright` skill。
- PDF：讀取、摘要、檢查與引用 PDF 內容。此項搭配上方必裝的 `pdf` skill 使用。
- Documents：Word / docx 文件處理。
- Spreadsheets：xlsx / csv / Sheets 類任務。
- Presentations：PowerPoint / Slides 類任務。

## 建議確認的系統 Skills

Codex 通常已內建：

- `skill-creator`
- `skill-installer`
- `plugin-creator`
- `openai-docs`
- `imagegen`

這些在 `.system` 底下，由 Codex 管理。不要手動覆蓋。

## Agent Execution Notes

- Codex：使用 Codex App plugins／connectors／`.system` skills；本文的 sandbox TOML 只是 Codex adapter。
- Claude：依當前版本的 Connectors／MCP／原生工具清單完成同等 read-only 驗證；缺少時使用共用 CLI skills。
- AntiGravity：依當前版本的 MCP Store／原生 browser／工具清單完成同等 read-only 驗證；缺少時使用共用 CLI skills。
- 驗證結果要記錄「Agent、通道、登入／權限狀態、實測動作、fallback」，不用某 Agent 沒有原生 plugin 作為排除理由。

## 建議建立的自訂全域 Skills

自訂全域 skills 的共用主版本放在：

```text
{{SYNC_ROOT}}/skills
```

本懶人包的自訂 skill 內容已內嵌在對應序號文件中。01 處理三 Agent 共用基礎 skills，並記錄各 Agent 的 plugins／connectors／內建能力 adapter；自訂 skill 請依各序號文末腳本安裝。

```bash
mkdir -p "{{SYNC_ROOT}}/skills"

for skill in codex-skill-creator project-init-sync startup-sync shutdown-sync tool-integration-workflow brainstorm; do
  # 請使用本文文末「內建 Skill 完整安裝內容」；不需要額外複製舊版獨立 skills 子目錄。
done

find "{{SYNC_ROOT}}/skills" -maxdepth 2 -name SKILL.md -print
```

再依需求安裝個人、內容製作與工具類 skill：

| Skill | 用途 | 安裝時機 |
| --- | --- | --- |
| `arry-assistant` 或自訂助手名稱 | 個人助手資料層 | 完成 `09-個人助手設定` 後 |
| `secondbrain-research-digest` | Obsidian 研究整理 | 完成 `05-第二大腦設定指南` 後 |
| `cross-device-sync` | 全域 skills 跨裝置同步 | 完成主線後，需要同步多台裝置時 |
| `social-cards` | 圖卡輸出 | 需要社群圖卡時，並安裝 Node 依賴 |
| `notebooklm-architecture`、`presentation-workflow` | NotebookLM / 簡報 | 需要 NotebookLM 架構或簡報工作流時 |
| `visual-note-generator` | 圖解筆記 / 視覺筆記 | 將手繪筆記依固定 Workflow 與可替換 Style Profile 生成 16:9／2K 圖解時 |

下載者可照 `11-Codex-Skill-Creator-工作流.md` 建立自己的版本，不需要沿用 `Arry` 命名。

## Gmail 驗證流程

1. 啟用 Gmail plugin / connector。
2. 連接自己的 Google 帳號。
3. 請當前 Agent 查詢 Gmail labels 或 mailbox profile。
4. 若顯示已連接但查不到資料，重新確認授權。

不要把實測帳號寫進文件；使用 `{{GOOGLE_ACCOUNT}}` 或自己的帳號。

## Google Calendar 驗證流程

1. 啟用 Google Calendar plugin。
2. 連接自己的 Google 帳號。
3. 請當前 Agent 查詢今天或明天行程。
4. 確認時區正確。

## Google Drive 驗證流程

1. 啟用 Google Drive plugin。
2. 連接自己的 Google 帳號。
3. 請當前 Agent 搜尋一個測試文件或列出最近檔案。
4. 若要編輯文件，先指定明確檔案，避免誤改。

## Notion 驗證流程

1. 啟用 Notion plugin / connector。
2. 連接自己的 Notion workspace。
3. 請當前 Agent 用只讀方式驗證，例如讀取目前連線使用者資訊，或搜尋一個你指定的測試頁面。
4. 若要寫入 Notion page 或 database，先指定目標頁面／database，並要求當前 Agent 先讀取 schema 再寫入。

不要把 Notion token、workspace ID、page ID 或 database ID 寫進 repo、README、AGENTS.md、skills 或公開筆記。若 Codex plugin 已可用，優先用 plugin，不要先手動建立 API token。

## PDF Skill 驗證流程

1. 確認已安裝 `{{SYNC_ROOT}}/skills/pdf/SKILL.md`。
2. 用一份不敏感 PDF 測試讀取、摘要與頁面定位。
3. 若要引用 PDF 內容，要求 Codex 標明檔名與頁碼或可確認的位置。
4. 若要產出或修改 PDF，依 `pdf` skill 流程做渲染檢查。

若 PDF 產出或解析需要本機 Python 套件，Codex sandbox 應只補入窄範圍可寫路徑：

```toml
[sandbox_workspace_write]
writable_roots = [
  "{{HOME}}/.gitconfig",
  "{{PROJECT_ROOT}}/.git",
  "{{HOME}}/.npm",
  "{{HOME}}/.config/configstore",
  "{{HOME}}/.clasprc.json",
  "{{HOME}}/Library/Caches/pip",
  "{{HOME}}/Library/Caches/com.apple.python",
  "{{HOME}}/Library/Python",
  "{{HOME}}/Library/Preferences/netlify",
]
```

這些路徑用途：

- `{{PROJECT_ROOT}}/.git`：允許 trusted repo 的 Git refs、FETCH_HEAD 與 lock files 正常寫入。
- `{{HOME}}/.gitconfig`：允許 `gh auth setup-git` 設定 Git credential helper。
- `{{HOME}}/.npm`、`.config/configstore`：允許 npm / npx 與 Node CLI 工具使用快取與設定。
- `Library/Caches/pip`、`Library/Caches/com.apple.python`、`Library/Python`：允許 pip / Python 安裝與快取。
- `Library/Preferences/netlify`、`.clasprc.json`：允許 Netlify CLI 與 Clasp OAuth 設定。

驗證套件可用：

```bash
python3 -c "import reportlab, pdfplumber, pypdf; print('pdf libs ok')"
```

## Playwright Skill 驗證流程

1. 確認已安裝 `{{SYNC_ROOT}}/skills/playwright/SKILL.md`。
2. 確認本機有 `npx`，因為 `playwright` skill 的 wrapper script 需要它。
3. 用不敏感測試頁驗證瀏覽器操作，例如開啟 `https://example.com`、snapshot、screenshot。
4. 瀏覽器自動化先使用當前 Agent 的原生 browser／computer-use；需要可重現 CLI 時使用共用 `playwright` skill，不必為了同一目的重複安裝外部 browser MCP。

## 驗證全域 Skills

檢查：

```bash
find "{{SYNC_ROOT}}/skills" -maxdepth 2 -name SKILL.md -print
```

每個自訂 skill 至少要有：

```text
<skill-name>/SKILL.md
```

`SKILL.md` frontmatter 至少包含：

```markdown
---
name: skill-name
description: Use when...
---
```

新增或修改後，分別重載 Codex、Claude、AntiGravity 的 skill 入口。

## 踩坑修正

- Plugin 顯示安裝完成，不代表授權成功；要實際查詢資料驗證。
- 新增或修改 skills 後，通常要對三 Agent 分別開新對話或重載入口。
- 工具不在目前可呼叫清單時，先用當前 Agent 的 tool search／plugin／connector／MCP 清單檢查，不要假設已載入。
- 瀏覽器自動化優先當前 Agent 原生通道；需要 terminal／CLI 型真實瀏覽器操作時，使用必裝的 `playwright` skill。
- 全域規則主版本放 `{{SYNC_ROOT}}/core-rules.md`，專案規則放專案根目錄 `AGENTS.md`；三 Agent 原生入口由 Item 16 管理。
- 外部／第三方 skill 教學不能直接照搬；自訂 skills 共用主版本放 `{{SYNC_ROOT}}/skills`，來源專屬設定改寫為三個 adapter。
- 不要覆蓋 `{{CODEX_HOME}}/skills/.system/skill-creator`；需要優化時建立 companion skill。
