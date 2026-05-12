#!/usr/bin/env bash

set -euo pipefail

cache_dir="${HOME}/Library/Application Support/Code/CachedProfilesData/__default__profile__"
user_cache="${cache_dir}/extensions.user.cache"
builtin_cache="${cache_dir}/extensions.builtin.cache"

print_section() {
  printf '\n== %s ==\n' "$1"
}

print_file_summary() {
  local label="$1"
  local file="$2"

  print_section "$label"
  printf 'file: %s\n' "$file"

  if [ ! -f "$file" ]; then
    printf 'missing\n'
    return
  fi

  printf 'size: %s bytes\n' "$(wc -c < "$file" | tr -d ' ')"
  printf 'entries:\n'
  jq -r '
    .result
    | sort_by(.identifier.id)
    | .[]
    | [
        .identifier.id,
        .version,
        (.location.fsPath // .relativeLocation // "unknown")
      ]
    | @tsv
  ' "$file"
}

print_section "Profile Cache Directory"
printf 'cache dir: %s\n' "$cache_dir"

if [ ! -d "$cache_dir" ]; then
  printf 'missing\n'
  exit 1
fi

print_file_summary "User Cache" "$user_cache"
print_file_summary "Builtin Cache" "$builtin_cache"

print_section "Duplicate Extension IDs"
if [ -f "$user_cache" ] && [ -f "$builtin_cache" ]; then
  comm -12 \
    <(jq -r '.result[].identifier.id' "$user_cache" | sort -u) \
    <(jq -r '.result[].identifier.id' "$builtin_cache" | sort -u)
else
  printf 'cache file missing\n'
fi
