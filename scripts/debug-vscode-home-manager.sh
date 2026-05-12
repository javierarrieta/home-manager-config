#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
extensions_file="$repo_root/modules/editors.nix"
extensions_dir="${HOME}/.vscode/extensions"
hm_app="${HOME}/Applications/Home Manager Apps/Visual Studio Code.app"
system_app="/Applications/Visual Studio Code.app"
nix_profile_code="${HOME}/.nix-profile/bin/code"
hm_profile="${HOME}/.local/state/nix/profiles/home-manager"
user_profile="${HOME}/.local/state/nix/profiles/profile"

resolve_link() {
  local path="$1"

  if [ -L "$path" ]; then
    readlink "$path"
  elif [ -e "$path" ]; then
    printf '%s\n' "$path"
  else
    printf 'missing\n'
  fi
}

lower() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

print_path_state() {
  local label="$1"
  local path="$2"

  printf '%s: %s\n' "$label" "$path"
  printf '  resolved: %s\n' "$(resolve_link "$path")"
}

print_section() {
  printf '\n== %s ==\n' "$1"
}

read_lines() {
  local file="$1"
  local line

  while IFS= read -r line; do
    printf '%s\n' "$line"
  done < "$file"
}

configured_extensions() {
  awk '
    /profiles\.default\.extensions/ { in_block = 1; next }
    in_block && /\];/ { in_block = 0 }
    in_block {
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0)
      if ($0 ~ /^[[:alnum:]-]+\.[[:alnum:].-]+$/) {
        print $0
      }
    }
  ' "$extensions_file"
}

installed_extensions() {
  if [ ! -d "$extensions_dir" ]; then
    return
  fi

  find "$extensions_dir" -mindepth 1 -maxdepth 1 \( -type d -o -type l \) -exec basename {} \; |
    while IFS= read -r name; do
      printf '%s\n' "${name%-[0-9]*}"
    done |
    awk 'NF { print tolower($0) }' |
    sort -u
}

print_section "Paths"
print_path_state "repo root" "$repo_root"
if command -v code >/dev/null 2>&1; then
  printf 'code on PATH: %s\n' "$(command -v code)"
  printf '  resolved: %s\n' "$(resolve_link "$(command -v code)")"
else
  printf 'code on PATH: missing\n'
fi
print_path_state "~/.nix-profile/bin/code" "$nix_profile_code"
print_path_state "~/Applications/Home Manager Apps/Visual Studio Code.app" "$hm_app"
print_path_state "/Applications/Visual Studio Code.app" "$system_app"
print_path_state "~/.local/state/nix/profiles/home-manager" "$hm_profile"
print_path_state "~/.local/state/nix/profiles/profile" "$user_profile"

print_section "Versions"
if command -v code >/dev/null 2>&1; then
  if ! code --version 2>&1; then
    printf 'code --version failed\n'
  fi
else
  printf 'code is not available on PATH\n'
fi

print_section "Configured Extensions"
expected_file="$(mktemp)"
installed_file="$(mktemp)"
trap 'rm -f "$expected_file" "$installed_file"' EXIT

configured_extensions > "$expected_file"
expected_count="$(wc -l < "$expected_file" | tr -d ' ')"
printf 'count: %s\n' "$expected_count"
read_lines "$expected_file"

print_section "Installed Extensions"
if [ -d "$extensions_dir" ]; then
  installed_extensions > "$installed_file"
  installed_count="$(wc -l < "$installed_file" | tr -d ' ')"
  printf 'directory: %s\n' "$extensions_dir"
  printf 'count: %s\n' "$installed_count"
  read_lines "$installed_file"
else
  printf 'directory missing: %s\n' "$extensions_dir"
  : > "$installed_file"
fi

print_section "Configured But Missing"
missing=0
while IFS= read -r ext; do
  ext_lc="$(lower "$ext")"
  found=0

  while IFS= read -r installed_ext; do
    if [ "$installed_ext" = "$ext_lc" ]; then
      found=1
      break
    fi
  done < "$installed_file"

  if [ "$found" -eq 0 ]; then
    printf '%s\n' "$ext"
    missing=1
  fi
done < "$expected_file"

if [ "$missing" -eq 0 ]; then
  printf 'none\n'
fi

print_section "Home Manager Metadata"
if [ -f "$extensions_dir/.extensions-immutable.json" ]; then
  printf '.extensions-immutable.json: %s\n' "$(resolve_link "$extensions_dir/.extensions-immutable.json")"
else
  printf '.extensions-immutable.json: missing\n'
fi

if [ -f "$extensions_dir/.obsolete" ]; then
  printf '.obsolete entries:\n'
  cat "$extensions_dir/.obsolete"
else
  printf '.obsolete: missing\n'
fi
