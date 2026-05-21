---
title: Codex Skill Creator Bootstrap Adapter
date: 2026-05-20
type: reference
tags:
  - codex
  - skills
  - compatibility
---

# Codex Skill Creator Bootstrap Adapter

This reference adapts `/Users/arrywu/Downloads/02-skill-creator-bootstrap.md` for Codex App. The source is useful as a workflow pattern, but it is Claude Code-oriented and must not be copied verbatim.

## Keep From The Source

- Start by detecting the user's actual skill environment before writing files.
- Install or create a complete skill folder, not only `SKILL.md`, when supporting resources are required.
- Use an interview to choose a first high-value skill instead of creating abstract examples.
- Validate that the skill exists, has correct frontmatter, and references real support files.
- Treat skill creation as iterative: create one useful skill, test it, then revise after real use.

## Convert For Codex

| Source assumption | Codex-compatible version |
|---|---|
| `~/.claude/skills` | `/Users/arrywu/.codex/skills` |
| `000_Agent/skills` as Claude symlink target | Arry assistant core may live in `codex_installation/000_Agent`, but Codex skills still live in `/Users/arrywu/.codex/skills` |
| slash command `/skill-name` | Skill metadata triggers; the user can name the skill, but do not depend on a slash-command menu |
| Claude `AskUserQuestion` | Ask concise questions in Codex; use available UI tools only when present |
| Claude subagents in `agents/*.md` | Use Codex subagents only when explicitly authorized by the user; otherwise use local validation checklists |
| `allowed-tools` | Omit; Codex tool access is controlled by the session and plugin permissions |
| `disable-model-invocation` / `user-invocable` | Omit; express trigger boundaries in `description` and body instructions |
| Anthropic sparse checkout install | Use only when the user explicitly wants a third-party skill package; otherwise create a Codex-native custom skill |
| Tell user to restart Claude Code | Say a new Codex conversation or app restart may be needed for new skill metadata to appear |

## Codex Skill Package Standard

Minimum:

```text
<skill-name>/
└── SKILL.md
```

Optional:

```text
<skill-name>/
├── SKILL.md
├── references/   # detailed docs loaded only when needed
├── scripts/      # deterministic utilities
└── assets/       # templates or output resources
```

Avoid extra `README.md`, installation guides, or changelogs inside a skill unless the user explicitly asks for them.

## Frontmatter Template

```markdown
---
name: skill-name
description: Use when the user asks for [specific task], [trigger phrase], or [workflow]. Include the domain, action, and output expectation.
metadata:
  short-description: Short user-facing phrase
---
```

Rules:

- `name` must match the folder name.
- `description` should front-load the most likely trigger phrases.
- Keep body instructions procedural and compact.
- Put long examples or source adaptations in `references/`.

## Global Skill Sync Requirement

After any custom global skill change, update:

`/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain/專案庫/codex_installation/全域 Skills/全域 Skills 同步.md`

Update three areas when applicable:

1. Custom skills table row
2. Skill summary section
3. Recent sync record with the date and exact change

Do not edit the system skill contents under `.system`; the mirror note may list them as read-only built-ins.
