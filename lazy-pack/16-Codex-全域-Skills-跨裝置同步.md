# 16-Codex-全域-Skills-跨裝置同步

> 2026-05-24 更新：本文件已改為自含式 Skill 安裝文件。請使用文末「內建 Skill 完整安裝內容」，不需要額外的舊版獨立 skills 子目錄。


> 版本：2026-05-21 Codex App 版
> 用途：把 Codex 全域 skills 搬到雲端同步資料夾，並讓 `{{CODEX_HOME}}/skills` 用 symlink 指回雲端實體資料夾。
> 成品：下載者可直接安裝 `cross-device-sync` skill，並依本文件把全域 skills 同步到 Google Drive / iCloud / Dropbox / OneDrive。

## 這份文件會做什麼

這份懶人包只處理 **Codex 全域 skills** 的跨裝置同步，不處理個人助手或專案本地的 `000_Agent/skills`。

它會把：

```text
{{CODEX_HOME}}/skills
```

改成 symlink，指向你雲端資料夾裡的：

```text
{{SYNC_ROOT}}/skills
```

這樣新裝置只要登入同一個雲端帳號，再重建 symlink，就能讀到同一份全域 skills。

路徑邊界：

- `{{CODEX_HOME}}/skills`：Codex App 全域觸發的 skills；可 symlink 到 `{{SYNC_ROOT}}/skills`。
- `{{SYNC_ROOT}}/memory`、`{{SYNC_ROOT}}/workflows`、`{{SYNC_ROOT}}/knowledge`：個人助手全域資料層；不 symlink 到 `{{CODEX_HOME}}/skills`。
- `<project-root>/000_Agent/skills`：單一專案本地 skill；不 symlink 到 `{{CODEX_HOME}}/skills`。

## 不會同步的東西

不要把整個 `{{CODEX_HOME}}` 丟進雲端同步。`{{CODEX_HOME}}` 裡通常會有：

- `auth.json`
- logs / sqlite / sessions
- cache / tmp
- shell snapshots
- 本機狀態與登入資訊

這些跨裝置同步容易壞，也有隱私風險。本文件只同步 Codex 全域 `skills/`。個人助手全域記憶與 workflow 放在 `{{SYNC_ROOT}}/memory` 與 `{{SYNC_ROOT}}/workflows`，不要和 Codex 全域 skills 混成同一個 symlink。

## 先填變數

依你的環境替換：

| 變數 | 說明 | 範例 |
|---|---|---|
| `{{CODEX_HOME}}` | Codex 設定資料夾 | `{{CODEX_HOME}}` |
| `{{SETUP_REPO}}` | 這份懶人包所在專案 | `{{SETUP_REPO}}` |
| `{{SYNC_ROOT}}` | 雲端同步母資料夾 | `{{HOME}}/Library/CloudStorage/GoogleDrive-alex@example.com/My Drive/codex_symlink` |
| `{{BACKUP_ROOT}}` | 本機備份位置 | `{{HOME}}` |

請先把上表變數替換成自己的實際路徑；不要直接複製其他人的本機路徑。

## Step 1：安裝 cross-device-sync skill

先把本懶人包附的 skill 複製到 Codex 全域 skills。

```bash
mkdir -p "{{CODEX_HOME}}/skills/cross-device-sync"
# 請使用本文文末「內建 Skill 完整安裝內容」；不需要額外複製舊版獨立 skills 子目錄。
test -f "{{CODEX_HOME}}/skills/cross-device-sync/SKILL.md" && echo "cross-device-sync installed"
```

安裝後建議開新 Codex 對話，再用「跨裝置同步」或「cross-device-sync」觸發。

## Step 2：確認目前 skills 不是 symlink

```bash
if [ -L "{{CODEX_HOME}}/skills" ]; then
  echo "目前已經是 symlink：$(readlink "{{CODEX_HOME}}/skills")"
else
  echo "目前是實體資料夾，可以繼續"
fi
```

如果已經是 symlink，先不要重跑後續步驟。請先確認它是不是已經指向你要的雲端資料夾。

