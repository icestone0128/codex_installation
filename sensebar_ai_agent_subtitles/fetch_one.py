#!/usr/bin/env python3
from __future__ import annotations

import argparse
import html
import json
import re
import subprocess
import time
from pathlib import Path
from urllib.parse import parse_qs, urlparse


ROOT = Path(__file__).resolve().parent
URLS = ROOT / "video_urls.txt"
RAW = ROOT / "raw_subtitles"
OUT = ROOT / "md"
STATUS = ROOT / "status.json"
SUMMARY = ROOT / "總表.md"

LANGS = "zh-TW"
PREFERRED_LABELS = {"zh-TW"}


def video_id_from_url(url: str) -> str:
    parsed = urlparse(url)
    if parsed.hostname == "youtu.be":
        return parsed.path.strip("/")
    query = parse_qs(parsed.query)
    if "v" in query:
        return query["v"][0]
    raise ValueError(f"Cannot parse video id from URL: {url}")


def load_urls() -> list[str]:
    return [line.strip() for line in URLS.read_text(encoding="utf-8").splitlines() if line.strip()]


def safe_filename(text: str) -> str:
    text = text.replace("/", "／")
    text = re.sub(r"\s+", " ", text).strip()
    text = text.rstrip(". ")
    return text or "untitled"


def load_titles() -> dict[int, str]:
    if not SUMMARY.exists():
        return {}
    titles: dict[int, str] = {}
    row_re = re.compile(r"^\| (\d+) \| [^|]+ \| ([^|]+) \| https?://[^|]+ \| [^|]+ \|$")
    for line in SUMMARY.read_text(encoding="utf-8").splitlines():
        match = row_re.match(line)
        if match:
            titles[int(match.group(1))] = match.group(2).strip()
    return titles


def load_status() -> dict:
    if STATUS.exists():
        return json.loads(STATUS.read_text(encoding="utf-8"))
    return {"successes": {}, "failures": {}, "last_run": None}


def save_status(status: dict) -> None:
    STATUS.write_text(json.dumps(status, ensure_ascii=False, indent=2), encoding="utf-8")


def next_index(status: dict, urls: list[str]) -> int:
    done = {int(k) for k in status.get("successes", {})}
    for idx in range(1, len(urls) + 1):
        if idx not in done:
            return idx
    return 0


def run_yt_dlp(index: int, url: str, use_cookies: bool) -> subprocess.CompletedProcess[str]:
    base = f"{index:02d}-{video_id_from_url(url)}"
    output = str(RAW / f"{base}.%(ext)s")
    cmd = [
        "yt-dlp",
        "--ignore-errors",
        "--skip-download",
        "--write-subs",
        "--write-auto-subs",
        "--sub-langs",
        LANGS,
        "--sub-format",
        "vtt",
        "--sleep-requests",
        "8",
        "--sleep-interval",
        "10",
        "--max-sleep-interval",
        "20",
        "-o",
        output,
        url,
    ]
    if use_cookies:
        cmd[1:1] = ["--cookies-from-browser", "chrome:Profile 1"]
    return subprocess.run(cmd, cwd=ROOT.parent, text=True, capture_output=True, timeout=180)


def strip_vtt(path: Path) -> list[tuple[str, str]]:
    rows: list[tuple[str, str]] = []
    current_time: str | None = None
    current_text: list[str] = []
    timestamp_re = re.compile(r"^(\d{2}:\d{2}:\d{2}\.\d{3}) --> .*$")
    tag_re = re.compile(r"<[^>]+>")

    for raw_line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw_line.strip()
        if not line or line == "WEBVTT" or line.startswith(("Kind:", "Language:", "NOTE")):
            continue
        match = timestamp_re.match(line)
        if match:
            if current_time and current_text:
                text = " ".join(current_text)
                if not rows or rows[-1][1] != text:
                    rows.append((current_time, text))
            current_time = match.group(1).split(".")[0]
            current_text = []
            continue
        if "-->" in line or line.isdigit():
            continue
        cleaned = re.sub(r"<\d{2}:\d{2}:\d{2}\.\d{3}>", "", line)
        cleaned = tag_re.sub("", cleaned)
        cleaned = html.unescape(cleaned)
        cleaned = " ".join(cleaned.split())
        if cleaned:
            current_text.append(cleaned)

    if current_time and current_text:
        text = " ".join(current_text)
        if not rows or rows[-1][1] != text:
            rows.append((current_time, text))
    return rows


def subtitle_label(path: Path, base: str) -> str:
    stem = path.name.removesuffix(".vtt")
    prefix = f"{base}."
    if stem.startswith(prefix):
        return stem.removeprefix(prefix)
    return stem


