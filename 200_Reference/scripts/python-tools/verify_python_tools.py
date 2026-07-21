from importlib import import_module
from importlib.metadata import distributions
import os
from pathlib import Path
import shutil

IMPORTS = [
    "docx",
    "docxcompose",
    "openpyxl",
    "xlsxwriter",
    "pandas",
    "pptx",
    "pypdf",
    "fitz",
    "pdfplumber",
    "pdf2image",
    "reportlab",
    "fpdf",
    "PIL",
    "matplotlib",
    "qrcode",
    "markitdown",
    "mammoth",
    "ocrmypdf",
    "edge_tts",
    "yt_dlp",
    "youtube_transcript_api",
]

CORE_WRAPPERS = [
    "python-tools-python",
    "edge-tts",
    "markitdown",
    "ocrmypdf",
    "yt-dlp",
]


def main() -> int:
    failed = []
    for name in IMPORTS:
        try:
            import_module(name)
        except Exception as exc:
            failed.append((name, str(exc)))

    print("Python packages:")
    if failed:
        for name, error in failed:
            print(f"  FAIL {name}: {error}")
    else:
        print("  OK all core imports")

    codex_home = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex"))
    runtime_home = Path(os.environ.get("PYTHON_TOOLS_HOME", codex_home / "python-tools"))
    wrapper_failures = []
    print("\nCore wrappers:")
    for name in CORE_WRAPPERS:
        wrapper = runtime_home / "bin" / name
        available = wrapper.is_file() and os.access(wrapper, os.X_OK)
        print(f"  {'OK' if available else 'MISSING'} {name}: {wrapper if available else '-'}")
        if not available:
            wrapper_failures.append(name)

    bridge = Path.home() / ".local" / "share" / "agent-tools" / "python-tools"
    print("\nThree-Agent bridge:")
    if bridge.is_symlink() and bridge.resolve() == runtime_home.resolve():
        print("  OK neutral bridge points to this runtime")
    else:
        print("  PENDING run LazyPack Item 16 to create or repair the neutral bridge")

    print("\nSystem tools:")
    for tool in ["tesseract", "gs", "pdftoppm", "ffmpeg", "soffice"]:
        path = shutil.which(tool)
        print(f"  {'OK' if path else 'MISSING'} {tool}: {path or '-'}")

    names = sorted(dist.metadata["Name"] for dist in distributions())
    print(f"\nInstalled distributions: {len(names)}")
    for name in names:
        print(f"  {name}")

    return 1 if failed or wrapper_failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
