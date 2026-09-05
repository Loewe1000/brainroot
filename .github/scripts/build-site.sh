#!/usr/bin/env bash
# =============================================================================
# build-site.sh — the manual for the package's own site
# =============================================================================
# Run from the repository root:
#
#     AGGREGAT=/path/to/Typst-Schule bash .github/scripts/build-site.sh
#
# Result in _site/:
#     index.html, docs.css, brainroot.pdf     the German manual
#     en.html, brainroot-en.pdf               the English manual
#     example.pdf                             every layout, theme and palette
#     llms.txt                                one line per chapter, for machines
#
# Why another repository is needed: docs/docs.typ builds on @schule/schuldocs,
# which lives in Typst-Schule. Taken over from typstage, minus its example
# decks.
# =============================================================================

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
AGGREGAT="${AGGREGAT:?AGGREGAT must point to a checkout of Typst-Schule}"
OUT="$ROOT/_site"
VERSION="$(sed -n 's/^version *= *"\(.*\)"/\1/p' "$ROOT/typst.toml" | head -1)"
PKGPATH="$(mktemp -d)"

trap 'rm -rf "$PKGPATH"' EXIT

# Package path: schuldocs from the aggregate, brainroot from *this* checkout,
# under both namespaces. The manual imports the package the way it is called
# after submission, `@preview/brainroot`; `--package-path` serves `preview`
# too, and packages missing there (cetz) still come from Typst's cache.
mkdir -p "$PKGPATH/schule/brainroot" "$PKGPATH/preview/brainroot"
cp -R "$AGGREGAT/schuldocs" "$PKGPATH/schule/schuldocs"
ln -s "$ROOT" "$PKGPATH/schule/brainroot/$VERSION"
ln -s "$ROOT" "$PKGPATH/preview/brainroot/$VERSION"

typst --version
echo "=== brainroot $VERSION ==="

rm -rf "$OUT"
mkdir -p "$OUT"

# --- Manuals (website, stylesheet and PDF in one bundle run each) -----------
# Two runs, because `docs()` is a show rule and writes exactly two outputs per
# file. The English file names its outputs itself (`en.html`,
# `brainroot-en.pdf`) and lands next to the German ones; both write
# `docs.css` with the same content.
for entry in docs.typ manual-en.typ; do
  (
    cd "$ROOT/docs"
    typst compile \
      --format bundle \
      --features bundle,html \
      --package-path "$PKGPATH" \
      --root "$ROOT" \
      "$entry" \
      "$OUT" \
      2>&1 | awk '!/^ *warning: (bundle|html) export/ && !/^ *= hint:/ && NF { print }'
    exit "${PIPESTATUS[0]}"
  )
done
[[ -f "$OUT/index.html" ]] || { echo "ERROR: manual without index.html" >&2; exit 1; }
[[ -f "$OUT/en.html" ]] || { echo "ERROR: English manual without en.html" >&2; exit 1; }
echo "  → manuals: index.html, en.html, docs.css, brainroot.pdf, brainroot-en.pdf"

# --- Example ----------------------------------------------------------------
typst compile --package-path "$PKGPATH" --root "$ROOT" "$ROOT/example.typ" "$OUT/example.pdf"
echo "  → example.pdf"

# --- llms.txt ---------------------------------------------------------------
python3 "$ROOT/.github/scripts/llms-txt.py" "$OUT"

echo "=== done in $OUT ==="
