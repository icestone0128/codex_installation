# Source Adaptation: 07-cross-device-sync.md

Source file: `07-cross-device-sync.md`

The source document is a Claude Code pro-kit for moving Claude configuration into a portable "AI brain" folder, backing it up, symlinking it back into `~/.claude`, adding optional GitHub backup, generating a health-check script, and writing a migration manual.

This Codex version keeps the useful operating model but changes the target surfaces and safety rules.

## Preserved Ideas

- Treat assistant setup as a user-owned portable asset, not a vendor-owned hidden folder.
- Pick the sync route based on device mix, not trendiness.
- Back up before moving files or creating symlinks.
- Keep portable rules, skills, and durable memory separate from machine-local state.
- Use GitHub as optional versioned offsite backup, preferably private.
- Generate health checks and migration notes so future device changes are repeatable.

## Converted Assumptions

| Original Claude guide | Codex-compatible conversion |
|---|---|
| `~/.claude/` is the main config root | `{{CODEX_HOME}}` is the Codex root |
| `~/.claude/skills` stores skills | `{{CODEX_HOME}}/skills` stores global Codex skills |
| `CLAUDE.md` is the rule file | `AGENTS.md` is the project rule file |
| Claude slash commands are user-facing entry points | Codex skills trigger by metadata and user intent |
| Claude subagents are part of the workflow | Codex subagents are only used when explicitly requested or clearly useful |
| `000_Agent/` is created by pro-kit 01 | A Codex user may keep personal assistant data under `{{SETUP_PROJECT_NAME}}/000_Agent` |
| Source examples refer to Raymond/Raymond-Agent | Use personal assistant and the user's existing Google Drive/Obsidian paths |

## Codex-Specific Safety Changes

- The skill must not automatically move or symlink `{{CODEX_HOME}}` assets during installation.
- Any future sync setup must be plan-first and approval-gated because it can affect all Codex sessions.
- The default sync approach should align with Google Drive project folders and Obsidian project cockpits.
- The existing personal assistant architecture uses `{{SETUP_PROJECT_NAME}}` as the data-layer root with `000_Agent/`, `100_Todo/`, and `200_Reference/` as sibling layers; do not treat `000_Agent/` as the whole mother folder for every use case.
- If `{{GITHUB_USER}}/{{SETUP_PROJECT_NAME}}` is public, private backups and personal memory must not be staged or tracked there.
- System skills under `{{CODEX_HOME}}/skills/.system` are Codex-managed and should not be edited or moved manually.
- Global skill changes must update the Obsidian mirror note at `專案庫/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md`.

## Interview Questions

Use short Traditional Chinese questions, usually one round:

1. 你要同步的裝置組合是什麼：只有一台、多台 Mac、Mac + Windows、Windows/Linux 為主，或其他？
2. 你想用哪個同步管道：Google Drive、iCloud、Dropbox、OneDrive、GitHub only，或讓 Codex 推薦？
3. 要不要加 GitHub 版本備份：私有 repo、公開 repo、不要、之後再說？
4. 健康檢查要怎麼跑：手動、每週、或排程？

After answers, summarize:

- device mix
- selected sync route
- backup/versioning route
- health-check cadence
- exact paths that would be touched
- exact files excluded for safety

Then wait for user approval before changing state.

## Suggested `.gitignore` Blocks

For private backups:

```gitignore
# Secrets and credentials
.env
.env.*
**/credentials.json
**/*.key
**/.credentials.json
**/token*

# Codex local or machine state
.codex/tmp/
.codex/cache/
.codex/sessions/
.codex/auth*

# System and build noise
.DS_Store
Thumbs.db
*.log
node_modules/
.venv*/
__pycache__/
```

For public backups, add:

```gitignore
# Personal or private memory
000_Agent/memory/
100_Todo/drafts/
100_Todo/archive/
300_Journal/
500_People/
*.private.md
```

Adjust these blocks to the actual folder layout before writing them.

## Health Check Shape

A Codex health check should verify:

- selected mother folder exists
- approved portable files exist
- custom skill folders each contain `SKILL.md`
- `SKILL.md` frontmatter includes `name` and `description`
- symlink targets exist if symlinks are used
- Git repo has a remote if GitHub backup was selected
- ignored sensitive files are not staged

The check should not print secrets, token contents, or private memory contents.

## Completeness Update

The first installed version summarized the source at a high level. The complete Codex conversion now lives in `codex-playbook.md` and covers:

- Section A preflight and four-question interview
- Section B mandatory backup
- Section C sync architecture and provider routes
- Section D private/public GitHub backup guidance
- Section E Codex health-check script shape
- Section F migration manual template
- Section G completion checklist
- pitfalls and FAQ converted from Claude Code to Codex App
