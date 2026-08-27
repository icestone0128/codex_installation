#!/usr/bin/env python3
"""驗證 LazyPack 內嵌的 skill 檔案是否與 codex_symlink 主版本逐字相同。

`sync-lazypack-embeds.py` 負責產生內嵌內容，但目前無法整批重跑（見該檔）。在它修好之前，
手動同步某個 Item 的內嵌區塊之後，用這支確認沒有漏檔或內容漂移。

delimiter 演算法與 `sync-lazypack-embeds.py` 的 `delimiter()` 相同，所以驗證通過就代表
未來 generator 修好後重跑會產生一致的結果。

用法：
    python3 verify-lazypack-embeds.py --skill cross-device-sync \\
        --item 200_Reference/lazy-pack/16-Codex-全域-Skills-跨裝置同步.md
"""

from __future__ import annotations

import argparse
import hashlib
import os
import re
import sys
from pathlib import Path

SKIP_FILES = {".DS_Store", ".gitkeep"}
SKIP_DIRS = {"__pycache__", ".git", "node_modules", ".venv"}

REPO = Path(__file__).resolve().parents[2]
DEFAULT_SKILLS = REPO.parent.parent / "codex_symlink" / "skills"


def delimiter(skill: str, relative_path: str) -> str:
    stem = re.sub(r"[^A-Z0-9]+", "_", f"{skill}_{relative_path}".upper()).strip("_")
    digest = hashlib.sha256(relative_path.encode()).hexdigest()[:10].upper()
    return f"AGENT_LAZYPACK_{stem}_{digest}"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--skill", required=True, help="Skill 名稱，例如 cross-device-sync。")
    parser.add_argument("--item", required=True,
                        help="LazyPack Item 路徑，可相對於 repo 根目錄。")
    parser.add_argument("--skills-root", default=str(DEFAULT_SKILLS),
                        help="主版本 skills 目錄。預設 codex_symlink/skills。")
    args = parser.parse_args()

    source = Path(args.skills_root).expanduser() / args.skill
    if not (source / "SKILL.md").is_file():
        print(f"ERROR 找不到 skill 主版本：{source}", file=sys.stderr)
        return 1
    item = Path(args.item).expanduser()
    if not item.is_absolute():
        item = REPO / item
    if not item.is_file():
        print(f"ERROR 找不到 LazyPack Item：{item}", file=sys.stderr)
        return 1

    text = item.read_text(encoding="utf-8")
    identical = differs = missing = 0

    for current, directories, filenames in os.walk(source):
        directories[:] = sorted(d for d in directories if d not in SKIP_DIRS)
        for filename in sorted(filenames):
            if filename in SKIP_FILES:
                continue
            path = Path(current) / filename
            relative = path.relative_to(source).as_posix()
            marker = delimiter(args.skill, relative)
            head = f"cat > \"{{{{SYNC_ROOT}}}}/skills/{args.skill}/{relative}\" <<'{marker}'\n"
            start = text.find(head)
            if start < 0:
                print(f"  MISSING  {relative}")
                missing += 1
                continue
            body_start = start + len(head)
            body_end = text.find(f"\n{marker}\n", body_start)
            try:
                expected = path.read_text(encoding="utf-8").rstrip("\n")
            except UnicodeDecodeError:
                continue  # 二進位檔以 base64 內嵌，不在本檢查範圍
            if text[body_start:body_end] == expected:
                identical += 1
            else:
                print(f"  DIFFERS  {relative}")
                differs += 1

    print(f"IDENTICAL={identical}  DIFFERS={differs}  MISSING={missing}")
    return 0 if differs == 0 and missing == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
