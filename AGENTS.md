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
- 需要時才 commit + push GitHub。

全域 Skill 同步：

- 全域 skills 預設位置：`/Users/arrywu/.codex/skills`
- 目前 `/Users/arrywu/.codex/skills` 是 symlink，實體位置在 `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/skills`
- Obsidian 同步索引：`專案庫/codex_installation/全域 Skills/全域 Skills 同步.md`
- 新增、修改、刪除任何全域 skill 後，一律同步更新上述 Obsidian 筆記。
- 若全域 skill 變更影響固定工作規則、路徑或專案邊界，也要同步更新本檔。

Arry 助手 AI 分身資料層：

- AI 分身名稱：Arry 助手。
- Arry 助手資料層放在本專案：
  - `000_Agent/`
  - `100_Todo/`
  - `200_Reference/`
- Arry 助手是 Codex App 版設定，不使用 Claude Code 專用的 `CLAUDE.md` 或 `~/.claude/skills` symlink。
- 可被所有專案呼叫的部分放在全域 skill：`/Users/arrywu/.codex/skills/arry-assistant/SKILL.md`。
- 若來源文件含 AI 分身預設名稱，不使用來源預設名，改用「Arry 助手」。
- 若 Arry 助手資料層與新專案初始化規則衝突，先詢問使用者再決定。
- `project-init-sync`、`startup-sync`、`shutdown-sync` 已整合 Arry 助手雙層資料層：未來新專案預設建立本地 `100_Todo/`、`200_Reference/`，並引用全域 Arry 助手核心層；現有專案開工/收工時可同步跨專案記憶。

新專案初始化時：

- 使用 `project-init-sync` 流程。
- 以 `lazy-pack/07-專案初始化工作模式.md` 為本專案內的固定參考檔；全域規則已同步到 `/Users/arrywu/.codex/AGENTS.md`。

## 主要檔案

入口檔：`docs/index.html`
設定檔：`.firebaserc`、`firebase.json`、`firestore.rules`
部署位置：GitHub Pages，來源為 `main` branch 的 `/docs` 目錄
部署網址：`https://icestone0128.github.io/codex_installation/`

## 不要做

- 不要把每日進度寫進 AGENTS.md。
- 不要自動納入無關 git 變更。
- 不要把 API key、token、密碼寫進 repo。
- 不要把不必要的個資或敏感資料寫進 repo。
