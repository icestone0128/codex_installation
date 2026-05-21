# Codex Skills Portfolio

This folder contains reusable Codex skills for the lazy pack. Use the numbered guides in `lazy-pack/README.md` first; this file is the skill inventory and copy checklist.

## Copy Setup

1. Copy the custom skill folders into the target user's Codex skills directory.
   - Default Codex path: `$CODEX_HOME/skills`
   - If `$CODEX_HOME` is not set, use `~/.codex/skills`.
2. Do not copy or edit `.system/` unless the target Codex installation explicitly requires it. System skills are managed by Codex.
3. When sharing `social-cards`, copying `node_modules/` is optional and usually not recommended across computers. Copy `package.json` and `package-lock.json`, then run `npm install` in the target `social-cards` folder.
4. For personal-workflow skills, set or replace these local values before use:
   - `ASSISTANT_NAME`: the personal assistant name, for example `Arry 助手`.
   - `ASSISTANT_ROOT`: the assistant data-layer root.
   - `OBSIDIAN_VAULT`: the user's Obsidian vault path.
   - `PROJECT_LIBRARY`: the Obsidian project cockpit folder.
   - `WORK_ROOT`: the default project workspace root.
5. Start with the skills that are fully portable, then adapt the configured skills.
6. After adding or changing skills, start a new Codex conversation or restart Codex if skill metadata does not refresh immediately.

Standard copy command:

```bash
mkdir -p "{{CODEX_HOME}}/skills/<skill-name>"
rsync -a --delete "{{SETUP_REPO}}/lazy-pack/skills/<skill-name>/" "{{CODEX_HOME}}/skills/<skill-name>/"
test -f "{{CODEX_HOME}}/skills/<skill-name>/SKILL.md" && echo "<skill-name> installed"
```

## Architecture

The skills are organized into five layers:

| Layer | Skills | Role |
|---|---|---|
| Governance and maintenance | `codex-skill-creator`, `cross-device-sync` | Create, validate, sync, migrate, and document skills |
| Project lifecycle | `project-init-sync`, `startup-sync`, `shutdown-sync` | Standardize project setup, opening checks, and close-out |
| Personal knowledge layer | `arry-assistant`, `secondbrain-research-digest` | Personal assistant memory, Obsidian research, and durable notes |
| Content and teaching workflows | `notebooklm-architecture`, `presentation-workflow`, `visual-note-generator`, `social-cards`, `doc-to-md` | NotebookLM control, slides, visual notes, cards, and document conversion |
| Tools and thinking workflows | `tool-integration-workflow`, `heptabase-cli`, `brainstorm`, `rightproblem-coach` | External tool routing, Heptabase CLI, planning, and problem framing |

## Portability Status

| Skill | Status | Notes for another user |
|---|---|---|
| `brainstorm` | Portable | No local path required. |
| `heptabase-cli` | Portable with dependency | Requires Heptabase desktop app, local CLI server, and compatible CLI version. |
| `notebooklm-architecture` | Portable | Bundled references are included. |
| `presentation-workflow` | Portable | Bundled NotebookLM/YAML references are included. |
| `rightproblem-coach` | Portable | Writes HTML to a local output path chosen by the session. |
| `visual-note-generator` | Portable | Bundled prompt reference is included. |
| `social-cards` | Portable with dependency | Requires Node dependencies before PNG export. Templates and script are bundled. |
| `doc-to-md` | Portable with dependency | Requires Python dependencies from bundled `scripts/requirements.txt`. |
| `tool-integration-workflow` | Portable | Replace any source example path with the user's project notes if needed. |
| `codex-skill-creator` | Portable with local mirror config | Replace Obsidian mirror path if the user wants skill inventory sync. |
| `cross-device-sync` | Portable with local sync config | Replace storage provider paths and assistant data roots. |
| `project-init-sync` | Portable with local defaults | Replace `WORK_ROOT`, `OBSIDIAN_VAULT`, and assistant-layer defaults. |
| `startup-sync` | Portable with local defaults | Works from project `AGENTS.md`; personal assistant reads are optional. |
| `shutdown-sync` | Portable with local defaults | Works from project `AGENTS.md`; personal assistant memory sync is optional. |
| `secondbrain-research-digest` | Portable with vault config | Replace `OBSIDIAN_VAULT`, index, and log paths. |
| `arry-assistant` | Personal template | Rename assistant, replace data root, memory path, output folders, and Obsidian sync path. |

## Relationship Rules

- Use `brainstorm` before implementation when the request is vague or explicitly planning-first.
- Use `project-init-sync` to create the project structure; it may reference `arry-assistant` only when a personal assistant layer is desired.
- Use `startup-sync` at the beginning of project work and `shutdown-sync` at the end.
- Use `codex-skill-creator` for any custom skill change. If a skill is added, changed, or deleted, update the local skill inventory note when that mirror exists.
- Use `cross-device-sync` when copying skills, assistant data, or project rules across devices.
- Use `tool-integration-workflow` before adding a connector, CLI, API, MCP server, or browser automation route.
- Use `secondbrain-research-digest` for Obsidian research outputs; use `arry-assistant` only for personal assistant memory and cross-project preferences.
- Use `presentation-workflow`, `notebooklm-architecture`, and `visual-note-generator` together for teaching decks: architecture controls NotebookLM behavior, presentation workflow controls slide narrative and YAML, visual note generator controls educational image prompts.
- Use `doc-to-md` before `secondbrain-research-digest` when a PDF/EPUB/TXT must first become Markdown.
- Use `social-cards` after a draft article, note, or digest exists and the user asks for social-media image cards.

## Completeness Checklist

Before sharing the package with another user:

- Every custom skill folder has a `SKILL.md`.
- Every `SKILL.md` has frontmatter with `name` and `description`.
- Every custom skill has an initial execution path: `Workflow`, `使用流程`, `工作流程`, `Step`, `Phase`, or a numbered startup list.
- Bundled scripts referenced in `SKILL.md` exist.
- Bundled references referenced in `SKILL.md` exist.
- Node dependencies such as `social-cards/node_modules/` are either present locally or rebuilt with `npm install`.
- 來源工具專用 frontmatter fields such as `allowed-tools`, `disable-model-invocation`, `user-invocable`, and `when_to_use` are absent from active `SKILL.md` files.
- Personal paths are either documented as local defaults or replaced by placeholders before sharing.
- No API keys, tokens, passwords, OAuth files, or private memory are included.
