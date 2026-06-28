# 22-Image-Generator-Skill-安裝

> 版本：2026-05-25 Codex App 版
> 用途：建立 `image-generator` 全域 skill，讓使用者用自然語句在 Codex 裡生圖、修圖、寫圖像提示與整理圖片資產。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/image-generator/`，不需要設定 OpenAI API key，也不需要任何非 Codex 工具。

## 來源與歷史紀錄

- 初次同步日期：2026-05-25。
- 來源文件：`08-用Image Gen Skill在Codex生圖.md`。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/image-generator/SKILL.md`。
- 這版定位：以 Codex 內建 image generation capability 作為一般生圖與修圖入口；API / CLI 只作為明確要求自動化時的進階例外。

## 這版和來源文件的差異

| 項目 | Codex 版調整 |
|---|---|
| 1 | 移除非 Codex 工具路徑、外部工具命令與非 Codex frontmatter 假設。 |
| 2 | 不要求 `OPENAI_API_KEY`；一般生圖、修圖與提示設計都走 Codex 內建影像生成能力。 |
| 3 | 使用可攜式路徑 `{{CODEX_HOME}}/skills/image-generator/`，不寫入個人電腦絕對路徑。 |
| 4 | 把新手教學整理成可觸發的 Codex skill workflow 與 reference 文件。 |

## 安裝方式

1. 打開本文文末「內建 Skill 完整安裝內容」。
2. 把整段安裝腳本複製到自己的環境執行。
3. 執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。
4. 安裝後開新 Codex 對話或重啟 Codex App，讓新的全域 skill metadata 被重新載入。

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/image-generator/SKILL.md" && echo "image-generator SKILL.md ok"
test -f "{{CODEX_HOME}}/skills/image-generator/references/imagegen-codex-workflow.md" && echo "image-generator reference ok"
```

合理結果是每一行都顯示 `ok`。

## 使用方式

安裝後可用下列語句觸發：

- 「使用 image-generator 幫我生成一張教學封面圖」
- 「幫我畫一張 16:9 的數學闖關遊戲背景圖」
- 「幫我把這張圖改成 YouTube 縮圖風格」
- 「幫我寫一段適合 Codex 生圖的提示詞」
- 「生成一個透明背景的課程徽章素材」

觸發語意包含：image-generator、generate image、生圖、修圖、圖片編輯、圖像提示、封面、插圖、角色、背景、透明背景素材、縮圖、漫畫分鏡、教學圖片。

## 預設工作流程

1. 判斷任務是生圖、修圖、提示詞撰寫，還是圖片資產整理。
2. 擷取用途、比例、主體、場景、風格、色彩、文字需求與限制。
3. 一般情況直接使用 Codex 內建 image generation capability；不要要求使用者設定 API key。
4. 預設建議圖片不要含文字；重要文字後續用簡報、HTML、Canva 或其他編輯工具加入。
5. 若使用者指定專案或 Obsidian 位置，完成後才回報實際檔案路徑。

## 踩坑紀錄

### 1. 不要把 API key 當成新手必備

Codex 內建生圖和 OpenAI API 是兩條路。一般生圖、修圖、教材視覺與圖片提示先用 Codex 內建能力；只有大量批次、自動化或成本追蹤需求才考慮 API。

### 2. 不要把非 Codex 工具路徑帶進正式安裝

正式版只使用 Codex 全域 skill 路徑 `{{CODEX_HOME}}/skills/image-generator/`。不要建立非 Codex skill 位置、外部工具命令或非 Codex metadata。

### 3. 圖中文字通常要保守

若圖片需要標題、按鈕字或精準中文，優先生成「無文字」視覺，再用簡報、HTML、Canva 或其他工具加文字。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/image-generator/SKILL.md` 存在。
- [ ] `{{CODEX_HOME}}/skills/image-generator/references/imagegen-codex-workflow.md` 存在。
- [ ] 搜尋 package 內沒有非 Codex 專用路徑、非 Codex frontmatter 或 API key 要求。
- [ ] 開新 Codex 對話後，可用 `image-generator`、生圖、修圖或圖片提示相關語句觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`image-generator`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

