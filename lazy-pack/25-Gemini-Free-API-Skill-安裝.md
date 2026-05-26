# 25-Gemini-Free-API-Skill-安裝

> 版本：2026-05-27 Codex App 版
> 用途：建立 `gemini-free-api` 全域 skill，協助使用者在 Codex 專案中安全設定、驗證與使用 Google AI Studio Gemini API Free Tier。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/gemini-free-api/`，不需要取得原作者本機資料夾，也不需要任何真實 API key。

## 來源與歷史紀錄

- 初次同步日期：2026-05-27。
- 來源文件：使用者提供的 `06-設定Gemini免費API.md`。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/gemini-free-api/SKILL.md`。
- 這版定位：把原本「設定 Gemini 免費 API」改成 Codex App 可用的全域 skill，並加入 API key 安全儲存、Free Tier / Paid Tier 判斷與低風險驗證流程。

## 這版和來源文件的差異

| 項目 | Codex 版調整 |
|---|---|
| 1 | 轉成 Codex App 全域 skill 結構，正式 skill name 使用可攜式英文 ID `gemini-free-api`。 |
| 2 | 移除「把 Key 貼給 Codex」與「直接 echo 到 shell 設定檔」的做法，改為只把 key 放在本機 secret 檔或環境變數。 |
| 3 | 明確區分 Gemini Plus / Google AI Pro 訂閱和 Gemini API 計費；API 是否收費取決於 Google AI Studio 專案的 Billing Tier。 |
| 4 | 依 Google 官方文件更新 Free / Paid / Prepay / Postpay / spend cap 邊界，不承諾「永遠完全免費」。 |
| 5 | 不在 skill 中指定或固定任何 Gemini 模型；由使用者的 Free Tier 帳號、Google AI Studio 專案與實際整合工具的預設設定決定。 |
| 6 | 加入 `references/setup-and-billing.md` 與 `agents/openai.yaml`，讓下載者可以直接安裝並重複使用。 |

## 安裝方式

1. 打開本文文末「內建 Skill 完整安裝內容」。
2. 把整段安裝腳本複製到自己的環境執行。
3. 執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。
4. 安裝後開新 Codex 對話或重啟 Codex App，讓新的全域 skill metadata 被重新載入。

## API key 安全原則

這個 LazyPack 不內嵌任何真實 API key。下載者必須到自己的 Google AI Studio 建立自己的 key，並只存在本機：

```text
{{CODEX_HOME}}/secrets/gemini_api_key
```

若使用 macOS / Linux / WSL，可讓 shell 啟動時讀取：

```bash
export GEMINI_API_KEY="$(cat "{{CODEX_HOME}}/secrets/gemini_api_key")"
```

不要把 `GEMINI_API_KEY` 寫進：

- GitHub repo
- `.env` 範例以外的可追蹤檔案
- README / docs / skill 檔案
- Obsidian 公開同步筆記
- 前端 HTML / JS
- 聊天紀錄或截圖

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/gemini-free-api/SKILL.md" && echo "gemini-free-api SKILL.md ok"
test -f "{{CODEX_HOME}}/skills/gemini-free-api/references/setup-and-billing.md" && echo "gemini-free-api reference ok"
test -f "{{CODEX_HOME}}/skills/gemini-free-api/agents/openai.yaml" && echo "gemini-free-api agent metadata ok"
```

合理結果是每一行都顯示 `ok`。

若已經在本機設定好 `GEMINI_API_KEY`，可用不指定模型的低風險請求確認 key 可用：

```bash
curl -sS "https://generativelanguage.googleapis.com/v1beta/models" \
  -H "x-goog-api-key: $GEMINI_API_KEY"
