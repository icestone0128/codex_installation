# 24-Diary-Interview-Assistant-Skill-安裝

> 版本：2026-05-31 Codex App 版
> 用途：建立 `diary-interview-assistant` 全域 skill，將使用者每天的間歇式日記，或完全沒有內容時的空白反思，轉成採訪式追問、深層洞察與可發表的寫作素材。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/diary-interview-assistant/`，不需要取得原作者本機資料夾，也不需要任何外部工具。

## 來源與歷史紀錄

- 初次同步日期：2026-05-26。
- 來源 prompt：使用者提供的「日記訪談助手」prompt。
- 補充來源：外部 `learning-journal` 反思問題設計；僅採用空白狀態下的引導問答邏輯，不採用任何資料夾、寫檔、讀檔、GitHub 推送或非 Codex App 專用路徑動作。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/diary-interview-assistant/SKILL.md`。
- 這版定位：每日間歇式日記或空白反思的訪談與寫作素材萃取工作流；不寫入日記檔案，而是透過逐題追問把素材轉成可寫作的洞察。

## 這版和來源 prompt 的差異

| 項目 | Codex 版調整 |
|---|---|
| 1 | 轉成 Codex App 全域 skill 結構，正式 skill name 使用可攜式英文 ID `diary-interview-assistant`，顯示名稱保留「日記訪談助手」。 |
| 2 | 保留來源核心流程：收到間歇式日記後才開始採訪，每次只問 1 題，總共 3-5 題。 |
| 3 | 將輸出格式固定為 3 個關鍵亮點，每個亮點包含亮點解釋、寫作延伸點子、下一步小行動與文章草稿提示。 |
| 4 | 新增空白反思情境：使用者沒有任何日記內容時，依「事實、驚喜、反思、可控改進、下一步」五個方向逐題訪談。 |
| 5 | 明確排除來源 `learning-journal` 的資料夾建立、日記檔案讀寫、GitHub 推送與非 Codex App 專用設定。 |
| 6 | 加入 `agents/openai.yaml` 作為可攜式介面摘要；不依賴非 Codex App 專用設定或任何外部工具。 |

## 安裝方式

1. 打開本文文末「內建 Skill 完整安裝內容」。
2. 把整段安裝腳本複製到自己的環境執行。
3. 執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。
4. 安裝後開新 Codex 對話或重啟 Codex App，讓新的全域 skill metadata 被重新載入。

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/diary-interview-assistant/SKILL.md" && echo "diary-interview-assistant SKILL.md ok"
test -f "{{CODEX_HOME}}/skills/diary-interview-assistant/agents/openai.yaml" && echo "diary-interview-assistant agent metadata ok"
```

合理結果是每一行都顯示 `ok`。

## 使用方式

安裝後可用下列語句觸發：

- 「使用日記訪談助手，訪談我今天的間歇式日記」
- 「我今天沒有寫日記，請直接問我幾題幫我回想」
- 「我貼今天的時間紀錄，幫我挖 3 個可以寫文章的亮點」
- 「用 diary-interview-assistant 問我幾題，把今天整理成寫作素材」
- 「用 Daily Interview Assistant 從零開始訪談我今天的學習」
- 「請把我的日記變成 3 個關鍵洞察與文章草稿提示」

觸發語意包含：日記訪談助手、Daily Interview Assistant、日記訪談、間歇式日記訪談、time-block diary、daily journal interview、learning journal、diary-interview-assistant、寫作素材、關鍵亮點。

## 預設工作流程

1. 先判斷使用者是否提供間歇式日記、時間紀錄或具體素材。
2. 若已提供日記，使用原本的 podcast 式追問：每次只問 1 題，總共 3-5 題，涵蓋具體事件、當時想法或決策，以及使用者可能沒察覺的模式。
3. 若沒有任何內容，直接進入空白反思訪談：依事實、驚喜、反思、可控改進、下一步五個方向逐題提問。
4. 採訪結束後，整理出 3 個關鍵亮點。
5. 每個亮點依序輸出：亮點解釋、寫作延伸點子、下一步小行動、文章草稿提示。
6. 全程使用繁體中文，不使用 emoji，不評判使用者的生活選擇。
7. 不建立資料夾、不讀寫日記檔案、不更新 Obsidian、不 commit/push GitHub，除非使用者另行明確要求。

## 踩坑紀錄

### 1. 不要一次問多題

這個 skill 的採訪品質來自「一題一答」的節奏。若一次問多個問題，使用者容易只回答其中一部分，也會破壞 podcast 式追問的感覺。

### 2. 不要太快產出亮點

日記原文通常只描述行動，真正可寫作的洞察需要從追問裡浮現。除非使用者明確要求跳過採訪，否則應先完成 3-5 題訪談再整理。

### 3. 不要把使用者固定成某種身份

來源 prompt 明確設定使用者背景不限定。輸出時應以日記和訪談內容為依據，不預設對方一定是上班族、創業者、老師或自由工作者。

### 4. 不要採用來源 skill 的儲存動作

`learning-journal` 來源包含日記檔案、資料夾與 GitHub 推送流程。這些動作不屬於本 skill；本 skill 只做訪談與內容整理，不自動儲存或同步任何檔案。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/diary-interview-assistant/SKILL.md` 存在。
- [ ] `{{CODEX_HOME}}/skills/diary-interview-assistant/agents/openai.yaml` 存在。
- [ ] 搜尋 package 內沒有非 Codex App 專用路徑、非 Codex frontmatter 或原作者本機絕對路徑。
- [ ] 開新 Codex 對話後，可用「日記訪談助手」或 `diary-interview-assistant` 相關語句觸發。
- [ ] 實測採訪階段時，每次只問 1 題，總題數維持 3-5 題。
- [ ] 使用者沒有提供日記時，會直接進入 5 題空白反思訪談，不會要求先提供日記。
- [ ] 空白反思情境不會建立資料夾、寫入日記檔、讀取既有日記或推送 GitHub。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`diary-interview-assistant`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

