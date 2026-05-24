# UUPM Integration — Codex-compatible optional path

UUPM is optional. The `landing-page` skill must work without it by using `fallback-design-rules.md`.

Do not auto-install UUPM. If the user wants to add UUPM later, route that as a separate tool-integration task and verify the Codex-compatible install path before using it.

## 1. Detection

After the positioning questions, check only non-destructive signals:

```bash
if command -v uipro >/dev/null 2>&1; then
  echo "UUPM_COMMAND_AVAILABLE"
elif [ -d "$HOME/.codex/skills/ui-ux-pro-max" ]; then
  echo "UUPM_CODEX_SKILL_AVAILABLE"
else
  echo "UUPM_NOT_AVAILABLE"
fi
```

If unavailable, continue with fallback mode.

## 2. User Message When Unavailable

Use a concise note, not an installation prompt:

```text
我目前沒有偵測到可直接使用的 UUPM 設計系統工具。這不影響生成頁面；我會先用內建 fallback 設計規則產生 2-3 個風格方向。之後若你想整合 UUPM，可以另外開一個工具整合任務處理。
```

## 3. Building A Query

Use the user's A-stage answers:

```text
query = "<industry keywords> <tone keywords> <product type>"
slug = "<user slug>"
```

If the answer is in Chinese, translate internally into 3-5 English search keywords and show the user the search phrase before using it.

## 4. Calling An Available UUPM Tool

Prefer a documented `uipro` command if present. If the only available integration is a Codex-compatible `ui-ux-pro-max` skill folder, inspect that skill's current instructions before calling any script.

The expected output is a Markdown design-system document. Save or copy the chosen design summary into:

```text
generated-pages/<slug>/design-system.md
```

## 5. Parse Design-System Markdown

Look for these sections:

- Pattern or layout strategy.
- Colors.
- Typography.
- Effects.
- Anti-patterns.
- Pre-delivery checklist.

If parsing fails or the result lacks colors and typography, switch to fallback mode.

## 6. Convert To CSS Variables

Inject the selected design tokens into the generated page:

```css
:root {
  --color-primary: #21A4B1;
  --color-secondary: #A8D5BA;
  --color-cta: #D4AF37;
  --color-bg: #FFF5F5;
  --color-text: #2D3436;
  --font-headline: "Cormorant Garamond", serif;
  --font-body: "Montserrat", sans-serif;
  --transition-base: 250ms cubic-bezier(0.4, 0, 0.2, 1);
  --shadow-soft: 0 4px 12px rgba(0, 0, 0, 0.06);
}
```

Only add external font links when the user accepts external CDN use or when the project already uses those fonts.

## 7. Present Style Options

Offer 2 or 3 style directions. Possible landing-page styles:

| # | Style | Use When |
|:--|:--|:--|
| 1 | Hero-Centric Design | The offer needs strong first-screen impact. |
| 2 | Conversion-Optimized | The page should drive signups or purchases quickly. |
| 3 | Feature-Rich Showcase | The product needs feature explanation. |
| 4 | Minimal & Direct | The audience already understands the offer. |
| 5 | Social Proof-Focused | Testimonials and credibility matter most. |
| 6 | Interactive Product Demo | The product is best understood by seeing it. |
| 7 | Trust & Authority | B2B, professional, or expert positioning. |
| 8 | Storytelling-Driven | A narrative arc sells the transformation. |

For each option, summarize color, type, layout, CTA rhythm, and tradeoff.

## 8. Delivery Checklist

After generating HTML, verify:

- Clickable links and buttons have pointer affordance.
- Hover transitions are 150-300ms where motion is used.
- Text contrast is readable.
- Layout works at 375, 768, 1024, and 1440 px widths when browser verification is available.
- Motion respects `prefers-reduced-motion`.

## 9. Fallback Conditions

Use fallback mode when:

- UUPM is unavailable.
- The user does not want external design tooling.
- UUPM output cannot be parsed.
- Any UUPM script or command fails.
- Browser or shell verification is unavailable.
