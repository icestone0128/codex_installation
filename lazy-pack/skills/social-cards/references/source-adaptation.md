---
title: Social Cards Source Adaptation
date: 2026-05-20
type: reference
tags:
  - codex
  - skills
  - social-cards
---

# Source Adaptation

This skill adapts the third-party `skills/social-cards` package from:

- Source page in document: `https://cc.lifehacker.tw`
- Source repo: `https://github.com/lifehacker-tw/claude-code-mini-course.git`
- Source folder: `skills/social-cards/`
- Original author attribution in source: Raymond Hou / 雷蒙
- Blog listed in source: `https://raymondhouch.com`
- Threads listed in source: `@raymond0917`
- Course listed in source: `https://lifehacker.tw/courses/24hr-claude-code-tutorial`
- Newsletter listed in source: `https://raymondhouch.com/subscribe`
- License stated by source: CC BY-NC-SA 4.0, personal learning and sharing allowed, commercial use prohibited

## Codex Conversion

- Target Codex global skill path: `{{CODEX_HOME}}/skills/social-cards`.
- Project-local option: if this card workflow is only for one project, use `<project-root>/000_Agent/skills/social-cards` instead and keep it as that project's portable skill package.
- Display name requested by user: Social Cards.
- Previous temporary package path: `codex_installation/converted-skills/cards`（已清理）。
- Removed source-only source-specific metadata fields.
- Replaced 來源工具 command assumptions with Codex trigger metadata and procedural instructions.
- Renamed template sets from `blue-dark` / `orange-light` to `brand-dark` / `brand-light`.
- Updated the default brand color to Pantone 285C, using digital HEX `#0072CE` for templates.
- Replaced the original sample handle with `@yourhandle` so generated cards do not inherit the source author's handle by default.

## Original Install Script Conversion Checklist

| Source instruction | Codex-compatible result |
|---|---|
| Install into 來源工具的全域 skills 路徑 | Installed into `{{CODEX_HOME}}/skills/social-cards` |
| Install into `000_Agent/skills` | Valid only for a project-local or assistant-local workflow; do not symlink it into global skills |
| Rename install folder to `cards` | Renamed to `social-cards`; display name is Social Cards |
| Use `/cards` as a slash command | Kept `/cards` as a trigger phrase only; Codex uses skill metadata |
| Keep `blue-dark` and `orange-light` template sets | Converted to `brand-dark` and `brand-light` for Pantone 285C branding |
| Install Playwright and Chromium | Installed locally in the skill folder |
| Verify by checking core files | Verified `SKILL.md`, 8 templates, screenshot script, Playwright, and Chromium |
| Export 2x PNG through Playwright | Verified with two generated PNG files in `/private/tmp/social-cards-rename-test/` |

## Brand Color

- Pantone: Pantone 285C
- Digital HEX: `#0072CE`
- RGB: `0, 114, 206`

Use `#0072CE` as the main accent in all generated social-card templates unless the user explicitly gives a different campaign palette.
