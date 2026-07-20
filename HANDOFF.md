# Project Handoff

## Current state

- Codex、Claude、AntiGravity 共用規則、skills、LazyPack 與 chezmoi 原生入口架構已完成整合；12 個專案的跨 Agent 契約與四個 runtime adapter 已完成驗證及 GitHub 發布。
- `startup-sync`／`shutdown-sync` 已加入固定 handoff 與 chezmoi session checkpoint；LazyPack 與 Obsidian 鏡像已驗證一致。
- 跨 Agent session 交接檔的唯一標準檔名已統一為 `HANDOFF.md`，所有主規則、相關 skills 與可攜安裝內容已同步。
- 12 個現有專案均已補齊共用 `AGENTS.md`、薄 `CLAUDE.md` 與大寫 `HANDOFF.md`；有模型呼叫的四個專案已建立 `auto|codex|claude|antigravity` adapter。
- 本機已安裝 Claude Code 2.1.205（Homebrew stable cask）與 Gemini CLI 0.51.0（Google 官方 npm stable package）；兩者的新 zsh PATH、`--version`／`--help` 與共享入口皆已驗證。

## Next action

- 實際啟用 Claude／Gemini 模型前，分別執行 `claude auth login` 與 `gemini` 完成 OAuth；若要讓開工 checkpoint 實際執行 `chezmoi update`，再決定是否為 chezmoi source 建立首次 commit 與 private remote。

## Blockers

- 目前 chezmoi source 尚無首個 commit 與 remote，因此 startup checkpoint 會安全跳過 `chezmoi update`；不影響既有 symlink 與共享主版本運作。
- Claude 與 Gemini 尚未完成帳號登入；這不影響 CLI 安裝完成，但在登入前不能執行模型請求。

## Last verified

- 2026-07-21，Codex；12/12 專案契約、11 個相鄰 repo 與本 repo 的 staged safety、四個 runtime 專案測試、CLI adapter dry-run、LazyPack／Obsidian 鏡像、九個 symlink、`chezmoi status` 與 shutdown checkpoint 均通過。
- 2026-07-21，Codex；Claude Code 2.1.205 與 Gemini CLI 0.51.0 安裝、fresh zsh PATH、CLI help／doctor、九個 chezmoi 入口與 LazyPack Item 10／16 安裝說明均已驗證；未啟動 OAuth、未 stage／commit／push。
