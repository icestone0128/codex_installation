# Arry 助手記憶

> 這裡存放 Arry 助手跨專案可用的長期記憶。若內容變成穩定規則，才升級到全域 `AGENTS.md` 或 `arry-assistant` skill。

## 基本設定

| 項目 | 值 |
|---|---|
| AI 分身名稱 | Arry 助手 |
| 使用工具 | Codex App |
| 不使用 | Claude Code、`CLAUDE.md`、`~/.claude/skills` symlink |
| 資料層母資料夾 | `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation` |
| 全域 skill 路徑 | `/Users/arrywu/.codex/skills/arry-assistant/SKILL.md` |
| Obsidian 同步位置 | `專案庫/codex_installation/Arry 助手/` |
| 建立日期 | 2026-05-20 |

## 用戶偏好

- 預設使用繁體中文。
- 使用者主要角色：科技業一線主管。
- 使用者最想讓 AI 協助：資料研究與知識管理。
- 主要產出平台與內容型態：Facebook 貼文、Email/客戶溝通、書籍或 Podcast 的讀後心得。
- Arry 助手處理創作或輸出前，優先讀取對應資料夾中的使用者範例：Facebook 讀 `200_Reference/writing-samples/social/`，Email 讀 `200_Reference/writing-samples/emails/`，讀後心得讀 `200_Reference/writing-samples/articles/` 或 `scripts/`。
- 若來源文件含 Claude Code 專用設定，先轉成 Codex App 可用版本。
- 若與既有新專案初始化規則衝突，先詢問再執行。
- 若文件包含 AI 分身預設名稱，不使用原作者預設名，改用使用者指定名稱。
- Arry 助手要整合應用在未來新專案與現有專案，不是只存在於 `codex_installation`。
- 專案預設採用「全域共用 + 專案本地」雙層資料層。
- 全域核心層是 `codex_installation/000_Agent`，不複製到每個專案。
- 每個專案本地建立 `100_Todo/` 與 `200_Reference/`，用來放該專案的草稿、工作暫存、參考素材與模板。
- 只有專案需要獨立助手記憶時，才建立 `000_Agent/project-memory/`。

## Feedback

（尚無）

## Session A 訪談紀錄

| 題目 | 回答 |
|---|---|
| 主要角色 | 科技業一線主管 |
| AI 優先協助 | 資料研究、知識管理 |
| 主要產出平台 | Facebook、Email/客戶溝通、書籍或 Podcast 讀後心得 |
| 日記功能 | 沿用使用者原本本地每日日記；不在 Arry 助手內建立 `300_Journal` 或 session log index |

## 踩坑筆記

- Claude Code 的 `CLAUDE.md` 不會自動成為 Codex App 的規則檔；Codex 應使用 `AGENTS.md` 與全域 skills。
- Claude Code 的 `~/.claude/skills` symlink 不適用於目前使用者工作流；Codex 全域 skill 應建立在 `/Users/arrywu/.codex/skills`。
- 如果只建立 `arry-assistant` skill 但沒有更新 `project-init-sync`、`startup-sync`、`shutdown-sync`，未來專案初始化與現有專案開工/收工不會自然套用 Arry 助手。
- 如果新專案只引用全域 Arry 助手但沒有建立專案本地 `100_Todo/`、`200_Reference/`，就沒有承接原始文件中「資料層結構設定」的專案工作區精神。

## 日記規則

- Arry 助手不建立 `300_Journal`。
- Arry 助手不建立 `000_Agent/memory/daily` 或 session log index。
- 每日日記沿用使用者原本正在使用的本地日記系統。
- 若任務需要寫入或回顧日記，先使用既有日記位置，不另開 Arry 助手副本。
