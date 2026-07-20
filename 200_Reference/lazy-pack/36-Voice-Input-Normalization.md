# 36 Voice Input Normalization

> 來源：`AGENT_SETUP_語音輸入文字正規化_跨Agent全域安裝.md`。本項只安裝 `voice-input-normalization`，用於把語音輸入文字正規化規則安全套用到支援的本機 AI Agent 全域設定。

## 用途

安裝 `voice-input-normalization` 全域 skill，並提供可重複執行的 installer：

- `--dry-run`：偵測 Codex、Claude Code、AntiGravity/Gemini、OpenCode 的設定位置，不寫入。
- `--apply`：建立備份後寫入受控 marker block 或專用 instruction 檔。
- `--remove --apply`：只移除受控區塊或專用規則檔，保留其他設定。
- OpenCode 會同步維護 `opencode.json` 的 `instructions` 陣列。

跨 Agent 全域設定規範不在本項獨立安裝；已併入 Item 16 `cross-device-sync` 的多 Agent 相容性與 global settings reference。

## 安裝位置

```text
{{SYNC_ROOT}}/skills/voice-input-normalization/
```

## 直接安裝

把本文文末「內建 Skill 完整安裝內容」整段複製執行。可先用環境變數指定安裝位置：

```bash
CODEX_HOME="${CODEX_HOME}" bash install-voice-input-normalization.sh
```

安裝後對 Codex、Claude、AntiGravity 分別開新對話或重載原生入口，讓 skill discovery 重新載入。

## 驗證安裝

```bash
test -f "{{SYNC_ROOT}}/skills/voice-input-normalization/SKILL.md"
test -f "{{SYNC_ROOT}}/skills/voice-input-normalization/references/normalization-rules.md"
test -x "{{SYNC_ROOT}}/skills/voice-input-normalization/scripts/install_voice_input_normalization.py"
python3 "{{SYNC_ROOT}}/skills/voice-input-normalization/scripts/install_voice_input_normalization.py" --dry-run
```

若安裝者有 Codex 內建 validator，可當作 Codex adapter 的額外驗證；Claude 與 AntiGravity 仍要各自做原生 discovery 測試：

```bash
python3 "{{CODEX_HOME}}/skills/.system/skill-creator/scripts/quick_validate.py" "{{SYNC_ROOT}}/skills/voice-input-normalization"
```

## 語音輸入正規化安裝方式

預設先 dry-run，不寫入任何 Agent 設定：

```bash
python3 "{{SYNC_ROOT}}/skills/voice-input-normalization/scripts/install_voice_input_normalization.py" --dry-run
```

確認後才套用：

```bash
python3 "{{SYNC_ROOT}}/skills/voice-input-normalization/scripts/install_voice_input_normalization.py" --apply
```

移除受控區塊或專用規則檔：

```bash
python3 "{{SYNC_ROOT}}/skills/voice-input-normalization/scripts/install_voice_input_normalization.py" --remove --apply
```

安全邊界：

- installer 只改使用者層級全域設定，不改專案設定。
- 修改既有檔案前會建立 timestamp backup。
- Codex / Claude / Gemini 使用 Markdown 受控區塊 upsert。
- OpenCode 使用獨立 instruction 檔與 `opencode.json` 的 `instructions` 陣列。
- 不修改模型、MCP、API key、登入憑證、cookies、tokens 或 provider 設定。
- 一般 ChatGPT 雲端聊天無法由本機檔案 installer 安裝，需使用者手動設定。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`voice-input-normalization`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- voice-input-normalization ----
mkdir -p "{{SYNC_ROOT}}/skills/voice-input-normalization"
# voice-input-normalization/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/voice-input-normalization/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/voice-input-normalization/SKILL.md" <<'AGENT_LAZYPACK_VOICE_INPUT_NORMALIZATION_SKILL_MD_0E95F5A366'
---
name: voice-input-normalization
description: Use when the user asks to install, update, remove, audit, or package speech-to-text / voice-input normalization rules across Codex, Claude Code, AntiGravity/Gemini, or OpenCode global settings.
metadata:
  short-description: Install speech-to-text correction rules
---

# Voice Input Normalization

Use this skill when the user wants AI agents to interpret speech-to-text mistakes safely, such as tool-name misrecognition, missing punctuation, homophones, or ambiguous file/path/command text.

## Safety Boundaries

- Only modify user-level global settings when the user explicitly asks for installation or removal.
- Never overwrite a full config file. Use controlled-block upsert or a dedicated rule file.
- Always create timestamped backups before changing existing files.
- Do not print full config files, tokens, cookies, OAuth credentials, API keys, or passwords.
- Do not change models, providers, MCP servers, connector permissions, login settings, or project-local files.
- If only one controlled-block marker is present, stop and report the malformed file.

