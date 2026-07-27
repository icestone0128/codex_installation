# Project Handoff

## Current state

- Arry 私人全域 `productivity-coach` 已完成，v3.1／V4 與 28 張單元卡是唯一教練主版本；舊 NotebookLM v2 內容不會覆蓋新版方法。
- Skill 可獨立完成精力、知識、成果三層卡點診斷，帶一個 5～15 分鐘最小練習，並在使用者確認後才回寫候選規則。
- NotebookLM 是選配工具，不是 Skill 的必要依賴；只有使用者明確要求時，Agent 才會建立／選擇筆記本、加入來源、設定 Chat 或建立 notes。
- Codex、Claude、AntiGravity 共用同一個私人全域 package；三個原生 skills 入口都解析到 `codex_symlink/skills/productivity-coach`。
- 私人課程與 NotebookLM 靜態來源不進 public LazyPack、public repo、commit、push 或部署；公開 repo 只保存本交接紀錄。

## Next action

- 在新對話用一個真實工作卡點測試自然語意觸發，例如「今天事情太多，不知道先做什麼」。
- 只有需要長期來源引用、規則累積或多輪教練時，才明確要求建立或使用 Productivity Coach NotebookLM。

## Blockers

- 無。Codex NotebookLM 原生 MCP 已連線；Claude／AntiGravity 若未設定對等 MCP，仍可完成本地教練流程並使用瀏覽器／人工 fallback。

## Last verified

- 2026-07-28，Codex App：專用 validator 通過，確認 28 張單元卡、Soul／Body Framework、合併來源最新且沒有舊 v2 單元路由。
- 2026-07-28，Codex App：Skill quick validator 通過；三 Agent compatibility audit 掃描 55 個檔案、0 findings；三個原生入口解析到同一全域 package。
- 2026-07-28，Codex App：NotebookLM 連線完成唯讀 notebook list 驗證，未建立或修改外部筆記本；public LazyPack 未包含私人 Skill 或課程來源。
