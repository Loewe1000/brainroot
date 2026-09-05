#!/usr/bin/env bash
# Renders every picture in this folder to SVG. Run from the repository root.
set -euo pipefail
cd "$(dirname "$0")"
for f in example-*.typ themes.typ palettes.typ logo.typ; do
  typst compile --root .. --format svg "$f" "${f%.typ}.svg"
  echo "  → ${f%.typ}.svg"
done
