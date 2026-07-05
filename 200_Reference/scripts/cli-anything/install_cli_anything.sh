#!/usr/bin/env bash

set -euo pipefail

CLI_ANYTHING_REPO="${CLI_ANYTHING_REPO:-https://github.com/HKUDS/CLI-Anything.git}"
CLI_ANYTHING_COMMIT="${CLI_ANYTHING_COMMIT:-dc7392489222dbcc520817609290755d6dd8b0bb}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PYTHON_TOOLS_ROOT="${PYTHON_TOOLS_ROOT:-$CODEX_HOME/python-tools}"
SOURCE_DIR="${SOURCE_DIR:-$PYTHON_TOOLS_ROOT/CLI-Anything}"
HUB_ROOT="${HUB_ROOT:-$PYTHON_TOOLS_ROOT/cli-anything-hub}"
BIN_DIR="${BIN_DIR:-$PYTHON_TOOLS_ROOT/bin}"
UV_CACHE_DIR="${UV_CACHE_DIR:-$PYTHON_TOOLS_ROOT/.uv-cache}"
PYTHON_VERSION="${PYTHON_VERSION:-3.12}"

log() {
  printf '[cli-anything] %s\n' "$*"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  }
}

need_cmd git
need_cmd bash
need_cmd uv

mkdir -p "$PYTHON_TOOLS_ROOT" "$BIN_DIR" "$UV_CACHE_DIR"

if [[ -d "$SOURCE_DIR/.git" ]]; then
  log "updating source checkout: $SOURCE_DIR"
  git -C "$SOURCE_DIR" fetch --tags origin
else
  if [[ -e "$SOURCE_DIR" ]]; then
    backup="${SOURCE_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
    log "source path exists but is not a git checkout; moving to $backup"
    mv "$SOURCE_DIR" "$backup"
  fi
  log "cloning $CLI_ANYTHING_REPO"
  git clone "$CLI_ANYTHING_REPO" "$SOURCE_DIR"
fi

git -C "$SOURCE_DIR" -c advice.detachedHead=false checkout "$CLI_ANYTHING_COMMIT"

skill_dir="$CODEX_HOME/skills/cli-anything"
if [[ -e "$skill_dir" ]]; then
  backup="${skill_dir}.backup.$(date +%Y%m%d-%H%M%S)"
  log "backing up existing Codex skill to $backup"
  mv "$skill_dir" "$backup"
fi

log "installing Codex cli-anything skill"
bash "$SOURCE_DIR/codex-skill/scripts/install.sh"

log "creating CLI-Hub virtual environment"
UV_CACHE_DIR="$UV_CACHE_DIR" uv venv --python "$PYTHON_VERSION" --allow-existing "$HUB_ROOT/.venv"

log "installing cli-anything-hub"
UV_CACHE_DIR="$UV_CACHE_DIR" uv pip install --python "$HUB_ROOT/.venv/bin/python" cli-anything-hub

log "writing cli-hub wrapper"
cat > "$BIN_DIR/cli-hub" <<EOF
#!/usr/bin/env bash
export HOME="$HUB_ROOT/home"
export CLI_HUB_NO_ANALYTICS=1
mkdir -p "\$HOME"
exec "$HUB_ROOT/.venv/bin/cli-hub" "\$@"
EOF
chmod +x "$BIN_DIR/cli-hub"

log "verifying Codex skill files"
test -f "$skill_dir/SKILL.md"
test -f "$skill_dir/references/HARNESS.md"
test -f "$skill_dir/references/commands/cli-anything.md"
test -f "$skill_dir/scripts/skill_generator.py"

log "verifying CLI-Hub"
"$BIN_DIR/cli-hub" --help >/dev/null
"$BIN_DIR/cli-hub" search image --json >/dev/null

log "installed"
log "source=$SOURCE_DIR"
log "commit=$(git -C "$SOURCE_DIR" rev-parse HEAD)"
log "skill=$skill_dir"
log "hub=$HUB_ROOT/.venv"
log "wrapper=$BIN_DIR/cli-hub"
log "restart Codex before expecting the new cli-anything skill to appear in fresh skill discovery."
