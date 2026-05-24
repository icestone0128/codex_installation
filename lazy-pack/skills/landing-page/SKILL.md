---
name: landing-page
description: Use when the user asks to create, rewrite, or restyle a landing page, sales page, course page, event signup page, product launch page, or lead-capture page. Run a guided Traditional Chinese interview, then generate a complete single-page HTML landing page with copy, visual direction, optional countdown, answers.json, and preview instructions. Trigger phrases include landing page, landing-page skill, 銷售頁, 報名頁, 課程頁, 活動頁, 產品頁, and 幫我做 landing page.
metadata:
  short-description: Guided landing page generator
---

# Landing Page Skill

Use this skill to guide the user from a rough offer into a complete landing page. The source workflow was adapted for Codex App, so do not depend on slash-command menus, non-Codex skill folders, or assistant-specific installers.

## Operating Rules

1. Use Traditional Chinese by default unless the user requests another language.
2. Ask one question at a time unless the user asks for a fast mode or pastes all material at once.
3. Use only the user's answers and explicitly provided source files for the page content. Do not fill from memory, persona notes, or unrelated project context.
4. If the user is stuck, offer 3 draft options based only on the answers already collected.
5. Do not install optional design tools automatically. If a tool such as UUPM is unavailable, continue with fallback design rules.
6. Do not auto-deploy, wire payments, collect secrets, or create production forms. CTA links are plain links unless the user provides a safe target URL.
7. When output files are written, keep them under `generated-pages/<slug>/` in the active project unless the user chooses another folder.
8. After generating HTML for a local app or page, use available browser verification when practical, or report the exact file path for preview.

## Source Files

- `references/question-bank.md`: the guided 17-question interview and examples.
- `references/fallback-design-rules.md`: design rules to use when no external design system is available.
- `references/uupm-integration.md`: optional UUPM-compatible workflow. Treat this as optional and Codex-adapted.
- `templates/base.html`: single-page landing page skeleton.
- `templates/countdown.js`: countdown behavior for countdown-enabled pages.

## Workflow

### 1. Decide The Mode

Use guided mode by default:

- A. Product positioning: product type, industry, tone, slug.
- B. Page content: hero, hook, about, outcomes, testimonials, audience, info, pricing, FAQ, speaker or maker.
- C. Conversion layer: countdown, deadline behavior, CTA text, CTA URL.

Use fast mode when the user says they will paste everything at once. In fast mode, classify the pasted content into the same answer structure and ask only for missing critical fields.

Use restyle mode when the user asks to revise an existing generated page. First look for `generated-pages/<slug>/answers.json`; if it exists, reuse it and ask only what should change.

### 2. Collect Answers

Read `references/question-bank.md` before asking detailed interview questions.

For each guided question:

- Show the question.
- Include short good and weak examples when useful.
- Accept `skip` only for optional sections.
- Accept "幫我生 3 個" and provide three concise choices based on prior answers.

Store the final structured answers as:

```json
{
  "product": {
    "type": "",
    "industry": "",
    "tone": [],
    "slug": ""
  },
  "content": {
    "hero": { "title": "", "subtitle": "" },
    "hook": "",
    "about": "",
    "learn": [],
    "testimonials": [],
    "audience": { "fit": [], "unfit": [] },
    "info": [],
    "pricing": [],
    "faq": [],
    "speaker": { "name": "", "bio": [], "photo": "" }
  },
  "countdown": {
    "enabled": false,
    "deadline": "",
    "onZero": "ended-state"
  },
  "cta": { "text": "", "href": "#" }
}
```

### 3. Choose The Design Direction

First check whether the active project has a design guide:

- `DESIGN.md`
- `design.md`
- `docs/DESIGN.md`
- `brand/DESIGN.md`

If found, summarize the brand colors, typography, and tone, then ask whether to use it. If the user confirms, use it and skip optional design-system discovery.

If no design guide exists, check whether a Codex-compatible UUPM installation is available by looking for a `uipro` command or a Codex skill/package named `ui-ux-pro-max`. If it is unavailable or fails, use `references/fallback-design-rules.md`.

Always present 2 or 3 style directions before writing the page. Each direction should include color, typography, layout mood, section rhythm, and why it fits the offer.

### 4. Generate The Page

Use `templates/base.html` as the base structure and `templates/countdown.js` only when countdown is enabled.

The generated page should include:

- Sticky navigation with section anchors.
- Hero with clear promise and CTA.
- Hook or pain-point section.
- About or mechanism section.
- Outcomes or what-you-get section.
- Optional testimonials.
- Fit and unfit audience section.
- Event, product, or offer information.
- Pricing or plan section.
- CTA section.
- Speaker, maker, or brand section.
- FAQ section.

Keep the HTML self-contained:

- Use CDN assets only when suitable and disclosed.
- Inline CSS for design tokens and custom layout.
- Inline countdown JavaScript only when needed.
- Use image URLs supplied by the user, or placeholders that are clearly marked.

### 5. Write Outputs

Create:

```text
generated-pages/<slug>/
├── index.html
├── answers.json
└── design-system.md
```

`design-system.md` should summarize the chosen visual direction, including colors, fonts, layout rules, and notable constraints. If no external design system was used, say it was generated from fallback rules.

### 6. Verify

Before final response:

- Confirm `SKILL.md` support files were available if the skill package is being maintained.
- Confirm generated `index.html` exists.
- If a browser tool is available and the output is local, preview the page and check for blank rendering, obvious overlap, broken anchors, and mobile width issues.
- Report exact output paths and any verification not performed.

## Out Of Scope

- Payment processing.
- Form backend integration.
- Full deployment.
- Member portals or subscription apps.
- Refund or legal guarantee copy unless the user supplies exact text.
- Claims, testimonials, or credentials not provided by the user.

## Attribution

Adapted from "引導式 Landing Page 生成 by 雷小蒙 / Raymond Hou" under CC BY-NC-SA 4.0. Preserve attribution and non-commercial license notes when sharing this skill package.
