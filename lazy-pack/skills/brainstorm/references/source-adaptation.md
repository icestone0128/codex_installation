# Brainstorm 來源轉換說明

來源檔：`04-brainstorm.md`

原始來源是 Claude Code 的 `/brainstorm` 安裝劇本，包含 `~/.claude/skills`、`AskUserQuestion`、slash command 與 Claude Code Plan Mode 比較。安裝到 Codex App 時已做以下轉換：

- 安裝位置改為 `{{CODEX_HOME}}/skills/brainstorm/`。
- 觸發方式改為 Codex skill metadata 與自然語意，例如「brainstorm」、「/brainstorm」、「先想清楚再動手」。
- 移除 Claude 專用路徑：`~/.claude/skills`、專案 `000_Agent/skills` symlink、Claude command shim。
- 移除 Claude 專用工具名稱 `AskUserQuestion`，改為 Codex 對話中的單題引導；若未來 Codex App 提供可用選項 UI，可用該 UI 呈現選項。
- 保留硬性閘門：使用者確認計劃前不實作、不 scaffold、不修改檔案。
- 保留四種溝通模式：小白、半技術、工程師、AI 判斷。
- 保留核心階段：確認主題、掃描上下文、列假設、深度釐清、方案比較、計劃書、下一步確認。
- 保存計劃書的預設位置改成 Codex 專案慣例：目前專案 `plans/`，或既有 `100_Todo/plans/`，或使用者指定路徑。

授權與致謝：原文標示「AI 規劃模式 by 雷小蒙」採 CC BY-NC-SA 4.0 個人使用自由、禁止商業用途；核心理念參考 obra/superpowers brainstorming skill（MIT License）。本檔只保存 Codex 相容改編摘要，不複製原始全文。
