# 04-建立第二大腦 Obsidian

## 目標

建立 Codex 可讀寫的 Obsidian 第二大腦，並固定 vault、資料夾、AGENTS 規則與專案庫。

## 前置條件

- 已安裝 Obsidian Desktop。
- 已決定 `{{OBSIDIAN_VAULT}}`。
- 已決定是否使用 Google Drive / iCloud / Dropbox / 本機資料夾同步。
- Codex 已被授權讀寫 `{{OBSIDIAN_VAULT}}`，或已設定 Filesystem / Obsidian MCP。

## 建立 Vault

建議資料夾：

```text
{{OBSIDIAN_VAULT}}
```

如果使用 Google Drive，請確認 Obsidian Desktop 實際開啟的 vault 就是這個資料夾。

## 建立資料夾結構

```bash
mkdir -p "{{OBSIDIAN_VAULT}}"/{Clippings,知識庫,創作庫,每日筆記,Templates,專案庫}
```

用途：

- `Clippings/`：剪藏與外部輸入。
- `知識庫/`：整理後的結構化知識。
- `創作庫/`：自己的作品。
- `每日筆記/`：每日、每週紀錄。
- `Templates/`：模板。
- `專案庫/`：Codex 專案駕駛艙。

## 建立 Vault AGENTS.md

在 `{{OBSIDIAN_VAULT}}/AGENTS.md` 建立：

```markdown
# 我的 Obsidian 筆記本

## 語言偏好

- 預設使用繁體中文。
- 回答以清楚、實用、可直接執行為主。

## 筆記規則

- 新增正式筆記時加上 frontmatter：`title`、`date`、`type`、`tags`。
- 不覆寫既有筆記；如果檔案存在，先讀原檔再詢問。
- 不刪除筆記，除非使用者明確指定。
- 不把 API key、token、密碼寫進筆記。

## 資料夾規則

- `Clippings/`：原始資料，不任意改寫。
- `知識庫/`：AI 可協助整理，使用者審核。
- `創作庫/`：不改寫個人聲音，除非使用者要求。
- `每日筆記/`：時間紀錄。
- `Templates/`：模板。
- `專案庫/`：每個專案一個子資料夾，固定使用 `專案庫/<專案名稱>/專案工作流程.md`。
```

## 建立知識庫入口

```bash
touch "{{OBSIDIAN_VAULT}}/知識庫/index.md"
touch "{{OBSIDIAN_VAULT}}/知識庫/log.md"
```

`index.md` 建議放主題索引；`log.md` 只追加重要整理紀錄。

## 專案庫規則

所有專案駕駛艙：

```text
{{OBSIDIAN_PROJECTS}}/<專案名稱>/專案工作流程.md
```

不要直接散放在 vault 根目錄。

## 驗證

1. Obsidian Desktop 能看到 `Clippings/`、`知識庫/`、`專案庫/`。
2. Codex 能讀 `{{OBSIDIAN_VAULT}}/AGENTS.md`。
3. Codex 能建立一個測試 note，Obsidian Desktop 能看到。
4. 測試 note 刪除前要確認不是正式筆記。

## 本機實測例

本機實測 vault 名稱為 `secondbrain`。下載者可使用自己的 vault 名稱，不要硬套 `secondbrain`。

## 踩坑修正

- 如果 Obsidian Desktop 看不到 Codex 新建檔案，先確認 Desktop 開的是同一個 vault。
- 如果 MCP 可以寫入但桌面看不到，通常是 vault 開錯或雲端同步未完成。
- 不要用別人的 vault 名稱猜測；以自己 Obsidian Desktop 開啟的資料夾為準。
- 不要把 API key、token、密碼寫進 Obsidian 筆記。
