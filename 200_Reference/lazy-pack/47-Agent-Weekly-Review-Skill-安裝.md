# 47-Agent Weekly Review Skill 安裝

> 2026-09-18 建立。來源是外部教材的「每週復盤」流程，改寫為 Codex／Claude／AntiGravity 三 Agent 共用版本：
> 資料來源改為多 repo 的 git 紀錄、`HANDOFF.md`、踩坑筆記與 skills 預算，分區改用全域規則既有的 A～D 級，
> 並與筆記庫的每週整理流程串成同一份待拍板清單。

## 這個 Item 解決什麼

用 AI 工作一段時間後，這三個問題沒人回答得出來：

- 這週它重複犯了什麼錯？
- 哪條規則你已經重講第五次了？
- 哪個流程你每次都要從頭教一遍？

答案不在記憶裡，散在這週的 commit、`HANDOFF.md`、踩坑筆記與駕駛艙裡，**需要有人去數**。

本 Item 安裝 `agent-weekly-review`：AI 把這週的紀錄撈出來數清楚、分好類，最後只丟**最多三件**需要你拍板的事；
能自己處理的自己做完並列出來。分工只有一條：**AI 負責數，使用者負責判斷**。

## 這個 Item 不解決什麼

| 需求 | 用哪個 |
| :-- | :-- |
| 整理筆記庫、剪藏與知識索引 | 你自己的筆記庫每週整理流程（見〈與筆記庫整理的整合〉） |
| 單一專案的進度與下一步 | 該專案的 `HANDOFF.md` 與專案駕駛艙 |
| 把某個重複流程做成 skill | Item 11 `codex-skill-creator`（本 skill 只負責提出候選） |
| 這週幾乎沒用 Agent 工作 | 不要跑；沒有資料的復盤只會產出漂亮的廢話 |

## 前置條件

- 已完成 README 設定表，知道 `{{SYNC_ROOT}}` 位置。
- 本機有 Python 3 與 PyYAML（skills 預算統計需要）。
- 用 Agent 實際工作過至少一週，且專案是 Git repo。
- 選配：Obsidian vault。用來看駕駛艙更新與存放週報；沒有 vault 時週報留在對話或自訂路徑。

## 安裝方式

複製文末「內建 Skill 完整安裝內容」的整段腳本執行。安裝前先依 README 設定 `{{SYNC_ROOT}}`；
package 只寫入共用主版本，Item 16 與 chezmoi 負責建立三個 Agent 的原生入口。

## 安裝後的第一次試跑

先只收集訊號，不產週報、不寫檔：

```bash
python3 "{{SYNC_ROOT}}/skills/agent-weekly-review/scripts/collect_weekly_signals.py" \
  --projects-root "<你放專案的資料夾>" \
  --sync-root "{{SYNC_ROOT}}" \
  --vault "<你的 Obsidian vault，可省略>"
```

輸出會包含：

- `METRICS` 一行五個數字：活躍 repo、commit 數、有紀錄天數、skill 數與 description 超標數、新增踩坑筆記數。
- 各 repo 的 commit 主旨、`HANDOFF.md` 日期、是否有未提交變更。
- 踩坑筆記中「第 N 次」之類的重複標記——只記症狀沒修來源的訊號。
- 這段期間被動到的專案駕駛艙。

數字對得上之後，再對 Agent 說「跑週報」走完整流程。

## 落點與寫檔規則

- 週報預設寫到 Obsidian `專案庫/<你的設定專案>/週報/YYYY-Www.md`，趨勢 `_trend.csv` 放同一層。
- **預設只在對話輸出，使用者明確同意才寫檔**；不覆蓋同名檔，同一週重跑改為追加「重跑紀錄」。
- 使用者同意保存週報，**不等於**同意執行裡面的修改建議；每個提案分開問。

## 與筆記庫整理的整合

筆記庫整理處理的是筆記，本 skill 盤點的是人與 AI 的協作，資料來源不重疊。固定順序是**先筆記庫、後協作**：

1. 跑完筆記庫的每週整理。
2. 接著跑 `agent-weekly-review`，把前者列出的待確認項目一併納入本週報的「需要你拍板」。
3. 兩份都完成後，在週報標明筆記庫整理已同步完成。

使用者只跑其中一個時不要自動補跑另一個，問一句就好。若你的全域規則有週日提醒，把兩件事寫在同一則提醒裡。

## 驗證

