# codex_installation

本專案為 Codex App 與 AntiGravity 共用工作底座的安裝、設定與可攜化資料夾，包含全域規則、Lazy Pack、全域 Skill 同步、Obsidian 鏡像與新專案初始化工作模式。

## 目錄

- `AGENTS.md`：本專案固定規則、同步邊界與安全規範。
- `000_Agent/`：只保留 Arry 助手全域資料層指向說明；不存放真實個人記憶、skills 或私有知識。
- `100_Todo/`：進行中草稿、工作計畫與封存。
- `200_Reference/`：參考資料、模板、腳本、Lazy Pack 與過去成果。
- `200_Reference/lazy-pack/`：Codex 懶人包存放目錄，包含全域 skill 的可攜式安裝內容。
- `200_Reference/scripts/`：專案腳本與同步健康檢查。
- `200_Reference/templates/`：安全設定範本、SOP 與可重用模板。
- `200_Reference/past-work/`：過往本地入口與歷史參考成果；目前不部署。

標準本地資料層：

- `100_Todo/drafts/`：文字草稿、回覆草稿、文章草稿與工作中素材。
- `100_Todo/projects/`：進行中的專案工作規劃；外部工具整合計畫放在 `100_Todo/projects/tool-integration/`。
- `100_Todo/archive/`：已完成或封存的工作摘要。
- `200_Reference/writing-samples/`：寫作與語氣參考。
- `200_Reference/templates/`：模板與安全範本；環境變數範本為 `200_Reference/templates/env.example`。
- `200_Reference/past-work/`：歷史參考成果。
- `200_Reference/scripts/`：只放可版本化腳本；runtime 與工具虛擬環境若需要，放 `200_Reference/scripts/runtime/` 並排除 Git。

本 repo 不使用專案根目錄 `src/`、`tests/`、`assets/`、`working/`、`output/` 作為固定結構；需要程式碼、素材、工作檔或成品時，依用途放入 `100_Todo/` 或 `200_Reference/` 下的標準資料夾。

## 專案設定

- GitHub repo：`https://github.com/icestone0128/codex_installation`
- Repo 類型：公開
- GitHub Pages：未啟用
- Firebase：使用既有 project `codex-4e80b`
  - 本 repo 目前只有 Firestore rules，沒有 Firebase Hosting 設定。
- 部署狀態：目前不部署；`200_Reference/past-work/docs/index.html` 只保留為本地過往入口檔。

## Obsidian 駕駛艙

專案進度與工作流程放在：

`/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain/專案庫/codex_installation/專案工作流程.md`

Obsidian 同步與鏡像對應：請參照 `AGENTS.md` 中的專屬同步規則。