## Standard Workflow

1. Read `references/normalization-rules.md`.
2. If the user asks to install or audit, run a dry-run first:

```bash
python3 "{{SYNC_ROOT}}/skills/voice-input-normalization/scripts/install_voice_input_normalization.py" --dry-run
```

3. Show the Codex, Claude, and AntiGravity targets plus any optional detected Agent surfaces.
4. Apply only after the user confirms:

```bash
python3 "{{SYNC_ROOT}}/skills/voice-input-normalization/scripts/install_voice_input_normalization.py" --apply
```

5. Verify marker counts and config syntax using the script output.
6. Tell the user which agents require restart or a fresh session.

## Supported Targets

- Codex: `{{CODEX_HOME}}/AGENTS.md`.
- Claude Code: `{{CLAUDE_HOME}}/rules/voice-input-normalization.md`.
- AntiGravity / Gemini: `{{GEMINI_HOME}}/GEMINI.md`.
- OpenCode: `{{HOME}}/.config/opencode/instructions/voice-input-normalization.md` and `{{HOME}}/.config/opencode/opencode.json` when OpenCode is detected.

The first three targets are always prepared, even when the matching app binary
is not installed yet, so a new machine remains future-ready.

## Uninstall

Use the same script with `--remove --apply`. It removes only the managed block or managed rule file and preserves unrelated settings.

```bash
python3 "{{SYNC_ROOT}}/skills/voice-input-normalization/scripts/install_voice_input_normalization.py" --remove --apply
```
AGENT_LAZYPACK_VOICE_INPUT_NORMALIZATION_SKILL_MD_0E95F5A366

# voice-input-normalization/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/voice-input-normalization/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/voice-input-normalization/agents/openai.yaml" <<'AGENT_LAZYPACK_VOICE_INPUT_NORMALIZATION_AGENTS_OPENAI_YAML_DEB9755D27'
interface:
  display_name: "Voice Input Normalization"
  short_description: "Install speech-to-text correction rules"
  default_prompt: "Use $voice-input-normalization to install voice input normalization rules."
AGENT_LAZYPACK_VOICE_INPUT_NORMALIZATION_AGENTS_OPENAI_YAML_DEB9755D27

# voice-input-normalization/references/normalization-rules.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/voice-input-normalization/references/normalization-rules.md")"
cat > "{{SYNC_ROOT}}/skills/voice-input-normalization/references/normalization-rules.md" <<'AGENT_LAZYPACK_VOICE_INPUT_NORMALIZATION_REFERENCES_NORMALIZATION_RULES_MD_CC249321DA'
# Voice Input Normalization Rules

This reference adapts `AGENT_SETUP_語音輸入文字正規化_跨Agent全域安裝.md` into shared Codex, Claude, and AntiGravity instructions.

## Managed Block

Installers must preserve the begin/end markers.

```markdown
<!-- BEGIN:SENSEBAR_VOICE_INPUT_NORMALIZATION_V1 -->
## 語音輸入文字正規化

使用者可能以語音輸入，文字中可能出現同音錯字、詞界切分錯誤、標點遺失、英文工具名稱音譯，以及路徑或指令辨識錯誤。

- 先依對話上下文理解使用者最合理的原意，不要逐字死讀。
- 明顯且不影響實際行動的小錯字，直接理解並繼續，不要逐項糾正或打斷使用者。
- 工具名稱可能被音譯或誤辨識。例如在 AI Agent 情境中，`Call Desk` 可能是 `Codex`、`Cloud Code` 可能是 `Claude Code`、`scheme` 可能是 `Skill`。這些只是語境提示，不得在所有情況下強制替換。
- 如果模糊內容會影響實際行動，例如人名、檔名、路徑、指令、工具名稱、數字、日期、金額或核心需求，而且無法從上下文可靠判斷，先用一句話確認理解，再執行。
- 不要默默把關鍵資訊改成猜測版本後直接執行。
- 不要捏造使用者沒有說過的數值、路徑、日期、名稱或授權。
- 回覆時使用自然、修正後的語意即可；除非使用者詢問，否則不必列出所有辨識錯字。
<!-- END:SENSEBAR_VOICE_INPUT_NORMALIZATION_V1 -->
```

## Upsert Rules

1. If the target Markdown file does not exist, create it with UTF-8.
2. If the target exists, create a timestamped sibling backup before modifying it.
3. If both markers exist exactly once, replace only the managed block.
4. If neither marker exists, append the block after one blank line.
5. If only one marker exists or marker counts are greater than one, stop and report the file as malformed.
6. Verify each marker appears exactly once after writing.

## Interpretation Rules

