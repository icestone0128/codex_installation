# 28-Netlify-Deploy-Skill-安裝

> 版本：2026-06-03 Codex App 版
> 用途：安裝 `netlify-deploy` 全域 skill，並把官方 Netlify MCP server 加入 Codex App，讓 Codex 可用 Netlify 作為額外部署空間。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/netlify-deploy/`。

## 來源與歷史紀錄

- 初次同步日期：2026-06-03。
- 來源 repo：https://github.com/mathruffian-dot/clasp-netlify-mcp-guide
- 來源 commit：`460c86b`。
- 官方 Netlify MCP：`@netlify/mcp`。
- 本次查得 npm 版本：`@netlify/mcp` 1.15.1。
- 本機已安裝 Netlify CLI：`netlify-cli/26.1.0 darwin-arm64 node-v25.9.0`。
- 本機 CLI 路徑：`/opt/homebrew/bin/netlify`。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/netlify-deploy/SKILL.md`。

## Codex 相容化調整

- 保留來源 repo 的 Clasp + Netlify 閉環部署思路與踩坑清單。
- 將來源中的非 Codex agent / tool 名稱轉成 Codex App MCP 設定。
- 正式 MCP route 改用 Netlify 官方 `@netlify/mcp`。
- 不內嵌 Netlify PAT、Google OAuth token、GitHub token 或任何 private key。
- 使用 `NPM_CONFIG_CACHE=/private/tmp/npm-cache` 避免 npm cache 權限問題。

## Netlify MCP 安裝

在 `{{CODEX_CONFIG}}` 加入：

```toml
[mcp_servers.netlify]
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "npx", "-y", "@netlify/mcp"]
startup_timeout_sec = 60
tool_timeout_sec = 180
```

修改後開新 Codex 對話或重啟 Codex App，讓 MCP server 重新載入。

## Netlify CLI 安裝

Netlify CLI 用來做本機登入、帳號狀態檢查與部署 troubleshooting。MCP 是 Codex 的工具通道；CLI 是本機輔助工具。

安裝：

```bash
NPM_CONFIG_CACHE=/private/tmp/npm-cache npm install -g netlify-cli
```

驗證：

```bash
command -v netlify
netlify --version
netlify status
```

本機 2026-06-03 驗證結果：

```text
/opt/homebrew/bin/netlify
netlify-cli/26.1.0 darwin-arm64 node-v25.9.0
Not logged in. Please log in to see project status.
```

注意：在 Codex sandbox 內直接執行 `netlify --version` 或 `netlify status`，可能因 CLI 需要寫入 `~/Library/Preferences/netlify/` 而出現 `EPERM`。這不是安裝失敗；需要時用外部執行權限或一般 Terminal 驗證。

## 前置條件

- Node.js 22 或更新版本。
- Netlify 帳號。
- 建議安裝 Netlify CLI：`NPM_CONFIG_CACHE=/private/tmp/npm-cache npm install -g netlify-cli`。
- 若 Netlify MCP 登入狀態不穩，先用 `netlify login` 與 `netlify status` 驗證。

## 安裝方式

1. 將上方 `netlify` MCP 區塊加入 `{{CODEX_CONFIG}}`。
2. 打開本文文末「內建 Skill 完整安裝內容」。
3. 把整段安裝腳本複製到自己的環境執行。
4. 執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。
5. 開新 Codex 對話或重啟 Codex App。

## 使用方式

- 「幫我用 Netlify 部署這個前端」
- 「幫我建立 Netlify MCP 部署流程」
- 「幫我把 Clasp + Google Sheets API 的前端部署到 Netlify」
- 「幫我檢查 Netlify MCP 是否能用」

## 驗證

```bash
node --version
env NPM_CONFIG_CACHE=/private/tmp/npm-cache npm view @netlify/mcp version
command -v netlify
netlify --version
test -f "{{CODEX_HOME}}/skills/netlify-deploy/SKILL.md" && echo "netlify-deploy SKILL.md ok"
test -f "{{CODEX_HOME}}/skills/netlify-deploy/references/source-adaptation.md" && echo "source adaptation ok"
test -f "{{CODEX_HOME}}/skills/netlify-deploy/references/source-original-readme.md" && echo "source original record ok"
test -f "{{CODEX_HOME}}/skills/netlify-deploy/references/clasp-netlify-pattern.md" && echo "clasp pattern ok"
```

