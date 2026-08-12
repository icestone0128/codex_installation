# 28-Netlify Deploy Skill 安裝

> 版本：2026-08-12
> 定位：Netlify MCP／CLI 、靜態前端部署，以及「已驗證 Apps Script Web App 後端」與 Netlify 前端的交接邊界。

## 2026-08-12 邊界調整

- `netlify-deploy` 只負責 Netlify 的安裝、登入、site 連結、preview／production 部署與驗證。
- Apps Script 的 OAuth、clone／pull、manifest、`.claspignore`、push、deployment 與 Web App URL 取得，改由 [[41-Clasp-Apps-Script-Skill-安裝]] 的 `clasp-setup` 負責。
- 兩者交接只傳遞「clasp API 返回的 Web App URL＋HTTP contract」；不傳遞 `.clasprc.json`、script ID、OAuth 狀態或未驗證 URL。
- 2026-06 的 Clasp + Netlify 實作紀錄保留在 package 的 provenance reference，不再是 Item 28 的執行主線。

## 來源與轉換

- 最初參考：[mathruffian-dot/clasp-netlify-mcp-guide](https://github.com/mathruffian-dot/clasp-netlify-mcp-guide)
- Netlify 現行路線：官方 `@netlify/mcp` 與 Netlify CLI。
- 三 Agent 共用目標、安全邊界與驗收；Codex、Claude、AntiGravity 只在各自原生 MCP 設定面有 adapter 差異。

## 前置條件

- 使用當前 `@netlify/mcp` package 要求的 Node.js 版本；不用舊文件的固定版本代替 live package 規格。
- Netlify 帳號。
- 如要用 MCP，要用當前 Agent 支援的原生設定面加入 `npx -y @netlify/mcp`，改完後開新對話或重啟對應 App。
- 如要串接 GAS，先完成 Item 41，並確認 Web App URL 與 HTTP contract。

## 安裝

本 Item 文末已內嵌完整 `netlify-deploy` package。先完成 Item 16 的 `{{SYNC_ROOT}}` 與三 Agent 原生入口，再執行文末安裝區塊。

Netlify MCP 執行入口：

```bash
npx -y @netlify/mcp
```

Netlify CLI 可選安裝：

```bash
npm install -g netlify-cli
netlify login
netlify status
```

`login`、site 建立、link、環境變數與部署都會改變外部狀態；要先確認 team、site、output folder 與 preview／production。

## Apps Script 後端交接

1. 只接受 Item 41 返回的 Web App URL，不從 `.clasp.json` 組合 URL。
2. 確認端點的公開性、執行身分、action／fields、錯誤格式、quota 與測試資料清理方式。
3. Apps Script 主機頁面可使用 `google.script.run`；Netlify 外部頁面不可使用，必須依 CORS、redirect、認證與資料敏感度選擇 `fetch`、只限公開低風險 GET 的 JSONP，或 server-side proxy。
4. 前端無法保存 secret；不把 token、OAuth 狀態、個資或特權 mutation 放進 query string、JSONP、source 或 build output。
5. 先做 local preview 與一次低風險端到端驗證，再依授權部署 Netlify preview 或 production。

## 唯讀驗證

```bash
npm view @netlify/mcp version engines --json
npx -y @netlify/mcp --help
test -f "{{SYNC_ROOT}}/skills/netlify-deploy/SKILL.md"
test -f "{{SYNC_ROOT}}/skills/netlify-deploy/references/clasp-netlify-pattern.md"
```

實際登入、建立 site 或部署不是安裝驗收的必要條件。

## 安全邊界

- 不把 Netlify PAT、`.env`、`.netlify/`、Google OAuth 或 `.clasprc.json` 寫入 LazyPack、Obsidian、repo 或對話摘要。
- production 部署一律逐次確認。
- GAS 專案目標、push 清單、deployment 與 OAuth 異常回到 Item 41 處理，不在 Item 28 重複實作。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`netlify-deploy`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- netlify-deploy ----
mkdir -p "{{SYNC_ROOT}}/skills/netlify-deploy"
# netlify-deploy/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/netlify-deploy/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/netlify-deploy/SKILL.md" <<'AGENT_LAZYPACK_NETLIFY_DEPLOY_SKILL_MD_0E95F5A366'
---
name: netlify-deploy
description: Use when installing, verifying, or using Netlify MCP or CLI from Codex, Claude, or AntiGravity, deploying static/frontend projects to Netlify, or connecting a Netlify frontend to an already prepared Google Apps Script Web App backend.
metadata:
  short-description: Netlify deploy workflow
---

# Netlify Deploy

Use this skill when the user asks to install Netlify MCP, deploy a site to Netlify, add Netlify as an extra deployment target, or connect a Netlify frontend to a verified Apps Script Web App. Use `clasp-setup` for Apps Script login, source synchronization, push, and deployment.

## Route

- Prefer the official Netlify MCP server: `@netlify/mcp`.
- Netlify's official guidance recommends adding the MCP server locally at the project root when the active MCP client supports project-local config. Verify the active Agent's current native MCP settings before editing it.
- Codex adapter: `{{CODEX_CONFIG}}`, usually `{{CODEX_HOME}}/config.toml`, may use this TOML shape:

```toml
[mcp_servers.netlify]
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "npx", "-y", "@netlify/mcp"]
startup_timeout_sec = 60
tool_timeout_sec = 180
```

- Claude adapter: configure `@netlify/mcp` through Claude's currently supported native MCP surface; verify with current local help or official documentation instead of translating Codex TOML literally.
- AntiGravity adapter: configure `@netlify/mcp` through AntiGravity's currently supported native MCP surface; verify with current local help or official documentation instead of translating Codex TOML literally.
- All adapters use the same package name, auth boundary, project/team/site confirmations, and deployment verification.
- Do not hard-code or commit `NETLIFY_PERSONAL_ACCESS_TOKEN`. Prefer browser / CLI login first. If a PAT is unavoidable, keep it only in the local MCP config or a local secret store and never in repo, skills, Obsidian, screenshots, or chat summaries.

## Official MCP and CLI Usage Principle

- Treat Netlify MCP as the active Agent's native route when its tools are loaded. Use it for agent-managed actions such as reading user/team/site context, creating or managing projects, creating environment variables or secrets on Netlify, and deploying the confirmed output folder.
- Treat Netlify CLI as the local operator route. Use it for login and account checks, troubleshooting MCP authentication, linking a local folder to an existing site, checking deploy behavior, and fallback manual deploys when MCP tools are not loaded.
- Keep the two routes complementary: install the CLI because Netlify recommends it for MCP usage and troubleshooting, but do not replace MCP with CLI when the MCP tools are available and the task is an agent-managed deployment.
- Before any create, link, environment-variable, or production deploy action, confirm the Netlify team, site name or site ID, output folder, deploy context, and whether the action is production or draft/preview.
- Use browser / CLI login as the default auth route. Use a PAT only as a temporary local workaround for MCP authentication issues, and remove it from local MCP config when it is no longer needed.
- Do not copy Netlify auth state, local CLI preferences, `.netlify/`, `.env`, or token-bearing MCP config into LazyPack, Obsidian, screenshots, chat summaries, or a public repo.

## Prerequisites

- Node.js 22 or newer.
- Netlify account.
- The active Agent is restarted or opened in a fresh session after editing its MCP config.
- Netlify CLI is optional but recommended for login troubleshooting: `npm install -g netlify-cli`, then `netlify login` and `netlify status`.
- For smoother Codex sandboxed npm / Netlify CLI checks, add only `~/.npm` and
  `~/Library/Preferences/netlify` to the Codex sandbox config when the user's
  environment allows it. Clasp auth permissions belong to `clasp-setup`.

## Netlify CLI

Install the CLI when the user wants local login, account checks, site linking, fallback deploys, environment-variable management, or deployment troubleshooting outside the MCP tool surface:

```bash
npm install -g netlify-cli
netlify login
netlify --version
netlify status
```

Use `NPM_CONFIG_CACHE=/private/tmp/npm-cache` if npm cache permissions are
broken or the current Codex sandbox has not been granted `~/.npm` write access.
In Codex sandboxed runs, `netlify --version` and `netlify status` may fail when
the CLI tries to write `~/Library/Preferences/netlify/`; either add that path to
the sandbox writable roots and restart/open a new Codex conversation, or rerun
those verification commands outside the sandbox when needed.

## Codex Adapter: Sandbox Writable Roots

When npm / npx or Netlify CLI checks are repeatedly blocked by
the Codex sandbox, keep the permission change narrow. Add only the
tool-specific cache or preferences folder to `{{CODEX_CONFIG}}` under
`[sandbox_workspace_write].writable_roots`:

```toml
[sandbox_workspace_write]
network_access = true
writable_roots = [
  "{{HOME}}/.npm",
  "{{HOME}}/Library/Preferences/netlify",
  "<existing project roots>"
]
```

After editing an Agent's adapter config, start a fresh Codex, Claude, or
AntiGravity session before testing again. Restart only the Agent whose native
config changed. Do not add the whole home directory or Homebrew prefix just
to make npm easier; `npm install -g` can still require a separate approval
because it writes outside these narrow tool folders.

Common CLI fallback commands:

```bash
netlify link
netlify deploy --dir <output-folder>
netlify deploy --dir <output-folder> --prod
netlify env:list
```

Use CLI production deploys only after the user has confirmed `--prod`. For secrets, prefer Netlify's environment-variable or secrets controls rather than committing values to files.

## Use Workflow

1. Check the project deployment target and output folder.
2. Confirm there is no secret in frontend code, `.env`, build output, or config examples.
3. Check whether Netlify CLI login is healthy when auth state is unknown or MCP auth is unstable: `netlify status` or `netlify login`.
4. If Netlify MCP tools are available in the session, use the smallest safe action:
   - read account / team status first;
   - create a new site only after confirming the target name and team;
   - create or update environment variables only after confirming scope and context;
   - deploy only the intended public output folder.
5. If MCP tools are not yet available, restart or open a fresh session in the active Agent after its native config edit.
6. Use CLI fallback only when MCP tools are unavailable, when the user explicitly asks for terminal deployment, or when troubleshooting requires a direct CLI check.
7. For static projects, deploy the built output folder such as `dist/`, `build/`, `public/`, or a confirmed frontend folder.
8. After deployment, report the Netlify public URL and whether it is production or draft/preview.

## Compatibility and Availability Check

When auditing this skill, verify these surfaces without creating or deploying a project unless the user asks:

| Surface | Check | Expected result |
|---|---|---|
| Shared skill | `{{SYNC_ROOT}}/skills/netlify-deploy/SKILL.md` and its references exist through all native entrypoints | Skill package is readable by Codex, Claude, and AntiGravity |
| Netlify MCP config | Active Agent native config references `npx -y @netlify/mcp` in its supported format | The active Agent can load the MCP server after restart/fresh session |
| Netlify MCP package | `npm view @netlify/mcp version` | Package resolves from npm |
| Netlify CLI | `netlify --version` and `netlify status` | CLI is installed; login status is readable outside the Codex sandbox |
| Codex sandbox npm / Netlify CLI writes | `{{CODEX_CONFIG}}` writable roots include `~/.npm` and `~/Library/Preferences/netlify` when sandboxed checks should run directly | npm / npx and Netlify CLI can avoid temporary or external workarounds after a new Codex session |
| Netlify API through CLI | `netlify api getCurrentUser` | Read-only API call returns current user metadata |
| Apps Script handoff | `clasp-setup` has returned a verified Web App URL and HTTP contract | Netlify receives no clasp credential, script ID, or unverified endpoint |

If the Netlify MCP server is configured but no Netlify MCP tools are exposed in the current Agent session, open a fresh session or restart that Agent before declaring MCP unavailable.

## Apps Script Backend Handoff

Use this boundary only after `clasp-setup` has prepared and verified the Apps
Script backend.

1. Keep `frontend/` and `apps-script/` separate. The backend skill owns
   `.claspignore`, `appsscript.json`, source synchronization, and deployment.
2. Accept only the Web App URL returned from clasp's API-backed
   `open-web-app` command. Do not derive a URL from `.clasp.json` or accept a
   script ID as a deployment URL.
3. Confirm the HTTP contract: actions, fields, authentication, public/private
   audience, rate and quota expectations, error shape, and test-data cleanup.
4. Apps Script-hosted HTML may use `google.script.run`; an external Netlify
   frontend cannot. Use the Web App HTTP endpoint and choose `fetch`, JSONP, or a
   server-side proxy based on CORS, redirects, authentication, and data
   sensitivity. Never put sensitive payloads in query strings or JSONP.
5. Keep the endpoint in a build-time environment variable or explicit public
   config only after deciding that it is safe to expose. URLs are not secrets,
   but a public endpoint can still authorize unintended operations if backend
   checks are weak.
6. Run a local frontend preview and verify desktop/mobile layout, error states,
   and one low-risk backend action before deploying Netlify.
7. Create or link the Netlify site, confirm preview versus production, then
   deploy the intended frontend folder.
8. Verify the live page, the final endpoint reference, the low-risk end-to-end
   action, and removal of temporary test records.

The detailed separation, HTTP, and verification checklist remains in
`references/clasp-netlify-pattern.md`.

## Agent Execution Notes

- Shared steps: confirm team/site/output/deploy context, use the same auth
  boundary, deploy the same folder, and verify the same public URL and status.
- Codex adapter: use the TOML example and narrow sandbox writable roots above.
- Claude adapter: use Claude's verified native MCP configuration and permission
  prompts; use the shared Netlify CLI when MCP tools are not loaded.
- AntiGravity adapter: use AntiGravity's verified native MCP configuration and
  permission prompts; use the shared Netlify CLI when MCP tools are not loaded.
- Fallback: `netlify status`, `netlify link`, and preview/production deploy CLI
  commands provide the shared route after explicit production confirmation.
- Verification: require account/team readback, site identity, deploy context,
  public URL, HTTP response, and intended asset check for every adapter.

## Troubleshooting

- If npm cache errors mention root-owned files, first check whether the current
  Codex session has reloaded `~/.npm` as a writable root. If not, restart/open a
  new Codex conversation after the config edit. Use
  `NPM_CONFIG_CACHE=/private/tmp/npm-cache` only as a temporary workaround.
- If `netlify` fails inside Codex with `EPERM` under
  `~/Library/Preferences/netlify/`, add that preferences folder to the sandbox
  writable roots and restart/open a new Codex conversation; rerun outside the
  sandbox only when the config change is not available.
- If Netlify auth is unstable, verify with `netlify status` or `netlify login`; use PAT only as a temporary local workaround.
- If using a PAT temporarily, store it only in local MCP config or local secret storage, restart the MCP client, and remove it after browser / CLI auth works again.
- If Netlify MCP deploy says state data is missing, create or identify the target site first, then deploy with the site ID.
- If Apps Script login, source, deployment, or URL retrieval is incomplete, stop
  Netlify work and return to `clasp-setup` instead of improvising a backend URL.
- If Apps Script Web App `POST` requests redirect into a Google Drive "cannot
  open this file" HTML page, switch lightweight frontend writes to `GET` +
  JSONP or implement a server-side proxy. For public static Netlify frontends,
  JSONP is often the smallest working path for simple upsert/list/delete APIs.
- If `netlify deploy --site <site-name>` returns `Project not found`, run
  `netlify sites:create --name <site-name>` or `netlify link` first, then deploy
  with the generated local `.netlify/state.json`.
- If frontend requests to Apps Script fail in a browser with multiple Google accounts, test in an incognito or clean browser session.

## References

- `references/source-adaptation.md`: how the source repo was converted into the shared three-agent skill.
- `references/source-original-readme.md`: source README provenance and extracted original checklist.
- `references/clasp-netlify-pattern.md`: external Netlify frontend boundary for
  a backend prepared by `clasp-setup`.
AGENT_LAZYPACK_NETLIFY_DEPLOY_SKILL_MD_0E95F5A366

# netlify-deploy/references/clasp-netlify-pattern.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/netlify-deploy/references/clasp-netlify-pattern.md")"
cat > "{{SYNC_ROOT}}/skills/netlify-deploy/references/clasp-netlify-pattern.md" <<'AGENT_LAZYPACK_NETLIFY_DEPLOY_REFERENCES_CLASP_NETLIFY_PATTERN_MD_792A3F7818'
# Apps Script Backend To Netlify Frontend Boundary

Use this checklist only after `clasp-setup` has prepared and verified the Apps
Script Web App. This reference owns the integration boundary and Netlify side;
it does not own clasp login, source synchronization, push, or deployment.

## Required Handoff

Receive these facts from `clasp-setup` before changing or deploying the
frontend:

- the Web App URL returned by clasp's API-backed `open-web-app` command;
- whether the endpoint is public, authenticated, or domain-restricted;
- the supported actions, fields, response shape, and error shape;
- whether the app executes as the owner or the accessing user;
- a low-risk test case and the required test-data cleanup;
- rate, quota, privacy, and data-retention constraints.

Do not accept a script ID, a URL assembled from `.clasp.json`, raw OAuth state,
or a credential file as part of this handoff.

## Repository Separation

A combined repository can use this layout:

```text
project/
├── apps-script/
│   ├── appsscript.json
│   └── src/
├── frontend/
│   ├── index.html
│   └── src/
└── README.md
```

The Apps Script folder remains under `clasp-setup`. Netlify must deploy only the
confirmed frontend build output. Do not copy `.clasp.json`, `.clasprc.json`,
`appsscript.json`, backend source, or local OAuth files into the published
folder.

## Browser Transport Decision

- `google.script.run` works only inside HTML served by Apps Script. It is not
  available to a page hosted by Netlify.
- Try ordinary HTTPS requests only after confirming authentication, redirects,
  CORS behavior, and the response type in a clean browser session.
- JSONP is suitable only for intentionally public, non-sensitive `GET`
  operations with strict server-side action and callback validation. Never put
  secrets, personal data, or privileged mutations in query strings or JSONP.
- Use a server-side proxy or a different authenticated backend when the browser
  cannot safely satisfy the endpoint contract.
- Treat a public Web App URL as public configuration, not as authorization.
  Backend checks must prevent unintended actions.

## Frontend Configuration

Keep the endpoint out of source until the deployment and exposure decision is
confirmed. Then use either:

- a build-time public environment variable; or
- an explicit public configuration file that contains no credential.

Never commit Netlify tokens, Google OAuth state, `.env`, or secret-bearing
request examples. Client-side JavaScript cannot keep a secret.

## Verification

Before a Netlify production deploy:

1. Run the frontend locally and confirm the exact build output folder.
2. Verify loading, error, empty, timeout, and unauthorized states.
3. Run one low-risk end-to-end action against the confirmed Web App URL.
4. Confirm the result in the expected backend data store.
5. Remove temporary test data when the project requires it.
6. Scan the frontend source and build output for credentials and unexpected
   internal identifiers.
7. Deploy a preview first unless the user explicitly approved production.

After deploy:

1. Confirm the Netlify site, team, URL, and preview/production context.
2. Confirm the published assets reference the intended endpoint.
3. Repeat the low-risk action in a clean or incognito browser session.
4. Verify mobile and desktop error states and remove test data.

If any Apps Script project, manifest, source, deployment, or URL issue appears,
stop the frontend workflow and return to `clasp-setup`.
AGENT_LAZYPACK_NETLIFY_DEPLOY_REFERENCES_CLASP_NETLIFY_PATTERN_MD_792A3F7818

# netlify-deploy/references/source-adaptation.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/netlify-deploy/references/source-adaptation.md")"
cat > "{{SYNC_ROOT}}/skills/netlify-deploy/references/source-adaptation.md" <<'AGENT_LAZYPACK_NETLIFY_DEPLOY_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40'
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

## 2026-08-12 Boundary Split

- Apps Script login, project targeting, source synchronization, push, versions,
  deployments, and API-returned Web App URLs now belong to the dedicated
  `clasp-setup` skill and LazyPack Item 41.
- `netlify-deploy` keeps only Netlify configuration/deployment and the external
  frontend handoff to an already verified Apps Script Web App.
- Historical source material remains here for provenance; its old clasp command
  aliases and combined ownership are not the current execution contract.
- The split was informed by `mathruffian-dot/clasp-gas-skill` at commit
  `da34a6a6e17ffdc210707c39914adaab99c6c7c7`, then rewritten for clasp v3 and
  the shared Codex, Claude, and AntiGravity skill root.

## Codex Changes

- Replaced client-specific wording with a shared Netlify workflow and native MCP adapters.
- Replaced older tool names such as `netlify-project-services-updater` and `netlify-deploy-services-updater` with the current official Netlify MCP package, `@netlify/mcp`.
- Kept Codex TOML as one adapter example and required Claude and AntiGravity to use their verified native MCP settings while sharing the same Netlify task contract.
- Added npm cache isolation with `NPM_CONFIG_CACHE=/private/tmp/npm-cache`, matching this LazyPack's MCP pattern.
- Added explicit restart/new-conversation guidance because new MCP servers load after config reload.
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

## Official MCP / CLI Split

- Netlify MCP is the agent route: it gives Codex access to Netlify API and CLI-backed capabilities for project creation, project management, team/user reads, environment-variable or secret management, and deployment.
- Netlify CLI is the local operator route: install it globally, use it for `netlify login`, `netlify status`, `netlify link`, direct deploy checks, and authentication troubleshooting.
- Netlify's MCP docs recommend installing Netlify CLI so the MCP server can use it directly where possible, and they also suggest installing the MCP server locally at the project root when the client supports local MCP configuration.
- A Netlify PAT is a temporary local workaround for MCP auth issues only. Do not commit it, embed it in LazyPack, or copy it into Obsidian notes.

## 2026-06-03 Compatibility Audit

Audited surfaces:

| Surface | Result |
|---|---|
| Node.js | Local version satisfies Netlify MCP's Node.js 22+ prerequisite |
| Netlify MCP config | `{{CODEX_CONFIG}}` contains `[mcp_servers.netlify]` using `npx -y @netlify/mcp` |
| Netlify MCP package | npm package resolves successfully |
| Netlify CLI | CLI is installed and reports its version outside the Codex sandbox |
| Netlify API through CLI | Read-only current-user API call succeeds after browser login |
| Apps Script boundary | Dedicated `clasp-setup` owns clasp and returns only the verified Web App URL plus HTTP contract |
| Three-Agent portability | `SKILL.md`, LazyPack Item 28, and Obsidian mirror use a shared skill source, portable placeholders, and separate Codex／Claude／AntiGravity adapters |
AGENT_LAZYPACK_NETLIFY_DEPLOY_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40

# netlify-deploy/references/source-original-readme.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/netlify-deploy/references/source-original-readme.md")"
cat > "{{SYNC_ROOT}}/skills/netlify-deploy/references/source-original-readme.md" <<'AGENT_LAZYPACK_NETLIFY_DEPLOY_REFERENCES_SOURCE_ORIGINAL_README_MD_7EF24CE131'
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
AGENT_LAZYPACK_NETLIFY_DEPLOY_REFERENCES_SOURCE_ORIGINAL_README_MD_7EF24CE131

test -f "{{SYNC_ROOT}}/skills/netlify-deploy/SKILL.md" && echo "netlify-deploy installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
