---
name: startup-sync
description: Use when the user says 開工, 繼續專案, 今天要做什麼, or asks to resume work on a project. Read project rules, Obsidian cockpit, and Git/Firebase/GitHub status without making automatic commits or pulls.
metadata:
  short-description: Resume project work
---

# Startup Sync

Use this workflow at the beginning of a work session.

1. Read the project `AGENTS.md` if it exists.
2. Find and read the Obsidian cockpit note listed in `AGENTS.md`.
3. If the project references a personal assistant skill such as `arry-assistant`, read:
   - `$CODEX_HOME/skills/<assistant-skill>/SKILL.md`, or `~/.codex/skills/<assistant-skill>/SKILL.md` when `$CODEX_HOME` is not set
   - `ASSISTANT_ROOT/000_Agent/memory/MEMORY.md` when the project documents an assistant root
4. Check Git status and current branch.
5. Check GitHub remote if present.
6. Check Firebase project if the project uses Firebase.
7. Summarize:
   - last known state
   - current local changes
   - likely next step
   - any blockers
   - personal assistant notes or preferences that apply to this project, if any

Do not automatically pull, commit, push, deploy, or rewrite rules unless the user asks.
