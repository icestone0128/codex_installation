#!/usr/bin/env python3
"""Regenerate LazyPack's self-contained skill install blocks from source packages."""

from __future__ import annotations

import argparse
import base64
import difflib
import hashlib
import os
from pathlib import Path
import re
import sys
import textwrap


REPO = Path(__file__).resolve().parents[2]
# REPO is <drive>/agentic_projects/codex_installation. The shared sync root that
# holds the skill master copies is codex_symlink/ at the drive level, i.e. two
# levels up from the repo, not one.
DEFAULT_SYNC_ROOT = REPO.parents[1] / "codex_symlink"
LAZYPACK = REPO / "200_Reference" / "lazy-pack"
EXCLUDED_SOURCE_DIRS = {".git", "__pycache__", "node_modules"}
EXCLUDED_SOURCE_FILES = {".DS_Store", ".gitkeep"}

# Resolved by resolve_skills_root() before any rendering happens.
SYNC_SKILLS: Path = DEFAULT_SYNC_ROOT / "skills"


class MissingSkill(Exception):
    """Raised when a skill listed in SECTIONS has no package under SYNC_SKILLS."""

    def __init__(self, skill: str, source: Path) -> None:
        super().__init__(f"Missing skill package: {source}")
        self.skill = skill
        self.source = source


def resolve_skills_root(sync_root: str | None, skills_root: str | None) -> Path:
    """Pick the skills master directory from CLI flags, environment, or default."""
    if skills_root:
        return Path(skills_root).expanduser().resolve()
    if sync_root:
        return (Path(sync_root).expanduser() / "skills").resolve()
    env_skills = os.environ.get("SYNC_SKILLS_ROOT")
    if env_skills:
        return Path(env_skills).expanduser().resolve()
    env_sync = os.environ.get("SYNC_ROOT")
    if env_sync:
        return (Path(env_sync).expanduser() / "skills").resolve()
    return (DEFAULT_SYNC_ROOT / "skills").resolve()


def delimiter(skill: str, relative_path: Path) -> str:
    stem = re.sub(r"[^A-Z0-9]+", "_", f"{skill}_{relative_path}".upper()).strip("_")
    digest = hashlib.sha256(str(relative_path).encode()).hexdigest()[:10].upper()
    return f"AGENT_LAZYPACK_{stem}_{digest}"


def source_files(source: Path):
    """Yield package files without traversing rebuildable dependency trees."""
    for current, directories, filenames in os.walk(source):
        directories[:] = sorted(
            directory for directory in directories if directory not in EXCLUDED_SOURCE_DIRS
        )
        current_path = Path(current)
        for filename in sorted(filenames):
            if filename in EXCLUDED_SOURCE_FILES:
                continue
            yield current_path / filename


def render_skill(skill: str) -> str:
    source = SYNC_SKILLS / skill
    if not (source / "SKILL.md").is_file():
        raise MissingSkill(skill, source)

    lines = [f"# ---- {skill} ----", f'mkdir -p "{{{{SYNC_ROOT}}}}/skills/{skill}"']
    for path in source_files(source):
        relative = path.relative_to(source)
        raw = path.read_bytes()
        try:
            content = raw.decode("utf-8")
        except UnicodeDecodeError:
            content = None
        else:
            # Heredocs emit whatever bytes we hand them, so a CRLF source file
            # would install with CRLF and show up as a diff in the LazyPack repo.
            # Vendored files (e.g. playwright/LICENSE.txt) are the only CRLF
            # sources, and their line endings carry no meaning. Binary payloads
            # take the base64 branch below and stay byte-exact.
            content = content.replace("\r\n", "\n").replace("\r", "\n")
        marker = delimiter(skill, relative)
        if content is not None and marker in content:
            raise ValueError(f"Generated delimiter occurs in {path}")
        target = f"{{{{SYNC_ROOT}}}}/skills/{skill}/{relative.as_posix()}"
        lines.extend([f"# {skill}/{relative.as_posix()}", f'mkdir -p "$(dirname "{target}")"'])
        if content is not None:
            lines.extend(
                [
                    f'cat > "{target}" <<\'{marker}\'',
                    content.rstrip("\n"),
                    marker,
                ]
            )
        else:
            encoded = "\n".join(textwrap.wrap(base64.b64encode(raw).decode("ascii"), 76))
            lines.extend(
                [
                    f'python3 - "{target}" <<\'{marker}\'',
                    "import base64",
                    "from pathlib import Path",
                    "import sys",
                    f'payload = """{encoded}"""',
                    "Path(sys.argv[1]).write_bytes(base64.b64decode(payload))",
                    marker,
                ]
            )
        if path.stat().st_mode & 0o111:
            lines.append(f'chmod +x "{target}"')
        lines.append("")
    lines.append(f'test -f "{{{{SYNC_ROOT}}}}/skills/{skill}/SKILL.md" && echo "{skill} installed for Codex, Claude, and AntiGravity"')
    return "\n".join(lines)