## Step 3：確認雲端目標資料夾

```bash
mkdir -p "{{SYNC_ROOT}}"
ls -la "{{SYNC_ROOT}}"
```

如果 `{{SYNC_ROOT}}/skills` 已存在，先檢查裡面是不是你要保留的 skills。不要直接覆蓋。

```bash
if [ -e "{{SYNC_ROOT}}/skills" ]; then
  echo "目標已存在，請先檢查：{{SYNC_ROOT}}/skills"
  exit 1
fi
```

## Step 4：建立備份、複製、改 symlink

這一步會改動 `{{CODEX_HOME}}/skills`。請完整執行，不要拆開跳步。

```bash
set -e

SOURCE="{{CODEX_HOME}}/skills"
ROOT="{{SYNC_ROOT}}"
TARGET="$ROOT/skills"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="{{BACKUP_ROOT}}/codex-backup-$STAMP"
OLD="$SOURCE.before-symlink-$STAMP"

if [ ! -d "$SOURCE" ] || [ -L "$SOURCE" ]; then
  echo "SOURCE_NOT_REAL_DIR:$SOURCE"
  exit 1
fi

if [ -e "$TARGET" ]; then
  echo "TARGET_ALREADY_EXISTS:$TARGET"
  exit 1
fi

mkdir -p "$BACKUP" "$ROOT"
cp -a "$SOURCE" "$BACKUP/skills"
cp -a "$SOURCE" "$TARGET"
mv "$SOURCE" "$OLD"
ln -s "$TARGET" "$SOURCE"

echo "BACKUP=$BACKUP"
echo "OLD=$OLD"
echo "TARGET=$TARGET"
echo "LINK=$(readlink "$SOURCE")"
```

## Step 5：驗證

```bash
test -L "{{CODEX_HOME}}/skills" && echo "skills is symlink"
test -d "$(readlink "{{CODEX_HOME}}/skills")" && echo "target exists"
find "$(readlink "{{CODEX_HOME}}/skills")" -maxdepth 2 -name SKILL.md -not -path "*/.system/*" -print | wc -l
test -f "{{CODEX_HOME}}/skills/cross-device-sync/SKILL.md" && echo "cross-device-sync readable"
```

合理結果：

- `skills is symlink`
- `target exists`
- skill 數量大於 0
- `cross-device-sync readable`

注意：`find "{{CODEX_HOME}}/skills"` 在某些系統上不會跟進 symlink，所以檢查數量時要用 `readlink` 取得實體目標。

## Step 6：第二台電腦怎麼接

第二台電腦登入同一個雲端帳號，等 `{{SYNC_ROOT}}/skills` 同步完成後：

```bash
set -e

SOURCE="{{CODEX_HOME}}/skills"
TARGET="{{SYNC_ROOT}}/skills"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="{{BACKUP_ROOT}}/codex-backup-$STAMP"

if [ ! -d "$TARGET" ]; then
  echo "TARGET_MISSING:$TARGET"
  exit 1
fi

if [ -e "$SOURCE" ] && [ ! -L "$SOURCE" ]; then
  mkdir -p "$BACKUP"
  cp -a "$SOURCE" "$BACKUP/skills"
  mv "$SOURCE" "$SOURCE.before-symlink-$STAMP"
fi

if [ -L "$SOURCE" ]; then
  rm "$SOURCE"
fi

ln -s "$TARGET" "$SOURCE"
test -f "$SOURCE/cross-device-sync/SKILL.md" && echo "skills symlink ready"
```

每台電腦的 Codex App 仍需要各自登入，不要同步 `auth.json`。

## 回復方式

如果改完後 Codex 讀不到 skills，先找剛才輸出的：

```text
BACKUP=...
OLD=...
```

最安全的回復方式：

```bash
rm "{{CODEX_HOME}}/skills"
mv "{{CODEX_HOME}}/skills.before-symlink-YYYYMMDD-HHMMSS" "{{CODEX_HOME}}/skills"
```

