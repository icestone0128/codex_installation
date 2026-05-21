---
name: secondbrain-research-digest
description: Use when the user asks to organize research, compare information, make a decision, turn scattered materials into Obsidian-ready Markdown notes, query or synthesize Secondbrain content, or produce structured data from notes in the secondbrain vault. Output concise Traditional Chinese Markdown plus a structured decision/data block.
metadata:
  short-description: Organize Secondbrain research notes
---

# Secondbrain Research Digest

Use this skill for repeated research, lookup, decision, and note-organization work that should read from or produce material for an Obsidian/Secondbrain-style vault.

## Default Paths

- Secondbrain vault: `{{OBSIDIAN_VAULT}}`
- Vault rules: `OBSIDIAN_VAULT/AGENTS.md`
- Main knowledge index: `OBSIDIAN_VAULT/知識庫/index.md`
- Knowledge log: `OBSIDIAN_VAULT/知識庫/log.md`
- Common source folders: `Clippings/`, `知識庫/`, `每日筆記/`, `教學素材/`, `影片筆記/`, `專案庫/`

When copying this skill to another user, ask for their vault path before reading or writing. If their vault does not use `知識庫/index.md` or `知識庫/log.md`, skip those updates unless they confirm equivalent paths.

## Workflow

1. Read the vault `AGENTS.md` before touching Secondbrain content.
2. Clarify the task type if it is not obvious:
   - research digest
   - comparison
   - decision memo
   - note cleanup
   - structured extraction
3. Ask which specific source folder, note, or search terms to use when the user has not supplied them. Do not scan the whole vault by default.
4. Gather only relevant notes and preserve source context. Prefer file inventory and targeted search before opening many files.
5. Produce two outputs:
   - an Obsidian-ready Markdown note
   - a structured data block for reuse
6. If writing to the vault is requested, use additive updates. Do not overwrite existing notes without explicit confirmation.
7. When creating a formal knowledge note, use frontmatter and preserve Obsidian links where useful.

## Output Shape

Default Markdown:

~~~markdown
---
title: <title>
date: <YYYY-MM-DD>
type: research-digest
tags:
  - secondbrain
  - research
---

# <title>

## 核心結論

## 資料來源

## 重點整理

## 決策建議

## 待確認

## 結構化資料

```yaml
topic:
sources:
claims:
decision:
next_actions:
open_questions:
```
~~~

For detailed templates and decision rules, read `references/research-note-template.md`.

## Safety Rules

- Do not rewrite personal voice-heavy notes unless the user asks.
- Do not invent facts, citations, or source claims.
- Do not add unrelated concepts just to make the note longer.
- Do not write secrets, API keys, tokens, passwords, or unnecessary personal data.
- Do not update `知識庫/index.md` or `知識庫/log.md` unless the change is clearly additive and safe.