def build_embedded_section(path: Path, skills: list[str]) -> str:
    text = path.read_text(encoding="utf-8")
    start = "<!-- BEGIN EMBEDDED_SKILLS -->"
    end = "<!-- END EMBEDDED_SKILLS -->"
    if start not in text or end not in text:
        raise ValueError(f"Embedded markers missing in {path}")
    install_list = "、".join(f"`{skill}`" for skill in skills)
    body = "\n\n".join(render_skill(skill) for skill in skills)
    section = f"""{start}

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：{install_list}。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{{{SYNC_ROOT}}}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

{body}
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

{end}"""
    before, remainder = text.split(start, 1)
    _, after = remainder.split(end, 1)
    return before + section + after


def build_one_skill_block(path: Path, skill: str) -> str:
    text = path.read_text(encoding="utf-8")
    pattern = re.compile(
        rf"# ---- {re.escape(skill)} ----\n.*?test -f \"\{{\{{(?:CODEX_HOME|SYNC_ROOT)\}}\}}/skills/{re.escape(skill)}/SKILL\.md\" && echo \"{re.escape(skill)} installed(?: for Codex, Claude, and AntiGravity)?\"",
        re.DOTALL,
    )
    replacement = render_skill(skill)
    updated, count = pattern.subn(lambda _: replacement, text, count=1)
    if count != 1:
        raise ValueError(f"Expected one {skill} block in {path}, found {count}")
    return updated


# ---------------------------------------------------------------------------
# Script embedding for Antigravity LazyPack
# ---------------------------------------------------------------------------

ANTIGRAVITY_REPO = Path(
    os.environ.get("ANTIGRAVITY_REPO", REPO.parent / "antigravity_installation")
).expanduser()
ANTIGRAVITY_LAZYPACK = ANTIGRAVITY_REPO / "200_Reference" / "lazy-pack"

LANG_MAP = {
    ".py": "python",
    ".sh": "bash",
    ".js": "javascript",
    ".ts": "typescript",
}


# ---------------------------------------------------------------------------
# Output handling
# ---------------------------------------------------------------------------


class Reporter:
    """Writes files, or in dry-run mode only reports what would change."""

    def __init__(self, dry_run: bool, show_diff: bool) -> None:
        self.dry_run = dry_run
        self.show_diff = show_diff
        self.identical: list[str] = []
        self.changed: list[str] = []
        self.skipped: list[str] = []

    def emit(self, path: Path, new_text: str, label: str) -> None:
        current = path.read_text(encoding="utf-8") if path.is_file() else ""
        if current == new_text:
            self.identical.append(label)
            print(f"IDENTICAL  {label}")
            return
        self.changed.append(label)
        verb = "WOULD WRITE" if self.dry_run else "WROTE"
        print(f"{verb} {label}")
        if self.show_diff:
            diff = difflib.unified_diff(
                current.splitlines(keepends=True),
                new_text.splitlines(keepends=True),
                fromfile=f"a/{path.name}",
                tofile=f"b/{path.name}",
            )
            sys.stdout.writelines(diff)
        if not self.dry_run:
            path.write_text(new_text, encoding="utf-8")

    def skip(self, label: str, reason: str) -> None:
        self.skipped.append(f"{label}: {reason}")
        print(f"SKIPPED    {label} ({reason})")

    def summary(self) -> int:
        print()
        print(
            f"summary: {len(self.identical)} identical, "
            f"{len(self.changed)} {'to change' if self.dry_run else 'changed'}, "
            f"{len(self.skipped)} skipped"
        )
        for entry in self.skipped:
            print(f"  skipped -> {entry}")
        return 1 if self.skipped else 0


