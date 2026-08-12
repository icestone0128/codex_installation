#!/usr/bin/env python3
"""Regenerate LazyPack's self-contained skill install blocks from source packages."""

from __future__ import annotations

import hashlib
import os
from pathlib import Path
import re
import base64
import textwrap


REPO = Path(__file__).resolve().parents[2]
SYNC_SKILLS = Path(
    os.environ.get("SYNC_SKILLS_ROOT", REPO.parent / "codex_symlink" / "skills")
).expanduser()
LAZYPACK = REPO / "200_Reference" / "lazy-pack"
EXCLUDED_SOURCE_DIRS = {".git", "__pycache__", "node_modules"}
EXCLUDED_SOURCE_FILES = {".DS_Store", ".gitkeep"}


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
        raise FileNotFoundError(f"Missing skill package: {source}")

    lines = [f"# ---- {skill} ----", f'mkdir -p "{{{{SYNC_ROOT}}}}/skills/{skill}"']
    for path in source_files(source):
        relative = path.relative_to(source)
        raw = path.read_bytes()
        try:
            content = raw.decode("utf-8")
        except UnicodeDecodeError:
            content = None
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


def replace_embedded_section(path: Path, skills: list[str]) -> None:
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
    path.write_text(before + section + after, encoding="utf-8")


def replace_one_skill_block(path: Path, skill: str) -> None:
    text = path.read_text(encoding="utf-8")
    pattern = re.compile(
        rf"# ---- {re.escape(skill)} ----\n.*?test -f \"\{{\{{(?:CODEX_HOME|SYNC_ROOT)\}}\}}/skills/{re.escape(skill)}/SKILL\.md\" && echo \"{re.escape(skill)} installed(?: for Codex, Claude, and AntiGravity)?\"",
        re.DOTALL,
    )
    replacement = render_skill(skill)
    updated, count = pattern.subn(lambda _: replacement, text, count=1)
    if count != 1:
        raise ValueError(f"Expected one {skill} block in {path}, found {count}")
    path.write_text(updated, encoding="utf-8")


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


def replace_embedded_script(lazypack_file: Path, script_name: str, script_path: Path) -> None:
    """Replace content between EMBEDDED_SCRIPT markers with the source script."""
    text = lazypack_file.read_text(encoding="utf-8")
    start = f"<!-- BEGIN EMBEDDED_SCRIPT:{script_name} -->"
    end = f"<!-- END EMBEDDED_SCRIPT:{script_name} -->"
    if start not in text or end not in text:
        raise ValueError(f"Embedded script markers for {script_name} missing in {lazypack_file}")
    if not script_path.is_file():
        raise FileNotFoundError(f"Source script not found: {script_path}")

    lang = LANG_MAP.get(script_path.suffix, "")
    content = script_path.read_text(encoding="utf-8").rstrip("\n")
    section = f"""{start}

```{lang}
{content}
```

{end}"""
    before, remainder = text.split(start, 1)
    _, after = remainder.split(end, 1)
    lazypack_file.write_text(before + section + after, encoding="utf-8")


def main() -> None:
    sections = {
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
    }
    for filename, skills in sections.items():
        replace_embedded_section(LAZYPACK / filename, skills)
        print(f"synced {filename}: {', '.join(skills)}")
    replace_one_skill_block(LAZYPACK / "09-個人助手設定.md", "arry-assistant")
    print("synced 09-個人助手設定.md: arry-assistant")

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
    for script_name, script_path in python_tool_scripts.items():
        replace_embedded_script(python_tools_item, script_name, script_path)
    print(
        "synced 34-Python-Tools-全域工具包安裝.md: "
        + ", ".join(python_tool_scripts)
    )

    # --- Antigravity Installation LazyPack: embedded scripts ---
    ag_lazypack = ANTIGRAVITY_LAZYPACK / "01-antigravity-lazypack.md"
    if ag_lazypack.is_file():
        ag_scripts = {
            "register_mcp.py": ANTIGRAVITY_REPO / "200_Reference" / "scripts" / "register_mcp.py",
            "setup.sh": ANTIGRAVITY_REPO / "200_Reference" / "scripts" / "setup.sh",
        }
        for script_name, script_path in ag_scripts.items():
            replace_embedded_script(ag_lazypack, script_name, script_path)
        print(f"synced antigravity 01-antigravity-lazypack.md: {', '.join(ag_scripts.keys())}")
    else:
        print(f"skipped antigravity sync: {ag_lazypack} not found")


if __name__ == "__main__":
    main()
