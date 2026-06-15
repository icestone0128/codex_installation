#!/usr/bin/env python3
from __future__ import annotations

import html
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parent
RAW = ROOT / "raw_subtitles"
OUT = ROOT / "md"

TIMESTAMP_RE = re.compile(r"^(\d{2}:\d{2}:\d{2}\.\d{3}) --> .*$")
TAG_RE = re.compile(r"<[^>]+>")


def clean_caption_line(line: str) -> str:
    line = re.sub(r"<\d{2}:\d{2}:\d{2}\.\d{3}>", "", line)
    line = TAG_RE.sub("", line)
    line = html.unescape(line)
    return " ".join(line.split())


def parse_vtt(path: Path) -> list[tuple[str, str]]:
    entries: list[tuple[str, str]] = []
    current_time: str | None = None
    current_text: list[str] = []

    for raw_line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw_line.strip()
        if not line or line == "WEBVTT" or line.startswith(("Kind:", "Language:", "NOTE")):
            continue

        match = TIMESTAMP_RE.match(line)
        if match:
            if current_time and current_text:
                text = " ".join(current_text)
                if not entries or entries[-1][1] != text:
                    entries.append((current_time, text))
            current_time = match.group(1).split(".")[0]
            current_text = []
            continue

        if "-->" in line or line.isdigit():
            continue

        cleaned = clean_caption_line(line)
        if cleaned:
            current_text.append(cleaned)

    if current_time and current_text:
        text = " ".join(current_text)
        if not entries or entries[-1][1] != text:
            entries.append((current_time, text))

    return entries


def title_from_filename(path: Path) -> tuple[str, str, str]:
    stem = path.name.removesuffix(".vtt")
    video_id_match = re.search(r"\[([A-Za-z0-9_-]{11})\]", stem)
    video_id = video_id_match.group(1) if video_id_match else ""
    language = "unknown"
    title = stem
    if "." in title:
        title, language = title.rsplit(".", 1)
    return title, video_id, language


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    index_lines = ["# Sense Bar AI Agent 字幕索引", ""]

    for idx, vtt in enumerate(sorted(RAW.glob("*.vtt")), start=1):
        title, video_id, language = title_from_filename(vtt)
        entries = parse_vtt(vtt)
        safe_name = f"{idx:02d}-{video_id or vtt.stem}.md"
        md_path = OUT / safe_name

        lines = [
            f"# {title}",
            "",
            f"- YouTube: https://www.youtube.com/watch?v={video_id}" if video_id else "- YouTube: unknown",
            f"- Subtitle file: `{vtt.name}`",
            f"- Language: `{language}`",
            "",
            "## Transcript",
            "",
        ]
        for timestamp, text in entries:
            lines.append(f"- `{timestamp}` {text}")

        md_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
        index_lines.append(f"- [{title}](md/{safe_name})")

    (ROOT / "README.md").write_text("\n".join(index_lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
