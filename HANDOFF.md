# Project Handoff

## Current state

- LazyPack 已全面移除寫死的軟體版本：安裝器一律在安裝當下取最新版（npm `@latest`、pip／uv 不鎖版本並加 `--upgrade`、GitHub release 查最新版並用 release 公布的 SHA-256 驗證、git 來源追蹤上游預設分支）。四類例外（Python 相容上限、範本 CDN 網址、最低需求、上游審查 commit）寫在 `AGENTS.md`，由新增的 `200_Reference/scripts/check-lazypack-version-pins.py` 把關，`shutdown-sync` 第 5 步已納入。目前 0 個寫死版本（舊版測得 79 處）。
- 本機工具全部升到當下最新：Homebrew 70 個 formula 加 codex、macwhisper；npm 的 gemini-cli、netlify-cli、npm、wrangler；Node 25→26、npm 11→12、FFmpeg 8→9 三個大版本；Python 3.14.7 與 uv 管理的 3.12.14；chezmoi、Claude Code CLI、Codex CLI、Obsidian 安裝程式 1.13.7。
- `heptabase-cli` skill 依上游 `heptameta/heptabase-cli-skills`（MIT，commit `0716461`）升到 CLI 相容範圍 `0.6.x`，新增 4 份 references 與 LICENSE，保留本機的中文 description、AI Tutor 章節與 `local-file add` recipe。
- Claude 補上 `notebooklm` 與 `obsidian` 兩個 MCP，三個 Agent 一致；`nlm` 升到 0.11.6、`mcpvault` 升到 0.16.0。因應 nlm 的下載限制修補，三個 adapter 都設了 `NOTEBOOKLM_DOWNLOAD_DIR`。LazyPack Item 06、07 補上安裝步驟與三 Agent adapter。
- 新增每週自動更新：`200_Reference/scripts/weekly-update-check.sh` 加 Claude 排程任務 `weekly-update-check`（每週日 06:00，系統加幾分鐘抖動）。涵蓋所有 Homebrew formula／cask、npm 全域、uv 工具與 Python、Item 34 共用 Python 工具包、Google Workspace MCP；cask 安裝檔先用可續傳 curl 下載並比對 SHA-256，升級前以正常方式關閉對應 App、升級後重開。`~/.claude/settings.json` 已加只放行這支腳本的 allow 規則（設定變更需重開 App 生效）。
- 修掉 Item 34 安裝器兩個既有 bug：`uv venv` 未加 `--allow-existing` 導致重跑必失敗；bash 3.2 在 `set -u` 下展開空陣列報 unbound。修好後共用 venv 套件才首次真正更新（auto-editor 31.6.0、groq 1.7.0、elevenlabs 2.68.0、yt-dlp 2026.8.19）。

## Next action

1. 重開 Claude App 讓 `settings.json` 的 allow 規則生效，並確認 9/27（日）06:08 的排程執行不再停在權限提示。
2. 做影片前先用小樣本驗證 FFmpeg 9 的字幕燒錄、`loudnorm` 與 `sidechaincompress`；本輪只確認版本可執行，沒有實際渲染。
3. 視需要把 `doc-to-md`、`vlm-to-md` 兩個仍使用系統 Python 3.9.6 的 runtime 改到共用 3.12 環境重建。

## Blockers

沒有技術阻塞。

## Last verified

2026-09-23 09:00 CST，Claude（Opus 5）：`weekly-update-check.sh --apply` 失敗步驟 0；`sync-lazypack-embeds.py --dry-run` 41 identical／0 to change；`lazypack-knowledge-embeds.py` 11 identical／0 to change；`check-lazypack-version-pins.py` 0 version pin(s)；repo LazyPack 與 Obsidian 懶人包 `diff -qr` 一致；Arry 助手鏡像 `diff -qr` 通過；Google Workspace MCP 監聽中、Claude 9 個 MCP 全連線、共用 Python 工具包驗證通過；6 個 commit 已推送至 `origin/main`（最新 `b1bb5bd`）。
