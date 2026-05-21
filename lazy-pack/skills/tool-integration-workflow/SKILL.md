---
name: tool-integration-workflow
description: Use when the user asks to integrate, install, connect, verify, or choose a route for an external tool, API, CLI, MCP server, Codex connector, browser automation, or service such as Firecrawl, Notion, Slack, Linear, Gmail, Calendar, GitHub, Google Drive, or similar. Follow a Codex App-compatible CLI/API/connector/MCP decision workflow, verify after setup, and never store secrets in repos, skills, AGENTS.md, or public notes.
metadata:
  short-description: External tool integration workflow
---

# Tool Integration Workflow

Use this skill only for external tool integration work. Do not apply it to ordinary skill calls such as writing notes, making slides, editing documents, or analyzing code unless the task requires adding, verifying, or choosing an external service integration.

## Trigger Examples

- "幫我整合 Firecrawl / Notion / Slack / Linear"
- "幫我安裝這個 API / CLI / MCP"
- "確認 Codex 能不能使用這個工具"
- "這個服務要走 CLI、API、MCP 還是 connector?"
- "把某個外部服務接進個人助手或新專案工作流"

## Core Rules

1. Confirm the user's actual use case before installing or configuring anything.
2. Prefer the lightest stable route that fits the task:
   - Codex connector or plugin when Codex App already provides a safe first-party workflow.
   - Official CLI when the service has a stable CLI and commands are enough.
   - REST API plus local `.env` when precise read/write control is needed.
   - MCP only when connector, CLI, or API are not suitable, or when MCP gives a clearly better agent experience.
   - Browser automation only as a last resort for UI-only workflows or local frontend verification.
3. For current tool choice, verify live docs or the currently available Codex tools when the route may have changed.
4. Install or configure only what the user confirmed. Do not add adjacent tools because they seem useful.
5. After setup, run one real, low-risk verification action.
6. Never write API keys, tokens, passwords, OAuth secrets, app passwords, admin credentials, or private keys into GitHub, repos, `AGENTS.md`, skills, public Obsidian notes, docs, README files, screenshots, or chat summaries.
7. If a global skill is added or changed as part of the integration, update the Obsidian global skill mirror note.

## Standard Workflow

1. Identify the target service and desired jobs-to-be-done.
2. Check what already exists:
   - Available Codex connectors/plugins/tools in the current session.
   - Local CLI install and auth state when relevant.
   - Existing project notes, skills, or integration plans.
3. Choose the route using the core rules.
4. Explain the selected route and any credentials needed before setup.
5. Execute only the confirmed setup.
6. Verify with a small real action:
   - Firecrawl: scrape one public URL.
   - GitHub: read repo/PR/issue status.
   - Gmail: read/search a safe mailbox query.
   - Calendar: read today's or a specified day's events.
   - Notion: read a test page or database after permission is granted.
7. Record the result in the relevant project plan or capability list.

## Secret Handling

- Store secrets only in a local secret store, local environment file, or provider-managed auth flow appropriate to the tool.
- Do not print full secret values.
- If a user pastes a secret, avoid repeating it; tell them where it should be stored safely.
- Before commit/push, check that no secret-bearing file is staged.

## References

- Detailed route checklist: `references/integration-route-checklist.md`
- Optional source project plan example for this user's local setup: `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation/100_Todo/integrations/2026-05-20-tool-integration-plan.md`
