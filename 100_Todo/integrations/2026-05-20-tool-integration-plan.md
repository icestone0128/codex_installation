---
created: 2026-05-20
status: in-progress
source: pro-kit 03 "外部工具整合包 by 雷小蒙"
adapted_for: Codex App
---

# 外部工具整合計畫（2026-05-20）

> 這份計畫是從 `/Users/arrywu/Downloads/03-tool-integration.md` 轉成 Codex App 可執行版本後產出的。
> 原文件是其他 AI 編輯器的設定腳本；本版改用 Codex App 與 AntiGravity、全域 skills、專案 `000_Agent/` 資料層與已安裝 connectors 的工作方式。

## 決策原則速查

在選每個工具的路線前，優先順序是：

1. CLI：例如 `gh`、官方 CLI；不用時不佔對話 context。
2. REST API + `.env`：適合需要精準控制、API 穩定的服務。
3. Codex connector / plugin：適合 Codex App 已內建且可授權的服務，例如 Gmail、Google Calendar、Google Drive、GitHub。
4. MCP：只在 CLI、API、Codex connector 都不適合時才加。
5. 瀏覽器控制：最後手段，適合沒有穩定 API 的網頁操作或前端驗證。

每個工具的「建議路線」只是目前初判；真正執行前要查官方文件或現有 Codex App 工具狀態，再確認是否仍是最佳做法。

## 工具清單

### [已知已整合] GitHub

- 用途：repo、issue、PR、GitHub Pages 與部署狀態確認。
- 建議路線：Codex GitHub connector + `gh` CLI。
- 目前狀態：既有環境曾驗證 `gh auth status` 可用；本計畫只記錄，不重設授權。
- 執行時要查的事情：
  - [ ] 目前 `gh auth status` 是否仍登入正確帳號。
  - [ ] Codex GitHub connector 是否仍可讀 repo / PR。
  - [ ] 是否需要針對特定 repo 增加操作流程 skill。
- 安裝 checklist：
  - [x] 使用既有 GitHub repo 與 Codex GitHub connector。
  - [ ] 重新驗證 `gh auth status`。
  - [ ] 跑一個實際驗證，例如列出目前 repo 狀態或 PR。
- 備註：此項屬於「既有整合待複驗」，不是今天新裝。

### [已知已整合] Google Drive / Docs / Sheets / Slides

- 用途：讀取、整理、建立、修改 Google Drive 檔案與 Docs/Sheets/Slides。
- 建議路線：Codex Google Drive connector。
- 目前狀態：Codex App 已提供 Google Drive 相關技能與 connector。
- 執行時要查的事情：
  - [ ] 目標檔案是否能透過 connector 讀取。
  - [ ] 寫入前是否需要使用者明確確認。
  - [ ] 對大型文件是否需要先匯出成本機檔案再處理。
- 安裝 checklist：
  - [x] 使用 Codex Google Drive connector。
  - [ ] 以一份非敏感文件做讀取驗證。
  - [ ] 必要時補一份 Google Drive 使用 SOP。
- 備註：已可用，但不同檔案仍受授權與分享設定影響。

### [已知已整合] Gmail

- 用途：搜尋信件、整理郵件脈絡、草擬回覆。
- 建議路線：Codex Gmail connector。
- 目前狀態：Codex App 已提供 Gmail 技能與 connector。
- 執行時要查的事情：
  - [ ] Gmail connector 是否仍可讀取 label / thread。
  - [ ] 是否需要建立「不自動寄信」固定規則。
  - [ ] 是否有常用查詢語法要寫入 Arry 助手資料層。
- 安裝 checklist：
  - [x] 使用 Codex Gmail connector。
  - [ ] 驗證讀取最近信件或特定搜尋。
  - [ ] 建立常用 Gmail 查詢與回覆草稿 SOP。
- 備註：發信、刪信、封存等動作需先讓使用者確認。

### [已知已整合] Google Calendar

- 用途：查行程、每日簡報、找空檔、會議準備。
- 建議路線：Codex Google Calendar connector。
- 目前狀態：Codex App 已提供 Google Calendar 技能與 connector。
- 執行時要查的事情：
  - [ ] Calendar connector 是否仍可讀取近期事件。
  - [ ] 是否需要固定的每日 brief 格式。
  - [ ] 是否要建立排程前確認規則。
- 安裝 checklist：
  - [x] 使用 Codex Google Calendar connector。
  - [ ] 驗證今天或明天行程讀取。
  - [ ] 建立每日 brief 或會議準備格式。
- 備註：新增、修改、取消事件都應先確認。

### [已知已整合] Obsidian / Secondbrain

- 用途：筆記、知識庫、專案駕駛艙、每日筆記、第二大腦整理。
- 建議路線：本機檔案讀寫 + 既有 Obsidian MCP / vault 規則。
- 目前狀態：主要 vault 固定為 `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain`。
- 執行時要查的事情：
  - [ ] 執行前先讀 vault 的 `AGENTS.md`。
  - [ ] 是否為補缺、追加，避免覆寫既有筆記結構。
  - [ ] 是否需要同步專案駕駛艙。
- 安裝 checklist：
  - [x] 使用既有本機 vault 與專案規則。
  - [ ] 驗證可讀取 `secondbrain/AGENTS.md`。
  - [ ] 如需寫入，先確認 Codex App 當次授權範圍。
- 備註：Obsidian 主要走本機 Markdown 檔，不優先新增額外 MCP。

### [已知已整合] Browser plugin

- 用途：本機網頁測試、前端截圖、互動驗證。
- 建議路線：Codex Browser plugin。
- 目前狀態：Codex App 使用 Browser plugin。
- 執行時要查的事情：
  - [ ] 目前 Browser plugin 是否可開本機 target。
  - [ ] 前端專案是否需要固定截圖驗證流程。
