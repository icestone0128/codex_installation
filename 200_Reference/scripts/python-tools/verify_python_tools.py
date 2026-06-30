from importlib import import_module
from importlib.metadata import distributions
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
    "ocrmypdf",
    "edge_tts",
    "yt_dlp",
    "youtube_transcript_api",
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

    print("\nSystem tools:")
    for tool in ["tesseract", "pdftoppm", "ffmpeg", "soffice"]:
        path = shutil.which(tool)
        print(f"  {'OK' if path else 'MISSING'} {tool}: {path or '-'}")

    names = sorted(dist.metadata["Name"] for dist in distributions())
    print(f"\nInstalled distributions: {len(names)}")
    for name in names:
        print(f"  {name}")

    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
