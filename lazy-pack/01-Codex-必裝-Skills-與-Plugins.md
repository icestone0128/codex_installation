# 01-Codex-必裝-Skills-與-Plugins

## 目標

確認 Codex 基礎工作能力：GitHub、Gmail、Google Calendar、Google Drive、文件、試算表、簡報、瀏覽器、技能建立與技能安裝。

## 前置條件

- 已安裝 Codex App。
- 已登入 OpenAI / Codex 使用帳號。
- 若要使用 Google 類工具，準備自己的 Google 帳號。
- 若要使用 GitHub，準備自己的 GitHub 帳號。

## 建議啟用的 Plugins / Connectors

依需求啟用，不需要一次全部打開：

- GitHub：repo、PR、issue、CI。
- Gmail：信件搜尋、摘要、草稿。
- Google Calendar：行程、會議準備、空檔查詢。
- Google Drive：Drive、Docs、Sheets、Slides。
- Notion：workspace 搜尋、頁面讀取、database 讀取與明確確認後的頁面建立/更新。
- Browser：本機或遠端網頁測試。
- Documents：Word / docx 文件處理。
- Spreadsheets：xlsx / csv / Sheets 類任務。
- Presentations：PowerPoint / Slides 類任務。

## 建議確認的內建 Skills

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

本懶人包附的自訂 skill 已放在 `lazy-pack/skills/`。先安裝基礎工作流：

```bash
mkdir -p "{{CODEX_HOME}}/skills"

for skill in codex-skill-creator project-init-sync startup-sync shutdown-sync tool-integration-workflow brainstorm; do
  rsync -a --delete "{{SETUP_REPO}}/lazy-pack/skills/$skill/" "{{CODEX_HOME}}/skills/$skill/"
done

find "{{CODEX_HOME}}/skills" -maxdepth 2 -name SKILL.md -print
```

再依需求安裝個人與內容製作類 skill：

| Skill | 用途 | 安裝時機 |
| --- | --- | --- |
| `arry-assistant` 或自訂助手名稱 | 個人助手資料層 | 完成 `09-個人助手設定` 後 |
| `secondbrain-research-digest` | Obsidian 研究整理 | 完成 `05-第二大腦設定指南` 後 |
| `cross-device-sync` | 全域 skills 跨裝置同步 | 完成主線後，需要同步多台裝置時 |
| `social-cards` | 圖卡輸出 | 需要社群圖卡時，並安裝 Node 依賴 |
| `doc-to-md` | PDF / EPUB / TXT 轉 Markdown | 需要文件轉換時，並安裝 Python 依賴 |
| `notebooklm-architecture`、`presentation-workflow`、`visual-note-generator` | NotebookLM / 簡報 / 視覺筆記 | 需要教學內容製作時 |
| `heptabase-cli` | Heptabase CLI 工作流 | 已安裝並啟動 Heptabase CLI 後 |
| `rightproblem-coach` | 問題結構化 | 需要問題規格書或教練流程時 |

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
- 全域規則放 `{{CODEX_HOME}}/AGENTS.md`，專案規則放專案根目錄 `AGENTS.md`。
- 外部 / Anthropic skill 教學不能直接照搬；Codex 自訂 skills 放 `{{CODEX_HOME}}/skills`，不要放 來源工具的 skills 路徑。
- 不要覆蓋 `{{CODEX_HOME}}/skills/.system/skill-creator`；需要優化時建立 companion skill。