- 五個數字都有，且能用同一條指令重現。
- 資料缺口誠實寫出（例如「這週有 3 天沒有紀錄」），沒有用推測補滿。
- 待拍板 ≤3 件，每件都有證據與「為什麼需要你決定」。
- 使用者未同意前沒有任何檔案被寫入或覆蓋。
- 新對話輸入 `$agent-weekly-review` 或「跑週報」能正確觸發。

## 踩坑修正

- **不要拿腳本數字當結論**：它只數得到 commit 與檔案，數不到「使用者這週重複糾正了什麼」。那部分讀對話與筆記，讀不到就寫沒有資料。
- **日期窗是包含今天在內的 N 個日曆天**，`--days 7` 是 7 天不是 8 天；回報有紀錄天數時分母要一致。
- **掃描範圍要先講出來再跑**，不要把家目錄或整台電腦當候選範圍。
- **寫入既有 Obsidian 檔案前先備份**，這在全域規則屬於要先備份的等級。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`agent-weekly-review`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- agent-weekly-review ----
mkdir -p "{{SYNC_ROOT}}/skills/agent-weekly-review"
# agent-weekly-review/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-weekly-review/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/agent-weekly-review/SKILL.md" <<'AGENT_LAZYPACK_AGENT_WEEKLY_REVIEW_SKILL_MD_0E95F5A366'
---
name: agent-weekly-review
description: "觸發：跑週報、每週復盤、這週做了什麼、盤點 AI 協作。數數字、分區，最多 3 件待拍板。"
metadata:
  short-description: Weekly agent collaboration review
  version: 0.1.0
  last-updated: 2026-09-18
---

# Agent Weekly Review

每週盤點「人和 AI 這一週怎麼協作」，把摩擦變成規則、skill 或待辦。分工只有一條：

> **AI 負責數**——幾個 commit、幾天有紀錄、同一個坑犯幾次、哪個 description 超標。
> **使用者負責判斷**——這值不值得做、是不是真的偏好、下週要不要改。

判斷某件事該誰做，用 `core-rules.md`〈不可逆操作邊界〉的既有分級，不要另造一套：

- **D 級**（唯讀查詢、產出草稿、寫本次暫存檔）→ 直接做，在週報列一行。
- **C 級**（改既有規則條目、合併去重、對外發布）→ 只能提案，附 diff 摘要等使用者點頭。
- **B 級**（覆寫規則檔、記憶檔、skill 套件、Obsidian 既有筆記）→ 先備份再動，且要使用者同意。
- **A 級** → 不執行，寫進待拍板由使用者自己來。

## 何時使用

- 使用者說「跑週報」「每週復盤」「這週做了什麼」「盤點一下 AI 協作」。
- 跑完 Obsidian 每週知識重整之後（見〈與每週知識重整的整合〉）。
- 連續三次糾正 AI 同一件事，想知道該補規則還是補 skill。

## 何時不要使用

- 這一週幾乎沒用 Agent 工作：沒有資料的復盤只會產出漂亮的廢話，直接說「資料不足，跳過這週」。
- 使用者要的是單一專案進度 → 讀該專案 `HANDOFF.md` 與駕駛艙就好。
- 使用者要的是筆記庫整理 → 那是 vault 的每週知識重整，不是本 skill。

## 必要輸入

- 專案根目錄（預設 `{{DRIVE}}/agentic_projects`）與共用資料層 `{{SYNC_ROOT}}`。
- 可選：Obsidian vault，用來看駕駛艙更新與寫週報。
- 日期窗預設最近 7 天，使用者可指定。

## 工作流程

1. **先確認範圍**：把要掃描的專案根目錄、`{{SYNC_ROOT}}` 與日期窗講出來給使用者確認。不要掃整台電腦或家目錄。
2. **收集訊號**（唯讀，不寫檔）：

   ```bash
   python3 "{{SYNC_ROOT}}/skills/agent-weekly-review/scripts/collect_weekly_signals.py" \
     --projects-root "{{DRIVE}}/agentic_projects" \
     --sync-root "{{SYNC_ROOT}}" \
     --vault "{{OBSIDIAN_VAULT}}" \
     --trend "{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/週報/_trend.csv"
   ```

   它輸出五個數字（活躍 repo、commit 數、有紀錄天數、skill 數與超標 description 數、新增踩坑筆記數）、各 repo 的 commit 主旨與 `HANDOFF.md` 日期、重複踩坑標記、被動到的駕駛艙，以及上週那一列趨勢。
