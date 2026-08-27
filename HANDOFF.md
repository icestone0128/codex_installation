# Project Handoff

## Current state

- **Pro-Kit 01–05 整合閉環**（2026-08-25～26，完整歷史見 Obsidian 駕駛艙）：
  - 01 → `REPOS.md`、verification Phase 0、arry-assistant 自我進化＋首次啟用訪談、
    core-rules 去重＋語言規則、協作偏好寫入 `MEMORY.md`（六欄全為訪談確認值）。
  - 02 → 三 Agent 防護：judgement 層（core-rules〈不可逆操作邊界〉四級）＋攔截層
    （Claude 17 deny + 2 ask；Codex 10 forbidden + 2 prompt；AntiGravity 無 deny 機制，
    走 sandbox＋判斷層驗證）。可攜主版本在 `cross-device-sync/assets/agent-guardrails.json`，
    `apply-agent-guardrails.py` 套用，checkpoint 每次輸出 `GUARDRAILS drift`。
  - 03／04 → 整合進 `codex-skill-creator`（baseline-first、雙測試、方法來源路線、
    模仿真人誠實邊界、勸退清單、熟練度優先、brief、回溯訪談），LazyPack Item 11。
  - 05 → 新全域 skill `personal-style-loop`（Item 44），三處懸空的寫作風格指向已收斂。
  - `heptabase-cli` skill 更新至 CLI 0.5.x（14 指令全涵蓋），Item 02 同步。
- 防護設定已寫入三個安裝 repo（codex Item 16 prose／claude §9／antigravity §8，
  各依 Agent 機制寫「套用 vs 驗證」）。第三方可從 public LazyPack 重現同等安裝；
  個人記憶、REPOS.md、風格庫不外流。
- 全域 skill 計數口徑：實際 82（必裝共享 2 ＋ 自訂 80），`ls` 會把 README.md 誤計。

- 2026-08-26 晚間：GitHub 清理完成——刪除測試 repo `github-test`（Public）與
  `codex-github-test`（Private），清除 3 個 repo 殘留的 `github-pages` 環境，全帳號複掃零殘留，
  `delete_repo` 權限用畢即收回。Pages CDN 快取（github-test 網址暫回 200）會自行過期。
- LazyPack Item 43 依收工檢查發現主版本 drift 並重新同步：`visual-prompt-kit` 當日在
  `trivial_matters_of_life` 大幅更新（Cover／輪播四道確認關卡、6 支驗證器、確認紀錄模板），
  內嵌與 17:35 後主版本 IDENTICAL，個資／pycache／絕對路徑皆 0。

- 2026-08-26 23:24 `a6286af`：新增「全文章最高密度知識圖卡（9:16）」工作流。
  `image-generator` 加 `references/high-density-knowledge-card.md` 與
  `scripts/validate_high_density_knowledge_card_plan.py`，LazyPack Item 22（+342 行）與
  Item 43 同步。先做內容覆蓋計畫再生圖，含外語白名單驗收。
- 2026-08-27 00:01 `734ae5d`：新增全域 skill `agent-dev-coach`＋LazyPack **Item 45**
  （agent 開發五關教練：拷問→規格→切票→TDD→雙軸審查，另附隨時可用的 PRD 打包）。
  來源為第三方 zip，依 `codex-skill-creator` source-adapter 路線轉三 Agent 共用版。
  **修掉上游必然失敗的缺陷**：原版用相對路徑呼叫 `scripts/`，教練工作目錄是學員專案、
  腳本在 skill 套件，第 2 關實測 `No such file or directory`。改為腳本自我定位
  ＋`SKILL.md` 先解析 skill root（一段 `ls -d` 涵蓋三入口）。
  edge test 另修兩個 validator 缺口：模糊詞漏抓「要好／很高」等寫法、schema 失敗會傾印整份 schema。
  全域 skill 計數 82 → **83**（自訂 80 → 81）。

