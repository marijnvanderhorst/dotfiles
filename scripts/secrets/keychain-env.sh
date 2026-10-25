#!/usr/bin/env bash
# keychain-env: print `export VAR=<value>` by reading a generic password
# from the macOS login Keychain. Use as: eval "$(keychain-env VAR [SERVICE])"
set -euo pipefail

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: keychain-env VAR_NAME [keychain_service_name]" >&2
  exit 64
fi

var="$1"
service="${2:-$1}"

if value=$(/usr/bin/security find-generic-password \
    -a "$USER" -s "$service" -w 2>/dev/null); then
  printf 'export %s=%q\n' "$var" "$value"
else
  echo "keychain-env: missing entry '$service' (run: keychain-sync $service)" >&2
  exit 1
fi
