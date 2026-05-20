---
updated: 2026-05-20
---

# 我的 AI 能幹清單

> 這份清單會跟著「外部工具整合計畫」更新。每次整合完一個工具，就把它能做的具體動作補進來。

## 已整合的工具

### GitHub（Codex connector + `gh` CLI）

- 檢查 repo 狀態、branch、commit 位置。
- 查看 GitHub Pages / repo 設定與部署線索。
- 協助整理 PR、issue、CI 狀態。
- 需要寫入、push、開 PR 時，先確認範圍再執行。

### Google Drive / Docs / Sheets / Slides（Codex connector）

- 搜尋與讀取 Drive 檔案。
- 協助整理 Google Docs、Sheets、Slides 內容。
- 建立或修改文件前會先確認目標檔案與寫入範圍。

### Gmail（Codex connector）

- 搜尋信件、整理 thread 摘要、萃取待辦。
- 草擬回覆或轉寄內容。
- 不會自動寄信；寄出、刪除、封存等動作需要使用者確認。

### Google Calendar（Codex connector）

- 查詢今天、明天或指定日期行程。
- 找空檔、整理會議準備摘要。
- 新增、改期、取消事件前需要使用者確認。

### Obsidian / Secondbrain（本機 Markdown + vault 規則）

- 讀取與整理 `secondbrain` vault 中的筆記。
- 協助維護專案駕駛艙、知識庫、每日筆記。
- 預設採取補缺與追加，不覆寫既有筆記結構。

### Browser / Playwright（Codex Browser plugin / Playwright MCP）

- 開啟本機網站進行互動測試。
- 截圖、檢查版面與前端行為。
- 對需要登入狀態的遠端頁面，改用合適的 Chrome / connector 工作流。

### Firecrawl（本地已跑通｜API key 僅本機保存）

- 抓取公開網頁內容，整理文章或研究資料。
- 需要使用時可做當次公開網頁驗證。
- API key 不放進 GitHub、repo 文件、AGENTS.md 或公開同步筆記。

## 待整合清單

參考 `100_Todo/integrations/2026-05-20-tool-integration-plan.md`。

目前明確待整合：無。

目前待確認是否需要：

- Notion
- Slack / Linear / Outlook

## 範本：每次整合完一個工具，加一段

### 工具名（實際路線｜整合日期：YYYY-MM-DD）

- 可以做的具體動作 1。
- 可以做的具體動作 2。
- 使用時的限制或安全規則。

試試看的指令：

- 「幫我用 [工具名] 查 ...」
- 「幫我把 [工具名] 裡的 ... 整理成摘要」
