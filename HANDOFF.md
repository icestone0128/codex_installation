# Project Handoff

## Current state

2026-09-17 完成一輪外部教材比對整合，全部已推送至 `origin/main`（改寫歷史後的 HEAD `fad9a77`）：

- 危險指令攔截：Claude deny 新增萬用字元規則，補擋旗標在後的 force push／`reset --hard`／`branch -D`（主檔 `cross-device-sync/assets/agent-guardrails.json`）；Codex 前綴比對限制照舊記錄。
- 規則：刪使用者檔案改用 `trash`；提問選項不做假輸入框；commit／push 前新增 `gh repo view` 可見性實查、只 add 指定檔案、50 MB 大檔掃描；第三方教材整合規則放回，出處只記在私有位置不進 GitHub。
- Google Workspace MCP：Codex、Claude、AntiGravity 統一走本機 `127.0.0.1:8000/mcp`；Codex 同義 Google plugins 停用；權限擴為 calendar／drive／gmail／docs／sheets／slides，OAuth 已重新同意。Item 02 安裝腳本支援 `--agent all|claude|codex|antigravity`。
- `cross-device-sync`：開工／收工 checkpoint 新增唯讀 `audit-agent-parity.py`（三 Agent 必要 MCP、Codex 同義 plugins、`AGENTS.override.md`）。
- Git 歷史已改寫移除外部教材出處字樣，201 個 commit 保留、最新檔案樹不變；本機已 `reset --hard origin/main` 對齊。

## Next action

1. 重新載入 AntiGravity，請它列出 Google 日曆，確認 `mcp_config.json` 的 `serverUrl` 設定實際可用；通過後在 Obsidian 駕駛艙標記完成。
2. 待決定：回報與驗收紀律（四種回報狀態、含糊字眼自查、大任務新對話驗收）寫進規則；每週協作復盤做成新 skill（需 `codex-skill-creator` 訪談）。
3. LazyPack Item 09 內嵌的 `agent-execution-strategy.md`、`context-management-strategy.md` 與主版本不一致，主版本含個人項目，需去識別化後再同步。

## Blockers

無。AntiGravity 驗證需要使用者在 App 內重新載入。

## Last verified

2026-09-17 23:35 CST，Claude（Claude Code 桌面版）：`origin/main` 與本機皆為 `fad9a77`、工作區乾淨；遠端歷史外部教材字樣 0；Claude 實測 Calendar／Sheets／Docs／Slides API 讀取成功，Codex `codex exec` 實測 Sheets／Slides 成功；`sync-lazypack-embeds` 40 identical；checkpoint `MCP_PARITY required_missing=none`、`CODEX_DUP enabled_duplicates=none`、`OVERRIDE agents_override=none`。