- Treat obvious low-risk speech-to-text mistakes as context, not as user errors to lecture about.
- Confirm before acting on ambiguous names, dates, commands, paths, file names, tool names, money, quantities, destructive operations, or authorization.
- Do not silently convert critical information into guessed values.
- Keep corrected responses natural; do not list every possible transcription mistake unless asked.

## Target Notes

- Codex may use `{{CODEX_HOME}}/AGENTS.md`; this can be a symlink to a portable global rules file.
- Claude Code should prefer a dedicated `{{HOME}}/.claude/rules/voice-input-normalization.md` rule file when supported.
- Gemini / AntiGravity can use `{{HOME}}/.gemini/GEMINI.md`.
- OpenCode uses a dedicated instruction file plus a JSON `instructions` entry.
AGENT_LAZYPACK_VOICE_INPUT_NORMALIZATION_REFERENCES_NORMALIZATION_RULES_MD_CC249321DA

# voice-input-normalization/scripts/install_voice_input_normalization.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/voice-input-normalization/scripts/install_voice_input_normalization.py")"
cat > "{{SYNC_ROOT}}/skills/voice-input-normalization/scripts/install_voice_input_normalization.py" <<'AGENT_LAZYPACK_VOICE_INPUT_NORMALIZATION_SCRIPTS_INSTALL_VOICE_INPUT_NORMALIZATION_PY_B97D5B4209'
#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import shutil
import subprocess
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path


BEGIN = "<!-- BEGIN:SENSEBAR_VOICE_INPUT_NORMALIZATION_V1 -->"
END = "<!-- END:SENSEBAR_VOICE_INPUT_NORMALIZATION_V1 -->"
BLOCK = """<!-- BEGIN:SENSEBAR_VOICE_INPUT_NORMALIZATION_V1 -->
## 語音輸入文字正規化

使用者可能以語音輸入，文字中可能出現同音錯字、詞界切分錯誤、標點遺失、英文工具名稱音譯，以及路徑或指令辨識錯誤。

- 先依對話上下文理解使用者最合理的原意，不要逐字死讀。
- 明顯且不影響實際行動的小錯字，直接理解並繼續，不要逐項糾正或打斷使用者。
- 工具名稱可能被音譯或誤辨識。例如在 AI Agent 情境中，`Call Desk` 可能是 `Codex`、`Cloud Code` 可能是 `Claude Code`、`scheme` 可能是 `Skill`。這些只是語境提示，不得在所有情況下強制替換。
- 如果模糊內容會影響實際行動，例如人名、檔名、路徑、指令、工具名稱、數字、日期、金額或核心需求，而且無法從上下文可靠判斷，先用一句話確認理解，再執行。
- 不要默默把關鍵資訊改成猜測版本後直接執行。
- 不要捏造使用者沒有說過的數值、路徑、日期、名稱或授權。
- 回覆時使用自然、修正後的語意即可；除非使用者詢問，否則不必列出所有辨識錯字。
<!-- END:SENSEBAR_VOICE_INPUT_NORMALIZATION_V1 -->
"""


@dataclass
class Result:
    agent: str
    status: str
    target: str
    backup: str
    verification: str
    restart: str


def command_exists(name: str) -> bool:
    return shutil.which(name) is not None


def backup_file(path: Path) -> str:
    if not path.exists():
        return "new file"
    stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    backup = path.with_name(f"{path.name}.bak-{stamp}")
    shutil.copy2(path, backup)
    return str(backup)


def upsert_markdown(path: Path, *, apply: bool, remove: bool) -> tuple[str, str]:
    old = path.read_text(encoding="utf-8") if path.exists() else ""
    begin_count = old.count(BEGIN)
    end_count = old.count(END)
    if begin_count != end_count or begin_count > 1:
        return "failed", f"malformed markers begin={begin_count} end={end_count}"

    if remove:
        if begin_count == 0:
            return "skipped", "managed block absent"
        start = old.index(BEGIN)
        end = old.index(END) + len(END)
        new = (old[:start] + old[end:]).rstrip() + "\n"
    elif begin_count == 1:
        start = old.index(BEGIN)
        end = old.index(END) + len(END)
        new = old[:start] + BLOCK.rstrip() + old[end:]
    else:
        sep = "\n\n" if old.strip() else ""
        new = old.rstrip() + sep + BLOCK

    if not apply:
        return "dry-run", "would update" if new != old else "already current"

    path.parent.mkdir(parents=True, exist_ok=True)
    backup = backup_file(path)
    path.write_text(new, encoding="utf-8")
    check = path.read_text(encoding="utf-8")
    ok = check.count(BEGIN) == (0 if remove else 1) and check.count(END) == (0 if remove else 1)
    return ("updated" if ok else "failed"), f"backup={backup}; marker check={'ok' if ok else 'failed'}"


