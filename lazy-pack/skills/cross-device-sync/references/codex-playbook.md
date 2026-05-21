# Codex Cross-Device Sync Playbook

This is the Codex App-compatible execution version of `/Users/arrywu/Downloads/07-cross-device-sync.md`.

The original file targets Claude Code. This playbook keeps the full intent and operational coverage, but replaces Claude-specific assumptions with Codex App, Arry Assistant, Google Drive, Obsidian, and `AGENTS.md` conventions.

## Purpose

Help the user make their AI assistant setup portable:

- keep reusable rules, skills, memory, workflow docs, and migration notes owned by the user
- avoid hiding important assets only inside one local app folder
- separate portable assets from credentials, cache, app state, and device-specific files
- support a new computer, a second computer, or future migration to another AI tool

## What The User Should Get

After an approved execution, the user should have some or all of:

- a sync route selected for their device mix
- a timestamped backup before risky file movement
- a visible mother folder for portable assistant assets
- optional symlinks from local app paths to the mother folder, only when approved and technically appropriate
- optional private GitHub backup with a `.gitignore`
- optional `sync-health.sh` or equivalent health check
- a migration note explaining how to restore on a new device or adapt to a future AI tool
- a final verification report with exact changed paths

## Codex Surfaces

Default Codex surfaces on this machine:

| Purpose | Path or rule |
|---|---|
| Codex home | `/Users/arrywu/.codex` |
| Custom global skills | `/Users/arrywu/.codex/skills` symlinked to `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/skills` |
| System skills | `/Users/arrywu/.codex/skills/.system` |
| Project rules | `AGENTS.md` |
| Main project | `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation` |
| Arry Assistant data-layer root | `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation` |
| Arry Assistant global core layer | `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation/000_Agent` |
| Arry Assistant local work/reference layers | `100_Todo/` and `200_Reference/` under `codex_installation` |
| Obsidian vault | `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain` |
| Global skill mirror note | `專案庫/codex_installation/全域 Skills/全域 Skills 同步.md` |
| GitHub repo visibility | `icestone0128/codex_installation` is public |

## Absolute Safety Rules

1. Do not perform real sync setup during skill installation.
2. Do not move, delete, symlink, or overwrite `/Users/arrywu/.codex`, `AGENTS.md`, Obsidian notes, Arry Assistant data, or Git history without explicit user approval after showing a concrete plan.
3. Make a timestamped backup before moving files, replacing files with symlinks, changing remotes, or editing shared memory.
4. Do not sync secrets or machine state:
   - `.env`, API keys, tokens, passwords
   - OAuth credentials and auth files
   - local settings tied to one computer
   - cache, telemetry, shell snapshots, session state
   - generated logs unless the user explicitly wants archival logs
5. Treat `codex_installation` as a public repo. Do not place private backups, credentials, private memory, drafts, or personal logs in tracked project paths.
6. Do not edit system skills under `/Users/arrywu/.codex/skills/.system`.
7. If Obsidian notes are involved, read the vault `AGENTS.md` and update additively.

## Section A: Preflight And Interview

### A-1. Confirm The Existing Codex/Arry Base

Check whether the user's existing Codex App assistant base is present:

```bash
test -d "/Users/arrywu/.codex" && echo "Codex home exists"
test -d "/Users/arrywu/.codex/skills" && echo "Codex skills folder exists"
test -d "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation" && echo "Arry Assistant data-layer root exists"
test -d "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation/000_Agent" && echo "Arry Assistant core exists"
test -d "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation/100_Todo" && echo "Arry Assistant work layer exists"
test -d "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation/200_Reference" && echo "Arry Assistant reference layer exists"
test -f "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation/AGENTS.md" && echo "codex_installation AGENTS.md exists"
```

If core pieces are missing, stop and explain the missing prerequisite. Do not invent a second assistant data layer. The existing architecture is a root plus layers: `codex_installation/` contains `000_Agent/`, `100_Todo/`, and `200_Reference/`.

### A-2. Inventory Current Assets

Gather only metadata unless the user asks for deeper inspection:

```bash
ls -la "/Users/arrywu/.codex" 2>/dev/null | head -40
find "/Users/arrywu/.codex/skills" -maxdepth 2 -name SKILL.md -print 2>/dev/null | sort
find "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation" -maxdepth 1 -type d -print 2>/dev/null | sort
find "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation/000_Agent" -maxdepth 2 -type f -print 2>/dev/null | sort | head -80
```

