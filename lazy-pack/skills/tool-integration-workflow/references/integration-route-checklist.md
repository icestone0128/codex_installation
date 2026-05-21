# Integration Route Checklist

This reference expands the `tool-integration-workflow` skill. Keep `SKILL.md` compact; use this file when a real external tool integration needs more structure.

## 1. Interview The Use Case

Ask only what is needed:

- What tool or service should be connected?
- What should Codex be able to do with it?
- Is read-only enough, or is write access required?
- Is this for one project, all future projects, or Arry assistant global use?
- Are credentials already available locally?

If the user only asks for analysis, do not configure anything until they approve execution.

## 2. Route Decision

Use this order:

1. Codex connector / plugin
   - Best when the connector already exists and handles auth safely.
   - Typical examples: Gmail, Google Calendar, Google Drive, GitHub.
2. Official CLI
   - Best when a stable CLI exists and the workflow is command-oriented.
   - Verify with a real command, not only `which`.
3. REST API + local environment
   - Best for precise read/write behavior and stable official APIs.
   - Store credentials outside tracked files.
4. MCP
   - Best when the service benefits from agent-native tools or no simpler route fits.
   - Keep MCP count small because every tool definition adds overhead.
5. Browser automation
   - Best for local frontend tests, UI-only services, or temporary verification.
   - Use logged-in browser automation only when the task requires the user's existing session.

## 3. Setup Safety

- Do not put secrets in:
  - GitHub
  - repo files
  - `AGENTS.md`
  - skill files
  - Obsidian notes that may sync publicly
  - documentation or screenshots
- Do not widen filesystem or service permissions unless the user explicitly agrees.
- Prefer read-only permissions when the requested task does not require writing.
- For OAuth or destructive actions, make the action and scope clear before proceeding.

## 4. Verification Patterns

Every integration needs a real check:

- Firecrawl: scrape `https://example.com` or another public URL and confirm markdown plus HTTP 200.
- GitHub: read repo metadata or current PR status.
- Gmail: run a safe search or summarize a small thread.
- Calendar: read events for a specific date.
- Google Drive: read a non-sensitive file the user selected.
- Notion: read a test page or database after the integration is invited.
- Heptabase: list or read a safe card through the CLI.

Verification should not create, send, delete, publish, or modify data unless the user explicitly asked for that.

## 5. Documentation After Setup

Record:

- Actual route used.
- Whether it was newly installed, already installed, or only verified.
- Where the safe configuration lives, without secret values.
- The verification action and result.
- Any limitations, quota notes, or permission boundaries.

Common project destinations:

- `100_Todo/integrations/<date>-tool-integration-plan.md`
- `000_Agent/knowledge/我的 AI 能幹清單.md`
- `000_Agent/knowledge/我的工具清單.md`
- Obsidian project cockpit when the integration changes project workflow.

## 6. Firecrawl Note

For this user's current machine, Firecrawl has been verified in Codex on 2026-05-20 by scraping `https://example.com` and receiving Markdown with HTTP 200. The API key must remain local and must not be uploaded to GitHub.
