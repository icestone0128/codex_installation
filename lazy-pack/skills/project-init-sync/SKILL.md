---
name: project-init-sync
description: Use when the user says 新專案初始化, 開始新專案, 初始化專案工作模式, or asks to create or standardize a project. Follow lazy pack #10 as the default standard for all future new projects: inspect first, ask for missing project facts, create AGENTS.md, README, .gitignore, Git repo, optional GitHub repo, optional Firebase link, and an Obsidian project cockpit without overwriting existing work.
metadata:
  short-description: Initialize new projects
---

# Project Init Sync

Use this workflow for every new project unless the user explicitly says not to.

## Default Paths

- Main Obsidian vault: `OBSIDIAN_VAULT`; for this user, `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain`
- Default work root: `WORK_ROOT`; for this user, `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟`
- Project cockpit root: `專案庫` inside the Obsidian vault
- Project cockpit note: `專案庫/<project-name>/專案工作流程.md` inside the Obsidian vault
- Optional personal assistant global layer: `ASSISTANT_ROOT`; for this user, `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink`
- Optional personal assistant global entry skill: `$CODEX_HOME/skills/arry-assistant/SKILL.md`, or `~/.codex/skills/arry-assistant/SKILL.md` when `$CODEX_HOME` is not set
- Optional personal assistant setup document: ask the user for the path if no local setup document exists
- Global assistant skills: `ASSISTANT_ROOT/skills`
- Project-local assistant folders: `100_Todo/`, `200_Reference/`, and optional `000_Agent/skills/`, `000_Agent/memory/`
- Standard task folders: `100_Todo/drafts/`, `100_Todo/projects/`, `100_Todo/archive/`
- Standard reference folders: `200_Reference/writing-samples/`, `200_Reference/templates/`, `200_Reference/past-work/`

When adapting this skill for another user, replace `OBSIDIAN_VAULT`, `WORK_ROOT`, `ASSISTANT_ROOT`, and `ASSISTANT_NAME` before creating files. If the user does not want a personal assistant layer, skip assistant-specific folders and sections.

## Workflow

1. Inspect the current folder first. Report what already exists and what is missing.
2. Confirm missing facts before creating files:
   - project name
   - purpose
   - work folder
   - GitHub repo needed or not
   - public or private repo
   - GitHub Pages needed or not
   - Obsidian cockpit path
   - Firebase needed or not
   - deployment target
3. For existing projects, only fill gaps. Do not overwrite existing `AGENTS.md`, `README.md`, `.gitignore`, Firebase config, or Git history.
4. Create or update the project root `AGENTS.md` with:
   - project name, purpose, work directory
   - GitHub repo or `未建立`
   - default branch
   - Obsidian vault absolute path
   - cockpit note vault-relative path
   - Firebase project id or `未使用`
   - startup/shutdown/new-project rules
   - optional personal assistant integration: always bring in the shared global personal-assistant entry skill when the user uses Arry Assistant, plus the shared core layer, project-local `100_Todo/`, `200_Reference/`, and local `000_Agent/skills` when project-only skills are needed
   - safety rules: no secrets, no personal or sensitive data
5. Create or fill `README.md`, `.gitignore`, and Git repo if missing.
6. Create the project-local data layer if missing:
   - `100_Todo/drafts/`
   - `100_Todo/projects/`
   - `100_Todo/archive/`
   - `200_Reference/writing-samples/`
   - `200_Reference/past-work/`
   - `200_Reference/templates/`
   - `000_Agent/skills/` only when the project needs project-specific assistant skills or local workflows
   - `000_Agent/memory/` only when the project needs project-specific assistant memory separate from the global Arry core
7. Create the Obsidian cockpit note at `專案庫/<project-name>/專案工作流程.md` in the vault, not inside the project repo.
   - If a personal assistant layer is used, include a short assistant integration section stating the model: shared global assistant core, project-local task/reference folders, and Obsidian as the knowledge/cockpit layer.
8. If GitHub is requested, use GitHub CLI or GitHub connector after auth verification. Public repo is preferred only when GitHub Pages is needed.
9. If Firebase is requested, keep `.firebaserc`, `firebase.json`, and rules scoped to the selected Firebase project. Never change Firebase project ID casually.
10. Finish by reporting:
   - work folder
   - Obsidian cockpit path
   - Git status
   - GitHub repo status
   - Firebase status
   - next action for the user

## Safety Rules

- Do not commit `.codex/`, `.claude/`, `.env`, API keys, tokens, passwords, admin credentials, personal data, or sensitive data.
- Do not store unnecessary personal or sensitive data in the repo.
- AGENTS.md stores fixed rules. Obsidian cockpit stores progress and next steps.
- A personal assistant layer, if used, has a two-layer model. Do not duplicate or move the shared assistant core layer.
- Every new project should get project-local `100_Todo/` and `200_Reference/` folders unless the user explicitly opts out.
- If the user asks for project-local assistant skills, create them under `000_Agent/skills/` and do not symlink that folder to `$CODEX_HOME/skills`.
- If the user asks for project-local assistant memory, create it under `000_Agent/memory/` and document how it syncs to the project cockpit.
- Any new skill must be portable: global skills sync to LazyPack and Obsidian global skill index; project skills stay as complete packages under project `000_Agent/skills/` and are recorded in the project cockpit.
