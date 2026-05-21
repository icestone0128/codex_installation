# 11-Codex-Skill-Creator-工作流

## 目標

把 外部 / Anthropic 取向的 Skill Creator 啟動包，轉成 Codex App 可用的全域 skill 建立流程。

這份文件是之後建立、優化、驗證 Codex skills 的正式懶人包。若來源文件提到 來源工具、來源工具的 skills 路徑、slash command、來源工具 subagent 或 來源工具專用 frontmatter，一律先依本文件轉換，不直接照做。

## 前置條件

- 已完成 `README.md` 的設定表。
- 已知道 Codex skills 位置：`{{CODEX_HOME}}/skills`。
- 已確認系統內建 skills 位置：`{{CODEX_HOME}}/skills/.system`。
- 已知道 Obsidian 全域 skill 索引位置；若沒有，可先建立：

```text
{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md
```

## 固定結論

- 使用環境：Codex App。
- 自訂全域 skills 固定放在 `{{CODEX_HOME}}/skills`。
- Codex 內建系統 skills 在 `{{CODEX_HOME}}/skills/.system`，平常只讀取，不覆蓋。
- 內建 `skill-creator` 保持系統版本；自訂優化放在 companion skill。
- 全域 skills 有新增、修改或刪除時，要同步更新 Obsidian 的全域 Skills 索引。

## 建立 Codex 版 Skill Creator Companion

建議 skill 名稱：

```text
codex-skill-creator
```

建立：

```text
{{CODEX_HOME}}/skills/codex-skill-creator/SKILL.md
{{CODEX_HOME}}/skills/codex-skill-creator/references/codex-bootstrap-adapter.md
```

用途：

- 把 外部 / Anthropic skill 教學轉成 Codex App 相容流程。
- 建立、優化、驗證自訂全域 skills。
- 記得同步 Obsidian 全域 skill 索引。

## 直接安裝本懶人包版本

下載本 repo 後，可直接複製已整理好的 companion skill：

```bash
mkdir -p "{{CODEX_HOME}}/skills/codex-skill-creator"
rsync -a --delete "{{SETUP_REPO}}/lazy-pack/skills/codex-skill-creator/" "{{CODEX_HOME}}/skills/codex-skill-creator/"
test -f "{{CODEX_HOME}}/skills/codex-skill-creator/SKILL.md" && echo "codex-skill-creator installed"
```

若下載者沒有使用 Obsidian 全域 skill 索引，安裝後可跳過本文的 Obsidian 同步步驟。

## 來源啟動包轉換規則

| 外部 / Anthropic 啟動包項目 | Codex App 相容做法 |
| --- | --- |
| 來源工具的 skills 路徑 | 改用 `{{CODEX_HOME}}/skills` |
| 來源工具的專案級 skills 路徑 專案 skill | 預設不要用；除非另有 Codex 專案級 skill 機制 |
| `000_Agent/skills` symlink | 不建立；個人助手核心可在 `{{SETUP_REPO}}/000_Agent`，但正式 Codex skill 放 `{{CODEX_HOME}}/skills` |
| 來源工具 slash command `/skill-name` | 不依賴；Codex 以 skill metadata 與任務語意觸發 |
| `allowed-tools` | 不寫入；Codex 工具權限由當前 session、plugin、connector 與沙箱控制 |
| `disable-model-invocation` / `user-invocable` | 不寫入；觸發邊界寫在 `description` 與本文規則 |
| `when_to_use` | 轉成 `description` 的觸發語意與本文工作流程 |
| 來源工具 subagent 設定 | 不照搬；Codex 只有在使用者明確要求副代理時才使用 subagent |
| 安裝官方 Anthropic skill-creator | Codex 已有內建 `.system/skill-creator`；通常不安裝、不覆蓋 |
| 告知重啟 來源工具 | 改成開新 Codex 對話或重啟 Codex App |

## Codex Skill 標準結構

最小結構：

```text
<skill-name>/
└── SKILL.md
```

需要範例、模板或長規則時：

```text
<skill-name>/
├── SKILL.md
├── references/
├── scripts/
└── assets/
```

原則：

- `SKILL.md` 保持精簡，放觸發、路徑、流程與安全規則。
- 長範例、來源轉換表、模板放 `references/`。
- 只有需要穩定重複執行的檢查或轉換，才放 `scripts/`。
- 不額外建立 README、安裝指南、變更紀錄，除非使用者明確要求。

## Frontmatter 範本

```markdown
---
name: skill-name
description: Use when the user asks for [具體任務], [觸發語], or [工作流程]. Include input source, action, and expected output.
metadata:
  short-description: Short user-facing phrase
---
```

檢查規則：

- `name` 必須與資料夾名稱一致。
- `description` 要把最常用觸發場景放前面。
- 不放 來源工具專用 欄位。
- 不寫 API key、token、密碼或個資。

