---
created: 2026-05-20
last_reviewed: 2026-08-02
status: in-progress
source: pro-kit 03 "外部工具整合包 by 雷小蒙"
adapted_for: Codex + Claude + AntiGravity
---

# 外部工具整合計畫（2026-05-20 建立，2026-08-02 複審）

> 這份計畫源自 `/Users/arrywu/Downloads/03-tool-integration.md`；現行版已整理為 Codex、Claude、AntiGravity 共用工作流，Agent 特有步驟需另列 adapter 與驗證方式。
> 原文件是其他 AI 編輯器的設定腳本；本版改用三 Agent 共用契約、全域 skills、專案 `000_Agent/` 資料層與已安裝 connectors / MCP 的工作方式。

## 2026-08-02 複審說明（先讀這段）

本檔建立於 2026-05-20，當時的預設是「Codex connector 優先於 MCP」。此後全域主檔 `codex_symlink/core-rules.md` 新增了「Google 服務接取預設路由（MCP 優先於 Connectors）」，**Google 相關工具的路線已與本檔原本寫法相反**。本次複審把 Google 三項改為 MCP-first 並結案已完成的驗證，其餘工具維持原路線。

若本檔任何敘述與 `core-rules.md` 衝突，一律以 `core-rules.md` 為準。

## 決策原則速查

在選每個工具的路線前，優先順序是：

1. **Google 服務（Gmail／Drive／Calendar／Docs／Sheets／Slides／Tasks）一律先走本機 Google Workspace MCP**，不新增或改用 connector。這是 `core-rules.md` 的硬性路由，優先於下面的通則。
2. CLI：例如 `gh`、官方 CLI；不用時不佔對話 context。
3. REST API + 本機 secret：適合需要精準控制、API 穩定的服務；key 一律存 `~/.codex/secrets/`。
4. MCP：需要跨 Agent 一致權限邊界與稽核路徑時優先於 connector。
5. connector / plugin：適合各 Agent 已內建且可授權、又沒有 MCP 對應的服務。
6. 瀏覽器控制：最後手段，適合沒有穩定 API 的網頁操作或前端驗證。

同一服務同時存在 MCP 與 connector 時，工具呼叫一律選 MCP，並在當次回報實際使用哪條 route。既有 connector 不因此自動關閉。

每個工具的「建議路線」只是目前初判；真正執行前要查官方文件或當前 Agent 工具狀態，再確認是否仍是最佳做法。

Context 預算提醒：目前活躍 MCP server 已超過 `context-management-strategy.md` 建議的 10 個上限，Google 三項在 MCP 與 connector 之間有功能重疊。新增任何整合前先評估是否會再推高 context 成本。

## 工具清單

### [已整合｜2026-08-02 複驗通過] GitHub

- 用途：repo、issue、PR、GitHub Pages 與部署狀態確認。
- 建議路線：`gh` CLI 為主，各 Agent 的 GitHub connector 為輔。
- 目前狀態：2026-08-02 複驗 `gh auth status` 為登入 `icestone0128`，token scopes `gist`、`read:org`、`repo`，protocol https。
- 執行時要查的事情：
  - [x] 目前 `gh auth status` 是否仍登入正確帳號。（2026-08-02 通過）
  - [x] GitHub route 是否仍可實際操作 repo。（2026-08-02 以 `gh repo create` + push + `gh repo view` 驗證）
  - [ ] 是否需要針對特定 repo 增加操作流程 skill。（目前判斷不需要）
- 安裝 checklist：
  - [x] 使用既有 GitHub repo 與 `gh` CLI。
  - [x] 重新驗證 `gh auth status`。（2026-08-02）
  - [x] 跑一個實際驗證。（2026-08-02 建立 private repo `chezmoi-agent-sync` 並 push，`gh repo view` 回報 `PRIVATE`）
- 備註：`repo` scope 足以建立與推送 private repo。建立 repo、push、開 PR 等外部動作仍逐次向使用者確認。

### [已整合｜MCP-first] Google Workspace（Drive／Gmail／Calendar）

> 2026-08-02 複審：原本本檔把這三項拆成三個 connector 區塊，現已由單一本機 Google Workspace MCP 取代，故合併記錄。

