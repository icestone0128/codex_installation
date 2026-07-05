#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PYTHON_TOOLS_HOME="${PYTHON_TOOLS_HOME:-$CODEX_HOME/python-tools}"
TAIGI_HOME="${TAIGI_HOME:-$PYTHON_TOOLS_HOME/taigi-teaching-agent}"
BIN_DIR="${BIN_DIR:-$PYTHON_TOOLS_HOME/bin}"
SOURCE_REPO="${SOURCE_REPO:-https://github.com/mathruffian-dot/taigi-teaching-agent.git}"
SOURCE_COMMIT="${SOURCE_COMMIT:-bf55f6fae291d21a483d30225607435e13b2bb66}"
PYTHON_VERSION="${PYTHON_VERSION:-3.12}"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required." >&2
  exit 1
fi

if ! command -v uv >/dev/null 2>&1; then
  echo "uv is required. Install uv first, then rerun this script." >&2
  exit 1
fi

mkdir -p "$PYTHON_TOOLS_HOME" "$BIN_DIR"

if [ -d "$TAIGI_HOME/.git" ]; then
  echo "Using existing repo: $TAIGI_HOME"
elif [ -e "$TAIGI_HOME" ]; then
  echo "Target exists but is not a git repo: $TAIGI_HOME" >&2
  echo "Move it aside or set TAIGI_HOME to another path." >&2
  exit 1
else
  git clone "$SOURCE_REPO" "$TAIGI_HOME"
  git -C "$TAIGI_HOME" checkout --detach "$SOURCE_COMMIT"
fi

cd "$TAIGI_HOME"

uv venv --python "$PYTHON_VERSION" --allow-existing .venv
uv pip install -r requirements.txt --python "$TAIGI_HOME/.venv/bin/python"

if [ ! -f "$TAIGI_HOME/config.json" ]; then
  cp "$TAIGI_HOME/config.example.json" "$TAIGI_HOME/config.json"
fi

cat > "$TAIGI_HOME/setup_macos.sh" <<'TAIGI_SETUP_MACOS'
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_VERSION="${PYTHON_VERSION:-3.12}"

if ! command -v uv >/dev/null 2>&1; then
  echo "uv is required. Install it first, then rerun this script." >&2
  exit 1
fi

cd "$ROOT"
uv venv --python "$PYTHON_VERSION" --allow-existing .venv
uv pip install -r requirements.txt --python "$ROOT/.venv/bin/python"

if [ ! -f "$ROOT/config.json" ]; then
  cp "$ROOT/config.example.json" "$ROOT/config.json"
fi

echo "Taigi Teaching Agent is ready."
echo "Run: $ROOT/.venv/bin/python -m taigi doctor"
TAIGI_SETUP_MACOS
chmod +x "$TAIGI_HOME/setup_macos.sh"

cat > "$BIN_DIR/taigi-teaching-agent" <<TAIGI_WRAPPER
#!/usr/bin/env bash
set -euo pipefail

ROOT="\${TAIGI_TEACHING_AGENT_ROOT:-$TAIGI_HOME}"
PYTHON="\$ROOT/.venv/bin/python"

if [ ! -x "\$PYTHON" ]; then
  echo "Taigi Teaching Agent venv is missing. Run: \$ROOT/setup_macos.sh" >&2
  exit 1
fi

cd "\$ROOT"
exec "\$PYTHON" -m taigi "\$@"
TAIGI_WRAPPER
chmod +x "$BIN_DIR/taigi-teaching-agent"

"$BIN_DIR/taigi-teaching-agent" doctor
"$BIN_DIR/taigi-teaching-agent" piau "今仔日天氣真好" >/dev/null
"$BIN_DIR/taigi-teaching-agent" tts "食飯" -o /tmp/taigi_dummy.wav --provider dummy >/dev/null

echo "Taigi Teaching Agent installed."
echo "Command: $BIN_DIR/taigi-teaching-agent --help"
