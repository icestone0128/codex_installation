# 01-Codex-必裝-Skills-與-Plugins

> 2026-05-31 更新：本文件列為 Codex App 起手式必裝清單。下載者必須加裝 Codex 的 PDF 與 Playwright skills，並啟用常用 plugins / connectors；自訂全域 Skill 已拆到各自的有序號文件，不需要額外的舊版獨立 skills 子目錄。


## 目標

確認 Codex 基礎工作能力：GitHub、Gmail、Google Calendar、Google Drive、PDF、文件、試算表、簡報、瀏覽器、Playwright CLI、技能建立與技能安裝。

## 前置條件

- 已安裝 Codex App。
- 已登入 OpenAI / Codex 使用帳號。
- 若要使用 Google 類工具，準備自己的 Google 帳號。
- 若要使用 GitHub，準備自己的 GitHub 帳號。

## 必裝 Codex Skills

下載者完成 Codex App 基礎安裝後，必須先加裝這兩個 Codex skills：

| Skill | 用途 | 安裝後應看到 |
| --- | --- | --- |
| `pdf` | PDF 讀取、摘要、版面檢查、PDF 產生與渲染驗證 | `{{CODEX_HOME}}/skills/pdf/SKILL.md` |
| `playwright` | 透過 Playwright CLI 操作真實瀏覽器、截圖、表單互動與 UI flow debug | `{{CODEX_HOME}}/skills/playwright/SKILL.md` |

安裝完成後，開新 Codex 對話或重啟 Codex App，讓 skill 清單重新載入。

驗證：

```bash
test -f "{{CODEX_HOME}}/skills/pdf/SKILL.md" && echo "pdf skill ok"
test -f "{{CODEX_HOME}}/skills/playwright/SKILL.md" && echo "playwright skill ok"
```

注意：這裡的 `playwright` 是 Codex skill / CLI 工作流，不是外部 MCP server 設定。

## 建議啟用的 Plugins / Connectors

依需求啟用，不需要一次全部打開：

- GitHub：repo、PR、issue、CI。
- Gmail：信件搜尋、摘要、草稿。
- Google Calendar：行程、會議準備、空檔查詢。
- Google Drive：Drive、Docs、Sheets、Slides。
- Notion：workspace 搜尋、頁面讀取、database 讀取與明確確認後的頁面建立/更新。此項歸在 01 必裝 plugins/connectors 檢查，不需要建立自訂全域 skill。
- Browser：本機或遠端網頁測試、互動操作、截圖與基本前端檢查。Codex App 使用者優先使用這個 plugin；需要 CLI 型真實瀏覽器自動化時，再使用上方必裝的 `playwright` skill。
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

## 建議建立的自訂全域 Skills

自訂全域 skills 放在：

```text
{{CODEX_HOME}}/skills
```

本懶人包的自訂 skill 內容已內嵌在對應序號文件中。01 只做必裝 Codex skills、基礎 plugins / connectors 與內建能力檢查；自訂 skill 請依 05、07、09 到 18 的文末內建腳本安裝。

```bash
mkdir -p "{{CODEX_HOME}}/skills"

for skill in codex-skill-creator project-init-sync startup-sync shutdown-sync tool-integration-workflow brainstorm; do
  # 請使用本文文末「內建 Skill 完整安裝內容」；不需要額外複製舊版獨立 skills 子目錄。
done

find "{{CODEX_HOME}}/skills" -maxdepth 2 -name SKILL.md -print
```

再依需求安裝個人、內容製作與工具類 skill：

| Skill | 用途 | 安裝時機 |
| --- | --- | --- |
| `arry-assistant` 或自訂助手名稱 | 個人助手資料層 | 完成 `09-個人助手設定` 後 |
| `secondbrain-research-digest` | Obsidian 研究整理 | 完成 `05-第二大腦設定指南` 後 |
| `cross-device-sync` | 全域 skills 跨裝置同步 | 完成主線後，需要同步多台裝置時 |
| `social-cards` | 圖卡輸出 | 需要社群圖卡時，並安裝 Node 依賴 |
| `notebooklm-architecture`、`presentation-workflow` | NotebookLM / 簡報 | 需要 NotebookLM 架構或簡報工作流時 |
| `visual-note-generator` | 圖解筆記 / 視覺筆記 | 需要手繪圖解、生圖提示、Q 版角色、資訊圖表或簡報結構時 |