- 用途：Drive 檔案讀寫、Gmail 搜尋與草稿、Calendar 行程查詢與事件管理。
- 建議路線：**本機 Google Workspace MCP**（`http://127.0.0.1:8000/mcp`，LaunchAgent `com.lazy-pack.google-workspace-mcp`）。不新增或改用 connector。
- 目前狀態：2026-08-02 以 `--permissions calendar:full drive:full gmail:full --tool-tier complete` 啟動，session 可見 38 支工具，含 `send_gmail_message`、`create_drive_file`、`manage_event`。OAuth 15 scopes，憑證存 `~/.codex/secrets/`，權限 600。只載入 calendar／drive／gmail，未含 Docs／Sheets／Slides。
- 執行時要查的事情：
  - [x] MCP 是否仍在 8000 埠並回報預期工具數。（2026-08-02 通過）
  - [x] 寫入前是否需要使用者明確確認。（已定案：寄信、刪除、覆蓋、變更共用權限一律逐次確認）
  - [x] 是否需要建立「不自動寄信」固定規則。（已寫入 `core-rules.md` 與 LazyPack Item 02）
  - [ ] 首次以真實資料執行寫入或寄信前，逐次取得使用者確認。（尚未做過真實寫入）
  - [ ] 是否要納入 Docs／Sheets／Slides；需要時改 MCP `--permissions` 並重跑 OAuth 同意。
- 安裝 checklist：
  - [x] 安裝並啟動本機 Google Workspace MCP。（LazyPack Item 02）
  - [x] 完成 OAuth 同意並確認 refresh token 存在、檔案權限 600。
  - [x] Calendar `list_calendars` 與 Drive 檔名搜尋唯讀 smoke test 通過。（2026-08-02）
  - [x] 建立 Google 接取預設路由規則並驗證三 Agent 入口都讀得到。
  - [ ] 大型 Drive 文件是否需要先匯出成本機檔案再處理。（尚未遇到）
- 備註：擴權為 full／complete 是使用者明確要求的結果，不是安裝預設；新環境仍從 core read-only 起步。既有 Google connectors 依使用者決定保留不關閉，但工具呼叫一律走 MCP。

### [已整合｜2026-08-02 複驗通過] Obsidian / Secondbrain

- 用途：筆記、知識庫、專案駕駛艙、每日筆記、第二大腦整理。
- 建議路線：本機檔案讀寫 + 既有 Obsidian MCP / vault 規則。
- 目前狀態：主要 vault 固定為 `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain`。
- 執行時要查的事情：
  - [x] 執行前先讀 vault 的 `AGENTS.md`。（已是固定開工流程）
  - [x] 是否為補缺、追加，避免覆寫既有筆記結構。（已定案：只補缺不覆寫）
  - [x] 是否需要同步專案駕駛艙。（已是固定收工流程）
- 安裝 checklist：
  - [x] 使用既有本機 vault 與專案規則。
  - [x] 驗證可讀取 vault 內容。（2026-08-02 讀取專案駕駛艙並完成懶人包與 Arry 助手鏡像 `diff -qr`）
  - [x] 如需寫入，先確認當次 Agent 授權範圍。（已納入本機檔案權限判讀規則）
- 備註：Obsidian 主要走本機 Markdown 檔，不優先新增額外 MCP。

### [已整合] 瀏覽器自動化

- 用途：本機網頁測試、前端截圖、互動驗證。
- 建議路線：各 Agent 原生瀏覽器能力。Claude 有 in-app Browser 與 Claude in Chrome 兩種 surface；Codex 用 Browser plugin；AntiGravity 用其對應 adapter。
- 目前狀態：可用，未在本次複審實測。
- 執行時要查的事情：
  - [ ] 目前瀏覽器 surface 是否可開本機 target。
  - [ ] 前端專案是否需要固定截圖驗證流程。
- 安裝 checklist：
  - [x] 使用各 Agent 原生瀏覽器能力作為優先方案。
  - [ ] 對具體前端專案建立測試步驟。（尚無前端專案需求）
- 備註：屬 Agent 內建能力，不是帳號型整合。需要既有登入 session 時才用 Claude in Chrome，其餘用 in-app browser。

### [已整合] Firecrawl

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

### [已整合] Notion

- 用途：如果仍在使用 Notion，可查資料庫、建立頁面或更新任務。
- 建議路線：各 Agent 的 Notion connector / plugin。只有 connector 不足以處理的特殊 API 工作，才另評估 REST API + 本機 secret。
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
- 建議路線：先評估 MCP，其次 connector，再其次官方 API。
- 目前狀態：尚未確認使用者是否需要；2026-08-02 複審時仍無需求。
- 執行時要查的事情：
  - [ ] 使用者是否實際使用這些服務。
  - [ ] 是否已有對應 MCP 或 connector 可安裝。
  - [ ] 是否有 workspace / org 權限限制。
- 安裝 checklist：
  - [ ] 使用者確認要整合的工具。
  - [ ] 查官方文件與當前 MCP / connector 狀態。
  - [ ] 只安裝被確認的項目。
  - [ ] 實測一個真實讀取或查詢動作。
