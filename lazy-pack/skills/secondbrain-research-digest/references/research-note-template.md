---
title: Secondbrain Research Note Template
date: 2026-05-20
type: reference
tags:
  - secondbrain
  - research
  - decision
---

# Secondbrain Research Note Template

Use this reference when the task needs a fuller note, comparison, or decision memo.

## Research Digest

~~~markdown
---
title: <主題>
date: <YYYY-MM-DD>
type: research-digest
tags:
  - 知識整理
  - <主題標籤>
---

# <主題>

## 核心結論

- <用 3-5 點寫出目前最重要的判斷>

## 背景與問題

- 問題：
- 使用情境：
- 目前已知：

## 資料來源

| 來源 | 路徑/連結 | 用途 | 可信度 |
|---|---|---|---|
|  |  |  |  |

## 重點整理

### 1. <重點>

- 觀察：
- 證據：
- 對我的意義：

## 決策建議

- 建議：
- 理由：
- 風險：
- 下一步：

## 待確認

- [ ] <需要使用者或外部資料確認的事>

## 結構化資料

```yaml
topic: ""
task_type: research_digest
sources: []
key_findings: []
decision:
  recommendation: ""
  rationale: []
  risks: []
next_actions: []
open_questions: []
```
~~~

## Comparison Table

Use this when the user is choosing among tools, workflows, sources, or options.

```markdown
## 比較表

| 選項 | 適合情境 | 優點 | 風險/限制 | 判斷 |
|---|---|---|---|---|
|  |  |  |  |  |

## 建議排序

1. <第一選擇>：<理由>
2. <第二選擇>：<理由>
3. <不建議>：<理由>
```

## Decision Rules

- If evidence is weak, say so directly.
- Separate source facts from inference.
- Keep the final recommendation actionable.
- If writing into Secondbrain, default to creating a new note or appending a dated section.
- If the user asks for broad vault review, ask for scope first: folder, topic, date range, or target output.
