#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PYTHON_TOOLS_HOME="${PYTHON_TOOLS_HOME:-$CODEX_HOME/python-tools}"
PYTHON_TOOLS_VENV="$PYTHON_TOOLS_HOME/teaching-file-tools/.venv"
UV_BIN="${UV_BIN:-}"

if [ -z "$UV_BIN" ]; then
  if command -v uv >/dev/null 2>&1; then
    UV_BIN="$(command -v uv)"
  elif [ -x /opt/homebrew/bin/uv ]; then
    UV_BIN=/opt/homebrew/bin/uv
  else
    echo "uv is required. Install uv first, then rerun this script." >&2
    exit 1
  fi
fi

mkdir -p "$PYTHON_TOOLS_HOME/bin" "$PYTHON_TOOLS_HOME/matplotlib-cache"

"$UV_BIN" venv --python 3.12 "$PYTHON_TOOLS_VENV"

"$UV_BIN" pip install \
  --python "$PYTHON_TOOLS_VENV/bin/python" \
  python-docx docxcompose openpyxl xlsxwriter pandas python-pptx \
  pypdf PyMuPDF pdfplumber pdf2image reportlab fpdf2 pillow matplotlib \
  qrcode markitdown ocrmypdf docx2pdf edge-tts yt-dlp youtube-transcript-api

cat > "$PYTHON_TOOLS_HOME/bin/python-tools-python" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
CACHE_ROOT="${MPLCONFIGDIR:-$HOME/.codex/python-tools/matplotlib-cache}"
if [ ! -d "$CACHE_ROOT" ] || [ ! -w "$CACHE_ROOT" ]; then
  CACHE_ROOT="${TMPDIR:-/tmp}/codex-python-tools-matplotlib-cache"
  mkdir -p "$CACHE_ROOT"
fi
export MPLCONFIGDIR="$CACHE_ROOT"
exec "$HOME/.codex/python-tools/teaching-file-tools/.venv/bin/python" "$@"
SH
chmod +x "$PYTHON_TOOLS_HOME/bin/python-tools-python"

if [ -d "$HOME/.audio-to-md" ] && [ ! -L "$HOME/.audio-to-md" ]; then
  if [ ! -e "$CODEX_HOME/audio-to-md" ]; then
    mv "$HOME/.audio-to-md" "$CODEX_HOME/audio-to-md"
  fi
fi
if [ -L "$HOME/.audio-to-md" ]; then
  rm "$HOME/.audio-to-md"
fi
if [ -d "$PYTHON_TOOLS_HOME/audio-to-md" ] && [ ! -e "$CODEX_HOME/audio-to-md" ]; then
  mv "$PYTHON_TOOLS_HOME/audio-to-md" "$CODEX_HOME/audio-to-md"
fi

if [ -d "$PYTHON_TOOLS_HOME/voxcpm2-voice-cloner" ] && [ ! -e "$CODEX_HOME/voxcpm2-voice-cloner" ]; then
  mv "$PYTHON_TOOLS_HOME/voxcpm2-voice-cloner" "$CODEX_HOME/voxcpm2-voice-cloner"
fi

if [ -d "$HOME/.doc-to-md" ] && [ ! -L "$HOME/.doc-to-md" ]; then
  if [ ! -e "$CODEX_HOME/doc-to-md" ]; then
    mv "$HOME/.doc-to-md" "$CODEX_HOME/doc-to-md"
  fi
fi
if [ -L "$HOME/.doc-to-md" ]; then
  rm "$HOME/.doc-to-md"
fi

if [ -d "$HOME/.vlm-to-md" ] && [ ! -L "$HOME/.vlm-to-md" ]; then
  if [ ! -e "$CODEX_HOME/vlm-to-md" ]; then
    mv "$HOME/.vlm-to-md" "$CODEX_HOME/vlm-to-md"
  fi
fi
if [ -L "$HOME/.vlm-to-md" ]; then
  rm "$HOME/.vlm-to-md"
fi

if [ -d "$CODEX_HOME/audio-to-md" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/audio-to-md" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
exec "$HOME/.codex/audio-to-md/audio-to-md" "$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/audio-to-md"
fi

if [ -d "$CODEX_HOME/voxcpm2-voice-cloner/.venv" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/voxcpm2-python" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
exec "$HOME/.codex/voxcpm2-voice-cloner/.venv/bin/python" "$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/voxcpm2-python"
fi

if [ -d "$CODEX_HOME/doc-to-md" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/doc-to-md" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
exec "$HOME/.codex/doc-to-md/doc-to-md" "$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/doc-to-md"
fi

if [ -d "$CODEX_HOME/vlm-to-md" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/vlm-to-md" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
exec "$HOME/.codex/vlm-to-md/vlm-to-md" "$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/vlm-to-md"
fi

"$PYTHON_TOOLS_HOME/bin/python-tools-python" -c "import docx, docxcompose, openpyxl, xlsxwriter, pandas, pptx, pypdf, fitz, pdfplumber, pdf2image, reportlab, fpdf, PIL, matplotlib, qrcode, markitdown, ocrmypdf; import edge_tts, yt_dlp, youtube_transcript_api; print('python teaching file tools ok')"

echo "Python tools installed at: $PYTHON_TOOLS_HOME"
echo "Add this to PATH when desired: $PYTHON_TOOLS_HOME/bin"
