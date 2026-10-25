#!/usr/bin/env bash
# keychain-sync: pull a secret from Bitwarden and store it in the macOS
# login Keychain as a generic password. Run once per secret (or on rotation).
set -euo pipefail

if [ $# -lt 1 ] || [ $# -gt 3 ]; then
  echo "Usage: keychain-sync <bitwarden_item> [keychain_service] [field]" >&2
  echo "  field defaults to 'password'" >&2
  exit 64
fi

item="$1"
service="${2:-$1}"
field="${3:-password}"

if ! command -v bw >/dev/null 2>&1; then
  echo "keychain-sync: 'bw' (bitwarden-cli) not found on PATH" >&2
  exit 127
fi

# Ensure bw is logged in
status=$(bw status 2>/dev/null || echo '{"status":"unauthenticated"}')
case "$status" in
  *'"status":"unauthenticated"'*)
    echo "keychain-sync: not logged in. Run 'bw login' first." >&2
    exit 1
    ;;
esac

# Ensure unlocked
if ! printf '%s' "$status" | grep -q '"status":"unlocked"'; then
  BW_SESSION=$(bw unlock --raw)
  export BW_SESSION
fi

value=$(bw get "$field" "$item")
/usr/bin/security add-generic-password \
  -a "$USER" -s "$service" -U -w "$value"
echo "Synced Bitwarden '$item' -> Keychain service '$service'"
