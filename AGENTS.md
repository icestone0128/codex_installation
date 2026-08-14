# codex_installation — AGENTS.md

## 專案入口

專案名稱：codex_installation
專案用途：Codex 安裝、連線、工作模式與專案初始化設定。
主要工作目錄：`{{SETUP_REPO}}`
GitHub repo：`icestone0128/codex_installation`（Public）
預設 branch：main

## Obsidian 對應筆記

Obsidian vault：`{{OBSIDIAN_VAULT}}`
專案駕駛艙：`專案庫/codex_installation/專案工作流程.md`
收工時優先更新：同上

> 注意：專案駕駛艙是 Obsidian vault 裡的一篇筆記，不是工作資料夾裡的 Markdown 檔。

## 工作桌 + 三個家

- 工作桌：`{{SETUP_REPO}}`
- GitHub：`icestone0128/codex_installation`（Public）
- Obsidian：主要 vault + `專案庫/codex_installation/專案工作流程.md`
- Firebase：`codex-4e80b`

## 同步規則

開工時：

- 使用 `startup-sync` 流程。
- 讀本檔。
- 讀取根目錄 `HANDOFF.md` 並與 live state 核對；缺少時由本次收工補建。
- 執行共享 chezmoi startup checkpoint；符合 commit＋remote＋clean 三項安全閘門時才自動 update，否則安全 no-op。
- 讀 Obsidian 駕駛艙。
- 檢查 Git 狀態。
- 不自動 pull、commit、push。

收工時：

- 使用 `shutdown-sync` 流程。
- 一律建立或更新根目錄 `HANDOFF.md`，只保留 Current state、Next action、Blockers、Last verified。
- 執行共享 chezmoi shutdown checkpoint；既有 `.syncRoot` templates 不執行 `chezmoi add`。
- 更新 Obsidian 駕駛艙。
- 如規則、路徑、專案邊界改變才更新本檔。
- 若本次有新增、修改、刪除或重新編號 LazyPack 內容，必須確認 `200_Reference/lazy-pack/` 已同步到 Obsidian `專案庫/codex_installation/懶人包/`，並把 repo 內 LazyPack 變更納入本專案 GitHub commit/push 範圍。
- 需要時才 commit + push GitHub。

全域 Skill 同步：

- 全域 skills 唯一實體主版本：`{{SYNC_ROOT}}/skills`。
- Codex `{{CODEX_HOME}}/skills`、Claude `{{CLAUDE_HOME}}/skills` 與 AntiGravity `{{GEMINI_CONFIG}}/skills` 是 chezmoi 管理的原生入口，都指向 `{{SYNC_ROOT}}/skills`。
- Skill 路徑採白名單：共用主版本只使用 `{{SYNC_ROOT}}/skills`，三個 Agent 只使用上述原生入口，專案本地只使用 `<project-root>/000_Agent/skills`。
- 建立、擷取、轉換、更新、改名或驗證自訂 skill 時，一律先使用 `{{SYNC_ROOT}}/skills/codex-skill-creator`；名稱保留是為了現有觸發相容，輸出 package 必須同時相容 Codex、Claude 與 AntiGravity。
- Obsidian 同步索引：`專案庫/codex_installation/全域 Skills/全域 Skills 同步.md`
- 新增、修改、刪除任何全域 skill 後，一律同步更新上述 Obsidian 筆記。
- 全域 skill 的主版本是 symlink 實體目錄 `{{SYNC_ROOT}}/skills`；LazyPack 不是主版本，而是 repo 內可公開 push、可讓使用者下載安裝的自含式可攜化版本。
- 新增、修改、刪除 symlink 實體目錄內任何全域 skill 後，也要同步更新 repo `200_Reference/lazy-pack/` 對應序號文件中的「內建 Skill 完整安裝內容」，讓 LazyPack 自含式安裝內容覆蓋所有應公開安裝的全域 skills、必要 references/scripts/assets 與安裝說明。
- LazyPack 允許和全域 skills 目錄結構不同：可用一份序號文件包多個 skills，也可包含 MCP、plugin、Obsidian、GitHub、Firebase、NotebookLM 等非 skill 安裝項目；但 README 的安裝總表必須清楚標出哪些是完整內嵌安裝、哪些只是外部依賴或必裝檢查。
- 個人專用或含個人記憶/身份設定的全域 skill 不放入公開 LazyPack；目前 `future-coach` 是 Arry 個人專用 skill，不公開安裝，也不算 LazyPack 缺口。
- 同步後要實際比對 `{{SYNC_ROOT}}/skills`、Codex／Claude／AntiGravity 三個原生入口、`200_Reference/lazy-pack/` 對應序號文件內嵌的 skill 名稱、LazyPack README 安裝總表與 Obsidian `全域 Skills 同步.md`；不可只更新其中一處。
- 若全域 skill 變更影響固定工作規則、路徑或專案邊界，也要同步更新本檔。

