# 41-Clasp + Apps Script Skill 安裝

> 版本：2026-08-13
> 定位：用官方 clasp v3 安全管理 Google Apps Script 的既有專案、新專案、原始碼、manifest、push 與 Web App deployment。

## 為什麼新增獨立 Item

舊版 Item 28 將 Clasp、GAS 與 Netlify 串成一條流程，但 Apps Script 並不只服務 Netlify。本 Item 將 GAS 的雲端原始碼與部署操作抽成 `clasp-setup`；Item 28 則專注 Netlify 前端與交接邊界。

## 來源比較與吸收結果

- 社群來源：[mathruffian-dot/clasp-gas-skill](https://github.com/mathruffian-dot/clasp-gas-skill)
- 檢視 commit：`da34a6a6e17ffdc210707c39914adaab99c6c7c7`（2026-08-09）。
- 保留：既有專案 clone／pull、Apps Script Web App 操作、deployment ID 與可選 MCP 提示。
- 改寫：使用 clasp v3 正式指令 `create-script`、`clone-script`、`create-deployment`、`list-deployments`、`update-deployment`、`open-web-app`。
- 不吸收：只寫 `~/.claude/skills`、`~/.agents/skills` 的安裝方式、「Node 22+」固定值、個人 Gmail 預設、直接組合 `/macros/s/<id>/exec` URL，以及將實驗性 MCP 當預設。
- 實際前置以 live npm `engines` 為準；2026-08-12 檢視的 `@google/clasp` 3.3.0 要求 Node `>=20`。
- 指令相容邊界：3.3.0 的 `create`、`clone`、`deploy`、`deployments`、`list`、`status`、`undeploy` 仍是可用 alias；本 Item 推薦正式 v3 名稱是為了清楚與向前相容，不代表舊名不存在。
- 真正破壞相容的舊形態另列：`login --status` 已移除；`open`／`open --web`／`open --addon` 與 `apis enable|disable` 已重整為獨立 v3 指令。

## 三 Agent 共用契約

- 主版本：`{{SYNC_ROOT}}/skills/clasp-setup`。
- Codex、Claude、AntiGravity 皆透過 Item 16 的 chezmoi 原生 symlink 入口讀取同一 package。
- 共用 CLI：`npx -y @google/clasp@3`。
- 共用安全邊界：OAuth、新建、pull、push、deployment 與刪除都要依操作類型取得明確授權；不把 Agent 的設定格式直接複製給另一個 Agent。

## 安裝

1. 先完成 Item 16，建立 `{{SYNC_ROOT}}`、共用 skills 主版本與三 Agent 原生入口。
2. 執行文末的「內建 Skill 完整安裝內容」。
3. 開新 Agent 對話或重啟對應 App，讓 skill discovery 重新載入。

## 安裝後預檢

下列指令不改變 Google 授權或 Apps Script 專案：

```bash
node --version
npm --version
npm view @google/clasp@3 version engines --json
npx -y @google/clasp@3 --version
npx -y @google/clasp@3 --help
test -f "{{SYNC_ROOT}}/skills/clasp-setup/SKILL.md"
```

如 npm cache 權限異常，只針對當次作業用 `NPM_CONFIG_CACHE=/private/tmp/clasp-npm-cache`，不放寬整個 home。

## 執行摘要

### 登入

```bash
npx -y @google/clasp@3 login
npx -y @google/clasp@3 show-authorized-user --json
```

`login` 會改變本機 OAuth 狀態，必須先說明帳號與 consent 邊界。回報只說明已／未授權，不回傳 email 或 raw JSON。

### 既有線上專案

```bash
npx -y @google/clasp@3 clone-script "<script-id-or-url>" --rootDir "<source-dir>"
```

已有本機 `.clasp.json` 時，先核對 target、Git 狀態與本地變更；`pull` 會寫入本機，不覆蓋未保存的修改。

### 新專案

```bash
npx -y @google/clasp@3 create-script --type standalone --title "<title>"
npx -y @google/clasp@3 create-script --type sheets --title "<title>"
npx -y @google/clasp@3 create-script --title "<title>" --parentId "<drive-file-id>"
```

`--type sheets|docs|slides|forms` 會新建 container 與 bound script；要綁定既有 Drive 檔案時，使用 `--parentId` 的 standalone 路線。clasp 3.3.0 help 文字雖提到 web app／API，實際實作不接受 `--type webapp|api`；Web App 要建 standalone project，再部署對應 entry point。

### Push 安全閘門

Clasp push 是整個線上專案的來源同步，不是單檔 patch。執行前要核對 `.clasp.json`、`.claspignore`、Git／備份基線與實際上傳清單：

```bash
npx -y @google/clasp@3 show-file-status --json
npx -y @google/clasp@3 push
```

不為繞過 mismatch 直接使用 `push --force`。

### Web App deployment

```bash
npx -y @google/clasp@3 create-deployment --description "<description>"
npx -y @google/clasp@3 list-deployments
npx -y @google/clasp@3 --json open-web-app "<deployment-id>"
npx -y @google/clasp@3 update-deployment "<deployment-id>" --description "<description>"
```

以 `open-web-app` 回傳 URL；不將 script ID 當 deployment ID，不手動拼接 `/exec` URL。如要保留原 URL，更新已確認 deployment，不反覆新建。

## 可選實驗性 MCP

Clasp v3 提供 `mcp`，但預設維持 CLI-first。只在使用者明確要求安裝或評估 MCP 時，才先檢查當前 CLI help、工具清單、Agent 原生設定與寫入範圍。不以 MCP 取代本機 Google Workspace MCP 的 Gmail／Drive／Calendar 路由。

## 安全邊界

- `.clasprc.json` 是 OAuth 憑證檔，Unix-like 環境建議權限 `600`；只檢查 metadata，不顯示內容。
- 不把 `.clasprc.json`、OAuth code／refresh token、custom OAuth client、`.env`、script ID 或 secret-bearing log 寫入 repo、LazyPack、Obsidian 或對話摘要。
- 公開 Web App、`ANYONE_ANONYMOUS`、執行身分與敏感資料上傳必須逐案確認。
- 每次云端寫入都回報專案 target、實際檔案清單、deployment ID、API 返回 URL 與低風險端到端驗證。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`clasp-setup`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- clasp-setup ----
mkdir -p "{{SYNC_ROOT}}/skills/clasp-setup"
# clasp-setup/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/clasp-setup/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/clasp-setup/SKILL.md" <<'AGENT_LAZYPACK_CLASP_SETUP_SKILL_MD_0E95F5A366'
---
name: clasp-setup
description: Use when the user asks to connect, clone, pull, edit, push, deploy, inspect, or troubleshoot Google Apps Script through clasp, including GAS web apps, container-bound scripts, existing online projects, or a Netlify frontend backed by Apps Script.
metadata:
  short-description: Safe clasp v3 and Apps Script workflow
---

# Clasp + Apps Script

This skill manages Google Apps Script source and deployments through the official
`@google/clasp` CLI. It uses one CLI-first workflow shared by Codex, Claude, and
AntiGravity; browser OAuth and cloud writes remain explicit user-controlled
steps.

## Route And Scope

- Use `npx -y @google/clasp@3` by default. A global npm install is optional and
  requires separate authorization.
- Treat the CLI channel and Google OAuth credential as separate decisions. The
  skill needs no API key.
- Use this skill for Apps Script project source, manifests, versions, and
  deployments. It does not replace the Google Workspace MCP route for ordinary
  Gmail, Drive, or Calendar operations.
- Clasp's built-in MCP server is experimental. Keep CLI as the default and read
  `references/agent-platform-notes.md` only when the user explicitly asks to
  install or evaluate MCP.
- If Netlify hosts an external frontend, finish the Apps Script backend and
  obtain its verified Web App URL here, then use `netlify-deploy` for the
  frontend boundary.

## Safety Boundaries

- Read-only inspection may check versions, help, local files, Git status, login
  status, file status, project lists, and deployment lists.
- `login`, `create-script`, `push`, `create-deployment`, `update-deployment`,
  `delete-script`, and `delete-deployment` change credentials or cloud state.
  State the target and wait for explicit authorization before running them.
- Clasp push replaces the online project content as a whole; it is not an
  atomic per-file patch. Before every push, verify the target project, review
  `show-file-status --json`, confirm `.claspignore`, and preserve a recoverable
  baseline in Git or a timestamped backup.
- Never run `push --force` merely to bypass a mismatch. Use it only after the
  user approves the exact target and file set.
- Never expose or commit `.clasprc.json`, OAuth codes, refresh tokens, custom
  OAuth client files, `.env`, or secret-bearing logs. The auth file should be
  readable only by its owner, normally mode `600` on Unix-like systems.
- `.clasp.json` identifies the target script. Do not overwrite an existing file
  or print its script ID unnecessarily.
- Never make a Web App public or use `ANYONE_ANONYMOUS` without confirming the
  data sensitivity, execution identity, and intended audience. Use the least
  broad Apps Script and OAuth permissions that satisfy the project.
- Do not upload identifiable or sensitive data merely because Apps Script or a
  Sheet is convenient. Follow the requesting project's data and privacy rules.

## Workflow Selector

1. Audit or install readiness: run only the preflight checks below.
2. Existing online project with no local checkout: use `clone-script` after the
   user identifies the project and destination.
3. Existing local clasp project: inspect `.clasp.json`, Git state, local files,
   and the intended remote before deciding whether to pull or push.
4. New Apps Script project: confirm the empty target folder and project type,
   then use `create-script`.
5. Web App deployment: validate `doGet` or `doPost`, manifest access settings,
   deployment target, and test data before deploying.
6. Netlify external frontend: complete steps 1-5 here, then hand off only the
   verified Web App URL and HTTP contract to `netlify-deploy`.

Read `references/clasp-v3-workflow.md` for the detailed v3 commands, deployment
sequence, compatibility-alias and breaking-change matrix, and error map.

## Preflight

Run these without changing auth or cloud state:

```bash
node --version
npm --version
npm view @google/clasp@3 version engines --json
npx -y @google/clasp@3 --version
npx -y @google/clasp@3 --help
```

- Trust the live npm `engines` declaration instead of a hard-coded Node version.
  At the 2026-08-12 source review, clasp 3.3.0 declared Node `>=20`.
- If npm cache permissions fail, use a task-specific temporary cache such as
  `NPM_CONFIG_CACHE=/private/tmp/clasp-npm-cache`; do not broaden the whole home
  directory or Homebrew prefix.
- Check whether `.clasprc.json` exists and inspect only its metadata. Do not
  print its contents. On Unix-like systems, correct an overly broad mode to
  `600` after the user authorizes the permission repair.
- Enabling the Apps Script API is a browser/account setting at
  `https://script.google.com/home/usersettings`. Do not create a test project
  merely to probe it during an audit.

## Authentication

Explain that Google opens a browser, state which account should be selected,
and let the user complete consent:

```bash
npx -y @google/clasp@3 login
npx -y @google/clasp@3 show-authorized-user --json
```

- In a remote or headless environment, use `login --no-localhost` and wait for
  the user to complete the displayed flow.
- Summarize login as authorized/not authorized and, when useful, Google-provided
  or custom client. Do not echo the email address or raw JSON unless requested.
- Managed Workspace accounts are not categorically unsupported. If
  `admin_policy_enforced` appears, stop and offer an authorized account or the
  domain-admin allowlist route; do not loop login attempts.

## Existing Project

1. Confirm project folder and intended online script.
2. If `.clasp.json` exists, inspect its presence and project layout without
   exposing the ID. Do not run `create-script` in that folder.
3. If no local project exists, clone into the confirmed destination:

```bash
npx -y @google/clasp@3 clone-script "<script-id-or-url>" --rootDir "<source-dir>"
```

4. Before `pull`, check Git status or create a timestamped backup because pull
   writes local files. Do not overwrite uncommitted local work.
5. After pull or clone, inspect `appsscript.json`, `.claspignore`, and the exact
   files that belong to Apps Script.

## New Project

Confirm that the folder has no `.clasp.json`, then choose the project type:

```bash
npx -y @google/clasp@3 create-script --type standalone --title "<title>"
npx -y @google/clasp@3 create-script --type sheets --title "<title>"
npx -y @google/clasp@3 create-script --title "<title>" --parentId "<drive-file-id>"
```

Use `--parentId` without a non-standalone `--type` to bind the script to an
existing supported Drive file. Use `--type sheets|docs|slides|forms` when clasp
should create a new container and its bound script. Despite the broad v3.3.0
help wording, `--type webapp` and `--type api` are not accepted container types;
create a standalone script and deploy the required entry point instead.
Creation is a cloud write and requires confirmation.

## Edit And Push

1. Keep only intended Apps Script sources and `appsscript.json` in the push set.
   Use `.claspignore` to exclude frontend builds, `.env`, credentials, local
   output, tests that should not run server-side, and unrelated project files.
2. Run relevant lint or tests, then review the local Git diff.
3. Inspect the exact upload set:

```bash
npx -y @google/clasp@3 show-file-status --json
```

4. Confirm the target project and upload set with the user.
5. Push without force first:

```bash
npx -y @google/clasp@3 push
```

6. Report the changed file set and whether the push succeeded. Do not deploy
   automatically just because push succeeded.

## Deploy A Web App

- Google requires a `doGet(e)` or `doPost(e)` function returning `HtmlOutput` or
  `TextOutput` for a Web App.
- Review the `webapp` manifest resource, especially `executeAs` and `access`.
  Confirm public access and owner-execution implications before deployment.
- Use explicit v3 command names:

```bash
npx -y @google/clasp@3 create-deployment --description "<description>"
npx -y @google/clasp@3 list-deployments
npx -y @google/clasp@3 --json open-web-app "<deployment-id>"
```

- To preserve an existing URL, update the confirmed deployment instead of
  creating another one:

```bash
npx -y @google/clasp@3 update-deployment "<deployment-id>" --description "<description>"
```

- Use the URL returned by `open-web-app`; never substitute `scriptId` for
  `deploymentId` or construct an `/exec` URL from `.clasp.json`.
- If no Web App entry point exists, inspect `doGet`/`doPost`, manifest settings,
  and deployment type. Do not repeatedly create deployments.
- Test with a low-risk record or health route, remove test data when required,
  and ask the user to verify the real Sheet or expected result before declaring
  completion.

## Failure Handling

- Retry the same login or API error at most twice after applying a specific
  correction. Then stop and offer a browser/manual editor route or an admin
  action instead of looping.
- `User has not enabled the Apps Script API`: enable the account setting and
  wait briefly for propagation.
- `Invalid container file type`: use a supported container type or create a
  standalone project. A standalone project can still be deployed as a Web App.
- `Deployment ID is required`: list deployments and pass the intended ID in
  non-interactive sessions.
- `No web app entry point found`: inspect Web App requirements and deployment
  configuration; do not assemble a URL manually.
- Local file or auth permission error: repair only the narrow npm cache or auth
  file boundary and retry after the active Agent reloads its permissions.

## Agent Execution Notes

- Shared steps: use the same `npx -y @google/clasp@3` commands, OAuth boundary,
  project target, backup rule, file-status gate, write confirmation, and
  deployment verification in all three Agents.
- Codex adapter: use the terminal and, when sandboxed, grant only the needed
  project root, npm cache, and `{{HOME}}/.clasprc.json`; start a fresh task after
  changing adapter permissions.
- Claude adapter: use the same CLI through Claude's terminal and native
  permission prompts; do not copy Codex TOML into Claude settings.
- AntiGravity adapter: use the same CLI through AntiGravity's terminal and
  native permission prompts; verify the current config surface before any MCP
  experiment.
- Fallback: use the Apps Script browser editor with an explicit copy/paste and
  deployment checklist when CLI login or API access remains blocked.
- Verification: every adapter must report the clasp version, auth state without
  credential disclosure, intended project, exact push set, deployment ID, API-
  returned URL, and low-risk end-to-end result.

## References

- `references/clasp-v3-workflow.md`: command matrix, Web App deployment flow,
  error handling, and verification checklist.
- `references/agent-platform-notes.md`: three Agent discovery/permission notes
  and the optional experimental MCP route.
- `references/source-adaptation.md`: inspected source, official checks, retained
  ideas, and rejected assumptions.
AGENT_LAZYPACK_CLASP_SETUP_SKILL_MD_0E95F5A366

# clasp-setup/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/clasp-setup/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/clasp-setup/agents/openai.yaml" <<'AGENT_LAZYPACK_CLASP_SETUP_AGENTS_OPENAI_YAML_DEB9755D27'
interface:
  display_name: "Clasp + Apps Script"
  short_description: "Safely maintain and deploy Apps Script with clasp v3"
  default_prompt: "Use $clasp-setup to connect to and safely maintain an Apps Script project."
AGENT_LAZYPACK_CLASP_SETUP_AGENTS_OPENAI_YAML_DEB9755D27

# clasp-setup/references/agent-platform-notes.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/clasp-setup/references/agent-platform-notes.md")"
cat > "{{SYNC_ROOT}}/skills/clasp-setup/references/agent-platform-notes.md" <<'AGENT_LAZYPACK_CLASP_SETUP_REFERENCES_AGENT_PLATFORM_NOTES_MD_92749FA9A5'
# Agent Platform Notes

The shared package and CLI workflow are authoritative. Native paths and MCP
configurations are adapters only.

## Shared Skill Discovery

- Shared source: `{{SYNC_ROOT}}/skills/clasp-setup`.
- Codex entrypoint: `{{CODEX_HOME}}/skills/clasp-setup`.
- Claude entrypoint: `{{CLAUDE_HOME}}/skills/clasp-setup`.
- AntiGravity entrypoint: `{{GEMINI_CONFIG}}/skills/clasp-setup`.
- Item 16 and chezmoi create the native entrypoint symlinks. Do not copy the
  package into alternate `.agents/skills` or project-vendor directories.

## Browser OAuth

All three Agents use the same clasp credential and user-controlled browser
consent. Use `login --no-localhost` only when the active terminal cannot receive
the local browser callback. Never automate selection of a Google account or
approval of OAuth scopes.

## Permissions

- Shared project access: grant only the intended Apps Script project folder.
- npm: grant the normal npm cache or use a task-specific temporary cache.
- clasp auth: grant only `{{HOME}}/.clasprc.json` when the Agent must refresh it;
  keep Unix mode `600`.
- Do not grant the whole home directory, Homebrew prefix, Google Drive root, or
  secrets directory to solve a narrow CLI permission problem.

## Experimental Clasp MCP

Clasp v3 includes an experimental stdio MCP server:

```bash
npx -y @google/clasp@3 mcp
```

Do not configure it by default. It adds tool definitions and currently exposes
only a limited subset of clasp capabilities. Add it only after the user asks for
long-running Agent-native Apps Script maintenance and accepts the context cost.

### Codex adapter

Verify the current Codex MCP schema before editing `{{CODEX_CONFIG}}`. A current
stdio shape may resemble:

```toml
[mcp_servers.clasp]
command = "npx"
args = ["-y", "@google/clasp@3", "mcp"]
```

Restart Codex or open a fresh task, then run the current MCP list command.

### Claude adapter

Verify current Claude help first. The official clasp repository currently
documents a native plugin and a manual stdio command similar to:

```bash
claude mcp add clasp -- npx -y @google/clasp@3 mcp
```

Do not translate Codex TOML into Claude configuration.

### AntiGravity adapter

Open AntiGravity's current installed-MCP raw configuration from its settings UI
rather than guessing a version-specific file. Configure the same stdio command,
refresh the MCP list, and verify through a read-only action.

### Fallback And Verification

- Fallback: use the shared CLI workflow; MCP is never required to complete an
  Apps Script project.
- Verification: all adapters must identify the same authenticated account
  privately, project target, source set, deployment, and Web App URL. Do not
  accept different result contracts merely because the native tool differs.
AGENT_LAZYPACK_CLASP_SETUP_REFERENCES_AGENT_PLATFORM_NOTES_MD_92749FA9A5

# clasp-setup/references/clasp-v3-workflow.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/clasp-setup/references/clasp-v3-workflow.md")"
cat > "{{SYNC_ROOT}}/skills/clasp-setup/references/clasp-v3-workflow.md" <<'AGENT_LAZYPACK_CLASP_SETUP_REFERENCES_CLASP_V3_WORKFLOW_MD_4A67B38E4E'
# Clasp v3 Workflow Reference

Use this reference after `SKILL.md` selects the concrete Apps Script task.

## Contents

1. Read-only audit
2. Project lifecycle
3. Web App deployment
4. v2 compatibility and breaking changes
5. Errors and recovery
6. Completion checklist

## Read-Only Audit

```bash
node --version
npm --version
npm view @google/clasp@3 version engines --json
npx -y @google/clasp@3 --version
npx -y @google/clasp@3 --help
npx -y @google/clasp@3 show-authorized-user --json
npx -y @google/clasp@3 list-scripts --json
```

Do not print raw authentication files. Reduce authorization output to the
minimum useful status.

## Project Lifecycle

### Existing Online Project

```bash
npx -y @google/clasp@3 clone-script "<script-id-or-url>" --rootDir "<source-dir>"
```

Use `pull` only after preserving uncommitted local work:

```bash
npx -y @google/clasp@3 pull
```

### New Project

```bash
npx -y @google/clasp@3 create-script --type standalone --title "<title>"
npx -y @google/clasp@3 create-script --type sheets --title "<title>"
npx -y @google/clasp@3 create-script --title "<title>" --parentId "<drive-file-id>"
```

Use `--type sheets|docs|slides|forms` to create a new container and bound
script. Use `--parentId` with the standalone route to bind to an existing
supported Drive file. In clasp 3.3.0, the help description mentions web apps
and APIs, but the implementation accepts only the four container types plus
standalone; use standalone for a Web App or executable API project and deploy
the required entry point afterward.

Never create over an existing `.clasp.json`.

### Push Gate

Clasp replaces the remote source set. Before push:

1. Verify the intended script and folder.
2. Preserve a recoverable Git or timestamped baseline.
3. Review `appsscript.json` and `.claspignore`.
4. Run lint/tests.
5. Run `show-file-status --json` and review every path.
6. Ask for confirmation, then run `push` without `--force`.

```bash
npx -y @google/clasp@3 show-file-status --json
npx -y @google/clasp@3 push
```

## Web App Deployment

Apps Script Web Apps need `doGet(e)` or `doPost(e)` returning an Apps Script
HTML or text output. The manifest `webapp` resource can define:

```json
{
  "webapp": {
    "executeAs": "USER_DEPLOYING",
    "access": "ANYONE"
  }
}
```

Choose values intentionally. `ANYONE_ANONYMOUS` exposes the endpoint without
login and requires explicit confirmation. Explicit `oauthScopes` should be the
least permissive set that supports the code.

Create or update a deployment:

```bash
npx -y @google/clasp@3 create-deployment --description "<description>"
npx -y @google/clasp@3 list-deployments
npx -y @google/clasp@3 update-deployment "<deployment-id>" --description "<description>"
```

Retrieve the Web App URL from the API-backed command:

```bash
npx -y @google/clasp@3 --json open-web-app "<deployment-id>"
```

Do not build a URL from `.clasp.json`; `scriptId` and `deploymentId` are not
interchangeable.

## v2 Compatibility And Breaking Changes

Do not use "v2 command" as a synonym for "unavailable." Clasp 3.3.0 retains
the following compatibility aliases. This workflow uses the canonical v3 names
for clarity and forward durability, not because the aliases are missing.

| Compatibility alias that still works in 3.3.0 | Canonical v3 name |
|---|---|
| `create` | `create-script` |
| `clone` | `clone-script` |
| `deploy` | `create-deployment` |
| `deployments` | `list-deployments` |
| `list` | `list-scripts` |
| `status` | `show-file-status` |
| `undeploy` | `delete-deployment` |

The following older command shapes are removed or restructured in 3.3.0 and
must use the current form:

| Removed or restructured v2 form | Current form |
|---|---|
| `login --status` | `show-authorized-user` |
| `open` | `open-script` |
| `open --web` | `open-web-app` |
| `open --addon` | `open-container` |
| `apis enable <api>` | `enable-api <api>` |
| `apis disable <api>` | `disable-api <api>` |

Precise scope: among `create`, `deploy`, `deployments`, `list`, `status`, and
`undeploy`, none disappeared in clasp 3.3.0; all remain aliases. In that
shortlist plus `login --status`, only `login --status` is unavailable. The
separate `open ...` and `apis ...` command shapes above are also breaking v2
forms and should not be described as retained aliases.

## Errors And Recovery

| Signal | Meaning | Response |
|---|---|---|
| `admin_policy_enforced` | Workspace admin blocks the OAuth client | Stop; use an authorized account or request domain-admin allowlisting. |
| `User has not enabled the Apps Script API` | Account-level API switch is off or propagating | Enable it at Apps Script user settings, wait briefly, retry once. |
| `No credentials found` | Clasp has no usable local auth | Run user-controlled login; never paste credentials into project files. |
| `Deployment ID is required` | Non-interactive open omitted its target | Run `list-deployments`, select the intended ID, and retry explicitly. |
| `No web app entry point found` | The deployment is not exposed as a Web App | Check `doGet`/`doPost`, manifest access settings, and deployment type. |
| npm cache `EPERM` | The Agent cannot write npm cache | Use a task-specific cache or narrowly grant the cache path. |
| auth-file `EPERM` | The Agent cannot refresh the local clasp credential | Narrowly grant the auth file, keep mode `600`, then reload the Agent. |

After two failed attempts with the same error, stop and propose the manual Apps
Script editor or a specific admin action.

## Completion Checklist

- Clasp major version and Node engine contract were checked live.
- Authorization is confirmed without publishing account or token details.
- The intended script and local folder are unambiguous.
- Local changes and upload set were reviewed.
- `.claspignore` excludes unrelated and secret-bearing files.
- Push/deployment received explicit authorization.
- Deployment ID and API-returned Web App URL are recorded safely.
- A low-risk end-to-end check passed and temporary records were removed.
- Netlify handoff, if any, contains only the verified URL and HTTP contract.
AGENT_LAZYPACK_CLASP_SETUP_REFERENCES_CLASP_V3_WORKFLOW_MD_4A67B38E4E

# clasp-setup/references/source-adaptation.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/clasp-setup/references/source-adaptation.md")"
cat > "{{SYNC_ROOT}}/skills/clasp-setup/references/source-adaptation.md" <<'AGENT_LAZYPACK_CLASP_SETUP_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40'
# Source Adaptation

## Inspected Sources

- Community source: `mathruffian-dot/clasp-gas-skill`.
- Source commit: `da34a6a6e17ffdc210707c39914adaab99c6c7c7`.
- Inspected: 2026-08-12.
- Official verification: `google/clasp` README, package metadata, current CLI
  help, and Google Apps Script manifest, authorization, and Web App guides.

The community repository was treated as untrusted static reference. Its install
scripts and embedded instructions were not executed.

## Retained

- CLI-first `pull -> edit -> push` maintenance loop.
- On-demand `npx` use instead of requiring a global install.
- Explicit clasp v3 command names and v2-to-v3 mapping.
- `show-authorized-user --json` for precise login status.
- Existing `.clasp.json` overwrite protection.
- `open-web-app` with an explicit deployment ID in non-interactive sessions.
- API-returned Web App URL instead of confusing `scriptId` and `deploymentId`.
- Headless `login --no-localhost`, managed-account error diagnosis, bounded
  retries, and a browser-editor fallback.
- Clasp MCP as experimental and optional, not the default route.

## Changed Or Rejected

- Replaced the source installer's copies to `~/.agents/skills` and
  `~/.claude/skills` with the documented shared `{{SYNC_ROOT}}/skills` package
  and chezmoi-managed native entrypoints.
- Rejected the blanket Node 22 requirement. The workflow checks live npm engine
  metadata; clasp 3.3.0 declares Node `>=20`.
- Rejected the blanket claim that v2 command names are unavailable. In clasp
  3.3.0, `create`, `clone`, `deploy`, `deployments`, `list`, `status`, and
  `undeploy` remain compatibility aliases. `login --status` is removed; older
  `open ...` and `apis enable|disable` shapes are separately restructured.
- Replaced "personal Gmail only" with a precise rule: managed Workspace accounts
  may work when their administrator allows the OAuth client; on
  `admin_policy_enforced`, stop and use an authorized route.
- Replaced blanket bans on names or personal data with project-specific data
  minimization and privacy controls.
- Limited `google.script.run` guidance to Apps Script-hosted HTML. External
  Netlify frontends use an HTTP Web App contract and the `netlify-deploy` skill.
- Removed automatic QR generation and other adjacent features that were not part
  of the requested Apps Script connection.
- Replaced unconditional unverified-app warning bypass instructions with scope,
  project-ownership, and OAuth verification checks.
- Added the official warning that clasp push replaces the whole remote source
  set, plus backup, file-status, and confirmation gates.
- Required explicit authorization for create, push, deployment, update, and
  deletion operations.

## Distribution Decision

This is a standalone shared global skill. LazyPack Item 41 contains its complete
portable package. `netlify-deploy` retains only the external-frontend integration
boundary and refers Apps Script source/deployment work to this skill.
AGENT_LAZYPACK_CLASP_SETUP_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40

test -f "{{SYNC_ROOT}}/skills/clasp-setup/SKILL.md" && echo "clasp-setup installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