def update_opencode_config(config: Path, instruction_rel: str, *, apply: bool, remove: bool) -> tuple[str, str]:
    if not config.exists():
        data = {}
        old = ""
    else:
        old = config.read_text(encoding="utf-8")
        try:
            data = json.loads(old or "{}")
        except json.JSONDecodeError as exc:
            return "failed", f"invalid JSON: {exc}"
    instructions = data.get("instructions", [])
    if not isinstance(instructions, list):
        return "failed", "top-level instructions is not an array"
    if remove:
        new_instructions = [x for x in instructions if x != instruction_rel]
    else:
        new_instructions = instructions if instruction_rel in instructions else instructions + [instruction_rel]
    data["instructions"] = new_instructions
    new = json.dumps(data, ensure_ascii=False, indent=2) + "\n"
    if not apply:
        return "dry-run", "would update opencode.json" if new != old else "already current"
    config.parent.mkdir(parents=True, exist_ok=True)
    backup = backup_file(config)
    config.write_text(new, encoding="utf-8")
    json.loads(config.read_text(encoding="utf-8"))
    count = data["instructions"].count(instruction_rel)
    expected = 0 if remove else 1
    return ("updated" if count == expected else "failed"), f"backup={backup}; instruction count={count}"


def detect_targets(home: Path) -> list[tuple[str, Path, str]]:
    targets: list[tuple[str, Path, str]] = [
        ("ChatGPT Codex", home / ".codex" / "AGENTS.md", "fresh Codex session required"),
        ("Claude Code", home / ".claude" / "rules" / "voice-input-normalization.md", "restart or fresh Claude session required"),
        ("AntiGravity/Gemini", home / ".gemini" / "GEMINI.md", "restart or fresh Gemini/AntiGravity session required"),
    ]
    if (home / ".config" / "opencode").exists() or command_exists("opencode"):
        targets.append(("OpenCode", home / ".config" / "opencode" / "instructions" / "voice-input-normalization.md", "restart or fresh OpenCode session required"))
    return targets


def main() -> int:
    parser = argparse.ArgumentParser(description="Install voice input normalization for Codex, Claude, and AntiGravity, plus optional detected agents.")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="Preview detected targets and intended changes.")
    mode.add_argument("--apply", action="store_true", help="Apply changes with backups.")
    parser.add_argument("--remove", action="store_true", help="Remove managed blocks/files instead of installing them.")
    parser.add_argument("--home", default=str(Path.home()), help="Override home directory for testing.")
    args = parser.parse_args()
    apply = bool(args.apply)

    home = Path(args.home).expanduser()
    results: list[Result] = []
    targets = detect_targets(home)
    if not targets:
        print("No AI agent targets available.")
        return 0

    for agent, target, restart in targets:
        if agent == "OpenCode":
            status, detail = upsert_markdown(target, apply=apply, remove=args.remove)
            config = home / ".config" / "opencode" / "opencode.json"
            cfg_status, cfg_detail = update_opencode_config(
                config,
                "./instructions/voice-input-normalization.md",
                apply=apply,
                remove=args.remove,
            )
            combined_status = "failed" if "failed" in (status, cfg_status) else ("dry-run" if not apply else "updated")
            results.append(Result(agent, combined_status, f"{target}; {config}", "-", f"{detail}; {cfg_detail}", restart))
        else:
            status, detail = upsert_markdown(target, apply=apply, remove=args.remove)
            results.append(Result(agent, status, str(target), "-", detail, restart))

    print("語音輸入文字正規化：跨 Agent 安裝結果")
    for item in results:
        print(f"\n[{item.status}] {item.agent}")
        print(f"- 設定檔：{item.target}")
        print(f"- 備份：{item.backup}")
        print(f"- 驗證：{item.verification}")
        print(f"- 重啟：{item.restart}")

    return 1 if any(r.status == "failed" for r in results) else 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VOICE_INPUT_NORMALIZATION_SCRIPTS_INSTALL_VOICE_INPUT_NORMALIZATION_PY_B97D5B4209
chmod +x "{{SYNC_ROOT}}/skills/voice-input-normalization/scripts/install_voice_input_normalization.py"

test -f "{{SYNC_ROOT}}/skills/voice-input-normalization/SKILL.md" && echo "voice-input-normalization installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->

## 安全邊界

- 不打包任何個人 API key、token、cookie、OAuth secret、session、Claude/OpenCode/Gemini 實際設定檔或 Codex local state。
- `voice-input-normalization` 的 script 預設可 dry-run；只有 `--apply` 才寫檔。
- 若目標設定檔由 chezmoi、dotfiles repo 或企業設定管理控制，先更新同步來源或模板，不要只改生成結果。
