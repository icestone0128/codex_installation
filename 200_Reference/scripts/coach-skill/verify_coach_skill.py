#!/usr/bin/env python3
"""Verify Arry's private Coach Skill group without exposing private content."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path


SKILLS = (
    "future-coach",
    "voice-coach",
    "waki-brain",
    "productivity-coach",
)
ALLOWED_AGENTS = {"codex", "claude", "antigravity"}

REQUIRED_FILES = {
    "future-coach": ("SKILL.md",),
    "voice-coach": (
        "SKILL.md",
        "references/course-catalog.json",
        "references/course-map.md",
        "references/issue-routing.json",
        "scripts/recommend_lessons.py",
    ),
    "waki-brain": (
        "SKILL.md",
        "references/package-catalog.json",
        "references/package-map.md",
        "references/trigger-keywords.md",
        "scripts/waki_brain.py",
    ),
    "productivity-coach": (
        "SKILL.md",
        "references/course-v3.1/00_ENGINE.md",
        "references/course-v3.1/units/00_INDEX.md",
        "references/notebooklm-workflow.md",
        "scripts/build_notebooklm_sources.py",
        "scripts/validate_productivity_coach.py",
    ),
}


class Verification:
    def __init__(self) -> None:
        self.checks: list[dict[str, str | bool]] = []

    def add(self, label: str, passed: bool, detail: str = "") -> None:
        self.checks.append(
            {"label": label, "passed": passed, "detail": detail}
        )

    @property
    def passed(self) -> bool:
        return all(bool(item["passed"]) for item in self.checks)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Verify the private Coach Skill group and native Agent entries."
    )
    parser.add_argument("--sync-root", required=True, type=Path)
    parser.add_argument(
        "--agents",
        default="codex,claude,antigravity",
        help="Comma-separated Agent entries to check.",
    )
    parser.add_argument(
        "--check-entrypoints",
        action="store_true",
        help="Also verify native Agent skill entrypoints.",
    )
    parser.add_argument(
        "--skip-runtime-checks",
        action="store_true",
        help="Skip package-specific script smoke tests.",
    )
    parser.add_argument("--json", action="store_true", dest="json_output")
    return parser.parse_args()


def frontmatter_name(path: Path) -> str | None:
    try:
        text = path.read_text(encoding="utf-8")
    except (OSError, UnicodeError):
        return None
    match = re.search(r"(?m)^name:\s*[\"']?([^\"'\n]+)", text)
    return match.group(1).strip() if match else None


def run_command(command: list[str], cwd: Path) -> tuple[bool, str]:
    completed = subprocess.run(
        command,
        cwd=cwd,
        capture_output=True,
        text=True,
        check=False,
        env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
    )
    output = "\n".join(
        part.strip() for part in (completed.stdout, completed.stderr) if part.strip()
    )
    summary = output.splitlines()[-1] if output else "no output"
    return completed.returncode == 0, summary


def verify_sources(sync_root: Path, result: Verification) -> None:
    skills_root = sync_root / "skills"
    result.add("shared skills root", skills_root.is_dir())
    result.add(
        "Arry Assistant memory layer",
        (sync_root / "memories" / "MEMORY.md").is_file(),
        "required by future-coach",
    )

    for skill in SKILLS:
        skill_root = skills_root / skill
        result.add(f"{skill} package", skill_root.is_dir())
        for relative in REQUIRED_FILES[skill]:
            result.add(
                f"{skill}:{relative}",
                (skill_root / relative).is_file(),
            )
        result.add(
            f"{skill} frontmatter",
            frontmatter_name(skill_root / "SKILL.md") == skill,
        )

    voice_notes = list(
        (skills_root / "voice-coach" / "references" / "course-notes").rglob("*.md")
    )
    result.add(
        "voice-coach course notes",
        len(voice_notes) >= 65,
        f"count={len(voice_notes)} expected>=65",
    )

    waki_root = skills_root / "waki-brain" / "references" / "project-packs"
    waki_packs = [path for path in waki_root.iterdir() if path.is_dir()] if waki_root.is_dir() else []
    result.add(
        "waki-brain project packs",
        len(waki_packs) == 13,
        f"count={len(waki_packs)} expected=13",
    )

    unit_root = (
        skills_root
        / "productivity-coach"
        / "references"
        / "course-v3.1"
        / "units"
    )
    unit_pattern = re.compile(r"^\d{2}-\d_.+\.md$")
    units = [
        path
        for path in unit_root.glob("*.md")
        if unit_pattern.match(path.name)
    ] if unit_root.is_dir() else []
    result.add(
        "productivity-coach numbered units",
        len(units) == 28,
        f"count={len(units)} expected=28",
    )


def verify_runtime(sync_root: Path, result: Verification) -> None:
    skills_root = sync_root / "skills"
    commands = (
        (
            "voice-coach smoke",
            [sys.executable, "scripts/recommend_lessons.py", "報告太快沒有重點", "--limit", "2"],
            skills_root / "voice-coach",
        ),
        (
            "waki-brain status",
            [sys.executable, "scripts/waki_brain.py", "status"],
            skills_root / "waki-brain",
        ),
        (
            "productivity-coach validator",
            [sys.executable, "scripts/validate_productivity_coach.py"],
            skills_root / "productivity-coach",
        ),
        (
            "productivity-coach source freshness",
            [sys.executable, "scripts/build_notebooklm_sources.py", "--check"],
            skills_root / "productivity-coach",
        ),
    )
    for label, command, cwd in commands:
        if not cwd.is_dir():
            result.add(label, False, "package missing")
            continue
        passed, detail = run_command(command, cwd)
        result.add(label, passed, detail)


def agent_entries() -> dict[str, Path]:
    home = Path.home()
    codex_home = Path(os.environ.get("CODEX_HOME", home / ".codex"))
    claude_home = Path(os.environ.get("CLAUDE_HOME", home / ".claude"))
    gemini_home = Path(os.environ.get("GEMINI_HOME", home / ".gemini"))
    return {
        "codex": codex_home / "skills",
        "claude": claude_home / "skills",
        "antigravity": gemini_home / "config" / "skills",
    }


def verify_entrypoints(
    sync_root: Path, requested_agents: list[str], result: Verification
) -> None:
    expected = (sync_root / "skills").resolve()
    entries = agent_entries()
    for agent in requested_agents:
        entry = entries.get(agent)
        if entry is None:
            result.add(f"{agent} entry", False, "unknown agent")
            continue
        result.add(
            f"{agent} skills entry",
            entry.exists() and entry.resolve() == expected,
        )
        for skill in SKILLS:
            result.add(
                f"{agent}:{skill}",
                (entry / skill / "SKILL.md").is_file(),
            )


def main() -> int:
    args = parse_args()
    sync_root = args.sync_root.expanduser().resolve()
    requested_agents = [
        item.strip().lower()
        for item in args.agents.split(",")
        if item.strip()
    ]
    unknown_agents = sorted(set(requested_agents) - ALLOWED_AGENTS)
    if unknown_agents:
        print(
            f"Unknown Agent selection: {','.join(unknown_agents)}",
            file=sys.stderr,
        )
        return 2

    result = Verification()
    verify_sources(sync_root, result)
    if not args.skip_runtime_checks:
        verify_runtime(sync_root, result)
    if args.check_entrypoints:
        verify_entrypoints(sync_root, requested_agents, result)

    if args.json_output:
        print(
            json.dumps(
                {"passed": result.passed, "checks": result.checks},
                ensure_ascii=False,
                indent=2,
            )
        )
    else:
        for item in result.checks:
            status = "PASS" if item["passed"] else "FAIL"
            detail = f" ({item['detail']})" if item["detail"] else ""
            print(f"{status} {item['label']}{detail}")
        print("Coach Skill verification: PASS" if result.passed else "Coach Skill verification: FAIL")

    return 0 if result.passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
