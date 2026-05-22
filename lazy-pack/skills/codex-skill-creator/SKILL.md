---
name: codex-skill-creator
description: Use when adapting 來源工具 or Anthropic skill-creation guides into Codex App-compatible skills, deciding whether a new skill belongs globally or inside a project, improving an existing custom Codex skill, creating a first practical skill through interview, validating SKILL.md frontmatter and bundled resources, or syncing portable skill copies. Avoid 來源工具專用 paths and fields; use global Codex skills under {{CODEX_HOME}}/skills and project skills under 000_Agent/skills.
metadata:
  short-description: Build Codex-compatible skills
---

# Codex Skill Creator

Use this skill as the user-maintained companion to Codex's built-in `skill-creator`. It converts external skill-building guides into Codex App-compatible workflows and keeps Arry's global skill inventory synchronized.

## Default Paths

- Custom global skills: `$CODEX_HOME/skills`, or `~/.codex/skills` when `$CODEX_HOME` is not set.
- Project-local skills: `<project-root>/000_Agent/skills`.
- Global portable copy root: `{{SETUP_REPO}}/lazy-pack/skills`.
- Built-in system skills: `$CODEX_HOME/skills/.system` (read-only for normal work).
- Optional skill mirror note: ask the user for their Obsidian or project inventory path when no local mirror is already documented.
- Optional mirror note: `{{OBSIDIAN_VAULT}}/專案庫/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md`.
- Setup repo root: `{{SETUP_REPO}}`.
- Obsidian vault: `{{OBSIDIAN_VAULT}}`.

## Portability Rules

1. Treat absolute personal paths as local defaults, not universal requirements.
2. When adapting this skill package for another user, replace `ASSISTANT_NAME`, `ASSISTANT_ROOT`, `OBSIDIAN_VAULT`, `PROJECT_LIBRARY`, and `WORK_ROOT` before depending on personal-workflow skills.
3. Keep general-purpose skills independent from personal memory or vault paths unless the user explicitly wants them connected.
4. If a mirror note does not exist, create one only after the user confirms where their durable skill inventory should live.
5. Every skill must have a portable package: global skills mirror to `{{SETUP_REPO}}/lazy-pack/skills/<skill-name>`; project skills live as complete packages under `<project-root>/000_Agent/skills/<skill-name>`.

## Compatibility Rules

1. Do not install or edit skills under 來源工具的 skills 路徑, 來源工具的專案級 skills 路徑, or 來源工具 command folders.
2. Do not overwrite `{{CODEX_HOME}}/skills/.system/skill-creator`; create or update custom skills instead.
3. Use Codex frontmatter with `name`, `description`, and optional `metadata.short-description`.
4. Do not copy 來源工具專用 fields such as `allowed-tools`, `disable-model-invocation`, `user-invocable`, `when_to_use`, or 來源工具 subagent config unless converting them into plain Codex instructions.
5. Do not assume slash-command behavior. In Codex, skills are triggered by the skill metadata and current task context.
6. Keep `SKILL.md` concise. Move detailed examples, source adaptations, schemas, and checklists into `references/`.
7. After adding, changing, or deleting a custom global skill, update the LazyPack portable copy and Obsidian global skill mirror note.
8. After adding, changing, or deleting a project-local skill, keep the complete portable package under the project `000_Agent/skills` and update the project cockpit.

## Ownership Decision

Before creating or modifying a skill, decide where it belongs:

- Global: reusable across projects, should trigger from any Codex project, or is part of the user's standard workflow. Store in `{{CODEX_HOME}}/skills/<skill-name>` and sync `{{SETUP_REPO}}/lazy-pack/skills/<skill-name>`.
- Project-local: only useful for the current project, depends on project-specific context, or is still a local draft. Store in `<project-root>/000_Agent/skills/<skill-name>`.
- Arry assistant remains a global entry skill. Use it during project initialization to read the assistant data layer and help decide whether future skills are global or project-local.

Do not symlink `000_Agent/skills` into `$CODEX_HOME/skills`.

For field-by-field conversion details, read `references/codex-bootstrap-adapter.md` when the source material is source-oriented or Anthropic-specific.

## Workflow

1. Identify the target:
   - New global skill: create `{{CODEX_HOME}}/skills/<skill-name>/SKILL.md`.
   - New project skill: create `<project-root>/000_Agent/skills/<skill-name>/SKILL.md`.
   - Existing custom skill: read the current skill first, then patch only the needed sections.
   - Built-in system skill: do not patch; create a companion custom skill or a reference note.
2. Extract the useful workflow from the source material:
   - trigger scenarios
   - repeatable steps
   - validation checks
   - resource layout
   - user-facing interview questions
   - failure handling
3. Convert to Codex App conventions:
   - replace 來源工具路徑 with Codex paths
   - replace slash-command assumptions with metadata-trigger guidance
   - replace 來源工具 agents with optional validation passes or plain instructions
   - replace CLI-only user instructions with Codex App language
4. Write the skill package:
   - `SKILL.md` for compact operating instructions
   - `references/` for detailed adapted source notes
   - `scripts/` only when deterministic checks are genuinely useful
   - `assets/` only when files are used in final outputs
5. Validate:
   - `SKILL.md` exists
   - frontmatter starts and ends with `---`
   - `name` matches the folder name
   - `description` clearly names the triggering tasks
   - referenced files actually exist
   - no 來源工具專用 path or field remains unless it is explicitly labeled as source-only context
   - personal paths are either replaced with portable placeholders or clearly labeled as this user's local defaults
6. Sync portable copies and indexes:
   - Global skill: sync `{{SETUP_REPO}}/lazy-pack/skills/<skill-name>` and the Obsidian global skill mirror note.
   - Project skill: keep the complete portable package under `<project-root>/000_Agent/skills/<skill-name>` and update the project cockpit.
7. Sync the Obsidian mirror note when the skill is global:
   - add or update the custom skill table row
   - add or update the skill summary section
   - append a dated sync record
8. Report the result with exact paths, ownership level, portable-copy status, and any restart requirement. New or changed global skills may require a new Codex conversation before the trigger list reflects them.

## Interview Pattern For A First Skill

When the user wants help choosing the first skill, ask only enough to pick one practical target:

1. What repeated AI request do you make most often?
2. How often does it happen?
3. What should the skill deliver: Markdown note, reusable text, structured data, analysis, or an action checklist?
4. What source folder or examples should the skill read, if any?
5. What should the skill never do?

Then propose one recommended skill and two alternatives. Once the user chooses, create the skill rather than leaving them with a plan.

## Validation Checklist

- Global skill lives under `{{CODEX_HOME}}/skills/<skill-name>/`; project skill lives under `<project-root>/000_Agent/skills/<skill-name>/`.
- Portable package exists in the correct place: `{{SETUP_REPO}}/lazy-pack/skills/<skill-name>` for global, project `000_Agent/skills/<skill-name>` for project-local.
- `SKILL.md` frontmatter includes `name` and `description`.
- `description` includes concrete trigger phrases and use cases.
- Detailed material is in `references/`, not bloating `SKILL.md`.
- The skill avoids secrets, tokens, and personal data.
- Obsidian mirror note is updated for global skill changes; project cockpit is updated for project-local skill changes.