如果 `before-symlink` 不在了，才使用 `{{BACKUP_ROOT}}/codex-backup-YYYYMMDD-HHMMSS/skills` 還原。

## 下載者安全規則

- 不要同步整個 `{{CODEX_HOME}}`。
- 不要同步 `auth.json`、token、`.env`、sqlite、logs、sessions、cache。
- 不要把私密 skills、個人記憶或草稿放進 public repo。
- 先備份，再 symlink。
- 改完後重開 Codex 新對話或重啟 Codex App。

## 驗收紀錄範本

完成後請記錄自己的結果：

```text
{{CODEX_HOME}}/skills
→ {{SYNC_ROOT}}/skills

BACKUP={{BACKUP_ROOT}}/codex-backup-YYYYMMDD-HHMMSS
OLD={{CODEX_HOME}}/skills.before-symlink-YYYYMMDD-HHMMSS
RESULT=<可讀到的自訂 skill 數量與抽測結果>
```

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills` 是 symlink。
- [ ] `readlink "{{CODEX_HOME}}/skills"` 指向 `{{SYNC_ROOT}}/skills`。
- [ ] `{{SYNC_ROOT}}/skills` 內有自訂 skills。
- [ ] `{{CODEX_HOME}}/skills/cross-device-sync/SKILL.md` 可讀。
- [ ] 本機備份資料夾存在。
- [ ] 未同步整個 `{{CODEX_HOME}}`。
- [ ] 未同步任何 token、憑證、`.env`、sqlite、logs、sessions。
- [ ] 開新 Codex 對話後，全域 skills 可觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`cross-device-sync`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{CODEX_HOME}}`。

