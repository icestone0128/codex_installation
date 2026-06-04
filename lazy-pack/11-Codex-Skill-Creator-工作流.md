# 11-Codex-Skill-Creator-工作流

> 2026-05-24 更新：本文件已改為自含式 Skill 安裝文件。請使用文末「內建 Skill 完整安裝內容」，不需要額外的舊版獨立 skills 子目錄。


## 目標

把 外部 / Anthropic 取向的 Skill Creator 啟動包，轉成 Codex App 可用的 skill 建立流程，並判斷新 skill 應該放在全域還是專案本地。

這份文件是之後建立、優化、驗證 Codex skills 的正式懶人包。若來源文件提到 來源工具、來源工具的 skills 路徑、slash command、來源工具 subagent 或 來源工具專用 frontmatter，一律先依本文件轉換，不直接照做。

## 前置條件

- 已完成 `README.md` 的設定表。
- 已知道 Codex 全域 skills 位置：`{{CODEX_HOME}}/skills`。
- 已知道專案本地 skills 位置：`<project-root>/000_Agent/skills`。
- 已確認系統內建 skills 位置：`{{CODEX_HOME}}/skills/.system`。
- 已知道 Obsidian 全域 skill 索引位置；若沒有，可先建立：

```text
{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md
```

## 固定結論

- 使用環境：Codex App。
- 自訂全域 skills 固定放在 `{{CODEX_HOME}}/skills`。
- Codex 內建系統 skills 在 `{{CODEX_HOME}}/skills/.system`，平常只讀取，不覆蓋。
- 個人助手或單一專案的本地 skills 固定放在對應的 `000_Agent/skills`，不要 symlink 到 `{{CODEX_HOME}}/skills`。
- 內建 `skill-creator` 保持系統版本；自訂優化放在 companion skill。
- 全域 skills 有新增、修改或刪除時，要同步更新 Obsidian 的全域 Skills 索引。
- 任何 skill 不論全域或專案本地，都要做成可攜式版本。

## 歸屬判斷

建立或修改 skill 前，先判斷：

| 問題 | 判斷 |
| --- | --- |
| 會跨多個專案重複使用嗎？ | 是，放全域 `{{CODEX_HOME}}/skills/<skill-name>` |
| 需要在任何 Codex 對話都能觸發嗎？ | 是，放全域 |
| 只服務目前專案的資料、流程、工具或客戶脈絡嗎？ | 是，放 `<project-root>/000_Agent/skills/<skill-name>` |
| 含有不適合公開或跨專案複用的專案脈絡嗎？ | 放專案本地 |
| 目前只是流程草稿，尚未穩定複用嗎？ | 先放 `000_Agent/skills`，成熟後再升級全域 |

可攜化規則：

- 全域 skill：實作在 `{{CODEX_HOME}}/skills/<skill-name>`，同步可攜副本到 `本文件文末內嵌內容：<skill-name>`，並更新 Obsidian 全域 Skills 索引。
- 專案 skill：實作在 `<project-root>/000_Agent/skills/<skill-name>`，該資料夾必須包含完整 `SKILL.md` 與必要資源；若專案使用 Git，跟著專案提交。
- 不把 `000_Agent/skills` symlink 到 `{{CODEX_HOME}}/skills`。

## 建立 Codex 版 Skill Creator Companion

建議 skill 名稱：

```text
codex-skill-creator
```

建立：

```text
{{CODEX_HOME}}/skills/codex-skill-creator/SKILL.md
{{CODEX_HOME}}/skills/codex-skill-creator/references/codex-bootstrap-adapter.md
```

用途：

- 把 外部 / Anthropic skill 教學轉成 Codex App 相容流程。
- 建立、優化、驗證自訂全域或專案本地 skills。
- 記得同步可攜式版本；全域 skill 同步 Obsidian 全域 skill 索引，專案 skill 同步專案駕駛艙。

## 直接安裝本懶人包版本

下載本 repo 後，直接使用本文文末的內建安裝腳本建立 companion skill：