3. **補人看得到、腳本看不到的部分**：使用者這週重複糾正了什麼、哪個流程每次都要重講。這些只能從對話與筆記讀，讀不到就寫「沒有資料」。
4. **誠實回報缺口**：先數「7 天裡有幾天真的留下紀錄」，缺的日子直接寫出來。**絕對不要用推測補滿沒有紀錄的日子。**
5. **找出該沉澱的東西**，每條都要附證據（哪一天、哪個檔案、哪個 commit）：
   - 同一類問題出現 2 次以上 → 缺規則還是缺 skill？規則進 `core-rules.md`（C 級，提案）；流程進 skill（由 `codex-skill-creator` 建立）。
   - 同一種任務做 3 次以上且跨 2 天以上 → skill 候選，但先過 `codex-skill-creator` 的勸退檢查。
   - 踩坑筆記出現「第 N 次」標記 → 代表只記症狀沒修來源，列為待拍板。
6. **檢查資料層健康度**：`MEMORY.md` 是否仍只有協作偏好與指標、`knowledge/` 是否有檔案沒被索引、skill description 是否有超過 90 字元者、開工 checkpoint 的 `MCP_PARITY`／`CODEX_DUP`／`OVERRIDE` 是否都是 none。
7. **先在對話輸出週報**，不要直接寫檔。格式如下。
8. **使用者同意後才寫檔**（見〈輸出格式〉的落點）。同意保存週報**不等於**同意執行裡面的修改建議；每個提案要分開問。

## 輸出格式

```markdown
# 第 <ISO 週數> 週 AI 協作週報（YYYY-MM-DD ~ YYYY-MM-DD）

## 一眼看完
[三句話：現在狀態、最值得注意的一件事、下一步]

## 這週一起做了什麼
- 資料來源：[實際用到哪些；缺口寫出來]
- [3–6 條，每條附證據]

## 需要你拍板（最多 3 件）
1. **[標題]** — 我看到：[證據] ／ 我建議：[具體動作] ／ 為什麼需要你：[一句話]

## 我已經自己處理掉的
- [一行一件，附影響範圍]

## 數字
| 指標 | 本週 | 上週 | 趨勢 |

## 下週只做三件事
1. 2. 3.

## 不建議現在做的事
- [防過度優化、防過早自動化]
```

落點（使用者同意後）：

- 週報：`{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/週報/YYYY-Www.md`，不覆蓋同名檔；同一週重跑就在原檔追加「重跑紀錄」段落。
- 趨勢：同層 `_trend.csv`，append 一列，表頭 `week,active_repos,commits,active_days,skills,desc_over_budget,new_pitfall_notes`。
- 資料夾不存在先問要不要建立。

報告紀律：

- **最多三件待拍板**，超過就自己排序砍掉後面的。給十件事等於一件都不會做。
- **每個結論都要附證據**，沒有證據就寫「我沒有足夠資料判斷」。
- **不要恭維**，健康的地方寫真的健康的，沒有就寫沒有。

## 與每週知識重整的整合

`obsidian-weekly-knowledge-refresh-secondbrain` 整理的是筆記庫，本 skill 盤點的是人與 AI 的協作，兩者資料來源不同、不重疊。固定順序是**先 vault 後協作**：

1. 跑完 vault 每週知識重整，取得本週筆記與 `知識庫/log.md` 的更新結果。
2. 接著跑本 skill；vault 那一輪列出的待確認項目，一併納入本週報的「需要你拍板」，不要讓使用者在兩份報告之間自己對照。
3. 兩份都完成後，在 Obsidian 週報標明「vault 重整已同步完成」。

使用者只跑其中一個時不要自動補跑另一個，問一句就好。

## 停止條件（必須問人）

- 日期窗內幾乎沒有資料 → 停下來說明，不要硬產週報。
- 任何 C 級以上的修改：改規則條目、改 skill description、刪除不是本次建立的檔案、決定某個流程要做成 skill、決定下週三件事。
- 寫入 Obsidian 既有檔案前（B 級）：先備份並取得同意。
- 週報要對外分享或寄送。

## 驗收標準

- 五個數字都有，且能用同一條指令重現。
- 資料缺口誠實寫出，沒有用推測補滿。
- 待拍板 ≤3 件，每件都有證據與「為什麼需要你」。
- 已自行處理的項目全部是 D 級。
- 使用者未同意前，沒有任何檔案被寫入或覆蓋。

## 三 Agent 執行

