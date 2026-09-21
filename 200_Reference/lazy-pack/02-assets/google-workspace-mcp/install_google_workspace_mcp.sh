#!/usr/bin/env bash

set -euo pipefail
umask 077

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PYTHON_TOOLS_HOME="${PYTHON_TOOLS_HOME:-$CODEX_HOME/python-tools}"
SECRETS_DIR="${SECRETS_DIR:-$CODEX_HOME/secrets}"
WORKSPACE_MCP_PORT="${WORKSPACE_MCP_PORT:-8000}"
WORKSPACE_MCP_READY_ATTEMPTS="${WORKSPACE_MCP_READY_ATTEMPTS:-15}"
# --agent all|claude|codex|antigravity (default all). REGISTER_* env vars still override per agent.
AGENT_TARGET="all"
CHECK_ONLY=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) CHECK_ONLY=1 ;;
    --agent=*) AGENT_TARGET="${1#--agent=}" ;;
    --agent) AGENT_TARGET="${2:?--agent requires all|claude|codex|antigravity}"; shift ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; exit 2 ;;
  esac
  shift
done
case "$AGENT_TARGET" in
  all|claude|codex|antigravity) ;;
  *) printf 'Invalid --agent value: %s\n' "$AGENT_TARGET" >&2; exit 2 ;;
esac
want_agent() { [[ "$AGENT_TARGET" == "all" || "$AGENT_TARGET" == "$1" ]] && echo 1 || echo 0; }
REGISTER_CLAUDE="${REGISTER_CLAUDE:-$(want_agent claude)}"
REGISTER_CODEX="${REGISTER_CODEX:-$(want_agent codex)}"
REGISTER_ANTIGRAVITY="${REGISTER_ANTIGRAVITY:-$(want_agent antigravity)}"
GEMINI_CONFIG="${GEMINI_CONFIG:-$HOME/.gemini/config}"
ANTIGRAVITY_MCP_CONFIG="$GEMINI_CONFIG/mcp_config.json"
CODEX_CONFIG="${CODEX_CONFIG:-$CODEX_HOME/config.toml}"
INSTALL_LAUNCH_AGENT="${INSTALL_LAUNCH_AGENT:-1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$PYTHON_TOOLS_HOME/bin"
UV_TOOL_DIR="$PYTHON_TOOLS_HOME/google-workspace-mcp/uv-tools"
UV_CACHE_DIR="$PYTHON_TOOLS_HOME/.uv-cache"
RUNNER_SOURCE="$SCRIPT_DIR/run_google_workspace_mcp.sh"
RUNNER_TARGET="$BIN_DIR/google-workspace-mcp-server"
WORKSPACE_MCP_BIN="$BIN_DIR/workspace-mcp"
WORKSPACE_CLI_BIN="$BIN_DIR/workspace-cli"
MCP_URL="http://127.0.0.1:$WORKSPACE_MCP_PORT/mcp"
CLAUDE_MCP_NAME="google-workspace"
MCP_NAME="google-workspace"
LAUNCH_AGENT_LABEL="com.lazy-pack.google-workspace-mcp"
LAUNCH_AGENT_TEMPLATE="$SCRIPT_DIR/$LAUNCH_AGENT_LABEL.plist.template"
LAUNCH_AGENT_PATH="$HOME/Library/LaunchAgents/$LAUNCH_AGENT_LABEL.plist"
LOG_DIR="$CODEX_HOME/logs"
STDOUT_LOG="$LOG_DIR/google-workspace-mcp.stdout.log"
STDERR_LOG="$LOG_DIR/google-workspace-mcp.stderr.log"
temp_plist=""
claude_details=""
workspace_tools=""

cleanup() {
  [[ -z "$temp_plist" ]] || rm -f "$temp_plist"
  [[ -z "$claude_details" ]] || rm -f "$claude_details"
  [[ -z "$workspace_tools" ]] || rm -f "$workspace_tools"
}

trap cleanup EXIT

log() {
  printf '[google-workspace-mcp] %s\n' "$*"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  }
}

