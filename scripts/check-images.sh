#!/usr/bin/env bash
# Fails if any chapter references an image file that does not exist.
set -euo pipefail
cd "$(dirname "$0")/.."

missing=0
for md in chapters/*.md; do
  dir=$(dirname "$md")
  while IFS= read -r path; do
    if [[ ! -f "$dir/$path" ]]; then
      echo "missing: $md -> $path"
      missing=1
    fi
  done < <(grep -oE '!\[[^]]*\]\([^)]+\)' "$md" | sed -E 's/.*\(([^)]+)\)/\1/')
done

if [[ $missing -ne 0 ]]; then
  exit 1
fi
echo "all image links resolve"
