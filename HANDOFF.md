# Project Handoff

## Current state

- LazyPack Item 39 `Coach Skill` 已完成，把 Life Coach（實際 Skill ID `future-coach`）、Voice Coach、Waki Brain、Productivity Coach 整理成單一私人新電腦安裝與驗證入口。
- Public repo 只包含可攜式說明、安全 installer 與 verifier；私人身份、記憶、聲音課程、Waki 購課專案包與 Productivity Coach 課程 corpus 仍只存在私人 `codex_symlink`。
- 安裝器重用 Item 16 chezmoi bootstrap，支援 dry-run、apply、verify-only 與明確授權的 chezmoi 安裝；沒有建立第五個會競爭觸發的 Coach Skill。
- Codex、Claude、AntiGravity 共用同一個私人全域 skills 主版本；Productivity Coach 的 NotebookLM 維持選配。

## Next action

- 在另一台電腦同步私人 `codex_symlink`、取得本 repo 後，先執行 Item 39 dry-run，再以 `--apply` 建立三 Agent 入口。
- 四個私人 Skill 更新後只需重新執行 Item 39 `--verify-only`；不需要重建或公開私人 corpus。

## Blockers

- 無。新電腦仍需先完成私人雲端同步，並為各 Agent、NotebookLM、Chrome 或其他外部服務分別登入。

## Last verified

- 2026-07-28，Codex App：Item 39 在隔離臨時 HOME 完成真實 apply；Codex、Claude、AntiGravity 入口與四個 Skill smoke tests 全數通過。
- 2026-07-28，Codex App：Voice Coach 65 份筆記／索引、Waki Brain 13 個專案包、Productivity Coach 28 張編號單元卡與來源 freshness 驗證通過。
- 2026-07-28，Codex App：相容性 audit 為 0 findings；公開路徑、secret signature、shell／Python syntax、Git diff 與 LazyPack／Obsidian 鏡像一致性檢查通過。
