# 04-建立第二大腦 Obsidian

## 目標

建立 Codex 可讀寫的 Obsidian 第二大腦，並固定 vault、資料夾、AGENTS 規則與專案庫。

## 固定 Vault

主要 Obsidian vault：

`/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain`

當使用者說「Obsidian」、「Secondbrain」、「我的筆記本」、「第二大腦」時，預設指這個 vault。

## 資料夾結構

- `Clippings/`：剪藏與外部輸入。
- `知識庫/`：整理後的結構化知識。
- `創作庫/`：自己的作品。
- `每日筆記/`：每日、每週紀錄。
- `Templates/`：模板。
- `專案庫/`：Codex 專案駕駛艙。

## AGENTS 規則

Obsidian vault 內要有：

`secondbrain/AGENTS.md`

全域 Codex 規則要記住：

`/Users/arrywu/.codex/AGENTS.md`

## 專案庫規則

所有專案駕駛艙：

`專案庫/<專案名稱>/專案工作流程.md`

不要直接散放在 vault 根目錄。

## 踩坑修正

- 如果 Obsidian Desktop 看不到 Codex 新建檔案，先確認 Desktop 開的是同一個 Google Drive vault。
- 如果 MCP 可以寫入但桌面看不到，通常是 vault 開錯或 Google Drive 同步未完成。
- 不要用 `Codex` 當 vault 名稱猜測；本機正式 vault 是 `secondbrain`。
- 不要把 API key、token、密碼寫進 Obsidian 筆記。

