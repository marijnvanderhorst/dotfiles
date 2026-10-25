# keychain_env VAR [SERVICE]
# direnv stdlib helper. Loads a secret from the macOS login Keychain into
# the env. SERVICE defaults to VAR. Seed entries with `keychain-sync`.
keychain_env() {
  if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    log_error "keychain_env: usage: keychain_env VAR [SERVICE]"
    return 1
  fi
  local var="$1"
  local service="${2:-$1}"
  local value
  if value=$(/usr/bin/security find-generic-password -a "$USER" -s "$service" -w 2>/dev/null); then
    export "$var=$value"
  else
    log_error "keychain_env: missing Keychain entry '$service' (run: keychain-sync $service)"
    return 1
  fi
}