- 安裝 checklist：
  - [x] 使用 Codex Browser plugin 作為優先方案。
  - [ ] 對具體前端專案建立測試步驟。
- 備註：Browser plugin 是 Codex App 內建瀏覽器自動化能力，不是帳號型整合。

### [已知已整合] Firecrawl

- 用途：抓取網頁內容、整理文章、做研究資料擷取。
- 建議路線：沿用本地已成功跑通的 Firecrawl 設定；若日後重裝，再重新查官方文件。
- 目前狀態：使用者確認 Firecrawl 先前已在本地跑成功；API key 只保存在本機，未上傳 GitHub。
- 執行時要查的事情：
  - [x] Firecrawl 本地是否曾成功跑通。
  - [x] API key 不進 GitHub / repo。
  - [ ] 免費額度、資料保存、隱私限制是否符合用途。
- 安裝 checklist：
  - [x] 使用者已完成本地 Firecrawl 跑通。
  - [x] API key 不上傳 GitHub。
  - [x] 2026-05-20 用 `https://example.com` 做當次驗證，成功回傳 Markdown 與 HTTP 200。
  - [ ] 若本機設定失效，再查官方最新文件重設。
- 備註：API key 只留在本機安全位置；不要在 repo、AGENTS.md、skill 文件或 Obsidian 公開同步筆記內寫入 API key。

### [已知已整合] Notion

- 用途：如果仍在使用 Notion，可查資料庫、建立頁面或更新任務。
- 建議路線：Codex Notion plugin / connector。只有 plugin 不足以處理的特殊 API 工作，才另評估 REST API + 本機 `.env`。
- 目前狀態：2026-05-20 已安裝 Notion plugin，並以讀取目前連線使用者資訊做低風險驗證成功。
- 執行時要查的事情：
  - [x] 使用者是否仍使用 Notion。
  - [x] 是否已有 Codex Notion plugin / connector 可用。
  - [x] 以讀取目前連線使用者資訊完成驗證。
  - [ ] 若要寫入特定 database，先 fetch schema 並確認目標 database / page。
- 安裝 checklist：
  - [x] 確認需要後再執行。
  - [x] 安裝 Codex Notion plugin。
  - [x] 用目前連線使用者資訊做只讀驗證。
  - [ ] 未來若要建立或更新 Notion 頁面，先取得使用者明確確認。
- 備註：目前不需要手動建立 Notion token，也不要把 token、workspace ID、頁面權限細節寫入 repo 或公開筆記。

### [待確認] Slack / Linear / Outlook

- 用途：團隊通訊、專案管理或微軟信箱。
- 建議路線：優先 Codex connector；沒有再評估官方 API / MCP。
- 目前狀態：尚未確認使用者是否需要。
- 執行時要查的事情：
  - [ ] 使用者是否實際使用這些服務。
  - [ ] Codex App 是否已有對應 connector 可安裝。
  - [ ] 是否有 workspace / org 權限限制。
- 安裝 checklist：
  - [ ] 使用者確認要整合的工具。
  - [ ] 查官方文件與 Codex connector 狀態。
  - [ ] 只安裝被確認的項目。
  - [ ] 實測一個真實讀取或查詢動作。
- 備註：不要因為原文件列出就自動安裝。

## 進度總覽

- 已知已整合待複驗：8 個
- 待整合：0 個
- 待確認：1 組
- 今天新增工具安裝：1 個（Notion plugin）

下次執行建議：補 Firecrawl 的額度/隱私備註；不需要重新安裝，也不要把 API key 放進 GitHub。

---

## 給未來 AI 執行時的指引（不要刪這段）

當使用者打開這份文件說「幫我挑某個工具來裝」時，請按以下步驟：

### 1. 確認範圍

先確認要整合的工具名稱與主要用途。若工具標成「待確認」，先問使用者是否真的需要，不要直接安裝。

### 2. 查最新整合方式

這一步不要跳過，也不要只用舊記憶。請查官方文件、GitHub README、Codex App 現有 connector / plugin 狀態，並比較：

- 官方 CLI 是否存在且穩定。
- REST API 是否穩定，是否需要 API key / OAuth。
- Codex App 是否已有 connector 或 plugin。
- MCP 是否仍是必要選項。

整理成一段話讓使用者拍板後再執行。

### 3. 執行安裝

- CLI 路線：依官方推薦安裝，完成 auth，跑一個驗證指令。
- API 路線：引導使用者取得 API key；只存安全 `.env`，不要寫入 repo 或公開筆記；必要時新增 `000_Agent/skills/` 下的使用 SOP。
- Codex connector / plugin 路線：優先使用 Codex App 既有工具；安裝或授權前先確認。
- MCP 路線：以 Codex App 的 `~/.codex/config.toml` 或當前 MCP 設定方式為準；不要套用其他 AI 編輯器的設定檔。
- 瀏覽器控制：只在沒有更穩方案時使用。

### 4. 驗證

每完成一個整合，都要做一個實際驗證：

- Gmail：搜尋或讀取最近信件摘要。
- Calendar：讀取今天或指定日期行程。
- GitHub：讀取 repo / PR / issue。
- Firecrawl：抓取一個公開網頁並回傳摘要。
- Notion：讀取一個測試頁面或資料庫。

### 5. 更新計畫文件

完成後更新對應工具區塊：

- 標題狀態改為已整合。
- checklist 打勾。
- 備註寫入實際路線、版本、驗證方式與踩坑。
- 更新「進度總覽」。

### 6. 更新能力清單

把新能力補到 `000_Agent/knowledge/我的 AI 能幹清單.md`，用使用者看得懂的動作描述，不只寫工具名稱。
