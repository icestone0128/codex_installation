# 01-Codex 必裝 Skills 與 Plugins

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

本懶人包已實測可用的自訂 skill 類型：

- `project-init-sync`：新專案初始化。
- `startup-sync`：開工接續。
- `shutdown-sync`：收工同步。
- `arry-assistant` 或 `{{ASSISTANT_NAME}}-assistant`：個人助手資料層。
- `codex-skill-creator`：把 Claude / Anthropic skill 教學轉成 Codex 相容 skill。
- `secondbrain-research-digest`：整理 Secondbrain 研究資料、查詢、決策與筆記。

下載者可照 `10-Codex版SkillCreator工作流.md` 建立自己的版本，不需要沿用 `Arry` 命名。

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
- Claude / Anthropic skill 教學不能直接照搬；Codex 自訂 skills 放 `{{CODEX_HOME}}/skills`，不要放 `~/.claude/skills`。
- 不要覆蓋 `{{CODEX_HOME}}/skills/.system/skill-creator`；需要優化時建立 companion skill。
