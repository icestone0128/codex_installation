---
name: presentation-workflow
description: Analyze and create presentations with an emphasis on NotebookLM slide generation, YAML-controlled visual style, and repeatable deck iteration. Use when Codex needs to read or critique a slide deck, plan a presentation, create slide content, generate or refine NotebookLM YAML style specifications, translate visual references such as Pinterest posters or landing pages into design language, define per-slide layouts and prompts, or revise NotebookLM-generated slides page by page.
---

# Presentation Workflow

Use this skill to analyze, plan, create, and revise presentations. When the task involves NotebookLM, treat YAML as a design specification file that tells NotebookLM how to generate the deck's visual style and page-by-page structure.

## Source Method

This skill is based on the user's Word document: `用 YAML 精準控制 NotebookLM 的簡報風格.docx`.

Core idea: do not ask NotebookLM to make a vague "good-looking" deck. Give it a structured YAML design brief with global style rules and page-level slide plans, then iterate with concrete slide-specific corrections.

## Workflow

1. Clarify the deck job:
   - Analyze an existing deck.
   - Create a new deck from source material.
   - Build a NotebookLM YAML style specification.
   - Revise a NotebookLM-generated deck.
2. Define the presentation goal:
   - audience, purpose, language, tone, target slide count, and delivery context.
3. Build or inspect the narrative:
   - Plan what each slide should do before writing layout instructions.
   - Decide the exact page count when working with NotebookLM YAML.
4. Define the visual language:
   - Use atmosphere, color scheme, typography, layout rules, image style, layout design, and decorative elements.
   - If the user provides visual references, analyze the underlying design logic rather than copying surface decoration.
5. Write YAML:
   - Combine `global_design` and `slides`.
   - Put style values in quoted strings.
   - Use page keys such as `p1`, `p2`, `p3`.
6. Generate or revise:
   - For NotebookLM, add the YAML file as a source and prompt NotebookLM to follow it.
   - After generation, review slide by slide and update only the pages that need improvement.
7. Preserve the best version:
   - Lock slides that already work.
   - Iterate weak slides two or three times, then assemble the best pages into the final deck.

## NotebookLM YAML Pattern

Read [notebooklm-yaml-style.md](references/notebooklm-yaml-style.md) when the user asks for YAML, NotebookLM slide control, or a reusable style template.

Use two major sections:

- `global_design`: the deck-wide design system.
- `slides`: the page-by-page construction plan.

The minimum useful global design fields are:

- `atmosphere`: three adjectives that define the whole tone.
- `color_scheme`: background, text, accent, and secondary colors.
- `typography`: heading, body, and data text rules.
- `layout_rules`: navigation, image style, layout design, and decorative elements.

The minimum useful slide fields are:

- `type`: the slide role, such as cover, intro, content, overview, or ending.
- `layout_style`: the layout method in descriptive terms.
- `visual_description`: a concrete description of how the page should look.
- `content`: exact title/subtitle text or a `generation_prompt`.

## Visual Reference Workflow

Read [style-extraction-workflow.md](references/style-extraction-workflow.md) when the user wants to turn Pinterest, posters, landing pages, screenshots, mood boards, or reference images into a presentation style.

Default process:

1. Collect a small set of references.
2. Ask what attracts the user: color, layout, image treatment, texture, atmosphere, or typography.
3. Extract design vocabulary:
   - color strategy
   - typography
   - composition
   - image treatment
   - texture and decoration
   - overall atmosphere
4. Convert the vocabulary into YAML fields.
5. Let the user adjust the style description before generating slides.

## Presentation Analysis

When analyzing an existing presentation:

1. Identify the deck's intended audience, purpose, and narrative.
2. Check whether slide titles communicate meaning or only label topics.
3. Inspect page density, visual hierarchy, layout consistency, and image relevance.
4. Identify the highest-impact fixes first.
5. If it is a NotebookLM deck, suggest YAML changes rather than only visual comments.

Lead review output with actionable findings. Keep compliments brief and specific.

## Creation Standards

For new presentations:

- Plan slide count and slide roles before writing slide copy.
- Use one main idea per slide.
- Prefer concrete visual descriptions over abstract style words.
- Use slide-level `generation_prompt` values for content pages.
- Use exact title/subtitle values for cover and section pages.
- Avoid generic phrases such as "high quality", "modern", or "professional" unless they are supported by concrete color, typography, layout, and image rules.

## NotebookLM Iteration

After NotebookLM produces a first draft:

1. Keep the slides that already work.
2. Give page-specific corrections:
   - "p1: move title/subtitle left and image right."
   - "p2: keep the layout, but change the character expression."
   - "p3: use three horizontal columns for the three directions."
3. Update the YAML instead of regenerating from vague comments.
4. Use Canva or PowerPoint for small typo or font fixes when faster than another NotebookLM generation.

## Output Formats

For a YAML request, return:

- a short explanation of the design direction
- a complete YAML block
- a NotebookLM usage prompt
- optional revision prompts

For deck creation, return:

- deck thesis
- slide outline
- slide-by-slide content
- visual direction
- YAML style specification when NotebookLM is involved

For analysis, return:

- diagnosis
- prioritized fixes
- revised structure or YAML changes
- slide-by-slide notes when possible
