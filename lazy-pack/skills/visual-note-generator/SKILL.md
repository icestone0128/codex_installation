---
name: visual-note-generator
description: Turn a photographed or scanned hand-drawn note into an upright, source-faithful 16:9 visual note using a replaceable personal Style Profile. Use when the user provides 手繪筆記、圖解筆記、白紙草圖、拍照筆記 or asks for Visual Note Generator, exact Traditional Chinese text preservation, Q-version character handling, a personalized hand-drawn style, or a finished 2K visual-note image. This skill is only for hand-drawn-note-to-image creation, not article rewriting, transcripts, social posts, prose-to-infographic work, or slide outlines.
---

# Visual Note Generator

Create one finished raster visual note from one hand-drawn source. Keep the workflow portable and keep personal rendering style in a replaceable YAML Style Profile.

## File Responsibilities

- `SKILL.md`: trigger, routing, loading order, and ownership boundaries.
- `references/workflow-contract.md`: process steps, required questions, output contract, and portfolio handoff.
- `references/generation-guardrails.md`: content/layout locks, prompt construction, validation, failure recovery, and learned pitfalls.
- `references/style-profile-guide.md`: Style Profile schema, precedence, customization, and portability rules.
- `references/default-style-profile.yaml`: bundled default personal style. It currently contains Arry's established style so every LazyPack installation can reproduce that look without local image assets.
- `references/style-profile-template.yaml`: blank portable starting point for another user's style.
- `agents/openai.yaml`: Codex UI metadata only. Never treat it as workflow instructions, output rules, or style data.

## Mandatory Loading Order

Before analyzing or generating:

1. Read `references/workflow-contract.md` completely.
2. Read `references/generation-guardrails.md` completely.
3. Read `references/style-profile-guide.md` completely.
4. Resolve and read exactly one Style Profile:
   - explicit profile supplied or selected by the user;
   - otherwise `references/default-style-profile.yaml`.

Do not merge Style Profile fields into the generic workflow files. Do not infer generic workflow rules from a personal profile.

## Style Profile Precedence

Use this order:

1. the user's explicit instructions for the current image;
2. a user-selected or attached Style Profile;
3. the bundled `default-style-profile.yaml`;
4. generic clean hand-drawn rendering only if no profile can be read.

User instructions may override style choices, but never override source-text fidelity or safety constraints unless the user explicitly corrects the source content.

## Execution

- Use the built-in image-generation/editing capability for the raster result.
- Treat the upright source image as the sole content and composition authority.
- Treat the selected Style Profile as rendering data only.
- Apply the workflow and guardrails independently of which Style Profile is selected.
- Deliver exactly 16:9 and at least 2560 × 1440 pixels; upscale with high-quality Lanczos resampling when native generation is smaller.

## Portability

The bundled Arry profile is textual and must work without Arry's local asset folders. Local character sheets and portfolio images are optional fidelity references, not installation requirements.

Another user should keep the same Skill workflow and replace only `default-style-profile.yaml` with a profile based on `style-profile-template.yaml`. They must not rewrite `workflow-contract.md` merely to change colors, handwriting, characters, decorations, or visual mood.
