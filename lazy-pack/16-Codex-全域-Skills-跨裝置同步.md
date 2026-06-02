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

若你也要讓 Codex 與其他 AI agent 共用同一份全域規則，主檔固定放：

```text
{{SYNC_ROOT}}/core-rules.md
```

`{{CODEX_HOME}}/AGENTS.md` (或 AntiGravity 的 `~/.gemini/config/AGENTS.md`) 只作為全域入口 symlink，指向 `{{SYNC_ROOT}}/core-rules.md`。不要再建立或維護 `{{SYNC_ROOT}}/agents/AGENTS.md`。

路徑邊界：

- `{{CODEX_HOME}}/skills`：Codex 全域 skills (在 AntiGravity 為 `~/.gemini/config/plugins/codex/skills`)；可 symlink 到 `{{SYNC_ROOT}}/skills`。
- `{{SYNC_ROOT}}/core-rules.md`：可攜式全域核心規則主檔；其他 AI agent 也應讀這一份。
- `{{CODEX_HOME}}/AGENTS.md`：Codex 全域規則入口 (在 AntiGravity 為 `~/.gemini/config/AGENTS.md`)；可 symlink 到 `{{SYNC_ROOT}}/core-rules.md`。
- `{{SYNC_ROOT}}/memories`、`{{SYNC_ROOT}}/workflows`、`{{SYNC_ROOT}}/knowledge`：個人助手全域資料層；不 symlink 到 `{{CODEX_HOME}}/skills`。
- `<project-root>/000_Agent/skills`：單一專案本地 skill；不 symlink 到 `{{CODEX_HOME}}/skills`。

## 多 Agent 相容性健檢

如果你未來可能使用其他 AI agent，本項也提供「多 Agent 相容性健檢」流程。這不是要建立另一套 agent 專用設定，而是檢查哪些資產可以被其他 agent 安全讀取、哪些必須轉換、哪些不應同步。

健檢重點：

- `{{SYNC_ROOT}}/core-rules.md` 是否仍是唯一全域核心規則主檔。
- `{{CODEX_HOME}}/AGENTS.md` 是否只是 Codex App 的 symlink 入口。
- 其他 AI agent 若要接入，是否透過自己的規則入口讀同一份 `core-rules.md`。
- `{{SYNC_ROOT}}/skills`、`memories`、`workflows`、`knowledge` 是否保持可攜式 Markdown / package 結構。
- MCP、plugin、hooks、commands、subtask / delegation 設定是否只做格式轉換，不直接共用不相容設定檔。
- session、logs、auth、cache、token、shell snapshot 是否明確排除。

這個流程預設只輸出健檢報告，不會直接改檔。詳細檢查表已內嵌在 `cross-device-sync/references/multi-agent-compatibility.md`。

## 不會同步的東西

不要把整個 `{{CODEX_HOME}}` 丟進雲端同步。`{{CODEX_HOME}}` 裡通常會有：

- `auth.json`
- logs / sqlite / sessions
- cache / tmp
- shell snapshots
- 本機狀態與登入資訊

這些跨裝置同步容易壞，也有隱私風險。本文件只同步 Codex 全域 `skills/`。個人助手全域記憶與 workflow 放在 `{{SYNC_ROOT}}/memories` 與 `{{SYNC_ROOT}}/workflows`，不要和 Codex 全域 skills 混成同一個 symlink。

## 先填變數

依你的環境替換：

| 變數 | 說明 | 範例 |
|---|---|---|
| `{{CODEX_HOME}}` | Codex 設定資料夾 | `{{CODEX_HOME}}` |
| `{{SETUP_REPO}}` | 這份懶人包所在專案 | `{{SETUP_REPO}}` |
| `{{SYNC_ROOT}}` | 雲端同步母資料夾 | `{{HOME}}/Library/CloudStorage/GoogleDrive-alex@example.com/My Drive/codex_symlink` |
| `{{GLOBAL_RULES}}` | 可攜式全域核心規則主檔 | `{{SYNC_ROOT}}/core-rules.md` |
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

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `~/.codex`。