verify_installation() {
  local attempt
  local require_endpoint="${1:-1}"
  local expected_tool
  local forbidden_tool

  test -x "$WORKSPACE_MCP_BIN"
  test -x "$WORKSPACE_CLI_BIN"
  test -x "$RUNNER_TARGET"

  "$WORKSPACE_MCP_BIN" --help >/dev/null
  "$WORKSPACE_CLI_BIN" --help >/dev/null

  if [[ "$require_endpoint" == "1" ]]; then
    workspace_tools="$(mktemp)"

    for ((attempt = 1; attempt <= WORKSPACE_MCP_READY_ATTEMPTS; attempt += 1)); do
      if "$WORKSPACE_CLI_BIN" --url "$MCP_URL" list > "$workspace_tools" 2>/dev/null; then
        log "MCP handshake passed: $MCP_URL"
        break
      fi
      sleep 1
    done

    if ((attempt > WORKSPACE_MCP_READY_ATTEMPTS)); then
      log "MCP endpoint is not ready: $MCP_URL"
      return 1
    fi

    # The contract follows the runner's --permissions: every enabled service must expose its
    # read tool, and write-capable tools are forbidden only when every service is readonly.
    local permissions
    permissions="$(grep -oE -- '--permissions[^\\]*' "$RUNNER_TARGET" | head -1 | sed 's/--permissions//')"
    if [[ -z "$permissions" ]]; then
      printf 'Cannot read --permissions from %s\n' "$RUNNER_TARGET" >&2
      return 1
    fi

    local entry service level all_readonly=1
    for entry in $permissions; do
      service="${entry%%:*}"
      level="${entry#*:}"
      [[ "$level" == "readonly" ]] || all_readonly=0
      case "$service" in
        calendar) expected_tool="list_calendars" ;;
        drive) expected_tool="search_drive_files" ;;
        gmail) expected_tool="search_gmail_messages" ;;
        docs) expected_tool="search_docs" ;;
        sheets) expected_tool="list_spreadsheets" ;;
        slides) expected_tool="get_presentation" ;;
        *) log "no read-tool mapping for service $service; skipped"; continue ;;
      esac
      if ! grep -F "$expected_tool" "$workspace_tools" >/dev/null; then
        printf 'Expected tool for %s is missing: %s\n' "$service" "$expected_tool" >&2
        return 1
      fi
    done

    if [[ "$all_readonly" == "1" ]]; then
      for forbidden_tool in manage_event create_drive_file create_drive_folder send_gmail_message; do
        if grep -F "$forbidden_tool" "$workspace_tools" >/dev/null; then
          printf 'Unexpected write-capable tool is enabled: %s\n' "$forbidden_tool" >&2
          return 1
        fi
      done
      log "read-only tool contract passed ($permissions)"
    else
      log "tool contract passed for write-enabled permissions ($permissions)"
    fi
  else
    log "endpoint check skipped; start $RUNNER_TARGET, then rerun with --check"
  fi

  if command -v claude >/dev/null 2>&1 && [[ "$REGISTER_CLAUDE" == "1" ]]; then
    claude mcp get "$CLAUDE_MCP_NAME" 2>/dev/null | grep -F "URL: $MCP_URL" >/dev/null
    log "Claude adapter points to $MCP_URL"
  fi

  if command -v codex >/dev/null 2>&1 && [[ "$REGISTER_CODEX" == "1" ]]; then
    codex mcp get "$MCP_NAME" 2>/dev/null | grep -F "$MCP_URL" >/dev/null
    log "Codex adapter points to $MCP_URL"
    if grep -A1 -E '^\[plugins\."(gmail|google-calendar|google-drive)@openai-curated"\]' "$CODEX_CONFIG" 2>/dev/null | grep -q '^enabled = true'; then
      printf 'Codex Google plugins are still enabled next to the MCP adapter.\n' >&2
      return 1
    fi
    log "Codex Google plugins disabled"
  fi

  if [[ "$REGISTER_ANTIGRAVITY" == "1" && -d "$GEMINI_CONFIG" ]]; then
    python3 - "$ANTIGRAVITY_MCP_CONFIG" "$MCP_NAME" "$MCP_URL" <<'PY'
import json, sys
path, name, url = sys.argv[1:4]
entry = json.load(open(path, encoding="utf-8")).get("mcpServers", {}).get(name, {})
if entry.get("serverUrl") != url:
    sys.exit(f"AntiGravity adapter missing or points elsewhere: {entry}")
PY
    log "AntiGravity adapter points to $MCP_URL"
  fi

  log "runtime=$WORKSPACE_MCP_BIN"
  log "credentials=$SECRETS_DIR/google_workspace_mcp_credentials"
}

if [[ "$CHECK_ONLY" == "1" ]]; then
  verify_installation 1
  exit 0
fi

need_cmd uv
need_cmd install
need_cmd sed

test -f "$RUNNER_SOURCE"
test -f "$LAUNCH_AGENT_TEMPLATE"

mkdir -p \
  "$BIN_DIR" \
  "$UV_TOOL_DIR" \
  "$UV_CACHE_DIR" \
  "$SECRETS_DIR/google_workspace_mcp_credentials" \
  "$LOG_DIR"
chmod 700 \
  "$SECRETS_DIR" \
  "$SECRETS_DIR/google_workspace_mcp_credentials" \
  "$LOG_DIR"

log "installing latest workspace-mcp"
# Python 3.12 is a compatibility ceiling shared with the Item 34 runtime, not a package pin.
env \
  UV_TOOL_DIR="$UV_TOOL_DIR" \
  UV_TOOL_BIN_DIR="$BIN_DIR" \
  UV_CACHE_DIR="$UV_CACHE_DIR" \
  uv tool install --force --upgrade --python 3.12 workspace-mcp
log "installed: $(env UV_TOOL_DIR="$UV_TOOL_DIR" UV_TOOL_BIN_DIR="$BIN_DIR" uv tool list 2>/dev/null | grep -m1 '^workspace-mcp ' || echo 'workspace-mcp (version unknown)')"

