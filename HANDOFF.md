# Project Handoff

## Current state

2026-09-10 已完成四層記憶架構與 Codex adapter 校正；待處理 rollout 尚未完成。
完整敘事在 Obsidian 駕駛艙 `專案庫/codex_installation/專案工作流程.md` 的 2026-09-10 四則紀錄；
全域 skill 變更紀錄在 `全域 Skills/全域 Skills 同步.md`。以下只列會影響下次工作的狀態：

- **常駐 context 已大幅下降**：`core-rules.md` 27,216 → 18,307 字元（≈8,838 tokens）；
  `memories/MEMORY.md` 48,480 → 1,145 tokens。合計常駐約 **9,983 tokens**。
- **記憶改為四層**：T0 常駐（core-rules + `MEMORY.md` 協作偏好）／T1 開工（`memory_summary.md`）／
  T2 按需（`extensions/ad_hoc/notes/INDEX.md` 46 則、`knowledge/` 策略）／T3 封存
  （`memories/archive/`、`rollout_summaries/`）。規範見 `knowledge/memory-tiering.md`。
  **不要整份載入 `memories/`。**
- **共享記憶是唯一主版本**：`~/.codex/memories` 維持指向 `codex_symlink/memories`；
  Codex 原生 memories 已停用，由 Arry 助手與開收工流程執行四層記憶，不建立第二份本機記憶。
- **84 個全域 skill**，description 全部 ≤175 字元，frontmatter 全數通過 YAML 驗證。
  新增 `obsidian-weekly-knowledge-refresh-secondbrain`（個人 vault 專用，不進公開 LazyPack）。
- **同步全綠**：LazyPack 40 identical / 0 to change；Obsidian `懶人包/` 與 `Arry 助手/` 鏡像
  `diff -qr` 一致；chezmoi status 乾淨。
- Codex CLI 已升級 **0.153.4**（0.149.1 跑不動預設模型 `gpt-6-astra`）。
- anydoc v0.2.4 已安裝，補 Office 文件轉 Markdown 缺口，接在 `doc-to-md` 的 Step 0。
- 上游 `lifehacker-tw/claude-code-mini-course` 授權已於 2026-07-18（commit `ec7b3b8`）
  改為付費學員限定。本地整合凍結在 snapshot `b2cd801`，**該日之後的內容不得再取用**。

## Next action

- **處理共享四層記憶 backlog**：原交接的 29 份並未處理。2026-09-10 15:36 live 重算為
  截止點後 32 個 archived rollout，其中 1 個已有 `stage1_outputs`，目前實際缺少 31 個。
- 不啟用 Codex 原生 memories、不改寫 `memories_1.sqlite`，也不建立第二份本機記憶；應由
  共享工作流把每份 rollout 整理至 T3 `rollout_summaries/`，再把可重用內容依規則提升至
  T2 索引或 T0／T1。批次寫入前要先備份目標檔案並驗證可恢復、可續跑、避免重複。
- 若未來 Codex 宣布支援 symlink memory root，先在隔離環境驗證不會建立第二份資料，再評估是否調整目前停用設定。

## Blockers

- 無。

## Last verified

- 2026-09-10 09:10 CST，Claude Code。84 個 skill frontmatter YAML 全數通過；
  `codex debug prompt-input` 確認 0 個 description 被截斷、skills 預算警告消失；
  LazyPack 40 identical / 0 to change；`懶人包/` 與 `Arry 助手/` 鏡像 `diff -qr` 一致；
  chezmoi status 乾淨；Codex CLI 0.153.4。
- 2026-09-10 15:20 CST，Codex App：新建互動式 Codex session
  `01a08a30-07bb-72b2-8cef-1314784c18ea`，狀態資料庫記錄 `memory_mode=disabled`，正常回覆 `OK`；
  啟動後 logs 新增的 symlink-memory 錯誤為 0。LazyPack 40 identical / 0 to change、三個
  skill package 合法、三 Agent 相容性掃描 23 檔 0 findings，Obsidian 兩組鏡像一致。
- 2026-09-10 15:36 CST，Codex App：重新核對原交接四項；archived rollout 253、
  `stage1_outputs` 27、截止點後 31 個未處理、jobs 新排程 0。原本「無記憶修復待辦」的判斷已撤回。