Record:

- does `config.toml` exist?
- how many custom skills exist?
- which assets are custom versus Codex-managed `.system`?
- whether Arry Assistant root, core, work, and reference layers are already under Google Drive
- whether `codex_installation` is public and what files are tracked
- whether the target Obsidian cockpit exists
- whether the current project has Git and a remote

### A-3. Ask Four Questions

Use concise Traditional Chinese. In Codex App, a plain text question is acceptable unless the current mode/tooling provides an interactive choice UI.

Ask:

1. 你的裝置組合是：只有一台、多台 Mac、Mac + Windows、Windows/Linux 為主，或其他？
2. 你想用哪個同步管道：Google Drive、iCloud、Dropbox、OneDrive、只靠 GitHub，或讓我推薦？
3. 要不要加 GitHub 版本備份：私有 repo、公開 repo、不要、之後再說？
4. 健康檢查要怎麼跑：手動、每週、每天排程，或先不要？

### A-4. Recommend A Route

Route logic:

| Device mix | Default recommendation |
|---|---|
| 多台 Mac | iCloud or existing Google Drive, depending on where the user reads notes |
| Mac + Windows | Google Drive or Dropbox |
| Windows/Linux first | Google Drive, OneDrive, Dropbox, or GitHub-only |
| Single computer | portability backup plus private GitHub, no real-time sync required |
| Existing Arry workflow on this machine | Google Drive plus Obsidian cockpit is the strongest default |

Before changing anything, show:

- device mix
- chosen sync channel
- GitHub backup decision
- health-check cadence
- exact target mother folder
- whether the target is the data-layer root, the global core layer, or a separate backup/export folder
- exact files or folders to touch
- exact exclusions
- rollback plan

Then wait for explicit approval.

## Section B: Mandatory Backup

Use a Codex-specific backup name and place it somewhere visible and outside the risky operation. Because `codex_installation` is public, do not create private backups inside tracked project paths. If a backup must live under the project folder temporarily, first ensure the backup folder is ignored and report that clearly.

Example:

```bash
BACKUP_DIR="$HOME/codex-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -a "$HOME/.codex/config.toml" "$BACKUP_DIR/config.toml" 2>/dev/null || true
cp -a "$HOME/.codex/skills" "$BACKUP_DIR/skills" 2>/dev/null || true
```

If Arry Assistant data will be changed:

```bash
cp -a "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation/000_Agent" "$BACKUP_DIR/000_Agent" 2>/dev/null || true
cp -a "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation/100_Todo" "$BACKUP_DIR/100_Todo" 2>/dev/null || true
cp -a "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation/200_Reference" "$BACKUP_DIR/200_Reference" 2>/dev/null || true
```

Verify backup:

```bash
find "$BACKUP_DIR" -maxdepth 3 -type f | wc -l
```

Tell the user:

- backup path
- what was backed up
- what was not backed up
- how to restore at a high level

Do not include destructive restore commands in final text unless the user is actively restoring.

## Section C: Build The Sync Architecture

### C-1. Choose Mother Folder

Possible mother folders:

| Route | Example mother folder |
|---|---|
| Existing Google Drive workflow | `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation` as the data-layer root |
| Arry Assistant global core only | `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation/000_Agent` |
| iCloud | `$HOME/Library/Mobile Documents/com~apple~CloudDocs/Arry-Agent` |
| Dropbox | `$HOME/Dropbox/Arry-Agent` |
| OneDrive | `$HOME/Library/CloudStorage/OneDrive-Personal/Arry-Agent` |
| GitHub only | `$HOME/Arry-Agent` or an approved project folder |

For this user, prefer the existing Google Drive `codex_installation` root when the task concerns the whole Arry Assistant data layer. Use `codex_installation/000_Agent` only when the task is specifically about the global core layer. Do not collapse `100_Todo/` and `200_Reference/` into `000_Agent/`.

### C-2. Decide What To Sync

Portable candidates:

- custom skill source or exported copies
- stable assistant rules and preferences
- reusable workflow docs
- migration docs
- health-check scripts
- curated memory intended for cross-project use
- Obsidian cockpit summaries and skill inventory indexes

Avoid syncing:

