#!/usr/bin/env python3
"""Fail when LazyPack hard-codes software versions.

LazyPack rule (2026-09-22): installers always resolve the newest release at
install time, and the documents never state "the current version is X".

Flagged:
  - package specs pinned in install commands (npm/npx/pnpm/yarn/bunx @1.2,
    pip/uv/pipx ==1.2 or ~=1.2, requirements-style `pkg==1.2`)
  - version defaults in scripts (FOO_VERSION="${FOO_VERSION:-1.2.3}")
  - source checkouts pinned to a commit (git checkout <sha>, *_COMMIT defaults)
  - release downloads with a literal version in the URL
  - hard-coded SHA-256 digests for downloads (resolve them from the release
    or model API at install time instead)
  - prose that records an installed or tested version number

Deliberate exceptions (decided by the user, see AGENTS.md):
  - Python interpreter compatibility ceilings (`--python 3.12`,
    PYTHON_VERSION defaults) when upstream packages do not yet support the
    newest Python
  - CDN library URLs inside generated HTML/video templates
  - minimum requirements ("Node.js 22.13.0 or newer", ">=20", "以上")
  - upstream review provenance (commit hashes recorded as "已讀來源／驗證
    commit", upstream reference versions of embedded snapshots)
  - a skill's own semver metadata, license text, example parameters

Usage: python3 check-lazypack-version-pins.py [--root LAZYPACK_DIR] [--show-allowed]
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
DEFAULT_ROOT = REPO / "200_Reference" / "lazy-pack"

VER = r"\d+(?:\.\d+)+"
RULES: list[tuple[str, re.Pattern[str]]] = [
    ("npm-pin", re.compile(r"(?:npm\s+(?:i|install|view)|npx|pnpm\s+(?:add|dlx)|yarn\s+(?:add|dlx)|bunx)\b[^\n`#]*?\s[\"']?(?:@[\w.-]+/)?[\w.-]+@[\^~]?\d")),
    ("npm-arg-pin", re.compile(r"[\"'](?:@[\w.-]+/)?[\w.-]+@\d+(?:\.\d+)*[\"']\s*,?\s*[\"']mcp[\"']")),
    ("pip-pin", re.compile(r"(?:pip3?\s+install|uv\s+(?:tool\s+install|pip\s+install|add)|pipx\s+install)\b[^\n#]*?[\w\]\"'-](?:==|~=)\s*\d")),
    ("requirements-pin", re.compile(r"^\s*[A-Za-z][\w.\-\[\],]*==\d", re.M)),
    ("version-default", re.compile(r"\b(?!PYTHON_)[A-Z][A-Z0-9_]*VERSION=\"\$\{[A-Z0-9_]+:-v?" + VER)),
    ("commit-default", re.compile(r"\b[A-Z][A-Z0-9_]*COMMIT=\"\$\{[A-Z0-9_]+:-[0-9a-f]{7,40}\}\"")),
    ("git-checkout-sha", re.compile(r"git\b[^\n]*\bcheckout\b[^\n]*\b[0-9a-f]{12,40}\b")),
    ("release-url-version", re.compile(r"releases/download/v?" + VER + r"/")),
    ("hardcoded-digest", re.compile(r"(?:digest|sha256|SHA256|expected)[\w]*[=:\s\"']+[0-9a-f]{64}\b")),
    ("prose-installed-version", re.compile(r"(?:已安裝|本機(?:已驗證|實測|版本)?|實測(?:基準|環境|基線)?|目前本機|當前實測|installed|Installed)[^\n|]{0,24}?(?<![\d.])v?\d+\.\d+\.\d+(?![\d.])")),
]

# Lines matching these are the documented exceptions above.
ALLOW = re.compile(
    r"--python\s+3\.\d+|PYTHON_VERSION|cdn\.jsdelivr\.net|unpkg\.com|cdnjs\.cloudflare\.com"
    r"|or newer|以上|>=|Version 2\.0|--version 1\.0\.0|^\s*version:|skill-version"
    r"|已讀來源|驗證 commit|Source checked|檢視 commit|參考版本|內嵌版本|upstream reference"
    r"|measured_against|sha256:\.\.\.|project_fingerprint|source_fingerprint|agent-harness"
)


def scan(root: Path, show_allowed: bool) -> int:
    findings = 0
    files = sorted(p for p in root.rglob("*") if p.is_file() and p.suffix in {".md", ".sh", ".py", ".txt", ".toml", ".template", ".json", ".ps1", ".bat"})
    for path in files:
        text = path.read_text(encoding="utf-8", errors="replace")
        for lineno, line in enumerate(text.splitlines(), 1):
            for name, pattern in RULES:
                if not pattern.search(line):
                    continue
                allowed = bool(ALLOW.search(line))
                if allowed and not show_allowed:
                    continue
                tag = "ALLOWED" if allowed else "PIN"
                if not allowed:
                    findings += 1
                print(f"{tag:7} {name:24} {path.relative_to(root)}:{lineno}: {line.strip()[:160]}")
    print(f"summary: {findings} version pin(s) in {root}")
    return 1 if findings else 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--root", type=Path, default=DEFAULT_ROOT)
    parser.add_argument("--show-allowed", action="store_true", help="also list lines kept as documented exceptions")
    args = parser.parse_args()
    return scan(args.root, args.show_allowed)


if __name__ == "__main__":
    sys.exit(main())