下載者可照 `11-Codex-Skill-Creator-工作流.md` 建立自己的版本，不需要沿用 `Arry` 命名。

## Gmail 驗證流程

1. 啟用 Gmail plugin / connector。
2. 連接自己的 Google 帳號。
3. 請 Codex 查詢 Gmail labels 或 mailbox profile。
4. 若顯示已連接但查不到資料，重新確認授權。

不要把實測帳號寫進文件；使用 `{{GOOGLE_ACCOUNT}}` 或自己的帳號。

## Google Calendar 驗證流程

1. 啟用 Google Calendar plugin。
2. 連接自己的 Google 帳號。
3. 請 Codex 查詢今天或明天行程。
4. 確認時區正確。

## Google Drive 驗證流程

1. 啟用 Google Drive plugin。
2. 連接自己的 Google 帳號。
3. 請 Codex 搜尋一個測試文件或列出最近檔案。
4. 若要編輯文件，先指定明確檔案，避免誤改。

## Notion 驗證流程

1. 啟用 Notion plugin / connector。
2. 連接自己的 Notion workspace。
3. 請 Codex 用只讀方式驗證，例如讀取目前連線使用者資訊，或搜尋一個你指定的測試頁面。
4. 若要寫入 Notion page 或 database，先指定目標頁面 / database，並要求 Codex 先讀取 schema 再寫入。

不要把 Notion token、workspace ID、page ID 或 database ID 寫進 repo、README、AGENTS.md、skills 或公開筆記。若 Codex plugin 已可用，優先用 plugin，不要先手動建立 API token。

## PDF Skill 驗證流程

1. 確認已安裝 `{{CODEX_HOME}}/skills/pdf/SKILL.md`。
2. 用一份不敏感 PDF 測試讀取、摘要與頁面定位。
3. 若要引用 PDF 內容，要求 Codex 標明檔名與頁碼或可確認的位置。
4. 若要產出或修改 PDF，依 `pdf` skill 流程做渲染檢查。

## Playwright Skill 驗證流程

1. 確認已安裝 `{{CODEX_HOME}}/skills/playwright/SKILL.md`。
2. 確認本機有 `npx`，因為 `playwright` skill 的 wrapper script 需要它。
3. 用不敏感測試頁驗證瀏覽器操作，例如開啟 `https://example.com`、snapshot、screenshot。
4. Codex App 工作流只使用 Browser plugin 與 `playwright` skill，不另外設定外部瀏覽器 MCP server。

## 驗證全域 Skills

檢查：

```bash
find "{{CODEX_HOME}}/skills" -maxdepth 2 -name SKILL.md -print
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

新增或修改後，開新 Codex 對話或重啟 Codex App。

## 踩坑修正

- Plugin 顯示安裝完成，不代表授權成功；要實際查詢資料驗證。
- 新增或修改 skills 後，通常要重開 Codex 對話或重啟 Codex App。
- 工具不在目前可呼叫清單時，先用 tool search 或 Codex plugin 清單檢查，不要假設已載入。
- 瀏覽器自動化優先使用 Codex App 內建 Browser plugin；需要 terminal / CLI 型真實瀏覽器操作時，使用必裝的 `playwright` skill。
- 全域規則放 `{{CODEX_HOME}}/AGENTS.md`，專案規則放專案根目錄 `AGENTS.md`。
- 外部 / Anthropic skill 教學不能直接照搬；Codex 自訂 skills 放 `{{CODEX_HOME}}/skills`，不要放 來源工具的 skills 路徑。
- 不要覆蓋 `{{CODEX_HOME}}/skills/.system/skill-creator`；需要優化時建立 companion skill。