- 備註：不要因為原文件列出就自動安裝。目前 MCP server 數量已超過建議上限，新增前要先評估 context 成本。

## 進度總覽（2026-08-02 複審）

- 已整合並複驗通過：GitHub、Google Workspace MCP、Obsidian／Secondbrain
- 已整合未在本次複審實測：瀏覽器自動化、Firecrawl、Notion
- 待確認：1 組（Slack／Linear／Outlook），目前無需求
- 本次複審變更：Google 三個 connector 區塊合併為單一 MCP-first 區塊；決策原則改為 MCP 優先於 connector

剩餘未勾選項目都是「有需求時才做」，不是積壓的待辦：

- Google Workspace 首次真實寫入／寄信前的逐次確認（尚未有真實寫入需求）
- 是否納入 Docs／Sheets／Slides（需要時才擴權並重跑 OAuth）
- 前端專案的截圖驗證步驟（目前無前端專案）
- Firecrawl 額度／隱私限制確認、設定失效時的重設
- Notion 寫入前的 schema 確認
- GitHub 專屬操作流程 skill（目前判斷不需要）

下次執行建議：本檔已無積壓工作。除非新增工具或既有路線失效，否則不需要再開啟；下次複審時先核對 `core-rules.md` 是否又有路由變更。

---

## 給未來 AI 執行時的指引（不要刪這段）

當使用者打開這份文件說「幫我挑某個工具來裝」時，請按以下步驟：

### 1. 確認範圍

先確認要整合的工具名稱與主要用途。若工具標成「待確認」，先問使用者是否真的需要，不要直接安裝。

### 2. 查最新整合方式

這一步不要跳過，也不要只用舊記憶。**先確認 `core-rules.md` 是否已對該服務指定固定路由**（例如 Google 服務一律走本機 MCP）；有指定就直接照做，不要重新比較。沒有指定時，再查官方文件、GitHub README 與當前 Agent 的 connector / MCP 狀態，並比較：

- 官方 CLI 是否存在且穩定。
- REST API 是否穩定，是否需要 API key / OAuth。
- 是否已有 MCP 可用（跨 Agent 權限邊界一致者優先）。
- 各 Agent 是否已有 connector 或 plugin。

整理成一段話讓使用者拍板後再執行。新增 MCP 前先確認不會把活躍 server 數推得更高。

### 3. 執行安裝

- CLI 路線：依官方推薦安裝，完成 auth，跑一個驗證指令。
- API 路線：引導使用者取得 API key；只存 `~/.codex/secrets/`（權限 700／600），不要寫入 repo 或公開筆記；必要時新增 `000_Agent/skills/` 下的使用 SOP。
- MCP 路線：以本機服務與各 Agent 的 MCP 註冊方式為準，並在同一份文件記錄 Codex／Claude／AntiGravity 三個 adapter；不要套用其他 AI 編輯器的設定檔。
- connector / plugin 路線：安裝或授權前先確認；已有 MCP 對應時不新增 connector。
- 瀏覽器控制：只在沒有更穩方案時使用。

### 4. 驗證

每完成一個整合，都要做一個實際驗證，**優先選唯讀動作**：

- Gmail：搜尋或讀取最近信件摘要（不寄信）。
- Calendar：讀取今天或指定日期行程（不建立事件）。
- Drive：檔名搜尋或讀取一份非敏感檔案（不寫入）。
- GitHub：讀取 repo / PR / issue。
- Firecrawl：抓取一個公開網頁並回傳摘要。
- Notion：讀取一個測試頁面或資料庫。

寄信、刪除、覆蓋、變更共用權限等不可逆動作不列入例行驗證；需要時逐次向使用者確認。

### 5. 更新計畫文件

完成後更新對應工具區塊：

- 標題狀態改為已整合。
- checklist 打勾。
- 備註寫入實際路線、版本、驗證方式與踩坑。
- 更新「進度總覽」。

### 6. 更新能力清單

跨專案可重用能力同步到 `codex_symlink/knowledge/` 的對應清單。不要在 public repo 內建立 `000_Agent/knowledge/`。

> 2026-08-02 更正：本節原本指向 `200_Reference/tool-capabilities.md`，該檔從未建立。跨專案能力清單的正確位置就是 `codex_symlink/knowledge/`，不需要在本 repo 另建一份。

### 7. 若路由與全域規則衝突

`core-rules.md` 是路由的唯一權威。發現本檔與它衝突時，先更新本檔並在複審說明段落記錄變更，不要在執行時自行折衷。
