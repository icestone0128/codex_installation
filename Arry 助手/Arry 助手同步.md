---
title: Arry 助手同步
date: 2026-05-20
type: project-note
tags:
  - codex
  - ai-assistant
  - arry-assistant
  - codex_installation
---

# Arry 助手同步

## 固定定位

- AI 分身名稱：Arry 助手。
- 使用工具：Codex App。
- 使用者角色：科技業一線主管。
- AI 優先協助：資料研究、知識管理。
- 主要輸出：Facebook 貼文、Email/客戶溝通、書籍或 Podcast 的讀後心得。
- 資料層母資料夾：`/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink`
- 資料層入口：`codex_symlink/`
- Codex 全域 skill：`/Users/arrywu/.codex/skills/arry-assistant/SKILL.md`

## Codex 轉換原則

- 不使用其他 AI 編輯器專用的規則檔（如舊版 `CLAUDE.md`）。
- 不使用其專屬路徑。
- 正式 skill 建立在 Codex 全域 skill 路徑。
- 若來源文件含 AI 分身預設名，一律改用「Arry 助手」。
- 若與新專案初始化規則衝突，先詢問使用者。

## 同步範圍與備份

- `codex_symlink/memories/MEMORY.md`：跨專案偏好、踩坑、固定規則候選。
- `全域 Skills/全域 Skills 同步.md`：全域 skill 索引。
- **全域資產備份** (已透過本資料夾的 `sync_backup.py` 實作單/雙向備份)：
  - `core-rules.md` (全域核心規則)
  - `automations/` (Codex 自動化工作流排程與 prompt)
  - `knowledge/` (知識與工具清單)
  - `memories/` (跨專案記憶與 rollout 記錄)
  - `rules/` (預設規則檔)
  - `workflows/` (工作流草稿與範本)

## 全域資產同步備份工作流

本資料夾內含 `sync_backup.py`，支援使用者對全域資產進行定期備份與整理：

- **單向備份 (全域 ➔ Obsidian)**：
  當全域設定或記憶更新，需要同步回 Obsidian 備份時，在終端機執行：
  ```bash
  python3 "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain/專案庫/codex_installation/Arry 助手/sync_backup.py" backup
  ```
- **雙向套用 (Obsidian ➔ 全域)**：
  若在 Obsidian 內整理與修改了備份的檔案 (如 `core-rules.md` 或記憶筆記)，欲套用回全域系統時，在終端機執行：
  ```bash
  python3 "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain/專案庫/codex_installation/Arry 助手/sync_backup.py" apply
  ```
  *(註：此操作會詢問確認以防誤蓋，亦可加上 `-y` 參數強制套用)*

## 雙層資料層

- 全域共用層：`codex_symlink/`，存放 Arry 助手核心記憶、跨專案偏好、踩坑、全域 skills、workflow 草稿與知識清單。
- 專案本地層：每個專案建立自己的 `100_Todo/` 與 `200_Reference/`，存放該專案的草稿、進行中工作、素材、範例與模板。
- 專案本地任務一階目錄：`100_Todo/drafts/`、`100_Todo/projects/`、`100_Todo/archive/`。
- 專案本地參考一階目錄：`200_Reference/writing-samples/`、`200_Reference/templates/`、`200_Reference/past-work/`。
- 專案本地記憶：只有專案需要獨立助手記憶時，才建立 `000_Agent/memory/`。
- 專案本地 skills：只有專案需要專屬 assistant skill 或局部流程時，才建立 `000_Agent/skills/`；不要 symlink 到 `/Users/arrywu/.codex/skills`。
- 不在每個專案複製 Arry 助手全域核心層。

## 今日狀態

- 2026-05-20：已建立 Codex App 版 Arry 助手資料層與全域 skill。
- 2026-05-20：已確認採用「全域共用 + 專案本地」雙層模式，並補齊現有專案 `habit_of_thought` 的本地 `100_Todo/` 與 `200_Reference/`。
- 2026-05-20：重新比對 `01-agent-folder-setup.md` 後，補齊平台客製資料夾與行動清單。
- 2026-05-20：完成 Session A 角色訪談：科技業一線主管；AI 優先支援資料研究與知識管理；主要產出為 Facebook、Email/客戶溝通、書籍或 Podcast 讀後心得。
- 2026-05-22：全域資料層改以 `codex_symlink/` 為主；專案本地記憶統一為 `000_Agent/memory/`，專案本地 skills 統一為 `000_Agent/skills/`；專案初始化一階目錄已納入 `project-init-sync` 與 `arry-assistant`。
- 2026-06-14：新增 Arry Q 版角色設定與知識圖解筆記風格資產。現行扁平結構為：Codex 角色資產放 `codex_symlink/knowledge/arry-visual-identity/`，Codex 圖解作品參考放 `codex_symlink/knowledge/visual-note-references/`，Obsidian 角色資產放本資料夾 `Arry-Visual-Identity/`，Obsidian 作品集放 `創作庫/Visual-Note-References/`，風格規格放 `codex_symlink/knowledge/arry-visual-identity.yaml`。
- 2026-06-19：完成 Arry 視覺資產路徑扁平化；舊的多層角色與作品集目錄已移除，相關 Skill、YAML、LazyPack 與索引均已改用現行路徑。
- 2026-06-19：完成 Visual Note Workflow／Style Profile 分層；Arry 個人風格集中在 Skill 的 `default-style-profile.yaml`，Knowledge 檔只保留資產位置與 canonical pointers。
- 2026-06-23：已部署 `sync_backup.py` 同步腳本，將全域 `core-rules.md` 及四大核心目錄 (`knowledge/`, `memories/`, `rules/`, `workflows/`) 備份至本資料夾，並完成首次備份，以利定期整理。