- 2026-08-27 06:0x 清理：依使用者要求清空過程檔與備份。已刪 `codex_symlink/backups/` 全部
  83 檔（含 **56 張生成圖**）、130 個 `.bak.*`、8 個整包備份、37 份 `~/agent-sync-backup-*`、
  396 個 `__pycache__`、78 個 `.DS_Store`，共釋出約 96M。
  **盤點時發現 `visual-prompt-kit-cleanup-20260826-223500` 與 `carousel-renders.bak` 存著
  56 張圖的唯一副本**（當初「清理」把成品移出 live 後沒放回），已完整列清單、兩度提示不可逆，
  使用者確認後刪除。這些圖已不存在，同系列若要重做需重新定義 `visual-dna.yaml` 規格。
  `drafts/` 依使用者選擇未動（tech_job 252M 的 114 個 podcast MP3、voice_coach 58M 課程素材）。
- `3827515`：新增 `cross-device-sync/scripts/prune-session-artifacts.py`（保留期 7 天）
  並掛進收工 checkpoint。白名單範圍：`backups/*`、`~/agent-sync-backup-*`、`__pycache__`、
  `.DS_Store`；不碰 skills／memories／knowledge／`100_Todo/`／git 工作樹。
  **孤兒媒體防線**：刪備份前建立 live 媒體索引，同名同大小在備份區外存在才算有副本，
  比不到就標 `ORPHAN-MEDIA` 保留、`--apply` 也不刪（逃生門 `--allow-orphan-media`）。
  預設 dry-run。實測索引 2480 個媒體檔 0.44 秒。checkpoint 新增 `--prune-days N`／`--no-prune`，
  開工不觸發。Item 16 已重生並補 prose。
- 保留期機制改版（同日稍後，依使用者回饋）：孤兒媒體從「一律擋下」改為**提出決策等同意**。
  原設計會讓待決項目永遠卡著、沒有 resolution path，只會變成永久堆積。
  新增 `--interactive`（逐一詢問，Enter 等於保留）、`--approve-delete NAME`（單項同意）、
  `--keep-orphans`（本次全留）；`--allow-orphan-media` 保留為「本次全刪」。
  沒有答覆就報 `PENDING=n` 原地保留，無人看顧的收工掃描既不偷刪也不擅自結案。
  收工 checkpoint 在 `PENDING>0` 時把項目與 `--interactive` 指令推到眼前。
  測試中發現 `ask()` 原本只讀 `/dev/tty`，在有 pty 但無 controlling terminal 的環境會失敗，
  已改為 stdin 優先、`/dev/tty` 備援、EOF 視為 pending（不謊報「你選擇保留」）。
- `17af917`：保留期清理擴及 **Agent 沙盒**。新增 `--agent auto|codex|claude|antigravity|all|none`，
  預設 `auto`＝只清當前執行中的那一個（刪別的 Agent 狀態時它可能正在跑，會弄壞進行中 session）。
  當前 session 的檔案一律跳過，不看年齡。checkpoint 不傳 `--agent`，收工自動生效。
  白名單：Claude `backups/.claude.json.backup.*`／`shell-snapshots`／`session-env`／`telemetry`／
  `tasks`／`sessions`；Codex `.codex-global-state.json.bak`／`.tmp`／`ambient-suggestions`／
  `config.toml.bak*`；AntiGravity `brain/`（當前 conversation 除外）。
  實測三個 Agent 的 glob 與 28 個受保護項目零交集。
- **兩處刻意排除，理由要留給下一手**：
  1. `~/.codex/archived_sessions`（2.4G／221 逾期）改為 opt-in `--include-codex-archives`。
     `memories/` 的 rollout summaries 用 id 引用這些逐字稿，實測 `MEMORY.md` 引用的一份
     就在 `archived_sessions/`（`01a00cba…` 命中）。archive 是搬家不是垃圾桶，清掉會斷稽核軌跡。
  2. `~/.codex/generated_images`（178M/112）、`audio-to-md`（231M/6336）、`doc-to-md`（95M/1242）、
     `attachments`、`dictation-history`、`~/.claude/projects`（15G，含助手記憶目錄）永久排除——
     這些是產出不是暫存。沙盒內產物是否已依 core-rules 複製到專案目錄無法回溯查證。