SECTIONS = {
    "01-Codex-必裝-Skills-與-Plugins.md": ["pdf", "playwright"],
    "02-Codex-MCP-Essentials.md": ["heptabase-cli"],
    "05-第二大腦設定指南.md": ["secondbrain-research-digest"],
    "07-連接-NotebookLM.md": ["notebooklm-architecture", "presentation-workflow"],
    "10-專案初始化工作模式.md": ["project-init-sync", "startup-sync", "shutdown-sync"],
    "11-Codex-Skill-Creator-工作流.md": ["codex-skill-creator"],
    "12-外部工具整合工作流.md": ["tool-integration-workflow", "cli-anything"],
    "13-Brainstorm-規劃模式.md": ["brainstorm"],
    "14-Social-Cards-Skill-安裝.md": ["social-cards"],
    "15-Landing-Page-Skill-安裝.md": ["landing-page"],
    "16-Codex-全域-Skills-跨裝置同步.md": ["cross-device-sync"],
    "17-RightProblem-Coach-Skill-安裝.md": ["rightproblem-coach"],
    "18-Document-to-Markdown-Skill-安裝.md": ["doc-to-md"],
    "19-SOIL-HTML-Deck-Skill-安裝.md": ["soil-html-deck"],
    "20-SOIL-Image-Deck-Skill-安裝.md": ["soil-image-deck"],
    "21-SOIL-General-Deck-Skill-安裝.md": ["soil-general-deck"],
    "22-Image-Generator-Skill-安裝.md": ["image-generator"],
    "23-Visual-Note-Generator-Skill-安裝.md": ["visual-note-generator"],
    "24-Diary-Interview-Assistant-Skill-安裝.md": ["diary-interview-assistant"],
    "25-Gemini-Free-API-Skill-安裝.md": ["gemini-free-api"],
    "26-HyperFrames-Skill-安裝.md": [
        "video-tool-evaluation", "animejs", "contribute-catalog", "css-animations", "gsap", "hyperframes",
        "hyperframes-cli", "hyperframes-media", "hyperframes-registry", "lottie",
        "remotion-to-hyperframes", "tailwind", "three", "typegpu", "waapi",
        "website-to-hyperframes",
    ],
    "27-Video-Spec-Builder-Skill-安裝.md": [
        "video-tool-evaluation", "video-spec-builder",
    ],
    "28-Netlify-Deploy-Skill-安裝.md": ["netlify-deploy"],
    "29-Video-Processing-Automation-Skill-安裝.md": [
        "video-tool-evaluation", "video-processing-automation",
    ],
    "30-Video-Creation-Automation-Skill-安裝.md": [
        "video-tool-evaluation", "video-creation-automation",
    ],
    "31-YouTube-Transcript-Collector-Skill-安裝.md": ["youtube-transcript-collector"],
    "32-VoxCPM2-Voice-Cloner-Skill-安裝.md": ["voxcpm2-voice-cloner"],
    "33-Audio-to-Markdown-Skill-安裝.md": ["audio-to-md"],
    "36-Voice-Input-Normalization.md": ["voice-input-normalization"],
    "37-Voice-Reply-Skill-安裝.md": ["voice-reply"],
    "38-YAML-Image-Deck-Skill-安裝.md": ["yaml-image-deck"],
    "40-Engineering-Methods-Skill-Suite-安裝.md": [
        "engineering-methods",
        "code-review",
        "codebase-design",
        "diagnosing-bugs",
        "domain-modeling",
        "grill-with-docs",
        "implement",
        "improve-codebase-architecture",
        "prototype",
        "research",
        "resolving-merge-conflicts",
        "tdd",
        "to-spec",
        "to-tickets",
        "triage",
        "wayfinder",
        "setup-engineering-methods",
        "grill-me",
        "grilling",
        "handoff",
        "teach",
        "writing-great-skills",
    ],
    "41-Clasp-Apps-Script-Skill-安裝.md": ["clasp-setup"],
    "42-Speak-Human-TW-Skill-安裝.md": ["speak-human-tw"],
    "43-Visual-Prompt-Kit-Skill-安裝.md": ["visual-prompt-kit"],
    "44-Personal-Style-Loop-Skill-安裝.md": ["personal-style-loop"],
    "45-Agent-Dev-Coach-Skill-安裝.md": ["agent-dev-coach"],
}

