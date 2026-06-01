# codex_installation

Codex installation, connector setup, workflow rules, and teaching-tool project initialization notes.

Project workspace initialized on 2026-05-07.

## Project Facts

- Project name: `codex_installation`
- Purpose: Codex installation, connector setup, reusable workflow rules, lazy-pack documentation, and project initialization standards.
- Work folder: `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation`
- Default branch: `main`
- GitHub repo: `icestone0128/codex_installation` (public)
- Obsidian cockpit: `secondbrain/專案庫/codex_installation/專案工作流程.md`
- Firebase project: `codex-4e80b`
- Deployment target: disabled. GitHub Pages is off; Firebase Hosting has no active site content for this repo.

## Links

- GitHub repo: https://github.com/icestone0128/codex_installation
- GitHub Pages: disabled

## Structure

- `AGENTS.md` - fixed project rules and workflow boundaries.
- `README.md` - repo overview and initialization facts.
- `.gitignore` - local, secret, dependency, and build-output exclusions.
- `docs/` - local documentation entry files. Not currently deployed.
- `lazy-pack/` - verified Codex setup notes, troubleshooting records, and self-contained skill installers embedded in the numbered files.
- `scripts/sync-health.sh` - read-only cross-device sync health check for symlinks, LazyPack mirror drift, Git state, and obvious secret patterns.
- `000_Agent/` - pointer only; Arry assistant global data now lives in Google Drive `codex_symlink/`.
- `100_Todo/` - project-local task, draft, and work-in-progress area.
- `200_Reference/` - project-local reference, template, and past-work area.
- `src/` - reserved application source folder.
- `tests/` - reserved test folder.

Standard project-local data layer:

- `100_Todo/drafts/`, `100_Todo/projects/`, `100_Todo/archive/`
- `200_Reference/writing-samples/`, `200_Reference/templates/`, `200_Reference/past-work/`

Portable setup helpers:

- `200_Reference/templates/codex-config.template.toml` - safe Codex config template for a new device. It uses placeholders for secrets and machine paths; do not sync the real `~/.codex/config.toml`.
- `scripts/sync-health.sh` - run after cross-device setup or skill sync work to verify the shared surfaces still line up.

## Getting Started

This repository is documentation-first. The local entry page is `docs/index.html`; GitHub Pages is currently disabled.

For project lifecycle work, use:

- Startup: read `AGENTS.md`, read the Obsidian cockpit, then check Git status.
- Shutdown: update the Obsidian cockpit, then report Git status.
- Initialization: use `lazy-pack/10-專案初始化工作模式.md` and only fill missing pieces in existing projects.

## Safety

- Do not commit `.env`, API keys, tokens, passwords, admin credentials, personal data, or sensitive data.
- Do not store Codex local auth/session/cache data in this repo.
- Keep daily progress in the Obsidian cockpit, not in `AGENTS.md`.
