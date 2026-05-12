#!/usr/bin/env bash

set -euo pipefail

logs_root="${HOME}/Library/Application Support/Code/logs"
extensions_dir="${HOME}/.vscode/extensions"

print_section() {
  printf '\n== %s ==\n' "$1"
}

if [ ! -d "$logs_root" ]; then
  printf 'VS Code logs directory missing: %s\n' "$logs_root"
  exit 1
fi

latest_log_dir="$(find "$logs_root" -mindepth 1 -maxdepth 1 -type d | sort | tail -n 1)"

if [ -z "$latest_log_dir" ]; then
  printf 'No VS Code log sessions found under %s\n' "$logs_root"
  exit 1
fi

print_section "Latest Session"
printf 'logs root: %s\n' "$logs_root"
printf 'latest: %s\n' "$latest_log_dir"

print_section "Extension Host Logs"
find "$latest_log_dir" -path '*/exthost/exthost.log' -print | sort

print_section "Load Errors"
rg -n -i \
  'incompatible|not compatible|disabled|rejected|skip(ped|ping)|cannot activate|failed to activate|extension host terminated|engine.*vscode|requires.*vscode|not found|unknown extension|corrupt' \
  "$latest_log_dir" \
  -g '*.log' || true

print_section "Activation Lines"
rg -n 'ExtensionService#_doActivateExtension' \
  "$latest_log_dir" \
  -g '*/exthost/exthost.log' || true

print_section "Configured Extension Activity"
if [ -d "$extensions_dir" ]; then
  find "$extensions_dir" -mindepth 1 -maxdepth 1 \( -type d -o -type l \) -exec basename {} \; |
    while IFS= read -r ext; do
      base="${ext%-[0-9]*}"
      rg -n -F "$base" "$latest_log_dir" -g '*.log' || true
    done
else
  printf 'extensions dir missing: %s\n' "$extensions_dir"
fi

print_section "Profile Cache"
cache_dir="${HOME}/Library/Application Support/Code/CachedProfilesData/__default__profile__"
if [ -d "$cache_dir" ]; then
  printf 'cache dir: %s\n' "$cache_dir"
  find "$cache_dir" -maxdepth 1 -type f | sort
else
  printf 'cache dir missing: %s\n' "$cache_dir"
fi