- `/Users/arrywu/.codex/skills/.system`
- credentials, OAuth state, secrets, `.env`
- session state, temporary caches, logs
- per-device config unless confirmed safe
- private drafts or personal memory in a public repo

### C-3. Copy Versus Symlink

Use symlinks only when they solve a real duplication problem and the user understands the tradeoff.

Safer default:

- keep the Codex-facing path as `/Users/arrywu/.codex/skills`; on this machine it is symlinked to Google Drive `codex_symlink/skills`
- mirror documentation, install instructions, and inventory into Obsidian and the existing project notes
- back up and version controlled exports as needed
- on a second device, recreate the symlink only after confirming the Google Drive folder has synced and the local `/Users/arrywu/.codex/skills` target has been backed up

Riskier route:

- move selected custom skills into the mother folder
- symlink them back into `/Users/arrywu/.codex/skills/<skill-name>`

Before symlinking, verify:

- target exists
- source is not a system skill
- backup is complete
- no file would be overwritten
- the target folder is private or explicitly safe for the contents being moved

### C-4. Route Notes

Apple/iCloud:

- Best for Apple-only setups.
- Decide mother location based on where the user reads Markdown. Obsidian generally wants real files inside its vault, not symlink targets.
- Keep symlinks outside iCloud when possible.

Dropbox:

- Useful across operating systems.
- Prefer mother folder inside Dropbox and symlink from local app path to mother, not the reverse.

Google Drive:

- Good default on this machine because projects already live in Google Drive.
- Quote paths carefully because they contain spaces and non-ASCII characters.
- Expect occasional sync delay.

OneDrive:

- Common for Microsoft-heavy setups.
- Check actual local path first.

GitHub only:

- Good for single-computer portability.
- Versioned backup matters more than real-time sync.

## Section D: GitHub Backup

Only do this if the user selected GitHub backup.

### D-1. Initialize Or Reuse Git

Check first:

```bash
git status --short --branch
git remote -v
```

Do not initialize inside the wrong folder. Do not add unrelated files.

In the current architecture, `codex_installation` already has a public GitHub repo. Do not use that public repo for private assistant memory or backups. If the user wants GitHub backup for private memory, recommend a separate private repo.

### D-2. `.gitignore` For Private Repo

Use and adapt:

```gitignore
# Secrets and credentials
.env
.env.*
**/credentials.json
**/*.key
**/.credentials.json
**/token*
**/auth*

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

### D-3. Extra Rules For Public Repo

Add stricter exclusions:

```gitignore
# Personal or private memory
000_Agent/memory/
000_Agent/**/private/
100_Todo/drafts/
100_Todo/archive/
300_Journal/
500_People/
*.private.md
codex-backup-*/
.local-backups/
```

### D-4. Stage Carefully

Before staging:

```bash
git status --short
```

After staging:

```bash
git diff --cached --name-only
```

Never stage secrets or machine-local state. If unsure, stop and ask.

### D-5. Push

If using GitHub CLI or connector, prefer private repositories for assistant memory. If the user wants public, warn that memory and personal notes may leak.

## Section E: Health Check Script

Generate a health check only after the target architecture is known. A Codex version should check Codex assets, not Claude assets.

Suggested `sync-health.sh` shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Codex sync health check"
FAIL=0

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"
MOTHER="${1:-}"

check_exists() {
  local label="$1"
  local path="$2"
  if [ -e "$path" ]; then
    echo "OK: $label -> $path"
  else
    echo "MISSING: $label -> $path"
    FAIL=$((FAIL+1))
  fi
}

check_exists "Codex home" "$CODEX_HOME"
check_exists "Codex skills" "$SKILLS_DIR"

if [ -n "$MOTHER" ]; then
  check_exists "Mother folder" "$MOTHER"
  if [ -d "$MOTHER/000_Agent" ]; then
    check_exists "Arry core layer" "$MOTHER/000_Agent"
    check_exists "Arry work layer" "$MOTHER/100_Todo"
    check_exists "Arry reference layer" "$MOTHER/200_Reference"
  fi
fi

if [ -d "$SKILLS_DIR" ]; then
  while IFS= read -r skill; do
    if ! grep -q "^name:" "$skill" || ! grep -q "^description:" "$skill"; then
      echo "BAD FRONTMATTER: $skill"
      FAIL=$((FAIL+1))
    fi
  done < <(find "$SKILLS_DIR" -maxdepth 2 -name SKILL.md -not -path "*/.system/*" -print)
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  echo "All checks passed."
else
  echo "$FAIL issue(s) found."
  exit 1
fi
```