Arry 助手 AI 分身資料層：

- AI 分身名稱：Arry 助手。
- Arry 助手 Obsidian 同步主版本只限 Google Drive `codex_symlink` 內的 `knowledge/` 與 `memories/` 根目錄第一層檔案，不放在 public repo：
  - `{{SYNC_ROOT}}/knowledge`
  - `{{SYNC_ROOT}}/memories`
- Arry 助手同步採用和 LazyPack 相同的「主版本 + Obsidian 實體鏡像 + 實際 diff 驗證」模型：
  - 主版本：上述 `knowledge/` 排除頂層 `visual-note-references/` 與 `.DS_Store` 後的內容，以及 `memories/` 根目錄第一層檔案；不是整個 `codex_symlink`。圖解作品只保留全域 Knowledge 與 Obsidian 創作庫兩處。
  - Obsidian 實體鏡像：`{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/Arry 助手`
  - 收工同步義務由本檔與全域 `core-rules.md` 記憶。
  - 固定執行 `codex_symlink/skills/arry-assistant/scripts/sync_obsidian_mirror.py`；同步後由腳本以暫存的過濾來源執行 `diff -qr`，`memories/` 只比對第一層檔案清單與內容。
  - 不使用 Obsidian symlink 當同步替代品；同步完成後 Obsidian `Arry 助手/` 必須是只包含經過濾的 `knowledge/` 與只含第一層檔案的 `memories/` 的實體鏡像資料夾，且與主版本一致。
- 本 repo 的 `000_Agent/` 只保留指向說明，不存放真實個人記憶或偏好。
- 跨 Agent 全域規則唯一實體主版本為 `codex_symlink/core-rules.md`；Codex、Claude 與 AntiGravity 的原生規則入口都由 Item 16 的 chezmoi bootstrap 指向它，不再使用或重建 `codex_symlink/agents/AGENTS.md`。
- 跨 Agent skills 唯一實體主版本為 `codex_symlink/skills`；Codex 使用 `~/.codex/skills`、Claude 使用 `~/.claude/skills`、AntiGravity 使用 `~/.gemini/config/skills`。舊 AntiGravity `config/AGENTS.md` 與 `config/plugins/codex/skills` 只保留相容入口。
- chezmoi 是新電腦安裝、入口重建與修復的必要工具；既有 Google Drive symlink 仍負責即時共用內容。chezmoi 另外管理三 Agent 共用 Python 工具的中立 bridge、env loader 與 shell profile 標記區塊，但不同步 runtime／venv、secrets、sessions、cache、OAuth/MCP 認證或 repo Git 歷史，也不自動 commit/push source。
- 三 Agent 共用 Python 工具的實體 runtime 預設在 `{{CODEX_HOME}}/python-tools`，中立入口在 `{{HOME}}/.local/share/agent-tools/python-tools`，loader 在 `{{HOME}}/.config/agent-tools/python-tools.env`；新電腦由 Item 34 重建 runtime、Item 16 重建入口，不替三個 Agent 複製三份 venv。
- 每次開工／收工由 `cross-device-sync/scripts/session-sync-checkpoint.sh` 自動執行 bootstrap dry-run 與 `chezmoi status`；開工只在 source 已有 commit、remote 且乾淨時自動 update。`chezmoi add` 不用於既有受管理 templates，只在新增白名單入口時使用受控 #16 流程。
- 可被所有專案與三個 Agent 呼叫的部分放在全域 skill 主版本：`{{SYNC_ROOT}}/skills/arry-assistant/SKILL.md`。
- Arry 助手本身是全域入口 skill；每次專案初始化都要帶入，用來讀取個人助手資料層並協助判斷新 skill 歸屬。
- 任何自訂 skill 的建立與維護都必須由全域 `codex-skill-creator` 工作流處理。
- 全域 skills 的唯一主版本是 `codex_symlink/skills`；各 Agent home 只保留 chezmoi 管理的原生入口 symlink。
- Arry 助手跨專案記憶與個人偏好放在 `codex_symlink/memories/MEMORY.md`。
- Arry 助手跨專案 workflow 草稿放在 `codex_symlink/workflows/`。
- Arry 助手跨策略總入口放在 `codex_symlink/knowledge/agent-execution-strategy.md`；需要實際執行、修改或同步時，先判斷任務階段，再按需載入詳細 Knowledge，不一次載入全部策略。
- 任何 skill 不論全域或專案本地，都要做成可攜式版本：全域 skill 以 `codex_symlink/skills` 為主版本，並將可公開安裝內容內嵌到 repo `200_Reference/lazy-pack/` 對應序號文件、同步 Obsidian 全域 Skills 索引與 Obsidian 懶人包鏡像；專案 skill 保留完整 package 在該專案 `000_Agent/skills/` 並記錄到專案駕駛艙。
- 若來源文件含 AI 分身預設名稱，不使用來源預設名，改用「Arry 助手」。
- 若 Arry 助手資料層與新專案初始化規則衝突，先詢問使用者再決定。
- `project-init-sync`、`startup-sync`、`shutdown-sync` 已整合 Arry 助手雙層資料層：未來新專案預設建立本地 `100_Todo/`、`200_Reference/`；若該專案需要本地 assistant skill 或本地記憶，再建立該專案自己的 `000_Agent/skills/`、`000_Agent/memories/`，並引用 `codex_symlink` 全域 Arry 助手資料層。現有專案開工/收工時可同步跨專案記憶。
- 專案 `AGENTS.md` 是跨 Agent 規則主版本；一律建立只含 `@AGENTS.md` 的薄 `CLAUDE.md`。一律使用 `HANDOFF.md` 記錄 current state、next action、blockers 與 last verified；開工先讀、收工更新，不放 secrets 或耐久記憶。