```bash
set -e

decode_base64() {
  if base64 --help 2>/dev/null | grep -q -- '-d'; then
    base64 -d
  else
    base64 -D
  fi
}

# ---- cross-device-sync ----
mkdir -p "{{CODEX_HOME}}/skills/cross-device-sync"
# cross-device-sync/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/cross-device-sync/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/cross-device-sync/SKILL.md" <<'CODEX_LAZYPACK_CROSS_DEVICE_SYNC_SKILL_MD'
---
name: cross-device-sync
description: Use when the user asks to set up, audit, repair, or document cross-device synchronization and portability for Codex App configuration, global skills, AGENTS.md rules, Arry Assistant data, Obsidian project cockpits, or AI assistant memory across Macs, Windows/Linux, Google Drive, iCloud, Dropbox, OneDrive, or GitHub backups.
metadata:
  short-description: Plan and verify Codex cross-device portability
---

# Cross-Device Sync

Use this skill to help the user make their Codex App setup portable across devices without binding their assistant memory, skills, or rules to one local machine.

This is a Codex App conversion of a Claude Code-oriented cross-device sync guide. Do not apply the source guide literally. In this environment, the default surfaces are:

- Codex config and skills: `$CODEX_HOME`, or `~/.codex` when `$CODEX_HOME` is not set
- Custom global skills: `$CODEX_HOME/skills`, or `~/.codex/skills` when `$CODEX_HOME` is not set
- Project rules: `AGENTS.md`
- Optional assistant data-layer root: `ASSISTANT_ROOT`
- Optional assistant global layer: `ASSISTANT_ROOT`, containing `skills/`, `memory/`, `workflows/`, and `knowledge/`
- Optional assistant local work/reference layers: `100_Todo/` and `200_Reference/` under the selected assistant or project root
- Optional Obsidian vault: `OBSIDIAN_VAULT`
- Optional project cockpit: `PROJECT_LIBRARY/<project-name>/專案工作流程.md`

This user's current defaults are documented in the root `README.md`; treat them as examples to replace, not universal paths.

## Non-Negotiables

- Do not create, depend on, or repair Claude-only paths such as `~/.claude`, `CLAUDE.md`, `.claude/skills`, Claude slash commands, or Claude subagents unless the user explicitly asks to migrate from Claude.
- Do not move, symlink, delete, or overwrite the user's existing Codex config, skills, memories, or Obsidian notes without first showing the concrete plan and getting explicit confirmation.
- Always make a timestamped backup before any operation that moves files, rewrites symlinks, changes Git remotes, or edits shared assistant memory.
- Never sync secrets, OAuth tokens, API keys, local credentials, app caches, shell snapshots, or machine-specific state across devices.
- Treat public repos as public. Do not put private backups, credentials, private memory, drafts, or personal logs into tracked project files.
- Prefer the user's established project folder and knowledge cockpit pattern unless they choose another sync route.

## Workflow

1. Read local rules:
   - Current project `AGENTS.md`
   - Secondbrain `AGENTS.md` if Obsidian notes are involved
   - `arry-assistant` skill if Arry Assistant data is involved
2. Inventory current state before proposing changes:
   - `$CODEX_HOME/config.toml` or `~/.codex/config.toml`
   - `$CODEX_HOME/skills` or `~/.codex/skills`
   - `$CODEX_HOME/memories` or `~/.codex/memories` if memory portability is in scope
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
| `來源工具的舊 skills 路徑` | `$CODEX_HOME/skills` or `~/.codex/skills` |
| `CLAUDE.md` | `AGENTS.md` |
| Claude slash commands | Codex skill metadata and normal user prompts |
| Claude subagents | Codex subagents only when explicitly requested; otherwise use validation passes |
| Claude memory | `$CODEX_HOME/memories` plus optional personal assistant durable data when relevant |
| `000_Agent` from source kit | Project-local assistant layer only; this user's global assistant layer is `ASSISTANT_ROOT` with `memory/`, `workflows/`, `knowledge/`, and `skills/` |
| Claude credentials/local state | Do not sync; each device logs in independently |

## Sync Route Guidance

- Apple-only multi-device setup: iCloud can work, but verify paths and symlink behavior carefully.
- Mac plus Windows or Android-heavy setup: Google Drive or Dropbox is usually more predictable.
- Windows/Linux-first setup: Google Drive, OneDrive, Dropbox, or GitHub-only depending on existing habits.
- Single computer: focus on portability backup and migration docs; real-time sync may be unnecessary.
- Existing personal-assistant workflows: prefer the user's already-established sync provider and project cockpit pattern.

## What To Sync

Usually portable:

- custom global skills under `$CODEX_HOME/skills` or `~/.codex/skills`, excluding `.system`
- reusable project rules and templates
- personal assistant durable references and reusable memory under `ASSISTANT_ROOT/memory` and `ASSISTANT_ROOT/workflows`, when the user explicitly wants that layer synced
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
CODEX_LAZYPACK_CROSS_DEVICE_SYNC_SKILL_MD

# cross-device-sync/agents/openai.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/cross-device-sync/agents/openai.yaml")"
cat > "{{CODEX_HOME}}/skills/cross-device-sync/agents/openai.yaml" <<'CODEX_LAZYPACK_CROSS_DEVICE_SYNC_AGENTS_OPENAI_YAML'
display_name: Cross-Device Sync
short_description: Plan, install, and verify portable Codex setup across devices.
default_prompt: Help me plan a safe Codex App cross-device sync setup.
CODEX_LAZYPACK_CROSS_DEVICE_SYNC_AGENTS_OPENAI_YAML

# cross-device-sync/references/codex-playbook.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/cross-device-sync/references/codex-playbook.md")"
cat > "{{CODEX_HOME}}/skills/cross-device-sync/references/codex-playbook.md" <<'CODEX_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_CODEX_PLAYBOOK_MD'
# Codex Cross-Device Sync Playbook

This is the Codex App-compatible execution version of `07-cross-device-sync.md`.

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
| Codex home | `{{CODEX_HOME}}` |
| Custom global skills | `{{CODEX_HOME}}/skills` symlinked to `{{SYNC_ROOT}}/skills` |
| System skills | `{{CODEX_HOME}}/skills/.system` |
| Project rules | `AGENTS.md` |
| Main project | `{{SETUP_REPO}}` |
| Arry Assistant global data-layer root | `{{SYNC_ROOT}}` |
| Arry Assistant memory/workflow layer | `{{SYNC_ROOT}}/memory`, `{{SYNC_ROOT}}/workflows` |
| Arry Assistant local work/reference layers | `100_Todo/` and `200_Reference/` under `codex_installation` |
| Obsidian vault | `{{OBSIDIAN_VAULT}}` |
| Global skill mirror note | `專案庫/codex_installation/全域 Skills/全域 Skills 同步.md` |
| GitHub repo visibility | `icestone0128/codex_installation` is public |

## Absolute Safety Rules

1. Do not perform real sync setup during skill installation.
2. Do not move, delete, symlink, or overwrite `{{CODEX_HOME}}`, `AGENTS.md`, Obsidian notes, Arry Assistant data, or Git history without explicit user approval after showing a concrete plan.
3. Make a timestamped backup before moving files, replacing files with symlinks, changing remotes, or editing shared memory.
4. Do not sync secrets or machine state:
   - `.env`, API keys, tokens, passwords
   - OAuth credentials and auth files
   - local settings tied to one computer
   - cache, telemetry, shell snapshots, session state
   - generated logs unless the user explicitly wants archival logs
5. Treat `codex_installation` as a public repo. Do not place private backups, credentials, private memory, drafts, or personal logs in tracked project paths.
6. Do not edit system skills under `{{CODEX_HOME}}/skills/.system`.
7. If Obsidian notes are involved, read the vault `AGENTS.md` and update additively.

## Section A: Preflight And Interview

### A-1. Confirm The Existing Codex/Arry Base

Check whether the user's existing Codex App assistant base is present:

```bash
test -d "{{CODEX_HOME}}" && echo "Codex home exists"
test -d "{{CODEX_HOME}}/skills" && echo "Codex skills folder exists"
test -d "{{SYNC_ROOT}}" && echo "Arry Assistant global root exists"
test -d "{{SYNC_ROOT}}/memory" && echo "Arry Assistant memory exists"
test -d "{{SYNC_ROOT}}/workflows" && echo "Arry Assistant workflows exists"
test -d "{{PROJECT_ROOT}}/100_Todo" && echo "Arry Assistant work layer exists"
test -d "{{PROJECT_ROOT}}/200_Reference" && echo "Arry Assistant reference layer exists"
test -f "{{SETUP_REPO}}/AGENTS.md" && echo "codex_installation AGENTS.md exists"
```

If core pieces are missing, stop and explain the missing prerequisite. Do not invent a second assistant data layer. The existing architecture is a root plus layers: `codex_installation/` contains `000_Agent/`, `100_Todo/`, and `200_Reference/`.

### A-2. Inventory Current Assets

Gather only metadata unless the user asks for deeper inspection:

```bash
ls -la "{{CODEX_HOME}}" 2>/dev/null | head -40
find "{{CODEX_HOME}}/skills" -maxdepth 2 -name SKILL.md -print 2>/dev/null | sort
find "{{SETUP_REPO}}" -maxdepth 1 -type d -print 2>/dev/null | sort
find "{{SYNC_ROOT}}/memory" -maxdepth 2 -type f -print 2>/dev/null | sort | head -80
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
cp -a "{{SYNC_ROOT}}/memory" "$BACKUP_DIR/memory" 2>/dev/null || true
cp -a "{{SYNC_ROOT}}/workflows" "$BACKUP_DIR/workflows" 2>/dev/null || true
cp -a "{{SYNC_ROOT}}/knowledge" "$BACKUP_DIR/knowledge" 2>/dev/null || true
cp -a "{{PROJECT_ROOT}}/100_Todo" "$BACKUP_DIR/100_Todo" 2>/dev/null || true
cp -a "{{PROJECT_ROOT}}/200_Reference" "$BACKUP_DIR/200_Reference" 2>/dev/null || true
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
| Existing Google Drive workflow | `{{SETUP_REPO}}` as the data-layer root |
| Arry Assistant global memory/workflows | `{{SYNC_ROOT}}/memory` and `{{SYNC_ROOT}}/workflows` |
| iCloud | `$HOME/Library/Mobile Documents/com~apple~CloudDocs/Arry-Agent` |
| Dropbox | `$HOME/Dropbox/Arry-Agent` |
| OneDrive | `$HOME/Library/CloudStorage/OneDrive-Personal/Arry-Agent` |
| GitHub only | `$HOME/Arry-Agent` or an approved project folder |