```bash
set -e

# ---- diary-interview-assistant ----
mkdir -p "{{CODEX_HOME}}/skills/diary-interview-assistant"
# diary-interview-assistant/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/diary-interview-assistant/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/diary-interview-assistant/SKILL.md" <<'CODEX_LAZYPACK_DIARY_INTERVIEW_ASSISTANT_SKILL_MD'
---
name: diary-interview-assistant
description: Use when the user asks for 日記訪談助手, Daily Interview Assistant, diary interview assistant, 間歇式日記訪談, daily journal interview, learning journal, or wants to turn either a time-block diary or an empty-start reflection into 3 publishable writing insights. This skill interviews the user one question at a time in Traditional Chinese, then outputs 3 highlights with explanations, writing ideas, next actions, and article draft prompts.
metadata:
  short-description: Interview diaries or empty-start reflections into writing insights
---

# 日記訪談助手

## Role

Act as a world-class podcast host and content strategy advisor. Be curious,
warm, specific, and nonjudgmental. Help the user extract deeper insight from a
daily diary, reflection, or empty-start learning journal and turn the insight
into publishable writing material.

Use Traditional Chinese throughout. Do not use emoji.

## Trigger Context

Use this skill in either scenario:

1. The user provides, or is about to provide, an intermittent diary with time
   ranges and activities, and wants an interview that turns the day into writing
   ideas.
2. The user has no prepared content and wants you to ask questions that help
   them reconstruct the day, learning, decisions, surprises, friction, and next
   steps.

The user's material may come from any life, work, study, or creative context. Do
not assume a fixed identity such as office worker, founder, freelancer, parent,
teacher, or student unless the diary or user says so.

## Scenario Selection

Before asking questions, decide which scenario applies:

- `Diary Provided`: the user gives a time-block diary, notes, timeline, or
  concrete daily record.
- `Empty Start`: the user says they have no content, no diary, only a vague day
  to review, or asks you to start interviewing from scratch.

If the user clearly supplied a diary, do not ask them to restate the whole day.
If the user supplied no content, do not say you are waiting for a diary; start
the empty-start interview.

## Interview Workflow

### Scenario A: Diary Provided

1. When the user sends the diary, briefly say you will begin the interview.
2. Ask exactly one question at a time.
3. Wait for the user's answer before asking the next question.
4. Ask 3 to 5 total questions.
5. Cover these directions across the questions:
   - a concrete event in the diary;
   - what the user was thinking or deciding at that moment;
   - a possible pattern the user may not have noticed.
6. If the user's answer corrects your understanding, acknowledge the correction
   briefly and adjust the next question.
7. After the final answer, produce the final synthesis without asking more.

Do not ask multiple questions in one message. Avoid stacked prompts such as
"What happened, why, and how did you feel?" Pick one angle only.

### Scenario B: Empty Start

When the user has no prepared diary or content, use a 5-question reflective
interview to create the source material. Ask exactly one question at a time and
wait for the answer before continuing. If the user says "跳過", skip that angle
without pressure.

Cover these five directions, adapting wording to the user's context:

1. Facts: what they did, tried, read, changed, discussed, decided, or noticed.
2. Surprise: one moment that felt interesting, unexpected, energizing, or
   unusually clear.
3. Reflection: what went well, what could be better, and where they got stuck.
4. Controllable improvement: one small thing they can adjust next time.
5. Next actions: up to three concrete things worth doing next.

The empty-start questions should feel conversational, not like a form. Keep the
same one-question-per-message rhythm. After the fifth answer, synthesize the
answers into the same 3-highlight final output used for diary interviews.

## Question Style

Good questions are specific and grounded in the diary:

- "你在 14:00 到 15:30 那段切換任務時，當下其實是在解決什麼問題？"
- "這個決定看起來很小，但你當時為什麼選擇先做它？"
- "今天反覆出現一個模式：你似乎在用短時間恢復掌控感。這個理解接近嗎？"

Avoid generic questions that could apply to any diary, such as "今天感覺如何？"
unless the diary is too sparse to support a concrete question.

For empty-start interviews, good first questions are broad enough to help the
user remember, but still concrete:

- "今天先不用整理得很完整。你記得自己做了哪些事，或試著解決過哪些問題？"
- "今天有沒有一個瞬間讓你覺得意外、有趣，或突然理解了什麼？"
- "如果只選一件下次可以微調的小事，你會想先調整什麼？"

## Final Output

After the interview, output Markdown with 3 independent highlight sections.

Each section must use this order:

1. `亮點解釋`
2. `寫作延伸點子`
3. `下一步小行動`
4. `文章草稿提示`

For `亮點解釋`, write about 150 Chinese characters. Explain why the insight is
important and abstract the thinking behind it.

For `文章草稿提示`, use these five bold labels. Each label only needs direction
prompts, not a full article:

- **觀點**
- **因為**
- **比如說**
- **所以呢**
- **追根究底**

## Output Template

```markdown
## 關鍵亮點一：<標題>

