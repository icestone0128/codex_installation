# codex_installation

本專案為 Codex 的安裝、測試與設定環境，包含專案規則、懶人包（lazy-pack）同步、Obsidian 同步等工作流程。

## 目錄

- `100_Todo/`：進行中事項、任務草稿與封存。
- `200_Reference/`：參考資料、模板與過去成果。
- `000_Agent/`：Arry 助手專案本地層，只放本專案專屬 skill 或 memories。
- `200_Reference/lazy-pack/`：Codex 懶人包存放目錄，包含全域 skill 的可攜式安裝內容。
- `200_Reference/past-work/`：過往本地入口與歷史參考成果。
- `src/` & `tests/`：測試用代碼與單元測試。
- `AGENTS.md`：Codex 專案規則。

標準本地資料層：

- `100_Todo/drafts/`、`100_Todo/projects/`、`100_Todo/archive/`
- `200_Reference/writing-samples/`、`200_Reference/templates/`、`200_Reference/past-work/`

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
