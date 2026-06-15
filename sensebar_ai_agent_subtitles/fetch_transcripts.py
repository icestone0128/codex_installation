#!/usr/bin/env python3
from __future__ import annotations

import json
import re
from pathlib import Path
from urllib.parse import parse_qs, urlparse

from youtube_transcript_api import YouTubeTranscriptApi
from youtube_transcript_api.formatters import WebVTTFormatter
from youtube_transcript_api._errors import (
    NoTranscriptFound,
    TranscriptsDisabled,
    VideoUnavailable,
)


ROOT = Path(__file__).resolve().parent
URLS = ROOT / "video_urls.txt"
RAW = ROOT / "raw_subtitles"
OUT = ROOT / "md"
MANIFEST = ROOT / "manifest.json"
FAILURES = ROOT / "failures.md"

LANGUAGE_PRIORITY = ["zh-TW", "zh-Hant", "zh-Hans", "zh", "en"]


def video_id_from_url(url: str) -> str:
    parsed = urlparse(url)
    if parsed.hostname == "youtu.be":
        return parsed.path.strip("/")
    query = parse_qs(parsed.query)
    if "v" in query:
        return query["v"][0]
    raise ValueError(f"Cannot parse video id from URL: {url}")


def safe_filename(text: str, max_len: int = 90) -> str:
    text = re.sub(r"[\\/:*?\"<>|]+", " ", text)
    text = " ".join(text.split())
    return text[:max_len].strip() or "untitled"


def timestamp(seconds: float) -> str:
    total = int(seconds)
    h = total // 3600
    m = (total % 3600) // 60
    s = total % 60
    return f"{h:02d}:{m:02d}:{s:02d}"


def as_dicts(transcript) -> list[dict]:
    rows = []
    for snippet in transcript:
        if isinstance(snippet, dict):
            rows.append(
                {
                    "text": snippet.get("text", ""),
                    "start": snippet.get("start", 0),
                    "duration": snippet.get("duration", 0),
                }
            )
        else:
            rows.append(
                {
                    "text": snippet.text,
                    "start": snippet.start,
                    "duration": snippet.duration,
                }
            )
    return rows


def choose_transcript(api: YouTubeTranscriptApi, video_id: str):
    transcript_list = api.list(video_id)

    try:
        return transcript_list.find_manually_created_transcript(LANGUAGE_PRIORITY), "manual"
    except NoTranscriptFound:
        pass

    try:
        return transcript_list.find_generated_transcript(LANGUAGE_PRIORITY), "generated"
    except NoTranscriptFound:
        pass

    for transcript in transcript_list:
        if transcript.language_code.startswith("zh"):
            return transcript, "fallback-zh"

    for transcript in transcript_list:
        return transcript, "fallback-any"

    raise NoTranscriptFound(video_id, LANGUAGE_PRIORITY, transcript_list)


def write_transcript(index: int, url: str, transcript_obj, transcript_type: str) -> dict:
    fetched = transcript_obj.fetch(preserve_formatting=False)
    rows = as_dicts(fetched)
    video_id = transcript_obj.video_id
    title = f"{index:02d}-{video_id}"
    base = safe_filename(title)

    raw_json = RAW / f"{base}.{transcript_obj.language_code}.json"
    raw_vtt = RAW / f"{base}.{transcript_obj.language_code}.vtt"
    md = OUT / f"{base}.md"

    raw_json.write_text(json.dumps(rows, ensure_ascii=False, indent=2), encoding="utf-8")
    raw_vtt.write_text(WebVTTFormatter().format_transcript(rows), encoding="utf-8")

    lines = [
        f"# {index:02d} {video_id}",
        "",
        f"- YouTube: {url}",
        f"- Video ID: `{video_id}`",
        f"- Subtitle language: `{transcript_obj.language_code}` ({transcript_obj.language})",
        f"- Subtitle type: `{transcript_type}`",
        f"- Raw subtitle JSON: `raw_subtitles/{raw_json.name}`",
        f"- Raw subtitle VTT: `raw_subtitles/{raw_vtt.name}`",
        "",
        "## Transcript",
        "",
    ]

    for row in rows:
        text = " ".join(row["text"].split())
        if text:
            lines.append(f"- `{timestamp(row['start'])}` {text}")

    md.write_text("\n".join(lines) + "\n", encoding="utf-8")

    return {
        "index": index,
        "video_id": video_id,
        "url": url,
        "language_code": transcript_obj.language_code,
        "language": transcript_obj.language,
        "type": transcript_type,
        "md": f"md/{md.name}",
        "raw_json": f"raw_subtitles/{raw_json.name}",
        "raw_vtt": f"raw_subtitles/{raw_vtt.name}",
        "snippet_count": len(rows),
    }


def main() -> None:
    RAW.mkdir(parents=True, exist_ok=True)
    OUT.mkdir(parents=True, exist_ok=True)

    api = YouTubeTranscriptApi()
    successes = []
    failures = []

    urls = [line.strip() for line in URLS.read_text(encoding="utf-8").splitlines() if line.strip()]
    for index, url in enumerate(urls, start=1):
        video_id = video_id_from_url(url)
        try:
            transcript_obj, transcript_type = choose_transcript(api, video_id)
            successes.append(write_transcript(index, url, transcript_obj, transcript_type))
        except (NoTranscriptFound, TranscriptsDisabled, VideoUnavailable, Exception) as exc:
            failures.append(
                {
                    "index": index,
                    "video_id": video_id,
                    "url": url,
                    "error": f"{type(exc).__name__}: {exc}",
                }
            )

    MANIFEST.write_text(
        json.dumps({"successes": successes, "failures": failures}, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )

    readme_lines = [
        "# Sense Bar AI Agent 字幕",
        "",
        f"- Total URLs: {len(urls)}",
        f"- Downloaded transcripts: {len(successes)}",
        f"- Failures: {len(failures)}",
        "",
        "## Files",
        "",
    ]
    for item in successes:
        readme_lines.append(
            f"- [{item['index']:02d} {item['video_id']}]({item['md']}) - "
            f"{item['language_code']} / {item['type']} / {item['snippet_count']} snippets"
        )
    (ROOT / "README.md").write_text("\n".join(readme_lines) + "\n", encoding="utf-8")

    failure_lines = ["# Subtitle Fetch Failures", ""]
    if failures:
        for failure in failures:
            failure_lines.extend(
                [
                    f"## {failure['index']:02d} {failure['video_id']}",
                    "",
                    f"- URL: {failure['url']}",
                    f"- Error: `{failure['error']}`",
                    "",
                ]
            )
    else:
        failure_lines.append("No failures.")
    FAILURES.write_text("\n".join(failure_lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