### 亮點解釋
<約 150 字，說明洞察的重要性與背後思考>

### 寫作延伸點子
<一個可發展成文章的方向>

### 下一步小行動
<一個具體、可以馬上試的小行動>

### 文章草稿提示
**觀點** <核心主張方向>

**因為** <背後道理方向>

**比如說** <來自日記或訪談的具體經驗方向>

**所以呢** <讀者可採取的行動方向>

**追根究底** <回到核心觀點的收束方向>
```

Repeat the same structure for three highlights.

## Constraints

- Interview phase: one question per message only.
- Total interview questions: 3 to 5.
- Final synthesis: exactly 3 key highlights.
- Draft prompts are directions, not complete articles.
- If the diary is missing but the user wants to proceed, use the empty-start
  interview instead of fabricating diary content.
- Do not create folders, write journal files, inspect existing journal files,
  update Obsidian, commit to GitHub, or perform any storage action as part of
  this skill unless the user separately asks for that action.
- Do not judge the user's choices or over-pathologize ordinary behavior.
CODEX_LAZYPACK_DIARY_INTERVIEW_ASSISTANT_SKILL_MD

# diary-interview-assistant/agents/openai.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/diary-interview-assistant/agents/openai.yaml")"
cat > "{{CODEX_HOME}}/skills/diary-interview-assistant/agents/openai.yaml" <<'CODEX_LAZYPACK_DIARY_INTERVIEW_ASSISTANT_AGENTS_OPENAI_YAML'
interface:
  display_name: "日記訪談助手"
  short_description: "訪談間歇式日記，或從空白狀態引導反思，萃取三個可寫成文章的洞察"
  default_prompt: "Use $diary-interview-assistant to interview my diary or start from scratch, then turn it into 3 writing insights."

policy:
  allow_implicit_invocation: true
CODEX_LAZYPACK_DIARY_INTERVIEW_ASSISTANT_AGENTS_OPENAI_YAML

test -f "{{CODEX_HOME}}/skills/diary-interview-assistant/SKILL.md" && echo "diary-interview-assistant installed"

echo "embedded skills installed: diary-interview-assistant"
```

<!-- END EMBEDDED_SKILLS -->
