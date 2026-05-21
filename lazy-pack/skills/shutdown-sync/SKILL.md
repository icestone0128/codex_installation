---
name: shutdown-sync
description: Use when the user says 收工, 結束今天工作, 同步收工, or asks to wrap up a project session. Summarize changes, update the Obsidian cockpit, optionally update AGENTS.md if fixed rules changed, then commit/push only with user intent and relevant files.
metadata:
  short-description: Wrap up project work
---

# Shutdown Sync

Use this workflow at the end of a work session.

1. Review what changed during this session.
2. Read project `AGENTS.md` and the Obsidian cockpit note.
3. If the project uses a personal assistant layer such as Arry 助手, decide whether the session produced reusable cross-project memory:
   - reusable preference or repeated lesson -> append to `ASSISTANT_ROOT/000_Agent/memory/MEMORY.md` when that durable memory path is documented and approved
   - project-only progress -> keep in the project cockpit
4. Update the Obsidian cockpit with:
   - what was completed
   - current status
   - next steps
   - blockers or issues
5. Update `AGENTS.md` only if stable project rules, paths, or boundaries changed.
6. Check Git diff and status.
7. Stage only files related to this session.
8. Commit and push only when the user asked for it or clearly expects it.
9. Report:
   - Obsidian update status
   - personal assistant memory sync status, if used
   - AGENTS.md update status
   - Git status
   - any remaining uncommitted files

Never commit secrets, local `.codex/` data, or unrelated changes.