```

正常狀態會回傳 JSON。這只驗證 key 與專案可讀，不會在 LazyPack 中固定任何模型。

## 使用方式

安裝後可用下列語句觸發：

- 「使用 gemini-free-api，幫我設定 Gemini API key」
- 「幫我確認這個 Codex 專案可不可以用 Gemini Free Tier」
- 「這個工具的 AI 功能用 Gemini API，從環境變數讀 Key」
- 「幫我檢查 Gemini API 是否會收費」
- 「把這個網頁工具的 AI 呼叫改成後端讀取 GEMINI_API_KEY」

觸發語意包含：Gemini API、Google AI Studio、Gemini Free Tier、GEMINI_API_KEY、AI Studio API key、API 收費、API billing。

## 預設工作流程

1. 先判斷使用者是要設定 key、驗證 key、檢查收費，還是把專案改成呼叫 Gemini。
2. 若涉及目前方案、預設可用能力或額度，優先查 Google AI Studio 專案的 Billing Tier 與 Rate limits 頁面。
3. 若使用者尚未有 key，引導到 Google AI Studio 建立 API key；不要要求使用者把完整 key 貼到對話。
4. 將 key 存到本機 secret 檔或系統環境變數，並設定權限。
5. 用最小請求驗證 API 能否回應。
6. 在專案中使用時，只從後端、CLI、serverless function 或本機工具讀取 `GEMINI_API_KEY`。
7. 若是前端網頁工具，正式版必須透過後端代理；不要把 key 放進 browser 可讀的 HTML / JS。

## 踩坑紀錄

### 1. Gemini Plus 不是 Gemini API 付款方案

Gemini Plus / Google AI Pro 是消費者訂閱；Gemini API 是否收費看 Google AI Studio 專案的 Billing Tier、Billing account 與使用量。不能因為有訂閱 Gemini Plus 就假設 API 已包含或不會收費。

### 2. Free Tier 不是無限制免費

Free Tier 可免費開始使用，但有速率、功能與資料使用條款限制。若專案升級或連到 billing account，可能進入 paid / prepay / postpay 流程。

### 3. API key 沒有自己的計費設定

API key 屬於某個 Google AI Studio / Cloud project。key 會繼承 project 的 tier、billing 狀態與限制。若同一個 project 內有多把 key，使用量會累加到同一個 project。

### 4. 不要在前端直放 key

前端 HTML / JS 會被使用者看到。教學測試可以用本機臨時請求，但可公開或可部署的工具應使用 serverless function、backend route 或本機 CLI 代理 Gemini API。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/gemini-free-api/SKILL.md` 存在。
- [ ] `{{CODEX_HOME}}/skills/gemini-free-api/references/setup-and-billing.md` 存在。
- [ ] `{{CODEX_HOME}}/skills/gemini-free-api/agents/openai.yaml` 存在。
- [ ] package 內沒有真實 API key、token、密碼或個人專案 ID。
- [ ] 搜尋 package 內沒有 Claude Code 專用路徑、非 Codex frontmatter 或原作者本機絕對路徑。
- [ ] 本機 `GEMINI_API_KEY` 可用低風險請求驗證。
- [ ] 若要給前端工具使用，已確認 key 不會出現在 browser bundle 或公開 repo。

## 官方參考

