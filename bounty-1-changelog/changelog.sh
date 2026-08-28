#!/usr/bin/env bash
set -euo pipefail

OUTPUT_FILE="${1:-CHANGELOG.md}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: run this script inside a Git repository." >&2
  exit 1
fi

last_tag="$(git describe --tags --abbrev=0 2>/dev/null || true)"
if [[ -n "$last_tag" ]]; then
  range="${last_tag}..HEAD"
  since_label="$last_tag"
else
  range="HEAD"
  since_label="repository start"
fi

mapfile -t commits < <(git log "$range" --pretty=format:'%s' --no-merges)

declare -a added=() fixed=() changed=() removed=()

categorize() {
  local subject="$1"
  local lower
  lower="$(printf '%s' "$subject" | tr '[:upper:]' '[:lower:]')"

  case "$lower" in
    feat:*|feat\(*|add:*|add\ *|new:*|new\ *) added+=("$subject") ;;
    fix:*|fix\(*|bugfix:*|bugfix\ *|hotfix:*|hotfix\ *) fixed+=("$subject") ;;
    remove:*|remove\ *|removed:*|delete:*|delete\ *|drop:*|drop\ *) removed+=("$subject") ;;
    *) changed+=("$subject") ;;
  esac
}

for subject in "${commits[@]}"; do
  [[ -n "$subject" ]] && categorize "$subject"
done

write_section() {
  local title="$1"
  shift
  local -a items=("$@")

  printf '## %s\n\n' "$title"
  if ((${#items[@]} == 0)); then
    printf -- '- None\n\n'
  else
    local item
    for item in "${items[@]}"; do
      printf -- '- %s\n' "$item"
    done
    printf '\n'
  fi
}

{
  printf '# Changelog\n\n'
  printf 'Generated from commits since **%s**.\n\n' "$since_label"
  write_section "Added" "${added[@]}"
  write_section "Fixed" "${fixed[@]}"
  write_section "Changed" "${changed[@]}"
  write_section "Removed" "${removed[@]}"
} > "$OUTPUT_FILE"

echo "Wrote $OUTPUT_FILE from ${#commits[@]} commit(s)."