install -m 0755 "$RUNNER_SOURCE" "$RUNNER_TARGET"

if [[ "$(uname -s)" == "Darwin" && "$INSTALL_LAUNCH_AGENT" == "1" ]]; then
  mkdir -p "$HOME/Library/LaunchAgents"
  touch "$STDOUT_LOG" "$STDERR_LOG"
  chmod 600 "$STDOUT_LOG" "$STDERR_LOG"

  temp_plist="$(mktemp)"
  sed \
    -e "s|__WORKSPACE_MCP_RUNNER__|$RUNNER_TARGET|g" \
    -e "s|__WORKSPACE_MCP_STDOUT__|$STDOUT_LOG|g" \
    -e "s|__WORKSPACE_MCP_STDERR__|$STDERR_LOG|g" \
    "$LAUNCH_AGENT_TEMPLATE" > "$temp_plist"
  plutil -lint "$temp_plist" >/dev/null
  install -m 0600 "$temp_plist" "$LAUNCH_AGENT_PATH"

  launchctl bootout "gui/$UID" "$LAUNCH_AGENT_PATH" >/dev/null 2>&1 || true
  launchctl bootstrap "gui/$UID" "$LAUNCH_AGENT_PATH"
  launchctl kickstart -k "gui/$UID/$LAUNCH_AGENT_LABEL"
  log "LaunchAgent started: $LAUNCH_AGENT_LABEL"
  endpoint_required=1
else
  log "LaunchAgent not installed; start the server with $RUNNER_TARGET"
  endpoint_required=0
fi

if command -v claude >/dev/null 2>&1 && [[ "$REGISTER_CLAUDE" == "1" ]]; then
  claude_details="$(mktemp)"

  if claude mcp get "$CLAUDE_MCP_NAME" > "$claude_details" 2>/dev/null; then
    if ! grep -F "URL: $MCP_URL" "$claude_details" >/dev/null; then
      printf 'Claude MCP name %s already exists with a different endpoint.\n' "$CLAUDE_MCP_NAME" >&2
      exit 1
    fi
    log "Claude adapter already configured"
  else
    claude mcp add \
      --transport http \
      --scope user \
      "$CLAUDE_MCP_NAME" \
      "$MCP_URL"
    log "Claude adapter added"
  fi
fi

if command -v codex >/dev/null 2>&1 && [[ "$REGISTER_CODEX" == "1" ]]; then
  if codex mcp get "$MCP_NAME" >/dev/null 2>&1; then
    if ! codex mcp get "$MCP_NAME" 2>/dev/null | grep -F "$MCP_URL" >/dev/null; then
      printf 'Codex MCP name %s already exists with a different endpoint.\n' "$MCP_NAME" >&2
      exit 1
    fi
    log "Codex adapter already configured"
  else
    codex mcp add "$MCP_NAME" --url "$MCP_URL"
    log "Codex adapter added"
  fi

  # One tool surface per agent: turn off Codex's Google plugins that duplicate this MCP.
  if [[ -f "$CODEX_CONFIG" ]]; then
    cp -p "$CODEX_CONFIG" "$CODEX_CONFIG.bak.$(date +%Y%m%d-%H%M%S)"
    python3 - "$CODEX_CONFIG" <<'PY'
import re, sys
path = sys.argv[1]
text = open(path, encoding="utf-8").read()
for name in ("gmail", "google-calendar", "google-drive"):
    text = re.sub(r'(\[plugins\."%s@openai-curated"\]\nenabled = )true' % re.escape(name), r"\1false", text)
open(path, "w", encoding="utf-8").write(text)
PY
    log "Codex Google plugins disabled (backup next to $CODEX_CONFIG)"
  fi
fi

if [[ "$REGISTER_ANTIGRAVITY" == "1" && -d "$GEMINI_CONFIG" ]]; then
  [[ -f "$ANTIGRAVITY_MCP_CONFIG" ]] || printf '{\n  "mcpServers": {}\n}\n' > "$ANTIGRAVITY_MCP_CONFIG"
  cp -p "$ANTIGRAVITY_MCP_CONFIG" "$ANTIGRAVITY_MCP_CONFIG.bak.$(date +%Y%m%d-%H%M%S)"
  python3 - "$ANTIGRAVITY_MCP_CONFIG" "$MCP_NAME" "$MCP_URL" <<'PY'
import json, sys
path, name, url = sys.argv[1:4]
data = json.load(open(path, encoding="utf-8"))
servers = data.setdefault("mcpServers", {})
current = servers.get(name)
if current and current.get("serverUrl") not in (None, url):
    sys.exit(f"AntiGravity MCP name {name} already exists with a different endpoint")
servers[name] = {"serverUrl": url}
open(path, "w", encoding="utf-8").write(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
PY
  log "AntiGravity adapter written; reload AntiGravity to connect"
fi

verify_installation "$endpoint_required"

log "OAuth client files are intentionally not created by this installer."
log "Add them under $SECRETS_DIR only after creating your own Google Cloud OAuth client."