def is_preferred_subtitle(path: Path, base: str) -> bool:
    label = subtitle_label(path, base)
    return label in PREFERRED_LABELS


def write_md(index: int, url: str, title: str, vtts: list[Path]) -> Path:
    video_id = video_id_from_url(url)
    base = f"{index:02d}-{video_id}"
    md = OUT / f"{safe_filename(title)}.md"
    lines = [
        f"# {title}",
        "",
        f"- Index: `{index:02d}`",
        f"- YouTube: {url}",
        f"- Video ID: `{video_id}`",
        f"- Subtitle sources: {', '.join(f'`{vtt.name}`' for vtt in vtts)}",
        "",
        "## Transcript",
        "",
    ]
    for vtt in vtts:
        label = subtitle_label(vtt, base)
        rows = strip_vtt(vtt)
        lines.extend([f"### {label}", ""])
        for ts, text in rows:
            lines.append(f"- `{ts}` {text}")
        lines.append("")
    md.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return md


def update_summary(status: dict) -> None:
    if not SUMMARY.exists():
        return
    text = SUMMARY.read_text(encoding="utf-8")
    for key, item in status.get("successes", {}).items():
        md_path = item.get("md")
        if not md_path:
            continue
        idx = int(key)
        link = f"[{Path(md_path).name}]({md_path})"
        text = re.sub(
            rf"(^\| {idx} \| .+? \| .+? \| .+? \| )(?:待抓取|限流待重試|\[[^\]]+\]\([^)]+\))( \|$)",
            rf"\1{link}\2",
            text,
            flags=re.MULTILINE,
        )
    SUMMARY.write_text(text, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Fetch one Sense Bar subtitle slowly.")
    parser.add_argument("--index", type=int, help="1-based index in video_urls.txt")
    parser.add_argument("--next", action="store_true", help="Fetch the next unprocessed item")
    parser.add_argument("--cookies", action="store_true", help="Use Chrome Profile 1 cookies")
    parser.add_argument("--from-existing", action="store_true", help="Use existing subtitle files without contacting YouTube")
    parser.add_argument("--sleep-after", type=int, default=120, help="Seconds to wait after one attempt")
    args = parser.parse_args()

    RAW.mkdir(parents=True, exist_ok=True)
    OUT.mkdir(parents=True, exist_ok=True)

    urls = load_urls()
    titles = load_titles()
    status = load_status()
    index = args.index or (next_index(status, urls) if args.next else 1)
    if index < 1 or index > len(urls):
        print("No valid index to process.")
        return 1

    url = urls[index - 1]
    title = titles.get(index, f"{index:02d}-{video_id_from_url(url)}")
    video_id = video_id_from_url(url)
    base = f"{index:02d}-{video_id}"

    started = time.strftime("%Y-%m-%d %H:%M:%S")
    print(f"Processing #{index}: {url}")
    if args.from_existing:
        proc_returncode = 0
        output = "Used existing subtitle files.\n"
    else:
        proc = run_yt_dlp(index, url, args.cookies)
        proc_returncode = proc.returncode
        output = proc.stdout + "\n" + proc.stderr

    candidates = sorted(vtt for vtt in RAW.glob(f"{base}*.vtt") if is_preferred_subtitle(vtt, base))
    if proc_returncode == 0 and candidates:
        old_md = status.get("successes", {}).get(str(index), {}).get("md")
        if old_md and (ROOT / old_md).exists():
            (ROOT / old_md).unlink()
        md = write_md(index, url, title, candidates)
        status.setdefault("successes", {})[str(index)] = {
            "url": url,
            "video_id": video_id,
            "title": title,
            "vtts": [str(vtt.relative_to(ROOT)) for vtt in candidates],
            "md": str(md.relative_to(ROOT)),
            "started": started,
            "finished": time.strftime("%Y-%m-%d %H:%M:%S"),
        }
        status.get("failures", {}).pop(str(index), None)
        print(f"OK: {md}")
    else:
        log_path = RAW / f"{base}.error.log"
        log_path.write_text(output, encoding="utf-8")
        status.setdefault("failures", {})[str(index)] = {
            "url": url,
            "video_id": video_id,
            "error_log": str(log_path.relative_to(ROOT)),
            "returncode": proc_returncode,
            "started": started,
            "finished": time.strftime("%Y-%m-%d %H:%M:%S"),
        }
        print(f"FAILED: see {log_path}")

    status["last_run"] = time.strftime("%Y-%m-%d %H:%M:%S")
    save_status(status)
    update_summary(status)

    if args.sleep_after > 0:
        print(f"Sleeping {args.sleep_after}s to avoid rate limits.")
        time.sleep(args.sleep_after)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