```bash
mkdir -p "{{CODEX_HOME}}/skills/codex-skill-creator"
# 請使用本文文末「內建 Skill 完整安裝內容」；不需要額外複製舊版獨立 skills 子目錄。
test -f "{{CODEX_HOME}}/skills/codex-skill-creator/SKILL.md" && echo "codex-skill-creator installed"
```

若下載者沒有使用 Obsidian 全域 skill 索引，安裝後可跳過本文的 Obsidian 同步步驟。

## 來源啟動包轉換規則

| 外部 / Anthropic 啟動包項目 | Codex App 相容做法 |
| --- | --- |
| 來源工具的全域 skills 路徑 | 需要全域觸發時改用 `{{CODEX_HOME}}/skills` |
| 來源工具的專案級 skills 路徑 專案 skill | 改放該專案 `000_Agent/skills`，只服務該專案 |
| `000_Agent/skills` symlink | 不建立；`000_Agent/skills` 是本地 skill 區，不等於 Codex 全域 skills |
| 來源工具 slash command `/skill-name` | 不依賴；Codex 以 skill metadata 與任務語意觸發 |
| `allowed-tools` | 不寫入；Codex 工具權限由當前 session、plugin、connector 與沙箱控制 |
| `disable-model-invocation` / `user-invocable` | 不寫入；觸發邊界寫在 `description` 與本文規則 |
| `when_to_use` | 轉成 `description` 的觸發語意與本文工作流程 |
| 來源工具 subagent 設定 | 不照搬；Codex 只有在使用者明確要求副代理時才使用 subagent |
| 安裝官方 Anthropic skill-creator | Codex 已有內建 `.system/skill-creator`；通常不安裝、不覆蓋 |
| 告知重啟 來源工具 | 改成開新 Codex 對話或重啟 Codex App |

## Codex Skill 標準結構

最小結構：

```text
<skill-name>/
└── SKILL.md
```

需要範例、模板或長規則時：

```text
<skill-name>/
├── SKILL.md
├── references/
├── scripts/
└── assets/
```

原則：

- `SKILL.md` 保持精簡，放觸發、路徑、流程與安全規則。
- 長範例、來源轉換表、模板放 `references/`。
- 只有需要穩定重複執行的檢查或轉換，才放 `scripts/`。
- 不額外建立 README、安裝指南、變更紀錄，除非使用者明確要求。

## Frontmatter 範本

```markdown
---
name: skill-name
description: Use when the user asks for [具體任務], [觸發語], or [工作流程]. Include input source, action, and expected output.
metadata:
  short-description: Short user-facing phrase
---
```

檢查規則：

- `name` 必須與資料夾名稱一致。
- `description` 要把最常用觸發場景放前面。
- 不放 來源工具專用 欄位。
- 不寫 API key、token、密碼或個資。

## 建立第一個真實 Skill 的流程

### 1. 訪談

只問足夠做決策的問題：

1. 最常重複交給 AI 的工作是什麼？
2. 發生頻率是多少？
3. 最後要交付什麼格式？
4. 需要讀取哪些固定資料、資料夾或範例？
5. 絕對不要做什麼？

### 2. 收斂成一個推薦 skill

輸出：

- 最推薦的一個 skill。
- 兩個備選。
- 為什麼這個最適合先做。

若使用者同意，直接建立，不停在建議。

### 3. 建立檔案

建立：

```text
{{CODEX_HOME}}/skills/<skill-name>/SKILL.md
<project-root>/000_Agent/skills/<skill-name>/SKILL.md
```

視需要加：

```text
{{CODEX_HOME}}/skills/<skill-name>/references/<reference>.md
<project-root>/000_Agent/skills/<skill-name>/references/<reference>.md
```

二選一建立，不要同時建立兩份正式來源；除非是把專案 skill 升級成全域 skill，才複製到全域 skills 並同步 LazyPack。

### 4. 驗證

必查：

- `SKILL.md` 存在。
- frontmatter 有 `---`、`name`、`description`。
- `name` 等於資料夾名稱。
- `description` 有具體觸發語。
- `references/` 內被引用的檔案真的存在。
- 沒有誤放 來源工具專用 欄位或路徑。

