---
name: notebooklm-architecture
description: Create reusable NotebookLM architecture source files that control a notebook's role, thinking logic, teaching method, output structure, formatting, and source-selection behavior. Use when the user asks to design, revise, or package NotebookLM control prompts, Soul Frameworks, Body Frameworks, source files, note-to-source workflows, YAML-like configuration content, teacher-facing NotebookLM templates, or reusable architecture instructions for NotebookLM.
---

# NotebookLM Architecture

## Purpose

Create file-ready NotebookLM framework content that a teacher can save as a note, convert into a source, export to Google Docs, and reuse across notebooks.

Use two framework types:

- Soul Framework: control the AI role, tone, reasoning, teaching method, and knowledge-handling attitude.
- Body Framework: control the output structure, layout, numbering, visual format, table style, and required sections.

For the full source rules from the original document, read `references/framework-spec.md`.

## Workflow

1. Identify the requested framework target.
   - Use Soul Framework when the user asks for role, voice, persona, thinking logic, reasoning rules, teaching method, or conversation style.
   - Use Body Framework when the user asks for layout, format, section structure, table proportions, numbering rules, visual style, or output shape.
   - If both are needed, create two clearly separated framework file contents.

2. Name the framework.
   - Use the user's explicit name when provided.
   - Otherwise infer a short descriptive Chinese name from the purpose.

3. Output only reusable file content plus the required teacher workflow.
   - Wrap each file's content between `---檔案內容開始---` and `---檔案內容結束---`.
   - Put the framework declaration as the first line inside the wrapper.
   - After the file content, include the NotebookLM conversion steps.

4. If the user asks to modify an existing framework document, edit the document directly when it is available and writable. Remind the user that NotebookLM can sync from the modified document.

## Required Declarations

Soul Framework first line:

```text
此為 [名稱] 靈魂框架, 勾選此資料則決定 AI 的角色定位與思考邏輯。
```

Body Framework first line:

```text
此為 [名稱] 格式框架, 勾選此資料則按照以下的結構與格式要求做輸出。
```

## Content Requirements

Soul Frameworks must include:

- `[身分設定]`
- `[邏輯約束]`
- `[知識處理態度]`
- `[對話風格]`

Body Frameworks must include the relevant subset of:

- `[結構比例]`
- `[視覺格式]`
- `[編號規範]`
- Specific output sections, tables, or formatting rules requested by the user.

Keep framework text operational and source-friendly. Write instructions that NotebookLM can follow after the source is checked, not commentary about the process.

## NotebookLM Conversion Steps

After producing framework content, include these steps unless the user explicitly asks for content only:

1. 點擊下方「儲存至記事 (Save to Note)」。
2. 進入記事後選擇「轉換成來源」。
3. 進入記事後選擇「匯出至 Google 文件」。
4. 於目標筆記本點擊「新增來源」，從 Google 雲端硬碟匯入該文件；之後可修改文件並讓 NotebookLM 同步。
