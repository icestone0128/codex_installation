#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PYTHON_TOOLS_HOME="${PYTHON_TOOLS_HOME:-$CODEX_HOME/python-tools}"
PYTHON_TOOLS_VENV="$PYTHON_TOOLS_HOME/teaching-file-tools/.venv"
UV_BIN="${UV_BIN:-}"
INSTALL_SYSTEM_TOOLS="${INSTALL_SYSTEM_TOOLS:-1}"
INSTALL_OFFICE_TOOLS="${INSTALL_OFFICE_TOOLS:-0}"
EXTRA_PIP_PACKAGES=()

log() {
  printf '[python-tools] %s\n' "$*"
}

is_macos() {
  [ "$(uname -s)" = "Darwin" ]
}

install_macos_system_tools() {
  if ! is_macos; then
    log "INSTALL_SYSTEM_TOOLS=1 is currently implemented for macOS/Homebrew only; skipping OS packages."
    return
  fi
  if ! command -v brew >/dev/null 2>&1; then
    printf 'Homebrew is required for macOS system tools. Install Homebrew, then rerun this script.\n' >&2
    exit 1
  fi

  log "installing macOS system tools: tesseract, language data, ghostscript, poppler, ffmpeg"
  brew install tesseract tesseract-lang ghostscript poppler ffmpeg

  if [ "$INSTALL_OFFICE_TOOLS" = "1" ]; then
    log "installing LibreOffice for soffice/docx conversion support"
    brew install --cask libreoffice
  fi
}

if [ "$INSTALL_SYSTEM_TOOLS" = "1" ]; then
  install_macos_system_tools
fi

if [ -z "$UV_BIN" ]; then
  if command -v uv >/dev/null 2>&1; then
    UV_BIN="$(command -v uv)"
  elif [ -x /opt/homebrew/bin/uv ]; then
    UV_BIN=/opt/homebrew/bin/uv
  elif is_macos && command -v brew >/dev/null 2>&1; then
    log "uv not found; installing uv with Homebrew"
    brew install uv
    UV_BIN="$(command -v uv)"
  else
    echo "uv is required. Install uv first, then rerun this script." >&2
    exit 1
  fi
fi

mkdir -p "$PYTHON_TOOLS_HOME/bin" "$PYTHON_TOOLS_HOME/matplotlib-cache"

"$UV_BIN" venv --python 3.12 "$PYTHON_TOOLS_VENV"

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    EXTRA_PIP_PACKAGES+=(pywin32)
    ;;
esac

"$UV_BIN" pip install \
  --python "$PYTHON_TOOLS_VENV/bin/python" \
  python-docx docxcompose openpyxl xlsxwriter pandas python-pptx \
  pypdf PyMuPDF pdfplumber pdf2image reportlab fpdf2 pillow matplotlib \
  qrcode 'markitdown[pdf,docx,pptx,xlsx]' ocrmypdf docx2pdf edge-tts yt-dlp youtube-transcript-api \
  "${EXTRA_PIP_PACKAGES[@]}"

cat > "$PYTHON_TOOLS_HOME/bin/python-tools-python" <<SH
#!/usr/bin/env bash
set -euo pipefail
CACHE_ROOT="\${MPLCONFIGDIR:-$PYTHON_TOOLS_HOME/matplotlib-cache}"
if [ ! -d "\$CACHE_ROOT" ] || [ ! -w "\$CACHE_ROOT" ]; then
  CACHE_ROOT="\${TMPDIR:-/tmp}/codex-python-tools-matplotlib-cache"
  mkdir -p "\$CACHE_ROOT"
fi
export MPLCONFIGDIR="\$CACHE_ROOT"
exec "$PYTHON_TOOLS_VENV/bin/python" "\$@"
SH
chmod +x "$PYTHON_TOOLS_HOME/bin/python-tools-python"

write_venv_command_wrapper() {
  command_name="$1"
  if [ ! -x "$PYTHON_TOOLS_VENV/bin/$command_name" ]; then
    return
  fi
  cat > "$PYTHON_TOOLS_HOME/bin/$command_name" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$PYTHON_TOOLS_VENV/bin/$command_name" "\$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/$command_name"
}

for command_name in edge-tts markitdown ocrmypdf yt-dlp; do
  write_venv_command_wrapper "$command_name"
done

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
  cat > "$PYTHON_TOOLS_HOME/bin/audio-to-md" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$CODEX_HOME/audio-to-md/audio-to-md" "\$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/audio-to-md"
fi

if [ -d "$CODEX_HOME/voxcpm2-voice-cloner/.venv" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/voxcpm2-python" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$CODEX_HOME/voxcpm2-voice-cloner/.venv/bin/python" "\$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/voxcpm2-python"
fi

if [ -d "$CODEX_HOME/doc-to-md" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/doc-to-md" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$CODEX_HOME/doc-to-md/doc-to-md" "\$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/doc-to-md"
fi

if [ -d "$CODEX_HOME/vlm-to-md" ]; then
  cat > "$PYTHON_TOOLS_HOME/bin/vlm-to-md" <<SH
#!/usr/bin/env bash
set -euo pipefail
exec "$CODEX_HOME/vlm-to-md/vlm-to-md" "\$@"
SH
  chmod +x "$PYTHON_TOOLS_HOME/bin/vlm-to-md"
fi

"$PYTHON_TOOLS_HOME/bin/python-tools-python" -c "import docx, docxcompose, openpyxl, xlsxwriter, pandas, pptx, pypdf, fitz, pdfplumber, pdf2image, reportlab, fpdf, PIL, matplotlib, qrcode, markitdown, mammoth, ocrmypdf; import edge_tts, yt_dlp, youtube_transcript_api; print('python teaching file tools ok')"

echo "Python tools installed at: $PYTHON_TOOLS_HOME"
echo "Shared command directory: $PYTHON_TOOLS_HOME/bin"
if [ -L "$HOME/.local/share/agent-tools/python-tools" ]; then
  echo "Three-Agent bridge detected. Start a new Agent conversation or run:"
  echo "  . \"$HOME/.config/agent-tools/python-tools.env\""
else
  echo "Next: run LazyPack Item 16 to create the Codex/Claude/AntiGravity bridge and shell loader."
fi