Cadence:

- manual: create the script only
- weekly: document it in the cockpit or weekly review checklist
- daily scheduled: ask before adding cron/launchd because that changes local machine behavior

## Section F: Migration Manual

Create or update a migration note when the user asks for a durable setup. Suggested location:

- assistant data-layer root: `codex_installation/000_Agent/MIGRATION.md` for global assistant migration
- Obsidian cockpit summary: `專案庫/<project>/專案工作流程.md`

Suggested sections:

```markdown
# Codex AI Assistant Migration Manual

## Current Architecture

- Mother folder:
- Data-layer root:
- Global core layer:
- Work/reference layers:
- Sync channel:
- GitHub repo:
- Health check:
- Last verified:

## New Computer

1. Install Codex App and sign in normally.
2. Sync or clone the mother folder.
3. Restore or install approved custom skills.
4. Recreate any approved symlinks.
5. Log in separately for services that use OAuth or local credentials.
6. Confirm `000_Agent/`, `100_Todo/`, and `200_Reference/` boundaries are still intact.
7. Run the health check.

## Future AI Tool

1. Identify that tool's rule-file convention.
2. Convert `AGENTS.md` rules instead of copying blindly.
3. Reuse Markdown knowledge and workflows where compatible.
4. Rebuild tool-specific skills in the target format.

## Restore From Backup

- Backup path:
- What it contains:
- What still needs manual login:
```

## Section G: Completion Checklist

Before reporting done, verify:

- backup exists if any risky action was taken
- selected mother/data-layer folder exists
- `000_Agent/`, `100_Todo/`, and `200_Reference/` boundaries remain intact when using the Arry Assistant architecture
- approved portable files exist in expected location
- symlink targets exist if symlinks were used
- health check exists and runs if generated
- migration note exists if requested
- `.gitignore` exists before Git staging
- no secrets are staged
- no private memory, drafts, or backups are staged into public `codex_installation`
- Obsidian mirror note is updated if global skills changed
- Codex restart/new conversation requirement is reported when applicable

## Pitfalls Converted From Source

- Backup is mandatory because move plus symlink operations can break the user's assistant setup quickly.
- Obsidian and similar local vault tools often behave best with real files inside the vault, not symlinked targets.
- Sync route should follow device mix and reading habits, not popularity.
- Single-computer users still benefit from portability and versioned backup.
- Private and public GitHub backups need different privacy defaults.
- Health checks should not be cron by default; scheduled checks are local machine configuration and should be opt-in.
- Sync rules/skills/memory; do not sync app state/cache/credentials.
- A migration manual is part of portability because future setup context is otherwise lost.

## FAQ Converted To Codex

### I already have Arry Assistant. Does this replace it?

No. Use the existing `codex_installation` as the data-layer root and `codex_installation/000_Agent` as the global core layer unless the user explicitly wants a new architecture.

### Should Codex credentials be synced?

No. Each device should log in independently. Do not copy auth tokens or OAuth files.

### Can system skills be synced?

Do not edit or move `.system` skills. They are managed by Codex. Only custom skills should be backed up or mirrored.

### What if iCloud or another sync tool mishandles symlinks?

Prefer real files in the cloud mother folder and local symlinks pointing to those real files. Verify with the health check. If a target is broken, stop and restore from backup rather than guessing.

### What if two computers edit the same memory file?

Expect conflicts. Resolve with file comparison or Git history. Avoid simultaneous edits on multiple machines.

### How should Windows symlinks be handled?

Windows symlinks may require developer mode or administrator permissions. If the user is not comfortable with that, avoid symlinks and use copy/install steps plus Git backup.

### Can the user switch sync providers later?

Yes. Back up first, choose a new mother folder, move only approved portable assets, verify, then update the migration note.

### Can the user publish skills but keep memory private?

Yes. Use separate repos or a strict `.gitignore`. Public repos should exclude personal memory, drafts, journals, people notes, and private files.

## Attribution Note

The source file credits Raymond Hou / 雷蒙 and is licensed CC BY-NC-SA 4.0 for personal use. Keep attribution in derived notes when quoting or redistributing source-derived material. This Codex skill is an operational adaptation for the user's local Codex App workflow.