```bash
set -e

decode_base64() {
  if command -v base64 >/dev/null 2>&1; then
    base64 --decode 2>/dev/null || base64 -D
  else
    python3 -c 'import base64,sys; sys.stdout.buffer.write(base64.b64decode(sys.stdin.buffer.read()))'
  fi
}

# ---- cross-device-sync ----
mkdir -p "{{CODEX_HOME}}/skills/cross-device-sync"
# cross-device-sync/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/cross-device-sync/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/cross-device-sync/SKILL.md" <<'CODEX_LAZYPACK_55B84175E734BB08CCCDB1E958F82FD90EE89E0F'
---
name: cross-device-sync
description: Use when the user asks to set up, audit, repair, or document cross-device synchronization and portability for Codex App configuration, global skills, AGENTS.md rules, shared core-rules.md, Arry Assistant data, Obsidian project cockpits, AI assistant memory, or multi-agent compatibility across Macs, Windows/Linux, Google Drive, iCloud, Dropbox, OneDrive, GitHub backups, or other AI agents.
metadata:
  short-description: Plan and verify Codex cross-device portability
---

# Cross-Device Sync

Use this skill to help the user make their Codex App setup portable across devices and compatible with other AI agents without binding assistant memory, skills, or rules to one local machine or one vendor-specific app folder.

This is a Codex App portability workflow. If source material comes from another AI agent ecosystem, do not apply that source literally. In this environment, the default surfaces are:

- Codex config and skills: `$CODEX_HOME`, or `~/.codex` when `$CODEX_HOME` is not set
- Portable global rules: `ASSISTANT_ROOT/core-rules.md` or `SYNC_ROOT/core-rules.md`; `$CODEX_HOME/AGENTS.md` may be a symlink entrypoint to that file
- Custom global skills: `$CODEX_HOME/skills`, or `~/.codex/skills` when `$CODEX_HOME` is not set
- Project rules: `AGENTS.md`
- Optional assistant data-layer root: `ASSISTANT_ROOT`
- Optional assistant global layer: `ASSISTANT_ROOT`, containing `skills/`, `memories/`, `workflows/`, and `knowledge/`
- Optional assistant local work/reference layers: `100_Todo/` and `200_Reference/` under the selected assistant or project root
- Optional Obsidian vault: `OBSIDIAN_VAULT`
- Optional project cockpit: `PROJECT_LIBRARY/<project-name>/專案工作流程.md`

This user's current defaults are documented in the root `README.md`; treat them as examples to replace, not universal paths.

## Non-Negotiables

- Do not create, depend on, or repair another tool's app-specific config paths, rule files, command shims, or delegation formats unless the user explicitly asks to migrate from that tool.
- Do not move, symlink, delete, or overwrite the user's existing Codex config, skills, memories, or Obsidian notes without first showing the concrete plan and getting explicit confirmation.
- Always make a timestamped backup before any operation that moves files, rewrites symlinks, changes Git remotes, or edits shared assistant memory.
- Never sync secrets, OAuth tokens, API keys, local credentials, app caches, shell snapshots, or machine-specific state across devices.
- Treat public repos as public. Do not put private backups, credentials, private memory, drafts, or personal logs into tracked project files.
- Prefer the user's established project folder and knowledge cockpit pattern unless they choose another sync route.
- For other AI agents, share durable Markdown assets such as `core-rules.md`, documented workflows, and portable skill packages; do not symlink incompatible app config files together.

## Workflow

1. Read local rules:
   - Current project `AGENTS.md`
   - Secondbrain `AGENTS.md` if Obsidian notes are involved
   - `arry-assistant` skill if Arry Assistant data is involved
2. Inventory current state before proposing changes:
   - `$CODEX_HOME/config.toml` or `~/.codex/config.toml`
   - `$CODEX_HOME/AGENTS.md` and its symlink target; if portability is intended, the target should be `ASSISTANT_ROOT/core-rules.md` or `SYNC_ROOT/core-rules.md`
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

## Multi-Agent Compatibility Audit

Use this route when the user asks whether their setup can be used by other AI agents, whether another agent should read the same memory/rules, or whether a non-Codex guide should be merged into this portability workflow.

Default behavior:

1. Audit first; do not modify files.
2. Treat `SYNC_ROOT/core-rules.md` as the cross-agent global rules source of truth.
3. Treat `$CODEX_HOME/AGENTS.md` as Codex's symlink entrypoint to that file.
4. Keep app-specific config files separate; convert settings formats instead of sharing them directly.
5. Classify each asset as portable, convertible, local-only, or unsafe-to-sync.
6. Produce a report with risks, recommended changes, and confirmation gates.

Read `references/multi-agent-compatibility.md` for the detailed checklist and report template.

## Codex Portability Map

Use this mapping when converting non-Codex assistant instructions:

| Source guide concept | Codex App version |
|---|---|
| `來源工具的舊 skills 路徑` | `$CODEX_HOME/skills` or `~/.codex/skills` |
| Source-specific global or project rule file | `AGENTS.md` for project rules, plus `core-rules.md` for portable global rules |
| Global agent rules shared across tools | `ASSISTANT_ROOT/core-rules.md` or `SYNC_ROOT/core-rules.md`, with `$CODEX_HOME/AGENTS.md` as a symlink entrypoint when supported |
| Source-specific command shortcuts | Codex skill metadata and normal user prompts |
| Source-specific delegation format | Codex validation passes or supported delegation tools only when explicitly requested |
| Source-specific memory folder | `$CODEX_HOME/memories` plus optional personal assistant durable data when relevant |
| `000_Agent` from source kit | Project-local assistant layer only; this user's global assistant layer is `ASSISTANT_ROOT` with `memories/`, `workflows/`, `knowledge/`, and `skills/` |
| Source-specific credentials/local state | Do not sync; each device logs in independently |

## Sync Route Guidance

- Apple-only multi-device setup: iCloud can work, but verify paths and symlink behavior carefully.
- Mac plus Windows or Android-heavy setup: Google Drive or Dropbox is usually more predictable.
- Windows/Linux-first setup: Google Drive, OneDrive, Dropbox, or GitHub-only depending on existing habits.
- Single computer: focus on portability backup and migration docs; real-time sync may be unnecessary.
- Existing personal-assistant workflows: prefer the user's already-established sync provider and project cockpit pattern.

## What To Sync

Usually portable:

- custom global skills under `$CODEX_HOME/skills` or `~/.codex/skills`, excluding `.system`
- portable global operating rules in `ASSISTANT_ROOT/core-rules.md` or `SYNC_ROOT/core-rules.md`, so other AI agents can read the same rule file
- reusable project rules and templates
- personal assistant durable references and reusable memory under `ASSISTANT_ROOT/memories` and `ASSISTANT_ROOT/workflows`, when the user explicitly wants that layer synced
- migration docs, health-check scripts, and setup notes

Usually not portable:

- tokens, OAuth files, credentials, API keys, `.env`
- per-device local settings
- caches, telemetry, shell snapshots, conversation state
- generated temp files and logs unless the user explicitly wants archival logs

## Reference

When more detail is needed:

- Read `references/codex-playbook.md` before executing a real cross-device setup, audit, repair, GitHub backup, health-check script, or migration-manual task. It contains the full Codex-converted Section A-G workflow, routes, templates, checks, pitfalls, and FAQ.
- Read `references/multi-agent-compatibility.md` before checking whether Codex settings, global rules, skills, memory, MCP, prompts, hooks, or project rules can be used by other AI agents.
- Read `references/source-adaptation.md` when you need to understand how external assistant setup material was converted into Codex App-safe behavior.
CODEX_LAZYPACK_55B84175E734BB08CCCDB1E958F82FD90EE89E0F

# cross-device-sync/agents/openai.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/cross-device-sync/agents/openai.yaml")"
cat > "{{CODEX_HOME}}/skills/cross-device-sync/agents/openai.yaml" <<'CODEX_LAZYPACK_8FFA99F5690F2F878E77D5EA84B1A981B6023AEE'
display_name: Cross-Device Sync
short_description: Plan, install, and verify portable Codex setup across devices.
default_prompt: Help me plan a safe Codex App cross-device sync setup.
CODEX_LAZYPACK_8FFA99F5690F2F878E77D5EA84B1A981B6023AEE

# cross-device-sync/references/codex-playbook.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/cross-device-sync/references/codex-playbook.md")"
cat > "{{CODEX_HOME}}/skills/cross-device-sync/references/codex-playbook.md" <<'CODEX_LAZYPACK_244B6B6094451DECC11683740063DB593740D1B6'
# Codex Cross-Device Sync Playbook

This is the Codex App-compatible execution version of an external cross-device assistant setup guide.

The original source targeted a different assistant app. This playbook keeps the useful operating coverage, but replaces app-specific assumptions with Codex App, Arry Assistant, Google Drive, Obsidian, and `AGENTS.md` conventions.

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
| Portable global rules | `{{SYNC_ROOT}}/core-rules.md`; `{{CODEX_HOME}}/AGENTS.md` may symlink to it |
| Custom global skills | `{{CODEX_HOME}}/skills` symlinked to `{{SYNC_ROOT}}/skills` |
| System skills | `{{CODEX_HOME}}/skills/.system` |
| Project rules | `AGENTS.md` |
| Main project | `{{SETUP_REPO}}` |
| Arry Assistant global data-layer root | `{{SYNC_ROOT}}` |
| Arry Assistant memory/workflow layer | `{{SYNC_ROOT}}/memories`, `{{SYNC_ROOT}}/workflows` |
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
test -d "{{SYNC_ROOT}}/memories" && echo "Arry Assistant memory exists"
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
find "{{SYNC_ROOT}}/memories" -maxdepth 2 -type f -print 2>/dev/null | sort | head -80
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
- whether the target is the data-layer root, the portable global rules file `core-rules.md`, the global core layer, or a separate backup/export folder
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
cp -a "{{SYNC_ROOT}}/memories" "$BACKUP_DIR/memories" 2>/dev/null || true
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
| Arry Assistant global memory/workflows | `{{SYNC_ROOT}}/memories` and `{{SYNC_ROOT}}/workflows` |
| iCloud | `$HOME/Library/Mobile Documents/com~apple~CloudDocs/Arry-Agent` |
| Dropbox | `$HOME/Dropbox/Arry-Agent` |
| OneDrive | `$HOME/Library/CloudStorage/OneDrive-Personal/Arry-Agent` |
| GitHub only | `$HOME/Arry-Agent` or an approved project folder |

For this user, prefer the existing Google Drive `codex_symlink` root when the task concerns the global Arry Assistant data layer. Do not put private memory back into the public `codex_installation` repo.

### C-2. Decide What To Sync

Portable candidates:

- custom skill source or exported copies
- stable assistant rules and preferences, with cross-tool global operating rules in `core-rules.md`
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
000_Agent/memories/
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

Generate a health check only after the target architecture is known. A Codex version should check Codex assets, not another assistant app's assets.

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
2. Convert project `AGENTS.md` rules instead of copying blindly; put cross-tool global rules in `{{SYNC_ROOT}}/core-rules.md`.
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

## Section H: Multi-Agent Compatibility Audit

Use this section when the user does not want to use another specific vendor's app, but wants Codex assets to remain readable by future or parallel AI agents.

This is an audit-first flow. Do not change files until the user approves the report.

Check these surfaces:

| Surface | Portable approach |
|---|---|
| Global rules | `{{SYNC_ROOT}}/core-rules.md` remains the source of truth |
| Codex global rules entrypoint | `{{CODEX_HOME}}/AGENTS.md` points to `{{SYNC_ROOT}}/core-rules.md` |
| Other AI agent rules | use that agent's supported entrypoint to read or reference `core-rules.md` |
| Global skills | keep Codex-compatible packages under `{{SYNC_ROOT}}/skills` |
| Project skills | keep project-only packages under each project's `000_Agent/skills` |
| MCP/tools | convert by intent into the target app's config format; never share incompatible config files directly |
| Memory | store durable preferences and decisions in Markdown under `{{SYNC_ROOT}}/memories` |
| Sessions/logs/auth/cache | keep local; do not sync |
| Project state | use project `AGENTS.md` plus Obsidian cockpit notes |

Report each item as one of:

- portable as-is
- convertible with a target-specific adapter
- local-only
- unsafe to sync

For the full checklist and report template, read `references/multi-agent-compatibility.md`.

## Pitfalls Converted From Source

- Backup is mandatory because move plus symlink operations can break the user's assistant setup quickly.
- Obsidian and similar local vault tools often behave best with real files inside the vault, not symlinked targets.
- Sync route should follow device mix and reading habits, not popularity.
- Single-computer users still benefit from portability and versioned backup.
- Private and public GitHub backups need different privacy defaults.
- Health checks should not be cron by default; scheduled checks are local machine configuration and should be opt-in.
- Sync `core-rules.md`, skills, and memory; do not sync app state/cache/credentials.
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
CODEX_LAZYPACK_244B6B6094451DECC11683740063DB593740D1B6

# cross-device-sync/references/multi-agent-compatibility.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/cross-device-sync/references/multi-agent-compatibility.md")"
cat > "{{CODEX_HOME}}/skills/cross-device-sync/references/multi-agent-compatibility.md" <<'CODEX_LAZYPACK_D92F8EF1D5DC5FD8C9B05219E1E310F3ED9B4B7F'
# Multi-Agent Compatibility Audit

Use this checklist when the user wants Codex, future AI agents, or another local agent runtime to share the same durable assistant setup.

The goal is not to make every app read the same config folder. The goal is to keep the user's rules, skills, workflows, memory, and migration notes in portable Markdown/packages, then expose each AI agent to those assets through that agent's own supported entrypoints.

## Core Principle

Share durable assets. Convert app-specific settings. Never sync secrets or local runtime state.

Durable assets:

- `SYNC_ROOT/core-rules.md`
- portable skill packages under `SYNC_ROOT/skills`
- reusable memory and preference notes under `SYNC_ROOT/memories`
- workflow notes under `SYNC_ROOT/workflows`
- knowledge indexes under `SYNC_ROOT/knowledge`
- project `AGENTS.md` files and Obsidian project cockpits

App-specific assets:

- Codex `config.toml`
- agent-specific settings files
- plugin manifests and caches
- session databases and logs
- auth files and OAuth tokens
- shell snapshots and temp files

## Audit Steps

### 1. Confirm The Rules Source Of Truth

Check:

```bash
test -f "{{SYNC_ROOT}}/core-rules.md" && echo "core-rules exists"
test -L "{{CODEX_HOME}}/AGENTS.md" && readlink "{{CODEX_HOME}}/AGENTS.md"
```

Expected:

- `{{SYNC_ROOT}}/core-rules.md` exists.
- `{{CODEX_HOME}}/AGENTS.md` points to `{{SYNC_ROOT}}/core-rules.md`.
- There is no separate legacy global rules file competing with `core-rules.md`.

For another AI agent, add that agent's own supported rules entrypoint and point or copy it to the same `core-rules.md` only if the agent supports that safely.

### 2. Classify Skills And Workflows

Check:

```bash
find "{{SYNC_ROOT}}/skills" -maxdepth 2 -name SKILL.md -print | sort
find "{{SYNC_ROOT}}/workflows" -maxdepth 2 -type f -print 2>/dev/null | sort
```

Classification:

| Asset | Default decision |
|---|---|
| Codex-compatible `SKILL.md` package | Portable, keep under `SYNC_ROOT/skills` |
| Project-only skill | Keep in project `000_Agent/skills` |
| Draft workflow | Keep in `SYNC_ROOT/workflows` until promoted |
| Runtime plugin cache | Local-only, do not sync |
| Agent marketplace install metadata | Local-only or reinstall per app |

Do not symlink project `000_Agent/skills` into global Codex skills.

### 3. Check MCP And External Tools

MCP settings are usually not directly portable because each app has its own config format and permission model.

Audit:

```bash
test -f "{{CODEX_CONFIG}}" && sed -n '1,220p' "{{CODEX_CONFIG}}"
```

Classify each integration:

- connector/plugin available in Codex App
- local CLI route
- API route with secret stored outside repo
- MCP server route requiring config conversion
- browser/manual route

Rule: convert settings by intent. Do not symlink one agent's config file into another agent's config location.

### 4. Check Memory And Durable Preferences

Portable memory should be human-readable Markdown or structured notes, not raw session history.

Check:

```bash
find "{{SYNC_ROOT}}/memories" -maxdepth 2 -type f -print 2>/dev/null | sort
```

Good candidates:

- durable preferences
- reusable decisions
- project naming conventions
- path rules
- repeated troubleshooting knowledge

Do not sync:

- raw session databases
- private logs
- app telemetry
- generated summaries containing secrets
- OAuth or token caches

### 5. Check Project Rules And Cockpits

For each active project:

- project root has `AGENTS.md`
- Obsidian cockpit exists under the expected project library path
- `AGENTS.md` points to stable project rules, not daily progress
- cockpit carries progress, next actions, and sync notes

For other AI agents, prefer reading the same project `AGENTS.md` if supported. If the agent expects another file name, generate a thin adapter that points back to `AGENTS.md` or `core-rules.md`, rather than forking the rules.

### 6. Check Commands, Hooks, And Agent Delegation

Do not copy commands or hooks across tools literally.

Classify:

| Source item | Multi-agent route |
|---|---|
| repeated workflow prompt | convert to skill or workflow note |
| one-off prompt | convert to prompt template |
| hook | rewrite only after checking target event model and permissions |
| agent delegation pattern | convert to checklist, validation pass, or explicit subtask only when the target supports it |
| app plugin | reinstall or rebuild for the target app |

### 7. Produce The Report

Use this format:

```text
## 現況摘要
- 專案位置：
- 同步方式：
- Codex 已有：
- 其他 AI agent 可共用：