三 Agent 執行契約：

- Arry 的專案固定同時支援 Codex、Claude 與 AntiGravity，共用同一份 `AGENTS.md`、`HANDOFF.md`、專案腳本、輸入輸出契約與驗證標準。
- 凡是 connector、plugin、MCP、內建生圖、sandbox、UI 操作或模型路由不同，必須在同一份 skill／腳本／文件中記錄「共用步驟／Codex adapter／Claude adapter／AntiGravity adapter／驗證」。
- 若某 Agent 沒有對等原生能力，改走共用腳本／CLI、該 Agent 的 MCP／plugin、經授權 API 或瀏覽器／人工步驟；不得將其中任一 Agent 標記為不支援。
- 分流腳本優先提供 `--agent auto|codex|claude|antigravity`（或等價參數），但三條路徑必須交付同一結果契約。

新專案初始化時：

- 使用 `project-init-sync` 流程。
- 以 `200_Reference/lazy-pack/10-專案初始化工作模式.md` 為本專案內的固定參考檔；全域規則已由 chezmoi 同步到 Codex `{{CODEX_HOME}}/AGENTS.md`、Claude `{{CLAUDE_HOME}}/CLAUDE.md` 與 AntiGravity `{{GEMINI_HOME}}/GEMINI.md`。

## 主要檔案

入口檔：`200_Reference/past-work/docs/index.html`
設定檔：`.firebaserc`、`firebase.json`、`firestore.rules`
部署位置：未啟用。GitHub Pages 已關閉；`200_Reference/past-work/docs/index.html` 只保留為本地過往入口檔。
部署網址：未啟用

## 初始化架構狀態

- `AGENTS.md`、`README.md`、`.gitignore` 已存在。
- Git repo 已存在，remote 為 `origin https://github.com/icestone0128/codex_installation.git`。
- GitHub repo 為 Public；GitHub Pages 目前未啟用。
- Firebase 使用既有 project `codex-4e80b`；本 repo 目前只有 Firestore rules，沒有 Hosting 設定。
- Obsidian 駕駛艙位於 `專案庫/codex_installation/專案工作流程.md`。
- Arry 助手全域資料層已移至 `codex_symlink/`；本專案 `000_Agent/` 只保留指向說明。
- 既有專案重新初始化時，只依架構補缺與更新狀態，不覆蓋既有設定或 Git 歷史。

## 不要做

- 不要把每日進度寫進 AGENTS.md。
- 不要自動納入無關 git 變更。
- 不要把 API key、token、密碼寫進 repo。
- 不要把不必要的個資或敏感資料寫進 repo。

## 專案結構與安全說明

### 專案目錄結構

- `AGENTS.md` - 固定專案規則與工作流邊界。
- `.gitignore` - 排除本機設定、憑證、相依套件與建置輸出。
- `200_Reference/lazy-pack/` - 經驗證的 Codex 安裝說明、除錯紀錄與內嵌全域技能安裝檔；這是必須跟著本 repo commit/push 到 GitHub 的公開 LazyPack 發布資料夾。
- `200_Reference/past-work/docs/` - 過往本地文件入口備份，目前不部署。
- `200_Reference/scripts/sync-health.sh` - 唯讀的跨裝置同步健康檢查腳本。
- `000_Agent/` - 僅保留指向說明，不存放真實個人記憶或偏好。
- `100_Todo/` - 專案本地待辦、草稿與工作中素材。
- `200_Reference/` - 專案本地參考資料、範本與過往作品。

### 可攜化與安全指南

- **設定檔範本**：`200_Reference/templates/codex-config.template.toml` 作為安全設定檔範本，使用佔位符遮蔽金鑰，不直接同步真實的 `{{CODEX_HOME}}/config.toml`。
- **安全邊界**：
  - 不提交 `.env`、API 金鑰、Token、密碼或 Admin 憑證。
  - 不在 Repo 或 Obsidian 中寫入學員真實姓名或敏感個資。
  - 日常進度與詳細待辦記錄於 Obsidian 駕駛艙中，不要寫入 `AGENTS.md`。