- 驗證期間 checkpoint 實跑（帶 `--apply`）清掉 Claude 沙盒 1019 項／6.1M：
  `session-env` 993、`shell-snapshots` 2、`telemetry` 23、`tasks` 1，皆逾期且在白名單內；
  輸出顯示 `session-env` 有「1 項為當前 session」被跳過，當前 session 保護確認有效。
- `e8e29d2`：`agent-guardrails.json` 的 `excluded` 說明原本只寫「移除」沒有受詞，
  被 compatibility audit 的 `(清除|移除|排除)…Claude` 規則命中。改寫為
  「這兩條 ask 規則整條拿掉」，語意更明確且不再誤觸。**只動說明文字**，
  `forbidden` 17 條與 `ask.git_publish: []` 皆未變動。

- 2026-08-27 `b61682f`：修好 `sync-lazypack-embeds.py`，整批重生恢復可用。
  兩個缺陷：(1) `SYNC_SKILLS` 預設用 `REPO.parent`，解析到不存在的
  `agentic_projects/codex_symlink/skills`，主版本其實在雲端硬碟根層 → 改 `REPO.parents[1]`，
  並加 `--sync-root`／`--skills-root` 與 `SYNC_ROOT`，找不到 exit 2。
  (2) skill 缺套件直接 `FileNotFoundError` 中斷整批 → 改 `MissingSkill`，
  **跳過整個 Item 檔**（只跳過單一 skill 會靜默刪掉已發布的安裝內容）、逐筆回報、exit 1。
  **sections 表本身沒錯**：81 筆引用、78 個不重複 skill 全部存在，先前的 `pdf` 錯誤
  只是缺陷 1 的第一個受害者（排在第一個項目第一位），不是 plugin skill 混入。
  另把 UTF-8 來源的 CRLF 正規化成 LF——`playwright/LICENSE.txt` 是唯一受影響檔案，
  不正規化會把 201 個 CR 寫進 public repo；二進位檔仍走 base64，維持 byte-exact。
  新增 `--dry-run`／`--show-diff`，只比對不寫檔。
- `verify-lazypack-embeds.py` 的 docstring 說 generator「目前無法整批重跑」已過時，一併更新為
  「整批驗證用 `--dry-run`，這支做單一 Item 細部檢查」。兩支的 delimiter 演算法一致，結果交叉吻合。
- **未引用的全域 skill 4 個**：`future-coach`（依規則不進公開 LazyPack）、`productivity-coach`、
  `voice-coach`、`waki-brain`。後三個待確認是刻意還是漏列。
- 併發踩坑：本 session 期間另一個 session 併行提交了 `4e6ef86`（含 Item 14／45），
  導致 `git status` 中途自行變動。Drive 同步的 repo 收工前務必重新確認工作樹，不能沿用開場快照。

## Next action

#### S-0【已結案】guardrails drift
- 開工時 checkpoint 報 `drift: ['git commit', 'git push']`。查證後為主版本落後，非設定被破壞。
- 本 session 期間（23:47）主版本已被修好：`agent-guardrails.json` 的 `ask.git_publish` 清空，
  並補上 `excluded` 說明（`permissions.ask` 優先權高於 PreToolUse hook 的 `allow`，
  無法用自動審核器取代彈窗，只能整條移除）。**非本 session 所為**，來源未確認。