- **共用步驟**：上述腳本與流程完全相同，輸出契約一致。
- **Codex adapter**：`$agent-weekly-review`；沙盒需可讀專案根目錄與 `{{SYNC_ROOT}}`，寫入 Obsidian 前確認 `writable_roots` 含 vault。
- **Claude adapter**：自然語言觸發或 `$agent-weekly-review`；用 Bash 執行腳本。
- **AntiGravity adapter**：同上；若終端機 sandbox 限制讀取專案根目錄，改用該 Agent 授權的檔案存取路徑執行同一支腳本。
- **Fallback**：沒有 Python 或掃描被擋時，改用 `git log --since` 逐 repo 手動收集，並在週報註明是手動來源。
- **驗證**：腳本輸出的 `METRICS` 行與週報數字一致；寫檔後重讀確認內容與路徑。
AGENT_LAZYPACK_AGENT_WEEKLY_REVIEW_SKILL_MD_0E95F5A366

# agent-weekly-review/scripts/collect_weekly_signals.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-weekly-review/scripts/collect_weekly_signals.py")"
cat > "{{SYNC_ROOT}}/skills/agent-weekly-review/scripts/collect_weekly_signals.py" <<'AGENT_LAZYPACK_AGENT_WEEKLY_REVIEW_SCRIPTS_COLLECT_WEEKLY_SIGNALS_PY_4A3A8D8C2F'
#!/usr/bin/env python3
"""Collect read-only signals for a weekly agent-collaboration review.

Counts what can be counted so the review spends its judgement on what cannot: repository
activity, handoff freshness, cockpit updates, new pitfall notes, repeated pitfalls, and the
skills description budget. It never writes, moves or deletes anything.

Usage:
  collect_weekly_signals.py --projects-root DIR --sync-root DIR [--vault DIR]
                            [--days 7] [--trend CSV] [--json]

--trend prints the previous row of an existing trend CSV for comparison; it does not append.
"""
from __future__ import annotations
import argparse, csv, datetime as dt, json, os, re, subprocess, sys
from pathlib import Path

WINDOW_FMT = "%Y-%m-%d"


def git(repo: Path, *args: str) -> str:
    try:
        out = subprocess.run(["git", "-C", str(repo), *args], capture_output=True, text=True, timeout=60)
    except (OSError, subprocess.SubprocessError):
        return ""
    return out.stdout if out.returncode == 0 else ""


def repo_activity(projects_root: Path, since: str) -> tuple[list[dict], set[str]]:
    rows, active_days = [], set()
    for repo in sorted(p for p in projects_root.iterdir() if (p / ".git").exists()):
        log = git(repo, "log", f"--since={since}", "--date=short", "--pretty=format:%ad\t%s")
        commits = [l for l in log.splitlines() if l.strip()]
        days = {l.split("\t", 1)[0] for l in commits}
        active_days |= days
        handoff = repo / "HANDOFF.md"
        rows.append({
            "repo": repo.name,
            "commits": len(commits),
            "days": sorted(days),
            "handoff_mtime": dt.date.fromtimestamp(handoff.stat().st_mtime).isoformat() if handoff.is_file() else None,
            "dirty": bool(git(repo, "status", "--porcelain").strip()),
            "subjects": [l.split("\t", 1)[1] for l in commits[:5] if "\t" in l],
        })
    return rows, active_days


def skills_budget(sync_root: Path, budget: int = 90) -> dict:
    import yaml
    skills_dir = sync_root / "skills"
    lengths, invalid = [], []
    for entry in sorted(skills_dir.iterdir()) if skills_dir.is_dir() else []:
        skill_file = entry / "SKILL.md"
        if not skill_file.is_file():
            continue
        head = re.match(r"^---\n(.*?)\n---\n", skill_file.read_text(encoding="utf-8"), re.S)
        if not head:
            invalid.append(entry.name)
            continue
        try:
            data = yaml.safe_load(head.group(1))
            lengths.append((len(" ".join(str(data["description"]).split())), entry.name))
        except Exception:
            invalid.append(entry.name)
    over = sorted((l for l in lengths if l[0] > budget), reverse=True)
    return {"count": len(lengths), "total_chars": sum(l for l, _ in lengths),
            "over_budget": [{"skill": n, "chars": l} for l, n in over], "invalid": invalid}


def pitfall_notes(sync_root: Path, since_date: dt.date) -> dict:
    notes_dir = sync_root / "memories" / "extensions" / "ad_hoc" / "notes"
    new_notes, repeated = [], []
    for note in sorted(notes_dir.glob("*.md")) if notes_dir.is_dir() else []:
        if note.name == "INDEX.md":
            continue
        if dt.date.fromtimestamp(note.stat().st_mtime) >= since_date:
            new_notes.append(note.name)
        text = note.read_text(encoding="utf-8", errors="ignore")
        hits = re.findall(r"第\s*([二三四五六七八九十\d]+)\s*次|again|再次", text)
        if hits:
            repeated.append({"note": note.name, "markers": len(hits)})
    return {"new_notes": new_notes, "repeated_pitfalls": repeated}


