# 01-Codex 必裝 Skills 與 Plugins

## 目標

確認 Codex 基礎工作能力：GitHub、Gmail、Google Calendar、文件、試算表、簡報、瀏覽器、技能建立與技能安裝。

## 已確認可用的插件與技能

- GitHub
- Gmail
- Google Calendar
- Browser
- Documents
- Spreadsheets
- Presentations
- `skill-creator`
- `skill-installer`
- `plugin-creator`
- `openai-docs`
- `imagegen`

## Gmail 實測流程

1. 安裝或啟用 Gmail plugin。
2. 連接 Google 帳號。
3. 用 Gmail connector 查詢 labels 或 mailbox profile。
4. 若安裝流程看似完成但工具不能用，重新確認連接狀態。

實測帳號：`icestone0128@gmail.com`

## Google Calendar 實測流程

1. 啟用 Google Calendar plugin。
2. 連接同一個 Google 帳號。
3. 用 calendar 工具查詢行事曆或事件。

## 全域 Skills 實測補齊

已建立三個全域流程：

- `/Users/arrywu/.codex/skills/project-init-sync/SKILL.md`
- `/Users/arrywu/.codex/skills/startup-sync/SKILL.md`
- `/Users/arrywu/.codex/skills/shutdown-sync/SKILL.md`

## 踩坑修正

- Gmail connector 可能顯示安裝完成，但授權沒有真正連上；要實際查 labels 或信件確認。
- 新增或修改 skills 後，通常要重開 Codex 對話或重啟 Codex App。
- 工具不在目前可呼叫清單時，先用 tool search 找，不要假設已載入。
- 全域規則放 `/Users/arrywu/.codex/AGENTS.md`，專案規則放專案根目錄 `AGENTS.md`。