- 但修的人漏了兩處，已由本次收工補完：
  1. LazyPack Item 16 內嵌 JSON 仍是舊版 → 收工全量重生時抓到並修正（`7c42ca6`），
     內嵌與主版本逐字比對 IDENTICAL，懶人包鏡像已同步。
  2. `claude_installation/200_Reference/lazy-pack/01-claude-lazypack.md:109` 仍寫
     「執行前詢問 git commit、git push」→ 已改寫為現況（`5e5492f`）。
- 收工 checkpoint 覆核：`GUARDRAILS CLAUDE drift: none CODEX block: present`。
- **這是「攔截清單單邊修改導致不一致」第 4 次**。既有規範仍然有效：三 Agent 一起改、雙向實測。

#### S-1【待辦】`personal-style-loop` 素材放置與第一輪校準
- 待使用者放 2～3 篇代表作進某專案 `200_Reference/writing-samples/`
  （schema 見 Item 44：`use_for`／`do_not_use_for` frontmatter、去識別化）後，
  跑第一輪校準。在此之前該 skill 是 `0.1.0` 未校準初版，其停止條件禁止無素材啟動。

#### S-2【已結案】Item 40 與 Item 45 長期併存
- 2026-08-27 使用者確認：兩者長期併存，不合併也不收掉其中一套。
- 分工：Item 40 是使用者自己動手的工具箱（各 skill 獨立呼叫、順序自由、無前進閘門）；
  Item 45 是帶人的單一連續流程（五關固定順序、每關須明確同意才前進、`.agent-flow/` 狀態機、
  教練話術與 HC 標籤）。可接力使用：Item 45 想清楚需求與切票，日常實作與審查回到 Item 40。
- 邊界已寫進 Item 45 與 LazyPack README，無後續動作。

## Blockers

- 無。C-1（維持 full-access）、C-2（on-request＋雙 Agent ask/prompt）、A-1～A-3、X-1
  皆已結案並經實測覆核。
- 跨 session 規範：接手者回報「已完成」時，務必對 live 狀態實測覆核再採信
  （2026-08-26 曾抓到一項 C-1 誤記）；修改攔截清單時三 Agent 一起改並雙向實測
  （已三次因單邊修改而不一致）；要讓 LazyPack 帶出去的檔案必須放在 skill 套件內。

## Last verified

- 2026-08-27 Claude Code 收工：`codex_installation` HEAD `b61682f`，已推 `origin/main`，
  工作樹 0 未提交。提交前掃描：secret pattern 0、`/Users/arrywu` 等個人絕對路徑 0（public repo）。
- `sync-lazypack-embeds.py --dry-run`：**40 identical、0 changed、0 skipped、exit 0**。
  dry-run 前後 45 個 LazyPack 檔案 SHA-256 全等，確認未寫檔。
- Item 16 內嵌 **15 檔**（前次紀錄寫 13，已過時）與主版本逐檔 IDENTICAL；
  `verify-lazypack-embeds.py` 獨立覆核 `IDENTICAL=15 DIFFERS=0 MISSING=0`。
- 缺 skill 的跳過路徑用空 skills root 實測：41 檔全部乾淨跳過、不中斷、exit 1；
  root 不存在時 exit 2。
- 收工 checkpoint：`CHEZMOI_STATUS=clean`、`CHEZMOI_ADD=not-needed-for-existing-templates`、
  `GUARDRAILS CLAUDE drift: none CODEX block: present`、`PRUNE PRUNED=0 PENDING=0`。
  九個 Agent 入口 symlink 與 Python tools bridge 皆 OK。
- Arry 助手鏡像：`copied=0, removed=0`，`diff -qr` 通過（本 session 未動 knowledge／memories）。
- 本 session 沙盒產物皆為驗證用暫存（原檔備份、SHA 清單、diff、空 skills root），無需歸檔。
- **不可回復**：2026-08-27 稍早刪除的 56 張圖與 `2026-08-25-six-learning-bottlenecks` 的
  `visual-dna.yaml` 全 Drive 已無副本。
