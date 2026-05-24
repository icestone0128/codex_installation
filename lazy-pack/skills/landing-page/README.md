# landing-page

Codex-compatible guided landing page skill adapted from "引導式 Landing Page 生成 by 雷小蒙 / Raymond Hou".

## What It Does

- Runs a structured interview for course, event, service, product, or signup landing pages.
- Generates `generated-pages/<slug>/index.html`.
- Saves `answers.json` for future rewrites or restyling.
- Saves `design-system.md` documenting the chosen visual direction.
- Supports optional countdown sections.
- Works without optional design tools by using bundled fallback design rules.

## Codex Usage

Ask naturally, for example:

- `使用 landing-page skill 幫我做一頁課程銷售頁`
- `幫我做 landing page`
- `幫我改版這個銷售頁`
- `用 landing-page 重新套風格`

Codex skills are triggered by metadata and context. Do not depend on a slash-command menu.

## Package Structure

```text
landing-page/
├── SKILL.md
├── README.md
├── references/
│   ├── question-bank.md
│   ├── uupm-integration.md
│   └── fallback-design-rules.md
└── templates/
    ├── base.html
    └── countdown.js
```

## Installation

Copy this folder to the Codex global skills folder:

```bash
mkdir -p "{{CODEX_HOME}}/skills/landing-page"
rsync -a --delete "{{SETUP_REPO}}/lazy-pack/skills/landing-page/" "{{CODEX_HOME}}/skills/landing-page/"
```

Start a new Codex conversation or restart Codex App if the skill metadata does not refresh immediately.

## License

Source attribution: 雷蒙三十 Starter Kit / Raymond Hou.

License: CC BY-NC-SA 4.0. Personal use, learning, and sharing are allowed; commercial use is not allowed under this license.
