# 13-Brainstorm-規劃模式

## 目標

把 來源工具 取向的 `/brainstorm` 規劃流程，轉成 Codex App 可用的全域 skill。

這個 skill 用在「先想清楚再動手」的情境：當使用者只有模糊想法、怕 AI 直接開工做錯方向，或想先得到一份計劃書時，Codex 會先釐清需求、列假設、比較方案，直到使用者確認計劃後才開始實作。

## 前置條件

- 已完成 `README.md` 的設定表。
- 已知道 Codex skills 位置：`{{CODEX_HOME}}/skills`。
- 已完成或讀過 `11-Codex-Skill-Creator-工作流.md`。
- 若使用 Obsidian 全域 skill 索引，已知道位置：

```text
{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md
```

## 固定結論

- skill 名稱：`brainstorm`
- 正式安裝位置：

```text
{{CODEX_HOME}}/skills/brainstorm/
```

- 懶人包內已附可直接複製的 skill 原始檔：

```text
{{SETUP_REPO}}/lazy-pack/skills/brainstorm/SKILL.md
{{SETUP_REPO}}/lazy-pack/skills/brainstorm/references/source-adaptation.md
```

- Codex 版觸發方式不是 來源工具 slash command，而是靠 skill metadata 與自然語意觸發，例如：
  - `brainstorm 我想做一個記帳 App`
  - `/brainstorm 我想改善目前的工作流程`
  - `先幫我規劃，不要直接執行`
  - `請先把這個想法整理成計劃`

## 直接安裝

下載本 repo 後，將整個 skill 資料夾複製到自己的 Codex skills 位置：

```bash
mkdir -p "{{CODEX_HOME}}/skills/brainstorm"
rsync -a --delete "{{SETUP_REPO}}/lazy-pack/skills/brainstorm/" "{{CODEX_HOME}}/skills/brainstorm/"
```

如果你已經有同名 skill，先備份再覆蓋：

```bash
cp -R "{{CODEX_HOME}}/skills/brainstorm" "{{CODEX_HOME}}/skills/brainstorm.backup.$(date +%Y%m%d-%H%M%S)"
rsync -a --delete "{{SETUP_REPO}}/lazy-pack/skills/brainstorm/" "{{CODEX_HOME}}/skills/brainstorm/"
```

## 驗證安裝

檢查檔案存在：

```bash
find "{{CODEX_HOME}}/skills/brainstorm" -maxdepth 3 -type f -print
```

應看到：

```text
{{CODEX_HOME}}/skills/brainstorm/SKILL.md
{{CODEX_HOME}}/skills/brainstorm/references/source-adaptation.md
```

檢查 frontmatter：

```bash
sed -n '1,12p' "{{CODEX_HOME}}/skills/brainstorm/SKILL.md"
```

應包含：

```markdown
---
name: brainstorm
description: Use when the user says brainstorm, /brainstorm, 規劃模式, 先想清楚再動手...
metadata:
  short-description: 先規劃再執行的引導式需求釐清
---
```

安裝後，開新 Codex 對話或重啟 Codex App，讓 skill 清單重新載入。

## 何時會觸發

使用者提出以下需求時應使用：

- 「brainstorm 我想做一個新工具」
- 「/brainstorm 我想改善這個專案」
- 「先幫我規劃，不要執行」
- 「我有一個模糊想法，幫我釐清」
- 「先列方案比較，等我確認後再做」

不應用在：

- 使用者已經要求直接做一個明確的小修正。
- 單純查詢事實、翻譯、改一句文字。
- 已有清楚規格且使用者明確不要再討論方案。

## 工作流程

1. 先確認溝通深度：小白、半技術、工程師或由 Codex 判斷。
2. 確認主題與任務類型：新東西、解決問題、改善現有東西或還不確定。
3. 輕量讀取上下文，例如 `AGENTS.md`、Git 狀態、根目錄主要檔案與使用者指定檔案。
4. 列出 3-6 個假設，請使用者修正。
5. 最多問 5 個關鍵問題，一次只問一個主要問題。
6. 提出 1-3 個方案並給推薦。
7. 產出計劃書；使用者確認前不實作。
8. 使用者選擇「現在執行」後，才離開 brainstorm 模式並開始做事。

## 硬性閘門

在使用者確認計劃之前，不可以：

- 寫程式碼或修改既有檔案。
- 建立專案結構或 scaffold。
- 執行會改變狀態的安裝、設定、部署、刪除、搬移動作。
- 把初步假設當成已確認需求。

允許做的事：

- 讀取相關檔案。
- 檢查狀態。
- 詢問問題。
- 整理方案。
- 產出計劃書草稿。

## 計劃書位置

Codex 版不在安裝時固定 `PLANS_DIR`。使用 skill 時才依專案狀況決定：

1. 若目前專案已有 `plans/`，優先放在 `plans/`。
2. 若目前專案使用個人助手本地層且已有 `100_Todo/plans/`，可放在 `100_Todo/plans/`。
3. 若使用者指定位置，以使用者指定為準。
4. 若使用者只想在對話中看計劃，不需要建立檔案。

檔名建議：

```text
YYYY-MM-DD-[主題關鍵字].md
```

## 同步 Obsidian 全域 Skill 索引

若你使用 Obsidian 記錄全域 skills，新增或更新這個 skill 後，同步：

```text
{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md
```

至少補三處：

1. 自訂全域 Skills 表格。
2. Skill 摘要段落。
3. 最近同步紀錄。

範例表格列：

```markdown
| `brainstorm` | `{{CODEX_HOME}}/skills/brainstorm/SKILL.md` | Brainstorm 規劃模式；用引導式問答把模糊想法轉成可執行計劃，確認前不實作 | 已同步 |
```

## 來源工具 轉換重點

| 來源工具 原流程 | Codex App 相容做法 |
| --- | --- |
| `/brainstorm` slash command | 可保留為觸發語，但不依賴 slash command 機制 |
| 來源工具的 skills 路徑 | 改用 `{{CODEX_HOME}}/skills` |
| `000_Agent/skills` symlink | 不建立；正式 Codex skill 放在 `{{CODEX_HOME}}/skills` |
| `AskUserQuestion` | 改成 Codex 對話中的單題引導 |
| 安裝時固定 `PLANS_DIR` | 使用 skill 時依專案決定 |
| 來源工具 Plan Mode 比較 | 改成 Codex 的「確認計劃前不實作」硬性閘門 |

## 踩坑修正

- 不要把原始 來源工具 安裝段落直接照貼到 Codex。
- 不要建立 來源工具的 skills 路徑、來源工具的專案級 skills 路徑 或 來源工具 command shim。
- Codex 不保證 `/brainstorm` 會像 來源工具 slash command 一樣被 UI 特別處理；要在 `description` 寫清楚自然語意觸發。
- 安裝後通常要開新 Codex 對話或重啟 Codex App。
- 這個 skill 是規劃閘門，不是自動執行工具；使用者確認前不要動檔案。

## 設定範例

本機曾建立：

```text
{{CODEX_HOME}}/skills/brainstorm/SKILL.md
{{CODEX_HOME}}/skills/brainstorm/references/source-adaptation.md
```

並已把原始 來源工具 `/brainstorm` 安裝劇本轉成 Codex App 相容流程。下載者應使用自己的 `{{CODEX_HOME}}` 與自己的專案位置。