範例檢查：

```bash
find "{{CODEX_HOME}}/skills/<skill-name>" -maxdepth 2 -type f -print
sed -n '1,20p' "{{CODEX_HOME}}/skills/<skill-name>/SKILL.md"
```

### 5. 同步

每次全域 skill 變更後，更新：

```text
{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md
```

至少更新三處：

- 自訂全域 Skills 表格。
- Skill 摘要段落。
- 最近同步紀錄。

若下載者沒有使用 Obsidian，也至少在 `{{SETUP_REPO}}/README.md` 或專案駕駛艙記錄 skill 清單。

每次專案 skill 變更後，更新該專案：

```text
<project-root>/000_Agent/skills/<skill-name>/
{{OBSIDIAN_PROJECTS}}/<project-name>/專案工作流程.md
```

至少記錄 skill 名稱、用途、實際路徑、可攜式資源是否完整。

## 本懶人包內含範例

本懶人包已附：

```text
{{CODEX_HOME}}/skills/codex-skill-creator/SKILL.md
{{CODEX_HOME}}/skills/codex-skill-creator/references/codex-bootstrap-adapter.md
{{CODEX_HOME}}/skills/secondbrain-research-digest/SKILL.md
{{CODEX_HOME}}/skills/secondbrain-research-digest/references/research-note-template.md
```

下載者應使用自己的 `{{CODEX_HOME}}` 與自己的 skill 名稱。

## 驗證

完成 skill 建立或更新後：

1. 檢查 skill 檔案：

```bash
find "{{CODEX_HOME}}/skills/<skill-name>" -maxdepth 2 -type f -print
```

2. 檢查 frontmatter：

```bash
sed -n '1,20p' "{{CODEX_HOME}}/skills/<skill-name>/SKILL.md"
```

3. 確認：
   - `name` 等於資料夾名。
   - `description` 有明確觸發情境。
   - 引用的 `references/` 檔案存在。
   - 沒有 來源工具的 skills 路徑、`allowed-tools`、`disable-model-invocation`、`user-invocable` 等 來源工具專用 正式設定。
4. 開新 Codex 對話，使用自然語言觸發該 skill 的任務。
5. 確認可攜式版本完整：全域 skill 同步 `本文件文末內嵌內容：<skill-name>`；專案 skill 保留在 `<project-root>/000_Agent/skills/<skill-name>`。
6. 同步 Obsidian 全域 Skills 索引、專案駕駛艙或專案 README。

## 踩坑修正

- 原始 `02-skill-creator-bootstrap.md` 是 來源工具 啟動包，不能原樣執行。
- 不要把官方 Anthropic `skill-creator` sparse checkout 到 Codex 系統 skill 位置；Codex 已有內建 `.system/skill-creator`。
- 不要覆蓋 `{{CODEX_HOME}}/skills/.system/skill-creator`，因為它由 Codex 管理。
- Codex 全域 skills 不放在 來源工具的 skills 路徑；專案級 skills 放 `<project-root>/000_Agent/skills`，但不建立 symlink。
- Codex 不應依賴 `/skill-name` slash command；要靠 `description` 寫清楚觸發語意。
- 來源工具專用 frontmatter 欄位要轉成 Codex 可理解的文字規則，不要照抄。
- 新增 skill 後不代表本對話立即可見；通常要開新對話或重啟 Codex App。
- Obsidian 同步紀錄要放在「最近同步紀錄」表格，不要誤插到自訂 skills 表格。
- Markdown 範本內若有巢狀 code fence，外層要用 `~~~markdown`，避免 YAML 範例提早結束區塊。
- 候選清單若寫進 repo 內，會出現在 git 未追蹤狀態；收工時要明確決定是否納入版本控制。

## 之後怎麼用

當使用者要求「建立 skill」、「優化 skill」、「把 來源 skill 教學轉成 Codex」、「跑 Skill Creator 啟動包」時：