For this user, prefer the existing Google Drive `codex_symlink` root when the task concerns the global Arry Assistant data layer. Do not put private memory back into the public `codex_installation` repo.

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

- `{{CODEX_HOME}}/skills/.system`
- credentials, OAuth state, secrets, `.env`
- session state, temporary caches, logs
- per-device config unless confirmed safe
- private drafts or personal memory in a public repo

### C-3. Copy Versus Symlink

Use symlinks only when they solve a real duplication problem and the user understands the tradeoff.

Safer default:

- keep the Codex-facing path as `{{CODEX_HOME}}/skills`; it may be symlinked to `{{SYNC_ROOT}}/skills` after cross-device sync is configured
- mirror documentation, install instructions, and inventory into Obsidian and the existing project notes
- back up and version controlled exports as needed
- on a second device, recreate the symlink only after confirming the Google Drive folder has synced and the local `{{CODEX_HOME}}/skills` target has been backed up

Riskier route:

- move selected custom skills into the mother folder
- symlink them back into `{{CODEX_HOME}}/skills/<skill-name>`

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

- assistant data-layer root: `codex_symlink/MIGRATION.md` for global assistant migration
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

No. Use the existing `codex_symlink` as the global data-layer root. Keep private memory out of the public `codex_installation` repo.

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
CODEX_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_CODEX_PLAYBOOK_MD