def cockpit_updates(vault: Path | None, since_date: dt.date) -> list[str]:
    if not vault or not vault.is_dir():
        return []
    projects = vault / "專案庫"
    return sorted(
        f"{p.parent.name}/{p.name}"
        for p in projects.rglob("*.md")
        if p.is_file() and dt.date.fromtimestamp(p.stat().st_mtime) >= since_date
    ) if projects.is_dir() else []


def previous_trend(path: Path | None) -> dict | None:
    if not path or not path.is_file():
        return None
    rows = list(csv.DictReader(path.open(encoding="utf-8")))
    return rows[-1] if rows else None


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--projects-root", required=True)
    ap.add_argument("--sync-root", required=True)
    ap.add_argument("--vault")
    ap.add_argument("--days", type=int, default=7, help="calendar days in the window, including today")
    ap.add_argument("--trend")
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()

    today = dt.date.today()
    # The window is N calendar days including today, so N=7 means Mon..Sun, not 8 dates.
    since_date = today - dt.timedelta(days=args.days - 1)
    since = since_date.strftime(WINDOW_FMT)
    projects_root, sync_root = Path(args.projects_root).expanduser(), Path(args.sync_root).expanduser()
    if not projects_root.is_dir() or not sync_root.is_dir():
        sys.exit("ERROR --projects-root and --sync-root must be existing directories")

    repos, active_days = repo_activity(projects_root, since)
    result = {
        "window": {"since": since, "until": today.isoformat(), "days": args.days},
        "repos": [r for r in repos if r["commits"] or r["dirty"]],
        "repos_scanned": len(repos),
        "active_days": sorted(active_days),
        "skills": skills_budget(sync_root),
        "pitfalls": pitfall_notes(sync_root, since_date),
        "cockpits_touched": cockpit_updates(Path(args.vault).expanduser() if args.vault else None, since_date),
        "previous_trend": previous_trend(Path(args.trend).expanduser() if args.trend else None),
    }
    metrics = {
        "week": today.strftime("%G-W%V"),
        "active_repos": len([r for r in repos if r["commits"]]),
        "commits": sum(r["commits"] for r in repos),
        "active_days": f"{len(active_days)}/{args.days}",
        "skills": result["skills"]["count"],
        "desc_over_budget": len(result["skills"]["over_budget"]),
        "new_pitfall_notes": len(result["pitfalls"]["new_notes"]),
    }
    result["metrics"] = metrics

    if args.json:
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 0
    print(f"WINDOW {since} .. {today} ({args.days} days)")
    print("METRICS " + "  ".join(f"{k}={v}" for k, v in metrics.items()))
    print(f"ACTIVE DAYS {', '.join(result['active_days']) or 'none'}  (資料缺口要在週報誠實寫出)")
    for r in result["repos"]:
        flag = " [未提交變更]" if r["dirty"] else ""
        print(f"  {r['repo']}: commits={r['commits']} days={len(r['days'])} handoff={r['handoff_mtime']}{flag}")
        for s in r["subjects"]:
            print(f"      - {s}")
    sk = result["skills"]
    print(f"SKILLS count={sk['count']} total_chars={sk['total_chars']} over90={len(sk['over_budget'])} invalid={len(sk['invalid'])}")
    for item in sk["over_budget"][:5]:
        print(f"      - {item['skill']} ({item['chars']})")
    pf = result["pitfalls"]
    print(f"PITFALLS new={len(pf['new_notes'])} repeated_markers={len(pf['repeated_pitfalls'])}")
    for n in pf["new_notes"][:5]:
        print(f"      - {n}")
    for r in sorted(pf["repeated_pitfalls"], key=lambda x: -x["markers"])[:5]:
        print(f"      ! 重複踩坑 {r['note']} (markers={r['markers']})")
    print(f"COCKPITS touched={len(result['cockpits_touched'])}")
    if result["previous_trend"]:
        print("PREVIOUS " + "  ".join(f"{k}={v}" for k, v in result["previous_trend"].items()))
    return 0


if __name__ == "__main__":
    sys.exit(main())
AGENT_LAZYPACK_AGENT_WEEKLY_REVIEW_SCRIPTS_COLLECT_WEEKLY_SIGNALS_PY_4A3A8D8C2F
chmod +x "{{SYNC_ROOT}}/skills/agent-weekly-review/scripts/collect_weekly_signals.py"

test -f "{{SYNC_ROOT}}/skills/agent-weekly-review/SKILL.md" && echo "agent-weekly-review installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
