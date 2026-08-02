# Project Handoff

## Current state

- Google Workspace MCP 已從 core read-only 改為可實際操作：wrapper
  `~/.codex/python-tools/bin/google-workspace-mcp-server` 與 LazyPack 主版本
  `200_Reference/lazy-pack/02-assets/google-workspace-mcp/run_google_workspace_mcp.sh`
  同步改為 `--permissions calendar:full drive:full gmail:full --tool-tier complete`。
  LaunchAgent 已重啟並監聽 `127.0.0.1:8000`，工具數由唯讀清單擴為 38 支，
  只載入 calendar／drive／gmail 三服務，未含 Docs／Sheets／Slides。
- OAuth 已由使用者重新完成同意，憑證從 6 個 readonly scope 換成 15 個
  （含 `gmail.send`、`gmail.modify`、`drive`、`calendar`），refresh token 存在，
  仍只存放於 `~/.codex/secrets/google_workspace_mcp_credentials`，權限 600。
- LazyPack Item 02 文件已標明目前設定是使用者明確要求的擴權結果，不是安裝預設；
  新環境仍從 core read-only 起步。Obsidian 懶人包鏡像 `diff -qr` 為 0。
- 全域主檔 `codex_symlink/core-rules.md` 新增「Google 服務接取預設路由
  （MCP 優先於 Connectors）」；Codex、Claude、AntiGravity 三個入口都已驗證讀得到。
  既有 Google 與 Notion connectors 依使用者決定保留，不關閉。
- chezmoi source `~/.local/share/chezmoi` 已建立首個 commit `b6d517c`
  （16 檔／189 行，三 Agent 入口 templates、Python bridge、shell profile
  modify_ scripts），工作樹乾淨。
- chezmoi source 已依使用者要求建立 private remote
  `icestone0128/chezmoi-agent-sync` 並 push；本地 `main` tracking `origin/main`，
  0 ahead／0 behind。推送前掃描確認 source 只含 templates／modify_ scripts／
  env loader，無 secret pattern、無 email、無機器專屬絕對路徑
  （`syncRoot`、`pythonToolsHome` 由 `promptStringOnce` 存在本機 config）。
- `.bash_profile` 的 chezmoi 漂移已 apply 修正（僅區塊順序），先備份到
  `~/.bash_profile.backup-20260802-115112`。修正後 `agent-python-tools` loader
  在 doc-to-md 之後才 prepend PATH，`doc-to-md` 與 `python-tools-python` 均解析到
  共用中立入口 `~/.local/share/agent-tools/python-tools/bin/`，符合全域規則。
- 開工 checkpoint 的 update 閘門已解除：`CHEZMOI_STATUS=clean` →
  `CHEZMOI_UPDATE=complete`，不再是 `skipped:no-remote`。
- LazyPack Item 16 已新增「建立 private remote 與新電腦從 remote 重建（選配）」
  一節，內容為通用佔位符寫法，未寫入個人 repo URL。
- `100_Todo/projects/tool-integration/2026-05-20-tool-integration-plan.md` 已複審：
  原決策原則寫「Codex connector 優先於 MCP」，與 `core-rules.md` 的 Google MCP-first
  路由相反，已改為 MCP 優先並加上複審說明段落。Google Drive／Gmail／Calendar
  三個 connector 區塊合併為單一「Google Workspace（MCP-first）」區塊；
  GitHub 與 Obsidian 兩項本次實測複驗通過。未勾選項由 39 降為 18，
  且全部為「有需求時才做」，無積壓待辦。尾段指引改為三 Agent 中性寫法，
  並更正原本指向從未建立的 `200_Reference/tool-capabilities.md`。
- `sync-health.sh` 本次結果：0 failures、1 warning（即本次未 commit 檔案）。
  三 Agent 10 個入口 symlink、Python bridge／loader／四個 shell profile、
  chezmoi managed entrypoints、78 個 SKILL.md、LazyPack 鏡像、secret 掃描全部 PASS。

## Next action

- google-workspace MCP 38 支工具已於 2026-08-02 session 重載後確認可見
  （含 `send_gmail_message`、`create_drive_file`、`manage_event`），此項結案。
  仍未以真實資料測試寫入或寄信；首次實際寫入前逐次向使用者確認。
- 本檔無積壓待辦。tool-integration 計畫已結案，除非新增工具或既有路線失效，
  否則不需再開啟；下次複審先核對 `core-rules.md` 是否又有路由變更。
- 可考慮但非必要：活躍 MCP server 數已超過 `context-management-strategy.md`
  建議的 10 個上限，Google 三項在 MCP 與 connector 之間功能重疊。
  使用者已決定保留 connectors，不自行關閉；要調整需使用者明確要求。
- 新電腦重建指令：
  `chezmoi init --apply https://github.com/icestone0128/chezmoi-agent-sync.git`，
  會提示輸入該機 `syncRoot` 與 `pythonToolsHome`；Python runtime 仍須由
  Item 34 於該機重建，不從 remote 拉 venv／模型／cache。

## Blockers

- 無。

## Last verified

- 2026-08-02，Claude Code Desktop：google-workspace MCP 以新參數啟動並綁定
  8000，`workspace-cli list` 回報 38 tools 且含寫入工具；Calendar 與 Drive
  唯讀 smoke test 通過，未以真實資料測試寫入或寄信。
- 2026-08-02，Claude Code Desktop：OAuth 憑證 15 scopes、refresh token 存在、
  檔案權限 600；repo LazyPack 與 Obsidian 懶人包鏡像 `diff -qr` 為 0；
  `git diff --check` 通過，公開 diff secret-pattern scan 無命中。
- 2026-08-02，Claude Code Desktop：`~/.claude/CLAUDE.md`、`~/.codex/AGENTS.md`、
  `~/.gemini/GEMINI.md` 三個 symlink 均解析到 `codex_symlink/core-rules.md`，
  新規則在三個入口都命中。
- 2026-08-02，Claude Code Desktop：chezmoi remote 建立後
  `gh repo view` 回報 `PRIVATE`、default branch `main`；重跑開工 checkpoint 得到
  `CHEZMOI_STATUS=clean`、`CHEZMOI_UPDATE=complete`（`Already up to date.`），
  入口備份寫入 `~/agent-sync-backup-20260802-115131/session-startup`；
  bootstrap dry-run 三 Agent 9 個入口 symlink 與 Python bridge 全數 OK；
  `bash -lc` 驗證 `doc-to-md`、`python-tools-python` 解析到共用中立入口。
- 2026-08-02，Claude Code Desktop：`sync-health.sh` 0 failures／1 warning；
  Arry 助手 `knowledge/` `diff -qr` 為 0，`memories/` 第一層 4 檔一致；
  repo LazyPack 與 Obsidian `懶人包/` `diff -qr` 為 0；`git diff --check` 通過，
  commit 前 diff secret-pattern scan 無命中。
