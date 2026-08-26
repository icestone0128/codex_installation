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

## Next action

#### S-1【唯一待辦】`personal-style-loop` 素材放置與第一輪校準
- 待使用者放 2～3 篇代表作進某專案 `200_Reference/writing-samples/`
  （schema 見 Item 44：`use_for`／`do_not_use_for` frontmatter、去識別化）後，
  跑第一輪校準。在此之前該 skill 是 `0.1.0` 未校準初版，其停止條件禁止無素材啟動。

## Blockers

- 無。C-1（維持 full-access）、C-2（on-request＋雙 Agent ask/prompt）、A-1～A-3、X-1
  皆已結案並經實測覆核。
- 跨 session 規範：接手者回報「已完成」時，務必對 live 狀態實測覆核再採信
  （2026-08-26 曾抓到一項 C-1 誤記）；修改攔截清單時三 Agent 一起改並雙向實測
  （已三次因單邊修改而不一致）；要讓 LazyPack 帶出去的檔案必須放在 skill 套件內。

## Last verified

- 2026-08-26，Claude Code 收工：三 repo 皆 0 未提交、與遠端同步
  （codex `a311071`／claude `725d135`／antigravity `a08ce12`）。
  guardrails `--verify` drift none；checkpoint `GUARDRAILS CLAUDE drift: none CODEX block: present`；
  Item 16 內嵌 JSON 與腳本皆與主版本 IDENTICAL；懶人包鏡像與 Arry 助手鏡像 `diff -qr` 一致。