- [Gemini Developer API pricing](https://ai.google.dev/gemini-api/docs/pricing)
- [Gemini API billing](https://ai.google.dev/gemini-api/docs/billing)
- [Google AI Studio API keys](https://aistudio.google.com/apikey)

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`gemini-free-api`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

```bash
set -e

# ---- gemini-free-api ----
mkdir -p "{{CODEX_HOME}}/skills/gemini-free-api"
# gemini-free-api/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/gemini-free-api/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/gemini-free-api/SKILL.md" <<'CODEX_LAZYPACK_GEMINI_FREE_API_SKILL_MD'
---
name: gemini-free-api
description: Use when the user asks to set up, verify, troubleshoot, or safely use Google AI Studio Gemini API Free Tier in Codex projects, including GEMINI_API_KEY storage, free-tier checks, account-default API verification, and backend-safe API integration without exposing secrets.
metadata:
  short-description: Set up and verify Gemini API Free Tier safely for Codex projects
---

# Gemini Free API

## Role

Help the user safely connect Codex projects to the Gemini API through Google AI
Studio. Prioritize secret safety, current billing status, and a low-risk
verification request before changing any project code.

Use Traditional Chinese by default unless the user asks for another language.

## Trigger Context

Use this skill when the user asks about:

- Gemini API setup;
- Google AI Studio API keys;
- Gemini Free Tier or API billing;
- `GEMINI_API_KEY`;
- Gemini API defaults in a Codex-built tool;
- checking whether an API call may cost money;
- moving a frontend Gemini call behind a backend or serverless proxy.

## Hard Safety Rules

- Never write real API keys, tokens, passwords, or OAuth secrets into repos,
  skills, README files, docs, Obsidian notes, screenshots, or chat summaries.
- Do not ask the user to paste the full API key into the conversation unless
  there is no safer route. Prefer asking them to paste it into Google AI Studio,
  a local secret file, a password manager, or a hidden shell prompt.
- Never put `GEMINI_API_KEY` in browser-visible HTML, JavaScript, static site
  config, or committed `.env` files.
- Use placeholders such as `{{GEMINI_API_KEY}}` or `AIza***` in documentation.
- If a tool output or user message includes a real key, do not repeat it.

## Billing Principles

Gemini Plus or Google AI Pro subscription is separate from Gemini API billing.
API billing depends on the Google AI Studio / Google Cloud project that owns the
API key.

Before saying whether usage is free, check the project's current Billing Tier in
AI Studio when possible. A Free Tier project usually shows a free status or a
prompt such as "Set up billing". A paid project can use Prepay or Postpay and may
have project-level or billing-account spend caps.

API keys do not have independent billing settings. A key inherits the tier,
billing status, rate limits, and spend-cap behavior of its project.

## Setup Workflow

1. Clarify whether the user wants to create a key, verify an existing key, check
   billing, or integrate Gemini into a project.
2. If current billing, free-tier status, or default availability matters,
   inspect Google AI Studio directly or ask the user to confirm the project's
   Billing Tier.
3. If creating a key, have the user create it in Google AI Studio under the
   correct project. Prefer a separate project for free-tier experiments.
4. Store the key locally:
   - macOS / Linux / WSL: `{{CODEX_HOME}}/secrets/gemini_api_key`, permission
     `600`, loaded into `GEMINI_API_KEY`.
   - Windows: user-level environment variable or a local secret manager.
5. Verify `GEMINI_API_KEY` is present without printing its value.
6. Make a minimal `generateContent` request.
7. If integrating into an app, read the key only on the backend, CLI, or
   serverless side.

## Recommended Local Secret Pattern

For macOS / Linux / WSL, use a local secret file and load it into the shell
environment:

```bash
mkdir -p "$HOME/.codex/secrets"
chmod 700 "$HOME/.codex/secrets"
printf "%s" "<paste-key-locally-not-in-chat>" > "$HOME/.codex/secrets/gemini_api_key"
chmod 600 "$HOME/.codex/secrets/gemini_api_key"
```

Then add this to the user's shell startup file if it is appropriate for their
environment:

```bash
if [ -r "$HOME/.codex/secrets/gemini_api_key" ]; then
  export GEMINI_API_KEY="$(cat "$HOME/.codex/secrets/gemini_api_key")"
fi
```

When working on the user's actual machine, adapt the path to their real
`CODEX_HOME`. Do not place the secret file inside a project repo.

## Verification

First verify the variable exists without printing it:

```bash
test -n "$GEMINI_API_KEY" && echo "GEMINI_API_KEY is set"
```

Verify the key without hardcoding any model:

```bash
curl -sS "https://generativelanguage.googleapis.com/v1beta/models" \
  -H "x-goog-api-key: $GEMINI_API_KEY"
```

Expected result: JSON response. If the response is 401, check the key. If it is
403, check project/API permissions or billing state. If it is 429, wait or check
rate limits.

## Project Integration Rules

For backend code:

- Read `process.env.GEMINI_API_KEY`, `Deno.env.get("GEMINI_API_KEY")`, server
  runtime secrets, or the platform's secret manager.
- Do not hardcode a Gemini model in this skill. Use the Free Tier account,
  Google AI Studio project, SDK, or integration tool's default Gemini setting
  unless the user explicitly asks for a model override.
- Keep prompts and non-secret config in code; keep the key outside code.

For frontend apps:

- Do not call Gemini directly from browser code with a real API key.
- Add a backend route, serverless function, edge function, or local CLI bridge.
- Validate user input and cap request size before forwarding to Gemini.

For public templates:

- Include `.env.example` with `GEMINI_API_KEY=your-key-here`.
- Add `.env`, `.env.local`, and local secret files to `.gitignore`.
- Include setup instructions, not a real key.

## When To Browse Or Recheck

Free-tier limits, rate limits, billing plans, default settings, and pricing can
change. For cost, defaults, or "latest" questions, verify against official
Google AI documentation or the user's current AI Studio project before making a
firm statement.

## Reference Files

Read `references/setup-and-billing.md` when the user asks for detailed setup,
cost, billing-tier, or troubleshooting guidance.
CODEX_LAZYPACK_GEMINI_FREE_API_SKILL_MD

# gemini-free-api/references/setup-and-billing.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/gemini-free-api/references/setup-and-billing.md")"
cat > "{{CODEX_HOME}}/skills/gemini-free-api/references/setup-and-billing.md" <<'CODEX_LAZYPACK_GEMINI_FREE_API_REFERENCES_SETUP_AND_BILLING_MD'
# Gemini API Setup And Billing Reference

## Purpose

Use this reference to help a Codex user create, store, verify, and use a Gemini
API key without leaking secrets or making incorrect billing promises.

## Recommended Project Pattern

For experiments, create a separate Google AI Studio project dedicated to Codex or
the current tool. This keeps usage and billing easier to inspect.

Suggested project naming:

```text
Codex Free Gemini API
```

The exact name is optional. What matters is that the user can recognize it in AI
Studio and confirm its Billing Tier.

## Free Tier Checklist

Before telling the user a project is free-tier, verify as much of this as
possible:

- The API key belongs to the intended Google AI Studio project.
- The project's Billing Tier is Free or asks the user to set up billing.
- The project is not linked to a paid billing account unless the user intends
  paid usage.
- The intended API capability is available in that tier.
- The user's intended traffic fits within rate limits.

Avoid absolute claims such as "this can never charge you." Use precise wording:

```text
This key is currently in a Free Tier project, so ordinary requests should use
free-tier quota. If billing is later enabled or the key is moved to a paid
project, usage can become billable.
```

## Gemini Plus / Google AI Pro

Gemini Plus or Google AI Pro is not the same thing as Gemini API billing. It may
give the user app-level features in Gemini, but API keys belong to AI Studio /
Cloud projects and follow those projects' billing settings.

## Key Storage

Good places:

- local secret file outside repos;
- OS keychain or password manager;
- deployment platform secret manager;
- CI/CD secret store.

Bad places:

- Git repo;
- `AGENTS.md`;
- `SKILL.md`;
- README or docs;
- Obsidian notes synced to public or shared storage;
- browser JavaScript;
- screenshots or chat logs.

## macOS / Linux / WSL Local Setup

Store:

```bash
mkdir -p "$HOME/.codex/secrets"
chmod 700 "$HOME/.codex/secrets"
printf "%s" "<paste-key-locally-not-in-chat>" > "$HOME/.codex/secrets/gemini_api_key"
chmod 600 "$HOME/.codex/secrets/gemini_api_key"
```

Load:

```bash
if [ -r "$HOME/.codex/secrets/gemini_api_key" ]; then
  export GEMINI_API_KEY="$(cat "$HOME/.codex/secrets/gemini_api_key")"
fi
```

Verify without printing:

```bash
test -n "$GEMINI_API_KEY" && echo "GEMINI_API_KEY is set"
```

## Windows PowerShell Local Setup

Use a user-level environment variable:

```powershell
[Environment]::SetEnvironmentVariable("GEMINI_API_KEY", "<paste-key-locally-not-in-chat>", "User")
```

Open a new terminal, then verify:

```powershell
if ($env:GEMINI_API_KEY) { "GEMINI_API_KEY is set" }
```

## API Verification

Verify the key without hardcoding any model:

```bash
curl -sS "https://generativelanguage.googleapis.com/v1beta/models" \
  -H "x-goog-api-key: $GEMINI_API_KEY"
```

## Troubleshooting

| Symptom | Likely Cause | Action |
|---|---|---|
| 401 | Invalid or revoked key | Create a new key in the intended project |
| 403 | API/project/billing restriction | Check project, permissions, and billing tier |
| 404 endpoint not found | Wrong endpoint or API version | Verify the endpoint and API version |
| 429 | Rate limit exceeded | Wait, reduce request volume, or inspect rate limits |
| Environment variable empty | Shell did not load secret | Open a new shell or check startup file |
| Unexpected charge risk | Project linked to billing | Check AI Studio Billing and Spend pages |

## Backend Integration Examples

Node.js:

```js
const apiKey = process.env.GEMINI_API_KEY;
if (!apiKey) {
  throw new Error("GEMINI_API_KEY is not set");
}
```

Deno:

```js
const apiKey = Deno.env.get("GEMINI_API_KEY");
if (!apiKey) {
  throw new Error("GEMINI_API_KEY is not set");
}
```

`.env.example`:

```text
GEMINI_API_KEY=your-key-here
```

`.gitignore`:

```text
.env
.env.local
*.secret
secrets/
```

## Official References

- Gemini Developer API pricing: https://ai.google.dev/gemini-api/docs/pricing
- Gemini API billing: https://ai.google.dev/gemini-api/docs/billing
- Google AI Studio API keys: https://aistudio.google.com/apikey
CODEX_LAZYPACK_GEMINI_FREE_API_REFERENCES_SETUP_AND_BILLING_MD

# gemini-free-api/agents/openai.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/gemini-free-api/agents/openai.yaml")"
cat > "{{CODEX_HOME}}/skills/gemini-free-api/agents/openai.yaml" <<'CODEX_LAZYPACK_GEMINI_FREE_API_AGENTS_OPENAI_YAML'
interface:
  display_name: "Gemini Free API 設定"
  short_description: "安全設定、驗證與使用 Google AI Studio Gemini API Free Tier"
  default_prompt: "Use $gemini-free-api to verify my Gemini API Free Tier setup and help my Codex project read GEMINI_API_KEY safely."

policy:
  allow_implicit_invocation: true
CODEX_LAZYPACK_GEMINI_FREE_API_AGENTS_OPENAI_YAML

test -f "{{CODEX_HOME}}/skills/gemini-free-api/SKILL.md" && echo "gemini-free-api installed"

echo "embedded skills installed: gemini-free-api"
```

<!-- END EMBEDDED_SKILLS -->