開新 Codex 對話後，請 Codex 檢查是否有可用的 Netlify MCP tools。第一次部署前先做 read-only account/status 類動作，再建立 site 或 deploy。

## 踩坑

- `npx @netlify/mcp` 是 MCP stdio server，直接在 terminal 執行可能會等待 MCP client，不一定會印出 help。
- 如果 npm cache 顯示 root-owned file，先使用 `NPM_CONFIG_CACHE=/private/tmp/npm-cache`，不要為單次任務改 `~/.npm` 權限。
- 如果 `netlify` 在 Codex sandbox 內因 `~/Library/Preferences/netlify/` 回報 `EPERM`，改用外部執行權限或一般 Terminal 驗證；不代表 CLI 未安裝。
- 若 Netlify auth 不穩，優先用 Netlify CLI 登入；PAT 只作為本機暫時 workaround，不寫進 repo 或筆記。
- Apps Script 專案若還沒啟用 Apps Script API，`clasp create` 會失敗，需要使用者到 Google Apps Script user settings 手動開啟。
- `.claspignore` 必須阻止前端 browser files 被推送到 Apps Script server。

## 最終檢查清單

- [ ] `{{CODEX_CONFIG}}` 有 `[mcp_servers.netlify]`。
- [ ] `netlify --version` 可顯示 CLI 版本。
- [ ] `{{CODEX_HOME}}/skills/netlify-deploy/SKILL.md` 存在。
- [ ] references 三個檔案存在。
- [ ] 開新 Codex 對話或重啟後能看到 Netlify MCP tools。
- [ ] Netlify token / Google token / GitHub token 未寫入 repo、skill、LazyPack 或 Obsidian。

## 官方參考

