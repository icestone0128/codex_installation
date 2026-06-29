# codex_installation — AGENTS.md

## 專案入口

專案名稱：codex_installation
專案用途：Codex 安裝、連線、工作模式與專案初始化設定。
主要工作目錄：`/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation`
GitHub repo：`icestone0128/codex_installation`（Public）
預設 branch：main

## Obsidian 對應筆記

Obsidian vault：`/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain`
專案駕駛艙：`專案庫/codex_installation/專案工作流程.md`
收工時優先更新：同上

> 注意：專案駕駛艙是 Obsidian vault 裡的一篇筆記，不是工作資料夾裡的 Markdown 檔。

## 工作桌 + 三個家

- 工作桌：`/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation`
- GitHub：`icestone0128/codex_installation`（Public）
- Obsidian：主要 vault + `專案庫/codex_installation/專案工作流程.md`
- Firebase：`codex-4e80b`

## 同步規則

開工時：

- 使用 `startup-sync` 流程。
- 讀本檔。
- 讀 Obsidian 駕駛艙。
- 檢查 Git 狀態。
- 不自動 pull、commit、push。

收工時：

- 使用 `shutdown-sync` 流程。
- 更新 Obsidian 駕駛艙。
- 如規則、路徑、專案邊界改變才更新本檔。
- 若本次有新增、修改、刪除或重新編號 LazyPack 內容，必須確認 `200_Reference/lazy-pack/` 已同步到 Obsidian `專案庫/codex_installation/懶人包/`，並把 repo 內 LazyPack 變更納入本專案 GitHub commit/push 範圍。
- 需要時才 commit + push GitHub。

全域 Skill 同步：

- 全域 skills 預設位置：`/Users/arrywu/.codex/skills`
- 目前 `/Users/arrywu/.codex/skills` 是 symlink，實體位置在 `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/skills`
- Skill 路徑採白名單：全域只使用 `/Users/arrywu/.codex/skills`，專案本地只使用 `<project-root>/000_Agent/skills`；不建立或使用其他工具的 skill 路徑。
- 建立、擷取、轉換、更新、改名或驗證自訂 skill 時，一律先使用 `/Users/arrywu/.codex/skills/codex-skill-creator`；內建 `skill-creator` 只作為唯讀輔助參考。
- Obsidian 同步索引：`專案庫/codex_installation/全域 Skills/全域 Skills 同步.md`
- 新增、修改、刪除任何全域 skill 後，一律同步更新上述 Obsidian 筆記。
- 全域 skill 的主版本是 symlink 實體目錄 `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/skills`；LazyPack 不是主版本，而是 repo 內可公開 push、可讓使用者下載安裝的自含式可攜化版本。
- 新增、修改、刪除 symlink 實體目錄內任何全域 skill 後，也要同步更新 repo `200_Reference/lazy-pack/` 對應序號文件中的「內建 Skill 完整安裝內容」，讓 LazyPack 自含式安裝內容覆蓋所有應公開安裝的全域 skills、必要 references/scripts/assets 與安裝說明。
- LazyPack 允許和全域 skills 目錄結構不同：可用一份序號文件包多個 skills，也可包含 MCP、plugin、Obsidian、GitHub、Firebase、NotebookLM 等非 skill 安裝項目；但 README 的安裝總表必須清楚標出哪些是完整內嵌安裝、哪些只是外部依賴或必裝檢查。
- 同步後要實際比對 `/Users/arrywu/.codex/skills`、`200_Reference/lazy-pack/` 對應序號文件內嵌的 skill 名稱、LazyPack README 安裝總表與 Obsidian `全域 Skills 同步.md`；不可只更新其中一處。
- 若全域 skill 變更影響固定工作規則、路徑或專案邊界，也要同步更新本檔。

Arry 助手 AI 分身資料層：

- AI 分身名稱：Arry 助手。
- Arry 助手全域資料層放在 Google Drive `codex_symlink`，不放在 public repo：
  - `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/core-rules.md`
  - `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/skills`
  - `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/memories`
  - `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/workflows`
  - `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/knowledge`
- 本 repo 的 `000_Agent/` 只保留指向說明，不存放真實個人記憶或偏好。
- Codex 全域規則唯一實體主版本為 `codex_symlink/core-rules.md`；`/Users/arrywu/.codex/AGENTS.md` 只是指向它的 symlink，不再使用或重建 `codex_symlink/agents/AGENTS.md`。
- Arry 助手是 Codex App 與 AntiGravity 設定，不使用其他 AI 編輯器專用的規則檔（例如舊版 `CLAUDE.md` 等）或其專屬路徑。
- 可被所有專案呼叫的部分放在全域 skill：`/Users/arrywu/.codex/skills/arry-assistant/SKILL.md`。
- Arry 助手本身是全域入口 skill；每次專案初始化都要帶入，用來讀取個人助手資料層並協助判斷新 skill 歸屬。
- 任何自訂 skill 的建立與維護都必須由全域 `codex-skill-creator` 工作流處理。
- 只有全域 Codex skills 才使用 `/Users/arrywu/.codex/skills`，此路徑目前指向 Google Drive `codex_symlink/skills`。
- Arry 助手跨專案記憶與個人偏好放在 `codex_symlink/memories/MEMORY.md`。
- Arry 助手跨專案 workflow 草稿放在 `codex_symlink/workflows/`。
- 任何 skill 不論全域或專案本地，都要做成可攜式版本：全域 skill 以 `codex_symlink/skills` 為主版本，並將可公開安裝內容內嵌到 repo `200_Reference/lazy-pack/` 對應序號文件、同步 Obsidian 全域 Skills 索引與 Obsidian 懶人包鏡像；專案 skill 保留完整 package 在該專案 `000_Agent/skills/` 並記錄到專案駕駛艙。
- 若來源文件含 AI 分身預設名稱，不使用來源預設名，改用「Arry 助手」。
- 若 Arry 助手資料層與新專案初始化規則衝突，先詢問使用者再決定。
- `project-init-sync`、`startup-sync`、`shutdown-sync` 已整合 Arry 助手雙層資料層：未來新專案預設建立本地 `100_Todo/`、`200_Reference/`；若該專案需要本地 assistant skill 或本地記憶，再建立該專案自己的 `000_Agent/skills/`、`000_Agent/memories/`，並引用 `codex_symlink` 全域 Arry 助手資料層。現有專案開工/收工時可同步跨專案記憶。

新專案初始化時：

- 使用 `project-init-sync` 流程。
- 以 `200_Reference/lazy-pack/10-專案初始化工作模式.md` 為本專案內的固定參考檔；全域規則已同步到 `/Users/arrywu/.codex/AGENTS.md`。

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

- **設定檔範本**：`200_Reference/templates/codex-config.template.toml` 作為安全設定檔範本，使用佔位符遮蔽金鑰，不直接同步真實的 `~/.codex/config.toml`。
- **安全邊界**：
  - 不提交 `.env`、API 金鑰、Token、密碼或 Admin 憑證。
  - 不在 Repo 或 Obsidian 中寫入學員真實姓名或敏感個資。
  - 日常進度與詳細待辦記錄於 Obsidian 駕駛艙中，不要寫入 `AGENTS.md`。
