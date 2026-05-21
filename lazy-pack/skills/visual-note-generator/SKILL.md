---
name: visual-note-generator
description: Generate and transform educational visual notes from hand-drawn diagrams, voice transcripts, articles, or draft teaching ideas. Use when Codex needs to create AI image prompts for visual notes, 16:9 infographic structures, Q-version educator avatars, social/article rewrites from visual-note transcripts, or slide structures based on the user's original content without adding unsupported ideas.
---

# Visual Note Generator

## Core Rule

Use the user's supplied source as the boundary. Do not add concepts, claims, examples, book content, accessories, or visual details that are not present in the source or explicitly requested by the user.

Prefer Traditional Chinese output unless the user asks for another language.

## Workflow

1. Identify the source type: hand-drawn note image, generated visual note, personal photo, voice transcript, article, or column draft.
2. Identify the target output: image prompt, avatar prompt, social post, article, infographic content structure, or slide structure.
3. Load `references/prompt-library.md` when exact reusable wording or output structure is needed.
4. Preserve the user's identity perspective, such as teacher, engineer, creator, parent, or another stated role.
5. Keep visual outputs educational, warm, clean, and readable. Avoid photorealism, 3D, excessive technology style, corporate-slide stiffness, and clutter.
6. For image prompts, explicitly state the aspect ratio, style, content boundary, text limits, and negative constraints.

## Task Patterns

### Hand-Drawn Note To Visual Diagram

Create a 16:9 horizontal, high-resolution visual diagram prompt. Preserve the original structure, wording, logic, and hierarchy. Emphasize clear lines, warm layered color, educational diagram style, and a friendly hand-drawn feel.

### Add Educator Avatar

Add a small Q-version educator character only as a supporting identity marker. Keep the diagram as the main subject. Place the character to one side, smiling or pointing toward a key point, without blocking content.

### Photo To Reusable Avatar

When a user provides a personal photo, transform the person into a professional, reusable educational Q-version avatar. Preserve major traits such as hairstyle, face shape, glasses, or facial hair. Avoid exaggerated costumes, babyish style, or props not present in the photo.

### Transcript To Article Or Post

Turn a visual-note transcript or reading reflection into a publishable article or social post while preserving the user's original viewpoint. Do not summarize mechanically. Build resonance, situation, viewpoint, perspective shift, and a memorable closing line.

### Text To Infographic Or Slides

Convert a column or article into a 16:9 infographic structure or slide outline. Visualize the core viewpoint instead of summarizing the whole text. Keep each slide or infographic section focused on one idea.

## Output Discipline

- Ask only when a missing parameter blocks useful output, such as the number of slides.
- If the source is too long, first extract the core viewpoint and identity stance, then generate the requested structure.
- If the user asks to generate an actual image and the `imagegen` skill or image tool is available, use it after composing the prompt.
- If generating prompts only, output ready-to-paste prompts with placeholders clearly marked.