- [Netlify MCP Server Docs](https://docs.netlify.com/build/build-with-ai/netlify-mcp-server/)
- [clasp-netlify-mcp-guide GitHub](https://github.com/mathruffian-dot/clasp-netlify-mcp-guide)

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`netlify-deploy`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

```bash
set -e

# ---- netlify-deploy ----
mkdir -p "{{CODEX_HOME}}/skills/netlify-deploy"

# netlify-deploy/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/netlify-deploy/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/netlify-deploy/SKILL.md" <<'CODEX_LAZYPACK_NETLIFY_DEPLOY_SKILL_MD'
---
name: netlify-deploy
description: Use when installing, verifying, or using Netlify MCP in Codex App, deploying static/frontend projects to Netlify, or building a Clasp Google Apps Script plus Netlify frontend deployment workflow.
metadata:
  short-description: Netlify deploy workflow
---

# Netlify Deploy

Use this skill when the user asks to install Netlify MCP, deploy a site to Netlify, add Netlify as an extra deployment target, or build a frontend plus Google Sheets / Apps Script backend workflow that deploys the frontend through Netlify.

## Route

- Prefer the official Netlify MCP server: `@netlify/mcp`.
- Codex App MCP config belongs in `{{CODEX_CONFIG}}`, usually `{{CODEX_HOME}}/config.toml`.
- Use this Codex TOML shape:

```toml
[mcp_servers.netlify]
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "npx", "-y", "@netlify/mcp"]
startup_timeout_sec = 60
tool_timeout_sec = 180
```

- Do not use source-tool commands such as `claude mcp add` in Codex.
- Do not hard-code or commit `NETLIFY_PERSONAL_ACCESS_TOKEN`. Prefer browser / CLI login first. If a PAT is unavoidable, keep it only in the local MCP config or a local secret store and never in repo, skills, Obsidian, screenshots, or chat summaries.

## Prerequisites

- Node.js 22 or newer.
- Netlify account.
- Codex App restarted, or a new Codex conversation opened, after editing MCP config.
- Netlify CLI is optional but recommended for login troubleshooting: `npm install -g netlify-cli`, then `netlify login` and `netlify status`.

## Netlify CLI

Install the CLI when the user wants local login, account checks, or deployment troubleshooting outside the MCP tool surface:

```bash
npm install -g netlify-cli
netlify --version
netlify status
```

Use `NPM_CONFIG_CACHE=/private/tmp/npm-cache` if npm cache permissions are broken. In Codex sandboxed runs, `netlify --version` and `netlify status` may fail when the CLI tries to write `~/Library/Preferences/netlify/`; rerun those verification commands outside the sandbox when needed.

## Use Workflow

1. Check the project deployment target and output folder.
2. Confirm there is no secret in frontend code, `.env`, build output, or config examples.
3. If Netlify MCP tools are available in the session, use the smallest safe action:
   - read account / team status first;
   - create a new site only after confirming the target name and team;
   - deploy only the intended public output folder.
4. If MCP tools are not yet available, tell the user to restart Codex App or open a new conversation after the config edit.
5. For static projects, deploy the built output folder such as `dist/`, `build/`, `public/`, or a confirmed frontend folder.
6. After deployment, report the Netlify public URL and whether it is production or draft/preview.

## Clasp + Netlify Pattern

Use this pattern when the user wants a zero-copy loop: frontend on Netlify, Google Sheets as data storage, Apps Script Web App as API.

1. Keep backend Apps Script files separate from frontend files.
2. Use `.claspignore` so Clasp only pushes Apps Script backend files and `appsscript.json`.
3. In frontend code, keep the Apps Script API URL as a placeholder until deployment returns a real URL.
4. Run Clasp login/create/push/deploy only after the user completes Google authorization.
5. Inject the final Apps Script Web App URL into frontend config before the Netlify deploy.
6. Deploy frontend through Netlify MCP, not through Apps Script.

## Troubleshooting

- If npm cache errors mention root-owned files, use `NPM_CONFIG_CACHE=/private/tmp/npm-cache` rather than changing `~/.npm` ownership during the task.
- If `netlify` fails inside Codex with `EPERM` under `~/Library/Preferences/netlify/`, rerun the CLI check outside the sandbox; the install can still be valid.
- If Netlify auth is unstable, verify with `netlify status` or `netlify login`; use PAT only as a temporary local workaround.
- If Netlify MCP deploy says state data is missing, create or identify the target site first, then deploy with the site ID.
- If Apps Script API is disabled, ask the user to enable it in Google Apps Script user settings before retrying Clasp create/deploy.
- If frontend requests to Apps Script fail in a browser with multiple Google accounts, test in an incognito or clean browser session.

## References

- `references/source-adaptation.md`: how the source repo was converted into this Codex skill.
- `references/source-original-readme.md`: source README provenance and extracted original checklist.
- `references/clasp-netlify-pattern.md`: portable Clasp plus Netlify checklist.
CODEX_LAZYPACK_NETLIFY_DEPLOY_SKILL_MD

# netlify-deploy/references/source-adaptation.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/netlify-deploy/references/source-adaptation.md")"
cat > "{{CODEX_HOME}}/skills/netlify-deploy/references/source-adaptation.md" <<'CODEX_LAZYPACK_NETLIFY_DEPLOY_SOURCE_ADAPTATION_MD'
# Source Adaptation

Source repo: `https://github.com/mathruffian-dot/clasp-netlify-mcp-guide`

Source commit inspected: `460c86b Initialize clasp-netlify-mcp-guide with complete Agent setup instructions and troubleshooting tips`

Inspected date: 2026-06-03.

## What Was Kept

- The deployment intent: a frontend deployed to Netlify, with Google Sheets accessed through an Apps Script Web App API.
- The safety rules: do not commit Netlify tokens, GitHub tokens, OAuth secrets, Google account details, deployment IDs that should stay private, or `.env` files.
- The `.claspignore` warning: frontend files must not be pushed into Apps Script as server code.
- The operational order: prepare backend and frontend files, deploy Apps Script, inject the Apps Script URL, then deploy frontend to Netlify.
- The troubleshooting cases around Apps Script API enablement, first-run authorization, Netlify site creation before deploy, and browser multi-account confusion.

## Codex Changes

- Replaced non-Codex client wording with Codex App MCP configuration.
- Replaced older tool names such as `netlify-project-services-updater` and `netlify-deploy-services-updater` with the current official Netlify MCP package, `@netlify/mcp`.
- Removed source-tool command assumptions such as `claude mcp add`.
- Added npm cache isolation with `NPM_CONFIG_CACHE=/private/tmp/npm-cache`, matching this LazyPack's MCP pattern.
- Added explicit restart/new-conversation guidance because Codex only loads new MCP servers after config reload.
- Kept Netlify PAT as a local-only fallback, not an installer requirement.

## Current Official Netlify MCP Route

Codex TOML:

```toml
[mcp_servers.netlify]
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "npx", "-y", "@netlify/mcp"]
startup_timeout_sec = 60
tool_timeout_sec = 180
```

Official Netlify docs currently list Node.js 22+, a Netlify account, and an MCP client as prerequisites, and show the MCP server command as `npx -y @netlify/mcp`.
CODEX_LAZYPACK_NETLIFY_DEPLOY_SOURCE_ADAPTATION_MD

# netlify-deploy/references/source-original-readme.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/netlify-deploy/references/source-original-readme.md")"
cat > "{{CODEX_HOME}}/skills/netlify-deploy/references/source-original-readme.md" <<'CODEX_LAZYPACK_NETLIFY_DEPLOY_SOURCE_ORIGINAL_README_MD'
# Source README Record

Source repo: `https://github.com/mathruffian-dot/clasp-netlify-mcp-guide`

Source commit inspected: `460c86b`.

The source repo contains one main `README.md`. This reference preserves the source provenance and the original workflow concepts in a Codex-portable form. The operational instructions in `SKILL.md` and `source-adaptation.md` are the authoritative Codex version.

## Original Checklist Concepts

- Prepare local files before cloud deployment.
- Keep Apps Script backend files separate from frontend browser files.
- Use `appsscript.json` for Apps Script Web App configuration.
- Use `.claspignore` to prevent frontend files from being pushed to Apps Script.
- Use Clasp to log in, create the Apps Script project, push backend files, deploy the Web App, and identify the Web App URL.
- Inject the Apps Script Web App URL into frontend code only after the URL exists.
- Create a Netlify site before deploying frontend files.
- Deploy the frontend folder to Netlify and report the public URL.

## Original Troubleshooting Themes

- Apps Script API may need to be enabled manually.
- Frontend files pushed into Apps Script can cause DOM-related server errors.
- Apps Script projects may require first-run authorization in the browser.
- Netlify deploy requires a known site ID or an existing site.
- Browser sessions with multiple Google accounts can confuse Apps Script Web App tests; use an incognito or clean session for verification.

## Security Themes

- Do not commit Netlify PATs.
- Do not commit GitHub tokens.
- Do not commit OAuth secrets or Google account credentials.
- Do not hard-code deployment secrets into frontend code.
CODEX_LAZYPACK_NETLIFY_DEPLOY_SOURCE_ORIGINAL_README_MD

# netlify-deploy/references/clasp-netlify-pattern.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/netlify-deploy/references/clasp-netlify-pattern.md")"
cat > "{{CODEX_HOME}}/skills/netlify-deploy/references/clasp-netlify-pattern.md" <<'CODEX_LAZYPACK_NETLIFY_DEPLOY_CLASP_NETLIFY_PATTERN_MD'
# Clasp + Netlify Pattern

This checklist is for projects where Netlify hosts the frontend and Google Apps Script exposes a Google Sheets-backed API.

## File Layout

Recommended split:

```text
project/
├── appsscript.json
├── gas_code.js
├── .claspignore
└── web/
    ├── index.html
    ├── style.css
    └── app.js
```

Use a different frontend folder if the project already has one. Do not move files just to match this template.

## Apps Script Side

`appsscript.json` must describe the Apps Script Web App deployment. Use the least broad scopes that work for the project.

`.claspignore` should exclude frontend files and allow only backend Apps Script files:

```text
**
!appsscript.json
!gas_code.js
```

If the backend uses multiple `.gs` or `.js` files, allow only those backend files explicitly.

## Frontend Side

Keep the Apps Script endpoint as a placeholder until deployment produces the final URL:

```js
const GAS_API_URL = "YOUR_GAS_API_URL_HERE";
```

After `clasp deploy`, inject the real Web App URL into frontend config, then deploy the frontend folder to Netlify.

## Verification

- `npx clasp push -f` succeeds and does not upload frontend browser files.
- `npx clasp deploy --description "Production Web App"` returns a deployment ID.
- The Apps Script Web App URL responds to a low-risk `GET` or health-check request.
- Netlify MCP deploy returns a public URL.
- The Netlify page can call the Apps Script API from an incognito or clean browser session.

## Safety

- Do not commit `.clasprc.json`, `.env`, Netlify PATs, Google OAuth secrets, or generated local auth files.
- Do not put a Netlify PAT in this skill package, LazyPack, README, or Obsidian notes.
- Treat public Netlify URLs as shareable, but do not expose private deployment metadata unless the user asks.
CODEX_LAZYPACK_NETLIFY_DEPLOY_CLASP_NETLIFY_PATTERN_MD
```
