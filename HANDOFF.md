# Project Handoff

## Current state

2026-09-10 一整天的工作已全部 commit 並推送（`e9512b0`），工作樹乾淨、與 `origin/main` 同步。
完整敘事在 Obsidian 駕駛艙 `專案庫/codex_installation/專案工作流程.md` 的 2026-09-10 兩則紀錄；
全域 skill 變更紀錄在 `全域 Skills/全域 Skills 同步.md`。以下只列會影響下次工作的狀態：

- **常駐 context 已大幅下降**：`core-rules.md` 27,216 → 18,307 字元（≈8,838 tokens）；
  `memories/MEMORY.md` 48,480 → 1,145 tokens。合計常駐約 **9,983 tokens**。
- **記憶改為四層**：T0 常駐（core-rules + `MEMORY.md` 協作偏好）／T1 開工（`memory_summary.md`）／
  T2 按需（`extensions/ad_hoc/notes/INDEX.md` 46 則、`knowledge/` 策略）／T3 封存
  （`memories/archive/`、`rollout_summaries/`）。規範見 `knowledge/memory-tiering.md`。
  **不要整份載入 `memories/`。**
- **84 個全域 skill**，description 全部 ≤175 字元，frontmatter 全數通過 YAML 驗證。
  新增 `obsidian-weekly-knowledge-refresh-secondbrain`（個人 vault 專用，不進公開 LazyPack）。
- **同步全綠**：LazyPack 40 identical / 0 to change；Obsidian `懶人包/` 與 `Arry 助手/` 鏡像
  `diff -qr` 一致；chezmoi status 乾淨。
- Codex CLI 已升級 **0.153.4**（0.149.1 跑不動預設模型 `gpt-6-astra`）。
- anydoc v0.2.4 已安裝，補 Office 文件轉 Markdown 缺口，接在 `doc-to-md` 的 Step 0。
- 上游 `lifehacker-tw/claude-code-mini-course` 授權已於 2026-07-18（commit `ec7b3b8`）
  改為付費學員限定。本地整合凍結在 snapshot `b2cd801`，**該日之後的內容不得再取用**。

## Next action

### 任務：驗證並復活 Codex 原生記憶 pipeline

這是本次唯一未完成的事，且**必須用互動式 Codex 執行** —— 非互動式 `codex exec` 不會觸發記憶排程。

**背景**

Codex 原生記憶功能（`~/.codex/config.toml` 的 `[memories]`，`generate_memories = true`、
`use_memories = true`；狀態在 `~/.codex/memories_1.sqlite`）自 2026-08-21 停擺。

根因已於 2026-09-10 查明並移除：consolidation 會把既有記憶讀回去當輸入，而
`MEMORY.md` 被自動追加的 Task Group 撐到 48,480 tokens，撐爆 context window。
證據是 `memory_stage1` 有 2 筆 job 以
`Codex ran out of room in the model's context window` 失敗且 `retry_remaining` 歸零，
最後一次成功的 `memory_consolidate_global` 停在 2026-08-21 06:07。

**交接時的實際狀態**

| 項目 | 數字 |
| :-- | :-- |
| `~/.codex/archived_sessions` rollout 檔案 | 253 個 |
| 已處理（`stage1_outputs`） | 27 個 |
| 2026-08-21 之後累積未處理 | 29 個 |
| jobs 表新的排隊列 | 0 |

**步驟**

1. 先查現況，不要預設它還沒跑 —— 你開啟這個互動式 session 的動作本身可能已經觸發排程：

   ```bash
   sqlite3 -header -column ~/.codex/memories_1.sqlite \
     "SELECT kind,status,COUNT(*) n,MAX(datetime(finished_at,'unixepoch','localtime')) last
      FROM jobs GROUP BY kind,status;"
   sqlite3 ~/.codex/memories_1.sqlite "SELECT COUNT(*) FROM stage1_outputs;"
   ```

   `memory_consolidate_global` 的 last 若已晚於 2026-08-21，代表已復活，跳到步驟 4。

2. 若仍無新 job，檢查 `[memories]` 的閘門條件實際預設值與是否命中：
   `disable_on_external_context`、`min_rollout_idle_hours`、`max_rollout_age_days`、
   `max_rollouts_per_startup`、`min_rate_limit_remaining_percent`。
   這些鍵名取自 CLI binary 的 config struct，尚未查證預設值。

3. 仍無進展時再考慮 2026-07-17 那 2 筆 `retry_remaining=0` 的 `memory_stage1`。
   **未經使用者明確同意不要改寫 Codex 內部狀態 DB** —— 那 2 筆是七月舊 thread，
   重跑的價值低於動 DB 的風險。

4. 復活成功後，確認分層守門有效：pipeline 會再往 `MEMORY.md` 追加 Task Group，
   `shutdown-sync` 第 4 步的守門規則是超過約 3,000 tokens 就把 Task Group 移進
   `memories/archive/`。實際跑一次確認它真的被執行，而不只是寫在文件裡。

**邊界**

- 不要搬移或刪除 `~/.codex/archived_sessions` 的 session 逐字稿；保留期由
  `cross-device-sync/scripts/prune-session-artifacts.py` 管理。
- 不要讓 `MEMORY.md` 重新膨脹。它同時是開工常駐 context 與 consolidation 的輸入，
  膨脹會一次弄壞兩件事。
- 相關規範：`knowledge/memory-tiering.md`（含本次事故的完整紀錄與定期檢查指令）。

## Blockers

- 無。上述任務不阻塞其他工作。

## Last verified

- 2026-09-10 09:10 CST，Claude Code。84 個 skill frontmatter YAML 全數通過；
  `codex debug prompt-input` 確認 0 個 description 被截斷、skills 預算警告消失；
  LazyPack 40 identical / 0 to change；`懶人包/` 與 `Arry 助手/` 鏡像 `diff -qr` 一致；
  chezmoi status 乾淨；Codex CLI 0.153.4。
- 未驗證：記憶 pipeline 是否真的復活（見 Next action，需互動式 Codex）。