```bash
set -e

# ---- image-generator ----
mkdir -p "{{CODEX_HOME}}/skills/image-generator"
# image-generator/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/image-generator/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/image-generator/SKILL.md" <<'CODEX_LAZYPACK_IMAGE_GENERATOR_SKILL_MD'
---
name: image-generator
description: Use when the user asks to generate, edit, restyle, or prepare images in Codex, including 生圖, 修圖, 圖像提示, 教學圖片, 封面, 插圖, 角色, 背景, transparent-background assets, thumbnails, comic panels, or visual assets for slides, websites, games, and Obsidian notes. This skill routes ordinary image work through Codex's built-in image generation capability without requiring an OpenAI API key.
metadata:
  short-description: Generate and edit images with Codex image generation
---

# Image Generator

Use this skill as a Codex App image-generation workflow. It is a lightweight
front door for Codex's built-in image generation capability, not an API-key or
CLI automation package.

## Core Rule

- For ordinary image creation, style exploration, or image editing,
  use Codex's built-in image generation capability.
- Do not ask the user to set `OPENAI_API_KEY` for normal image work.
- Do not create API scripts, billing setup, batch-generation workflows, or CLI
  routes unless the user explicitly asks for API automation.
- Do not use non-Codex skill paths, external tool commands, or non-Codex
  frontmatter.

## When To Use

Use this skill when the user asks for:

- new images, illustrations, covers, thumbnails, backgrounds, teaching visuals,
  game assets, badges, icons, comics, storyboards, or social visuals;
- edits to an attached or referenced image, such as restyling, changing the
  background, adjusting composition, creating variants, or making transparent
  assets;
- image prompts for later generation;
- guidance on where generated images should be saved or copied inside a project,
  Obsidian vault, slide deck, website, or asset folder.

If the request is really a deterministic diagram, chart, UI mockup, PowerPoint
layout, SVG icon, or code-native canvas element, decide whether a code/vector
tool is more appropriate before using image generation.

## Workflow

1. Identify the output intent: image generation, image editing, prompt writing,
   or asset placement.
2. Extract the minimum useful prompt fields:
   - purpose;
   - aspect ratio or target size;
   - subject and scene;
   - style;
   - colors;
   - text policy;
   - constraints and exclusions.
3. If enough information is present, generate or edit directly. Ask a short
   clarification only when the missing detail changes the output materially.
4. Prefer "no text" for images unless the user explicitly needs text in the
   image. Important text is usually better added later in slides, HTML, Canva,
   or another editor.
5. After generation, report the useful result and any local path or project
   placement action that was actually completed.

## Prompt Template

```text
Generate an image:
Purpose:
Aspect ratio:
Subject:
Scene:
Style:
Colors:
Text:
Constraints:
```

## Editing Images

When the user provides or references an image:

- preserve the user-specified subject, identity, composition, or object if they
  ask to keep it;
- state the intended edit in the prompt rather than rewriting the whole image
  from scratch;
- for transparent-background assets, request a clean isolated subject and avoid
  complex semi-transparent edges when possible;
- if the user needs project assets, copy or move the final file only when a
  concrete destination is requested and available.

## Safety And Secrets

- Never ask the user to paste API keys into chat, `AGENTS.md`, Obsidian notes,
  or repo files.
- If an API route is explicitly requested, keep secrets in local environment
  variables or ignored local files only.
- For public LazyPack documentation, keep paths portable with placeholders such
  as `{{CODEX_HOME}}`, `{{PROJECT_ROOT}}`, and `{{OBSIDIAN_VAULT}}`.

## Reference

Read `references/imagegen-codex-workflow.md` for examples, beginner guidance,
and common pitfalls.
CODEX_LAZYPACK_IMAGE_GENERATOR_SKILL_MD

# image-generator/references/imagegen-codex-workflow.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/image-generator/references/imagegen-codex-workflow.md")"
cat > "{{CODEX_HOME}}/skills/image-generator/references/imagegen-codex-workflow.md" <<'CODEX_LAZYPACK_IMAGE_GENERATOR_REFERENCES_IMAGEGEN_CODEX_WORKFLOW_MD'
# Image Generator Reference: Codex Image Generation Workflow

This reference adapts the user-provided guide
`08-用Image Gen Skill在Codex生圖.md` into a Codex App-compatible skill workflow.

## Positioning

There are two possible image routes:

| Route | Best for | API key |
|---|---|---|
| Codex built-in image generation | ordinary image creation, teaching visuals, covers, thumbnails, image edits, simple assets | not required |
| OpenAI API automation | large batches, programmatic pipelines, explicit cost tracking, fixed scripts | required |

Default to the built-in Codex image generation route. Mention API only when the
user explicitly asks for automation, large-scale generation, or API control.

## Beginner Requests

Useful prompt patterns:

```text
Generate a 16:9 teaching slide cover about AI helping teachers prepare lessons.
Style: bright modern illustration, warm classroom, clean composition.
Text: no text.
Constraints: no watermark, no futuristic UI, no clutter.
```

```text
Generate a transparent-background badge for a math game.
Subject: equation-solving champion badge.
Style: friendly classroom game asset.
Text: no text.
Constraints: clean silhouette, readable at small size.
```

```text
Edit the attached image into a YouTube thumbnail style.
Preserve the main person.
Change the background to a bright classroom.
Text: no text.
```

## Prompt Fields

Use these fields when the user needs help writing a prompt:

- Purpose: where the image will be used.
- Aspect ratio: 16:9, 1:1, 4:5, 9:16, transparent asset, etc.
- Subject: main person, object, scene, or concept.
- Scene: environment and composition.
- Style: photo, watercolor, modern anime illustration, flat editorial, etc.
- Colors: key palette or mood.
- Text: no text, or exact requested text if unavoidable.
- Constraints: no watermark, no logo, no clutter, no sci-fi UI, no fake text.

## Common Pitfalls

| Problem | Cause | Practical fix |
|---|---|---|
| User is unsure which quota is used | built-in image generation and API billing are separate systems | Use built-in image generation by default; API is only for explicit automation |
| Image contains poor text | image models may render text inaccurately | Generate with no text, then add text later in slides or design tools |
| Transparent edges look messy | hair, smoke, glass, or semi-transparent objects are hard | Use a clean isolated subject and simple edges |
| Asset is hard to reuse | image stays only in generated output location | Copy it into the project or Obsidian attachment folder when requested |
| Prompt is too detailed without purpose | image loses focus | Start from purpose and composition, then add style and constraints |

## Project Placement

When the user wants the generated image saved into a project, prefer stable
asset paths such as:

- `{{PROJECT_ROOT}}/assets/images/`
- `{{PROJECT_ROOT}}/public/images/`
- `{{PROJECT_ROOT}}/src/assets/`
- `{{OBSIDIAN_VAULT}}/<note-folder>/attachments/`

Report the final path only after the file has actually been copied or created.

## Codex Compatibility

- Use Codex App image generation capability for generation and editing.
- Keep the skill in `{{CODEX_HOME}}/skills/image-generator/`.
- Do not use non-Codex tool commands, non-Codex skill paths, or non-Codex
  metadata.
- Do not require API keys for normal image work.
CODEX_LAZYPACK_IMAGE_GENERATOR_REFERENCES_IMAGEGEN_CODEX_WORKFLOW_MD

echo "image-generator skill installed at {{CODEX_HOME}}/skills/image-generator"
```

<!-- END EMBEDDED_SKILLS -->
