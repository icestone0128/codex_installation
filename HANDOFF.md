# Project Handoff

## Current state

2026-09-10 已完成四層記憶架構、Codex adapter 校正與原交接 rollout backlog。
完整敘事在 Obsidian 駕駛艙 `專案庫/codex_installation/專案工作流程.md` 的 2026-09-10 紀錄；
全域 skill 變更紀錄在 `全域 Skills/全域 Skills 同步.md`。以下只列會影響下次工作的狀態：

- **常駐 context 已大幅下降**：`core-rules.md` 27,216 → 18,307 字元（≈8,838 tokens）；
  `memories/MEMORY.md` 48,480 → 1,145 tokens。合計常駐約 **9,983 tokens**。
- **記憶改為四層**：T0 常駐（core-rules + `MEMORY.md` 協作偏好）／T1 開工（`memory_summary.md`）／
  T2 按需（`extensions/ad_hoc/notes/INDEX.md` 52 則、`knowledge/` 策略）／T3 封存
  （`memories/archive/`、`rollout_summaries/`）。規範見 `knowledge/memory-tiering.md`。
  **不要整份載入 `memories/`。**
- **共享記憶是唯一主版本**：`~/.codex/memories` 維持指向 `codex_symlink/memories`；
  Codex 原生 memories 已停用，由 Arry 助手與開收工流程執行四層記憶，不建立第二份本機記憶。
- **原交接 backlog 已完成 31／31**：新增共享 `process_shared_memory_backlog.py`，31 個 archived
  rollout 均已寫入 T3 `rollout_summaries/`；31 個唯一 thread ID、格式與密鑰掃描 0 問題，
  `verify` 為 pending 0。T2 索引由 46 增至 52，T1 新增 2 項穩定偏好，T0 無新增。
- **84 個全域 skill**，description 全部 ≤175 字元，frontmatter 全數通過 YAML 驗證。
  新增 `obsidian-weekly-knowledge-refresh-secondbrain`（個人 vault 專用，不進公開 LazyPack）。
- **同步全綠**：LazyPack 40 identical / 0 to change；Obsidian `懶人包/` 與 `Arry 助手/` 鏡像
  `diff -qr` 一致；chezmoi status 乾淨。
- Codex CLI 已升級 **0.153.4**（0.149.1 跑不動預設模型 `gpt-6-astra`）。
- anydoc v0.2.4 已安裝，補 Office 文件轉 Markdown 缺口，接在 `doc-to-md` 的 Step 0。
- 上游 `lifehacker-tw/claude-code-mini-course` 授權已於 2026-07-18（commit `ec7b3b8`）
  改為付費學員限定。本地整合凍結在 snapshot `b2cd801`，**該日之後的內容不得再取用**。

- 2026-09-10 補洞：`memory_summary.md`（T1）原本**沒有任何寫入者** —— 原生 consolidation
  停用後沒有流程接手，它只會被讀、不會被更新。已把寫入責任指派給 `shutdown-sync` 第 4 步，
  並把該步驟改寫成依 T0／T1／T2／駕駛艙分流的路由表；同時移除與分層矛盾的
  「append to `MEMORY.md`」敘述。四層現在讀寫 owner 都齊備且可驗證。

## Next action

- 無待辦任務。以下為長期觀察項目：
- 目前無共享記憶 backlog。後續若有新的 archived rollout 需要整理，先執行
  `arry-assistant/scripts/process_shared_memory_backlog.py inventory`，再以 `process`／`verify` 續跑。
- 若未來 Codex 宣布支援 symlink memory root，先在隔離環境驗證不會建立第二份資料，再評估是否調整目前停用設定。

## Blockers

- 無。

## Last verified

- 2026-09-10 19:15 CST，Claude Code 收工：chezmoi clean、`chezmoi add` 未使用；
  `MEMORY.md` 分層檢查 1,145 tokens／clean；LazyPack 40 identical／0 to change；
  兩組 Obsidian 鏡像 `diff -qr` 一致；UNARCHIVED 三組皆為本次驗證暫存，不需歸檔。
- 2026-09-10 18:55 CST，Claude Code 開工檢查：獨立驗證 Codex 交接四項全數完成 ——
  `process_shared_memory_backlog.py verify` 回傳 pending 0、LazyPack 40 identical／0 to change、
  Obsidian 兩組鏡像 `diff -qr` 一致、chezmoi clean、84 個 skill frontmatter 全通過且 0 個超過 175 字元、
  `MEMORY.md` 維持 1,145 tokens。Git 乾淨且與遠端同步。
  另補上 T1 寫入者缺口（見 Current state 末項）。

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
- 2026-09-10 17:50 CST，Codex App：原交接缺少的 31 筆已全部完成共享 T3 摘要；
  `process_shared_memory_backlog.py verify` 回傳 pending 0，31 個新檔／31 個唯一 thread ID／
  格式與密鑰掃描 0 問題。T2 52 則、T1 新增 2 項、T0 無新增；內部 SQLite 的
  `stage1_outputs` 與 `jobs` 筆數維持不變，處理器現以 `mode=ro` 強制唯讀。
- 2026-09-10 18:00 CST，Codex App：成果 commit `81a639c` 已推送至 `origin/main`；
  LazyPack 40 identical／0 to change、Obsidian 兩組鏡像一致、跨 Agent sync health
  0 failures／0 warnings，shutdown checkpoint 為 chezmoi clean、`UNARCHIVED=0`。
