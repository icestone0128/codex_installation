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
- `e8e29d2`：`agent-guardrails.json` 的 `excluded` 說明原本只寫「移除」沒有受詞，
  被 compatibility audit 的 `(清除|移除|排除)…Claude` 規則命中。改寫為
  「這兩條 ask 規則整條拿掉」，語意更明確且不再誤觸。**只動說明文字**，
  `forbidden` 17 條與 `ask.git_publish: []` 皆未變動。

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

#### S-2【可選，需使用者決策】Item 40 與 Item 45 是否併存
- 兩者底層方法重疊（拷問／規格／切票／TDD／審查），但使用情境不同：
  Item 40 是使用者自己做事的工具箱、各 skill 獨立呼叫；Item 45 是帶人的單一連續流程，
  多了教練話術、HC 標籤、`.agent-flow/` 狀態機與每關必須明確同意才前進的閘門。
- 已在 Item 45 寫明邊界並保留併存。若日後判定只需一套，這是可收掉的候選，但屬使用者決策。

## Blockers

- 無。C-1（維持 full-access）、C-2（on-request＋雙 Agent ask/prompt）、A-1～A-3、X-1
  皆已結案並經實測覆核。
- 跨 session 規範：接手者回報「已完成」時，務必對 live 狀態實測覆核再採信
  （2026-08-26 曾抓到一項 C-1 誤記）；修改攔截清單時三 Agent 一起改並雙向實測
  （已三次因單邊修改而不一致）；要讓 LazyPack 帶出去的檔案必須放在 skill 套件內。

## Last verified

- 2026-08-27 06:40，Claude Code 收工：`codex_installation` 0 未提交、與遠端同步，HEAD `e8e29d2`；
  `claude_installation` `5e5492f`、`antigravity_installation` `4328ac6` 皆 0 未提交。
- 收工 checkpoint：`CHEZMOI_STATUS=clean`、`GUARDRAILS drift: none CODEX block: present`、
  `PRUNE PRUNED=0 FREED=0B KEPT=1`（KEPT 是 1 小時前建的 guardrails 備份，未達 7 天保留期，
  行為正確）。這是保留期機制第一次在正式收工流程執行。
- compatibility audit 掃 `skills/` 678 檔，**findings=0**。
- Item 16 內嵌 13 檔與主版本逐檔比對 IDENTICAL 且無遺漏；懶人包鏡像 `diff -qr` 一致；
  Arry 助手鏡像 copied=0 removed=0，`diff -qr` 通過。
- prune 腳本夾具驗收 9 項全過（含唯一副本被擋下、dry-run 零刪除），邊界退出碼正確，
  `bash -n` 通過，checkpoint 三條路徑實測正確。
- **不可回復**：本次刪除的 56 張圖與 `2026-08-25-six-learning-bottlenecks` 的
  `visual-dna.yaml` 全 Drive 已無副本。