# cross-device-sync/references/source-adaptation.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/cross-device-sync/references/source-adaptation.md")"
cat > "{{CODEX_HOME}}/skills/cross-device-sync/references/source-adaptation.md" <<'CODEX_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_SOURCE_ADAPTATION_MD'
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
| `來源工具的舊 skills 路徑` stores skills | `{{CODEX_HOME}}/skills` stores global Codex skills |
| `CLAUDE.md` is the rule file | `AGENTS.md` is the project rule file |
| Claude slash commands are user-facing entry points | Codex skills trigger by metadata and user intent |
| Claude subagents are part of the workflow | Codex subagents are only used when explicitly requested or clearly useful |
| `000_Agent/` is created by pro-kit 01 | This user's global Arry Assistant data lives under `codex_symlink/`; project-local data may use each project's `000_Agent/` |
| Source examples refer to Raymond/Raymond-Agent | Use Arry Assistant and the user's existing Google Drive/Obsidian paths |

## Codex-Specific Safety Changes

- The skill must not automatically move or symlink `{{CODEX_HOME}}` assets during installation.
- Any future sync setup must be plan-first and approval-gated because it can affect all Codex sessions.
- The default sync approach for this user should align with Google Drive project folders and Obsidian project cockpits.
- The existing Arry Assistant architecture uses Google Drive `codex_symlink/` as the global layer for `skills/`, `memory/`, `workflows/`, and `knowledge/`; project-local data may still use each project's `000_Agent/`.
- `icestone0128/codex_installation` is public, so private backups and personal memory must not be staged or tracked there.
- System skills under `{{CODEX_HOME}}/skills/.system` are Codex-managed and should not be edited or moved manually.
- Global skill changes must update the Obsidian mirror note at `專案庫/codex_installation/全域 Skills/全域 Skills 同步.md`.

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
CODEX_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_SOURCE_ADAPTATION_MD

test -f "{{CODEX_HOME}}/skills/cross-device-sync/SKILL.md" && echo "cross-device-sync installed"

echo "embedded skills installed: cross-device-sync"
```

<!-- END EMBEDDED_SKILLS -->