## 可攜資產
-

## 需要轉換的資產
-

## 不應同步的資產
-

## 風險清單
1.
2.
3.

## 建議修改清單
高優先：
-

中優先：
-

低優先：
-

## 下一步執行計畫
1. 先改哪些檔案：
2. 需要備份哪些檔案：
3. 哪些步驟要等使用者確認：
```

Do not edit files during the audit unless the user explicitly approves the proposed plan.

## Fit With LazyPack Item 16

This audit belongs inside LazyPack Item 16 because it is a portability and synchronization health check. It should not become a standalone global skill unless it grows into a broader migration system with its own scripts, templates, and repeated execution path.
CODEX_LAZYPACK_D92F8EF1D5DC5FD8C9B05219E1E310F3ED9B4B7F

# cross-device-sync/references/source-adaptation.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/cross-device-sync/references/source-adaptation.md")"
cat > "{{CODEX_HOME}}/skills/cross-device-sync/references/source-adaptation.md" <<'CODEX_LAZYPACK_FDD90718FB7D696B0C6E7269869C4ACC0D1E2053'
# Source Adaptation: Cross-Device Assistant Setup

Source type: external assistant portability guide

The source document described moving an assistant app configuration into a portable user-owned folder, backing it up, linking it back into the app, adding optional GitHub backup, generating a health-check script, and writing a migration manual.

This Codex version keeps the useful operating model but changes the target surfaces and safety rules.

## Preserved Ideas

- Treat assistant setup as a user-owned portable asset, not a vendor-owned hidden folder.
- Pick the sync route based on device mix, not trendiness.
- Back up before moving files or creating symlinks.
- Keep portable `core-rules.md`, skills, and durable memory separate from machine-local state.
- Use GitHub as optional versioned offsite backup, preferably private.
- Generate health checks and migration notes so future device changes are repeatable.

## Converted Assumptions

| Original source-guide idea | Codex-compatible conversion |
|---|---|
| Source app config root is the main config root | `{{CODEX_HOME}}` is the Codex root |
| `來源工具的舊 skills 路徑` stores skills | `{{CODEX_HOME}}/skills` stores global Codex skills |
| Source app rule file is the rule file | `AGENTS.md` is the project rule file; cross-tool global rules belong in `{{SYNC_ROOT}}/core-rules.md` |
| Source app command shortcuts are user-facing entry points | Codex skills trigger by metadata and user intent |
| Source app delegation format is part of the workflow | Codex validation passes or supported delegation tools are used only when explicitly requested or clearly useful |
| `000_Agent/` is created by pro-kit 01 | This user's global Arry Assistant data lives under `codex_symlink/`; project-local data may use each project's `000_Agent/` |
| Source examples refer to Raymond/Raymond-Agent | Use Arry Assistant and the user's existing Google Drive/Obsidian paths |

## Codex-Specific Safety Changes

- The skill must not automatically move or symlink `{{CODEX_HOME}}` assets during installation.
- Any future sync setup must be plan-first and approval-gated because it can affect all Codex sessions.
- The default sync approach for this user should align with Google Drive project folders and Obsidian project cockpits.
- The existing Arry Assistant architecture uses Google Drive `codex_symlink/` as the global layer for `skills/`, `memories/`, `workflows/`, and `knowledge/`; project-local data may still use each project's `000_Agent/`.
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
000_Agent/memories/
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
- Section H multi-agent compatibility audit, adapted from a later cross-tool health-check guide
- pitfalls and FAQ converted from the source app to Codex App

## 2026-06-01 Multi-Agent Compatibility Addition

The later source was reviewed as a portability health-check pattern. The user does not plan to use that source app, so the useful parts were converted into a generic multi-agent audit instead of a new standalone skill.

Preserved ideas:

- audit before modifying files
- distinguish durable Markdown assets from app-specific settings
- map rules, skills, tools, memory, commands, hooks, and agent delegation separately
- convert settings formats instead of symlinking incompatible app config files
- output risks and suggested next steps before execution

Codex-only conversion:

- source-specific names are not used as operating surfaces
- `{{SYNC_ROOT}}/core-rules.md` is the cross-agent global rules source of truth
- `{{CODEX_HOME}}/AGENTS.md` remains Codex's symlink entrypoint
- `{{SYNC_ROOT}}/skills`, `memories`, `workflows`, and `knowledge` remain the portable assistant data layer
- other AI agents should read or adapt those durable assets through their own supported entrypoints
CODEX_LAZYPACK_FDD90718FB7D696B0C6E7269869C4ACC0D1E2053

test -f "{{CODEX_HOME}}/skills/cross-device-sync/SKILL.md" && echo "cross-device-sync installed"

echo "embedded skills installed: cross-device-sync"
```

<!-- END EMBEDDED_SKILLS -->
