---
name: cross-device-sync
description: Use when the user asks to set up, audit, repair, or document cross-device synchronization and portability for Codex App configuration, global skills, AGENTS.md rules, personal assistant data, Obsidian project cockpits, or AI assistant memory across Macs, Windows/Linux, Google Drive, iCloud, Dropbox, OneDrive, or GitHub backups.
metadata:
  short-description: Plan and verify Codex cross-device portability
---

# Cross-Device Sync

Use this skill to help the user make their Codex App setup portable across devices without binding their assistant memory, skills, or rules to one local machine.

This is a Codex App conversion of a Claude Code-oriented cross-device sync guide. Do not apply the source guide literally. In this environment, the default surfaces are:

- Codex config and skills: `{{CODEX_HOME}}`
- Custom global skills: `{{CODEX_HOME}}/skills`
- Project rules: `AGENTS.md`
- personal assistant data-layer root: `{{SETUP_REPO}}`
- personal assistant global core layer: `{{SETUP_REPO}}/000_Agent`
- personal assistant local work/reference layers: `100_Todo/` and `200_Reference/` under the same project root
- Obsidian vault: `{{OBSIDIAN_VAULT}}`
- {{SETUP_PROJECT_NAME}} cockpit: `專案庫/{{SETUP_PROJECT_NAME}}/專案工作流程.md`

## Non-Negotiables

- Do not create, depend on, or repair Claude-only paths such as `~/.claude`, `CLAUDE.md`, `.claude/skills`, Claude slash commands, or Claude subagents unless the user explicitly asks to migrate from Claude.
- Do not move, symlink, delete, or overwrite the user's existing Codex config, skills, memories, or Obsidian notes without first showing the concrete plan and getting explicit confirmation.
- Always make a timestamped backup before any operation that moves files, rewrites symlinks, changes Git remotes, or edits shared assistant memory.
- Never sync secrets, OAuth tokens, API keys, local credentials, app caches, shell snapshots, or machine-specific state across devices.
- If `{{GITHUB_USER}}/{{SETUP_PROJECT_NAME}}` is public, Do not put private backups, credentials, private memory, drafts, or personal logs into tracked project files.
- Prefer the user's established Google Drive project folder and Obsidian cockpit pattern unless the user chooses another sync route.

## Workflow

1. Read local rules:
   - Current project `AGENTS.md`
   - Obsidian vault `AGENTS.md` if Obsidian notes are involved
   - `{{ASSISTANT_SKILL_NAME}}` skill if personal assistant data is involved
2. Inventory current state before proposing changes:
   - `{{CODEX_HOME}}/config.toml`
   - `{{CODEX_HOME}}/skills`
   - `{{CODEX_HOME}}/memories` if memory portability is in scope
   - project `AGENTS.md` files that should travel with each project
   - relevant Obsidian cockpit notes
3. Interview briefly in Traditional Chinese:
   - device mix: one computer, multiple Macs, Mac plus Windows, Windows/Linux first, or custom
   - preferred sync channel: Google Drive, iCloud, Dropbox, OneDrive, GitHub only, or let Codex recommend
   - backup/versioning preference: private GitHub repo, public repo with strict ignores, local backup only, or decide later
   - health-check frequency: manual, weekly, or scheduled
4. Recommend a route and wait for explicit approval before state changes.
5. After approval, implement in small reversible steps:
   - create timestamped backups
   - create the chosen mother folder
   - copy or move only approved portable assets
   - create symlinks only when they reduce duplication and are safe on the selected platform
   - create `.gitignore` before any Git add
   - create a health-check script if useful
   - create or update a migration note
6. Verify:
   - paths exist
   - symlink targets exist if symlinks were used
   - ignored files are actually ignored
   - no secrets or machine-local state are staged
   - Codex skill frontmatter still validates if skills were moved or created
7. Report exact paths changed, backup path, verification result, and whether Codex needs a restart or new conversation.

## Codex Portability Map

Use this mapping when converting Claude-oriented instructions:

| Source guide concept | Codex App version |
|---|---|
| `~/.claude/skills` | `{{CODEX_HOME}}/skills` |
| `CLAUDE.md` | `AGENTS.md` |
| Claude slash commands | Codex skill metadata and normal user prompts |
| Claude subagents | Codex subagents only when explicitly requested; otherwise use validation passes |
| Claude memory | `{{CODEX_HOME}}/memories` plus personal assistant durable data when relevant |
| `000_Agent` from source kit | Existing personal assistant core layer in `{{SETUP_PROJECT_NAME}}/000_Agent` |
| Claude credentials/local state | Do not sync; each device logs in independently |

## Sync Route Guidance

- Apple-only multi-device setup: iCloud can work, but verify paths and symlink behavior carefully.
- Mac plus Windows or Android-heavy setup: Google Drive or Dropbox is usually more predictable.
- Windows/Linux-first setup: Google Drive, OneDrive, Dropbox, or GitHub-only depending on existing habits.
- Single computer: focus on portability backup and migration docs; real-time sync may be unnecessary.
- Existing personal-assistant workflow: prefer Google Drive plus Obsidian cockpit, because the user's projects already live there.

## What To Sync

Usually portable:

- custom global skills under `{{CODEX_HOME}}/skills`, excluding `.system`
- reusable project rules and templates
- personal assistant durable references and reusable memory
- migration docs, health-check scripts, and setup notes

Usually not portable:

- tokens, OAuth files, credentials, API keys, `.env`
- per-device local settings
- caches, telemetry, shell snapshots, conversation state
- generated temp files and logs unless the user explicitly wants archival logs

## Reference

When more detail is needed:

- Read `references/codex-playbook.md` before executing a real cross-device setup, audit, repair, GitHub backup, health-check script, or migration-manual task. It contains the full Codex-converted Section A-G workflow, routes, templates, checks, pitfalls, and FAQ.
- Read `references/source-adaptation.md` when you need to understand how the original `07-cross-device-sync.md` was converted from Claude Code assumptions into Codex App-safe behavior.