## 建立第一個真實 Skill 的流程

### 1. 訪談

只問足夠做決策的問題：

1. 最常重複交給 AI 的工作是什麼？
2. 發生頻率是多少？
3. 最後要交付什麼格式？
4. 需要讀取哪些固定資料、資料夾或範例？
5. 絕對不要做什麼？

### 2. 收斂成一個推薦 skill

輸出：

- 最推薦的一個 skill。
- 兩個備選。
- 為什麼這個最適合先做。

若使用者同意，直接建立，不停在建議。

### 3. 建立檔案

建立：

```text
{{CODEX_HOME}}/skills/<skill-name>/SKILL.md
```

視需要加：

```text
{{CODEX_HOME}}/skills/<skill-name>/references/<reference>.md
```

### 4. 驗證

必查：

- `SKILL.md` 存在。
- frontmatter 有 `---`、`name`、`description`。
- `name` 等於資料夾名稱。
- `description` 有具體觸發語。
- `references/` 內被引用的檔案真的存在。
- 沒有誤放 來源工具專用 欄位或路徑。

範例檢查：

```bash
find "{{CODEX_HOME}}/skills/<skill-name>" -maxdepth 2 -type f -print
sed -n '1,20p' "{{CODEX_HOME}}/skills/<skill-name>/SKILL.md"
```

### 5. 同步

每次全域 skill 變更後，更新：

```text
{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md
```

至少更新三處：

- 自訂全域 Skills 表格。
- Skill 摘要段落。
- 最近同步紀錄。

若下載者沒有使用 Obsidian，也至少在 `{{SETUP_REPO}}/README.md` 或專案駕駛艙記錄 skill 清單。

## 本懶人包內含範例

本懶人包已附：

```text
{{CODEX_HOME}}/skills/codex-skill-creator/SKILL.md
{{CODEX_HOME}}/skills/codex-skill-creator/references/codex-bootstrap-adapter.md
{{CODEX_HOME}}/skills/secondbrain-research-digest/SKILL.md
{{CODEX_HOME}}/skills/secondbrain-research-digest/references/research-note-template.md
```

下載者應使用自己的 `{{CODEX_HOME}}` 與自己的 skill 名稱。

## 驗證

完成 skill 建立或更新後：

1. 檢查 skill 檔案：

```bash
find "{{CODEX_HOME}}/skills/<skill-name>" -maxdepth 2 -type f -print
```

2. 檢查 frontmatter：

```bash
sed -n '1,20p' "{{CODEX_HOME}}/skills/<skill-name>/SKILL.md"
```

3. 確認：
   - `name` 等於資料夾名。
   - `description` 有明確觸發情境。
   - 引用的 `references/` 檔案存在。
   - 沒有 來源工具的 skills 路徑、`allowed-tools`、`disable-model-invocation`、`user-invocable` 等 來源工具專用 正式設定。
4. 開新 Codex 對話，使用自然語言觸發該 skill 的任務。
5. 同步 Obsidian 全域 Skills 索引或專案 README。

## 踩坑修正

- 原始 `02-skill-creator-bootstrap.md` 是 來源工具 啟動包，不能原樣執行。
- 不要把官方 Anthropic `skill-creator` sparse checkout 到 Codex 系統 skill 位置；Codex 已有內建 `.system/skill-creator`。
- 不要覆蓋 `{{CODEX_HOME}}/skills/.system/skill-creator`，因為它由 Codex 管理。
- Codex skills 不放在 來源工具的 skills 路徑，也不建立 來源工具的專案級 skills 路徑 或 symlink。
- Codex 不應依賴 `/skill-name` slash command；要靠 `description` 寫清楚觸發語意。
- 來源工具專用 frontmatter 欄位要轉成 Codex 可理解的文字規則，不要照抄。
- 新增 skill 後不代表本對話立即可見；通常要開新對話或重啟 Codex App。
- Obsidian 同步紀錄要放在「最近同步紀錄」表格，不要誤插到自訂 skills 表格。
- Markdown 範本內若有巢狀 code fence，外層要用 `~~~markdown`，避免 YAML 範例提早結束區塊。
- 候選清單若寫進 repo 內，會出現在 git 未追蹤狀態；收工時要明確決定是否納入版本控制。

## 之後怎麼用

當使用者要求「建立 skill」、「優化 skill」、「把 來源 skill 教學轉成 Codex」、「跑 Skill Creator 啟動包」時：

1. 先套用本文件的 Codex 相容規則。
2. 使用 `codex-skill-creator` companion skill。
3. 若是第一個真實工作 skill，先做簡短訪談。
4. 建立或更新 `{{CODEX_HOME}}/skills/<skill-name>`。
5. 驗證 frontmatter、路徑與 reference。
6. 同步 Obsidian 全域 Skills 筆記或專案 README。
7. 回報是否需要開新對話或重啟 Codex App。