1. 先套用本文件的 Codex 相容規則。
2. 使用 `codex-skill-creator` companion skill。
3. 若是第一個真實工作 skill，先做簡短訪談。
4. 判斷 skill 歸屬，建立或更新 `{{CODEX_HOME}}/skills/<skill-name>` 或 `<project-root>/000_Agent/skills/<skill-name>`。
5. 驗證 frontmatter、路徑與 reference。
6. 同步可攜式版本：全域同步 LazyPack 與 Obsidian 全域 Skills；專案同步專案 `000_Agent/skills` 與專案駕駛艙。
7. 回報是否需要開新對話或重啟 Codex App。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`codex-skill-creator`。

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

# ---- codex-skill-creator ----
mkdir -p "{{CODEX_HOME}}/skills/codex-skill-creator"
# codex-skill-creator/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/codex-skill-creator/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/codex-skill-creator/SKILL.md" <<'CODEX_LAZYPACK_CODEX_SKILL_CREATOR_SKILL_MD'
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
- This user's global skills symlink: `{{CODEX_HOME}}/skills`, pointing to Google Drive `codex_symlink/skills`.
- Project-local skills: `<project-root>/000_Agent/skills`.
- Global portable copy root: `{{SETUP_REPO}}/lazy-pack/<對應序號文件>`.
- Built-in system skills: `$CODEX_HOME/skills/.system` (read-only for normal work).
- Optional skill mirror note: ask the user for their Obsidian or project inventory path when no local mirror is already documented.
- This user's current mirror note: `{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md`.
- This user's current project root: `{{SETUP_REPO}}`.
- This user's current Obsidian vault: `{{OBSIDIAN_VAULT}}`.

## Portability Rules

1. Treat absolute personal paths as local defaults, not universal requirements.
2. When adapting this skill package for another user, replace `ASSISTANT_NAME`, `ASSISTANT_ROOT`, `OBSIDIAN_VAULT`, `PROJECT_LIBRARY`, and `WORK_ROOT` before depending on personal-workflow skills.
3. Keep general-purpose skills independent from personal memory or vault paths unless the user explicitly wants them connected.
4. If a mirror note does not exist, create one only after the user confirms where their durable skill inventory should live.
5. Every skill must have a portable package: global skills mirror to `{{SETUP_REPO}}/lazy-pack/<對應序號文件>`; project skills live as complete packages under `<project-root>/000_Agent/skills/<skill-name>`.

## Compatibility Rules

1. Do not install or edit skills under 來源工具專用 skills paths, `來源工具舊 skills 路徑`, or 來源工具 command folders.
2. Do not overwrite `{{CODEX_HOME}}/skills/.system/skill-creator`; create or update custom skills instead.
3. Use Codex frontmatter with `name`, `description`, and optional `metadata.short-description`.
4. Do not copy 來源工具專用 fields such as `allowed-tools`, `disable-model-invocation`, `user-invocable`, `when_to_use`, or 來源工具 subagent config unless converting them into plain Codex instructions.
5. Do not assume slash-command behavior. In Codex, skills are triggered by the skill metadata and current task context.
6. Keep `SKILL.md` concise. Move detailed examples, source adaptations, schemas, and checklists into `references/`.
7. After adding, changing, or deleting a custom global skill, update the LazyPack portable copy and Obsidian global skill mirror note.
8. After adding, changing, or deleting a project-local skill, keep the complete portable package under the project `000_Agent/skills` and update the project cockpit.

## Ownership Decision

Before creating or modifying a skill, decide where it belongs:

- Global: reusable across projects, should trigger from any Codex project, or is part of Arry's standard workflow. Store in `{{CODEX_HOME}}/skills/<skill-name>` and sync `{{SETUP_REPO}}/lazy-pack/<對應序號文件>`.
- Project-local: only useful for the current project, depends on project-specific context, or is still a local draft. Store in `<project-root>/000_Agent/skills/<skill-name>`.
- Arry assistant remains a global entry skill. Use it during project initialization to read the assistant data layer and help decide whether future skills are global or project-local.

Do not symlink `000_Agent/skills` into `{{CODEX_HOME}}/skills`.