SINGLE_BLOCKS = {
    "09-個人助手設定.md": "arry-assistant",
}


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--sync-root",
        help=(
            "Shared sync root holding the skill master copies (its skills/ subdirectory "
            f"is used). Default: {DEFAULT_SYNC_ROOT}"
        ),
    )
    parser.add_argument(
        "--skills-root",
        help="Skills directory itself, bypassing --sync-root. Overrides SYNC_SKILLS_ROOT.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Render everything and report differences without writing any file.",
    )
    parser.add_argument(
        "--show-diff",
        action="store_true",
        help="Print a unified diff for every file that differs.",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    global SYNC_SKILLS
    args = parse_args(argv)
    SYNC_SKILLS = resolve_skills_root(args.sync_root, args.skills_root)
    if not SYNC_SKILLS.is_dir():
        print(f"error: skills root not found: {SYNC_SKILLS}", file=sys.stderr)
        print(
            "hint: pass --sync-root <dir containing skills/> or set SYNC_ROOT.",
            file=sys.stderr,
        )
        return 2

    print(f"skills root: {SYNC_SKILLS}")
    print(f"lazypack:    {LAZYPACK}")
    print(f"mode:        {'dry-run' if args.dry_run else 'write'}")
    print()

    reporter = Reporter(args.dry_run, args.show_diff)

    for filename, skills in SECTIONS.items():
        path = LAZYPACK / filename
        if not path.is_file():
            reporter.skip(filename, "LazyPack file not found")
            continue
        try:
            new_text = build_embedded_section(path, skills)
        except MissingSkill as error:
            # Rendering a section without one of its skills would silently drop
            # install content from a published LazyPack item, so skip the whole
            # file and report it instead.
            reporter.skip(filename, f"no package for skill '{error.skill}' at {error.source}")
            continue
        reporter.emit(path, new_text, f"{filename}: {', '.join(skills)}")

    for filename, skill in SINGLE_BLOCKS.items():
        path = LAZYPACK / filename
        if not path.is_file():
            reporter.skip(filename, "LazyPack file not found")
            continue
        try:
            new_text = build_one_skill_block(path, skill)
        except MissingSkill as error:
            reporter.skip(filename, f"no package for skill '{error.skill}' at {error.source}")
            continue
        reporter.emit(path, new_text, f"{filename}: {skill}")

    python_tools_item = LAZYPACK / "34-Python-Tools-全域工具包安裝.md"
    python_tool_scripts = {
        "install_python_tools.sh": REPO
        / "200_Reference"
        / "scripts"
        / "python-tools"
        / "install_python_tools.sh",
        "verify_python_tools.py": REPO
        / "200_Reference"
        / "scripts"
        / "python-tools"
        / "verify_python_tools.py",
    }
    emit_embedded_scripts(reporter, python_tools_item, python_tool_scripts)

    ag_lazypack = ANTIGRAVITY_LAZYPACK / "01-antigravity-lazypack.md"
    ag_scripts = {
        "register_mcp.py": ANTIGRAVITY_REPO / "200_Reference" / "scripts" / "register_mcp.py",
        "setup.sh": ANTIGRAVITY_REPO / "200_Reference" / "scripts" / "setup.sh",
    }
    emit_embedded_scripts(reporter, ag_lazypack, ag_scripts)

    return reporter.summary()


def emit_embedded_scripts(
    reporter: Reporter, lazypack_file: Path, scripts: dict[str, Path]
) -> None:
    """Refresh every EMBEDDED_SCRIPT block in one LazyPack file, then emit once."""
    if not lazypack_file.is_file():
        reporter.skip(lazypack_file.name, "LazyPack file not found")
        return
    missing = [name for name, path in scripts.items() if not path.is_file()]
    if missing:
        reporter.skip(lazypack_file.name, f"source script not found: {', '.join(missing)}")
        return
    new_text = lazypack_file.read_text(encoding="utf-8")
    for script_name, script_path in scripts.items():
        new_text = _apply_script_block(new_text, script_name, script_path, lazypack_file)
    reporter.emit(lazypack_file, new_text, f"{lazypack_file.name}: {', '.join(scripts)}")


def _apply_script_block(
    text: str, script_name: str, script_path: Path, lazypack_file: Path
) -> str:
    start = f"<!-- BEGIN EMBEDDED_SCRIPT:{script_name} -->"
    end = f"<!-- END EMBEDDED_SCRIPT:{script_name} -->"
    if start not in text or end not in text:
        raise ValueError(f"Embedded script markers for {script_name} missing in {lazypack_file}")
    lang = LANG_MAP.get(script_path.suffix, "")
    content = script_path.read_text(encoding="utf-8").rstrip("\n")
    section = f"""{start}

```{lang}
{content}
```

{end}"""
    before, remainder = text.split(start, 1)
    _, after = remainder.split(end, 1)
    return before + section + after


if __name__ == "__main__":
    raise SystemExit(main())
