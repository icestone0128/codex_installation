#!/usr/bin/env bash

set -euo pipefail
umask 077

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PYTHON_TOOLS_HOME="${PYTHON_TOOLS_HOME:-$CODEX_HOME/python-tools}"
SECRETS_DIR="${SECRETS_DIR:-$CODEX_HOME/secrets}"
WORKSPACE_MCP_PORT="${WORKSPACE_MCP_PORT:-8000}"
WORKSPACE_MCP_BIN="${WORKSPACE_MCP_BIN:-$PYTHON_TOOLS_HOME/bin/workspace-mcp}"
WORKSPACE_MCP_CREDENTIALS_DIR="${WORKSPACE_MCP_CREDENTIALS_DIR:-$SECRETS_DIR/google_workspace_mcp_credentials}"

read_secret_file() {
  local secret_path="$1"
  local value

  [[ -f "$secret_path" ]] || return 1
  IFS= read -r value < "$secret_path"
  [[ -n "$value" ]] || return 1
  printf '%s' "$value"
}

if [[ ! -x "$WORKSPACE_MCP_BIN" ]]; then
  printf 'workspace-mcp executable not found: %s\n' "$WORKSPACE_MCP_BIN" >&2
  exit 1
fi

mkdir -p "$SECRETS_DIR" "$WORKSPACE_MCP_CREDENTIALS_DIR"
chmod 700 "$SECRETS_DIR" "$WORKSPACE_MCP_CREDENTIALS_DIR"

if client_id="$(read_secret_file "$SECRETS_DIR/google_workspace_mcp_oauth_client_id")"; then
  export GOOGLE_OAUTH_CLIENT_ID="$client_id"
fi

if client_secret="$(read_secret_file "$SECRETS_DIR/google_workspace_mcp_oauth_client_secret")"; then
  export GOOGLE_OAUTH_CLIENT_SECRET="$client_secret"
fi

if user_email="$(read_secret_file "$SECRETS_DIR/google_workspace_mcp_user_email")"; then
  export USER_GOOGLE_EMAIL="$user_email"
fi

export WORKSPACE_MCP_CREDENTIALS_DIR
export WORKSPACE_MCP_HOST="127.0.0.1"
export WORKSPACE_MCP_PORT
export WORKSPACE_MCP_PORT_FALLBACK_COUNT="0"

exec "$WORKSPACE_MCP_BIN" \
  --transport streamable-http \
  --permissions calendar:readonly drive:readonly gmail:readonly \
  --tool-tier core