For field-by-field conversion details, read `references/codex-bootstrap-adapter.md` when the source material is 來源工具導向 or Anthropic-specific.

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
   - replace 來源工具 paths with Codex paths
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
   - Global skill: sync `{{SETUP_REPO}}/lazy-pack/<對應序號文件>` and the Obsidian global skill mirror note.
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
- Portable package exists in the correct place: `{{SETUP_REPO}}/lazy-pack/<對應序號文件>` for global, project `000_Agent/skills/<skill-name>` for project-local.
- `SKILL.md` frontmatter includes `name` and `description`.
- `description` includes concrete trigger phrases and use cases.
- Detailed material is in `references/`, not bloating `SKILL.md`.
- The skill avoids secrets, tokens, and personal data.
- Obsidian mirror note is updated for global skill changes; project cockpit is updated for project-local skill changes.

CODEX_LAZYPACK_CODEX_SKILL_CREATOR_SKILL_MD

# codex-skill-creator/references/codex-bootstrap-adapter.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/codex-skill-creator/references/codex-bootstrap-adapter.md")"
cat > "{{CODEX_HOME}}/skills/codex-skill-creator/references/codex-bootstrap-adapter.md" <<'CODEX_LAZYPACK_CODEX_SKILL_CREATOR_REFERENCES_CODEX_BOOTSTRAP_ADAPTER_MD'
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

This reference adapts `02-skill-creator-bootstrap.md` for Codex App. The source is useful as a workflow pattern, but it is 來源工具-oriented and must not be copied verbatim.

## Keep From The Source

- Start by detecting the user's actual skill environment before writing files.
- Install or create a complete skill folder, not only `SKILL.md`, when supporting resources are required.
- Use an interview to choose a first high-value skill instead of creating abstract examples.
- Validate that the skill exists, has correct frontmatter, and references real support files.
- Treat skill creation as iterative: create one useful skill, test it, then revise after real use.

## Convert For Codex

| Source assumption | Codex-compatible version |
|---|---|
| 來源工具 global skills path | `{{CODEX_HOME}}/skills` for skills that must trigger across projects |
| 來源工具 project-level skills path | `<project-root>/000_Agent/skills` for skills that serve only one project |
| `000_Agent/skills` as symlink target | Do not symlink it into `{{CODEX_HOME}}/skills`; it is the assistant or project-local portable skill package |
| slash command `/skill-name` | Skill metadata triggers; the user can name the skill, but do not depend on a slash-command menu |
| 來源工具 `AskUserQuestion` | Ask concise questions in Codex; use available UI tools only when present |
| 來源工具 subagents in `agents/*.md` | Use Codex subagents only when explicitly authorized by the user; otherwise use local validation checklists |
| `allowed-tools` | Omit; Codex tool access is controlled by the session and plugin permissions |
| `disable-model-invocation` / `user-invocable` | Omit; express trigger boundaries in `description` and body instructions |
| Anthropic sparse checkout install | Use only when the user explicitly wants a third-party skill package; otherwise create a Codex-native custom skill |
| Tell user to restart 來源工具 | Say a new Codex conversation or app restart may be needed for new skill metadata to appear |

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

## Portable Skill Sync Requirement

After any custom global skill change, update:

`{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md`

and sync the portable copy:

`{{SETUP_REPO}}/lazy-pack/<對應序號文件>`

After any project-local skill change, keep the complete portable package under:

`<project-root>/000_Agent/skills/<skill-name>`

and record the skill in that project's cockpit.

Update three areas when applicable:

1. Custom skills table row
2. Skill summary section
3. Recent sync record with the date and exact change

Do not edit the system skill contents under `.system`; the mirror note may list them as read-only built-ins.

CODEX_LAZYPACK_CODEX_SKILL_CREATOR_REFERENCES_CODEX_BOOTSTRAP_ADAPTER_MD

test -f "{{CODEX_HOME}}/skills/codex-skill-creator/SKILL.md" && echo "codex-skill-creator installed"

echo "embedded skills installed: codex-skill-creator"
```

<!-- END EMBEDDED_SKILLS -->
