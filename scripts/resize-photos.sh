#!/usr/bin/env bash
# resize-photos.sh
# -------------------------------------------------------------------
# Takes everything in /photos-raw and produces web-optimized JPEGs in
# /photos, then rewrites /photos/manifest.json for the carousel.
#
# Supports macOS `sips` when available; otherwise falls back to
# ImageMagick `magick`/`convert`.
# -------------------------------------------------------------------

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RAW_DIR="$REPO_ROOT/photos-raw"
OUT_DIR="$REPO_ROOT/photos"
MAX_EDGE=1600
QUALITY=80

if [ ! -d "$RAW_DIR" ]; then
  echo "Error: $RAW_DIR does not exist."
  exit 1
fi

mkdir -p "$OUT_DIR"

resize_one() {
  local src="$1" dest="$2"
  if command -v sips >/dev/null 2>&1; then
    sips -s format jpeg -s formatOptions "$QUALITY" -Z "$MAX_EDGE" "$src" --out "$dest" >/dev/null
  elif command -v magick >/dev/null 2>&1; then
    magick "$src" -auto-orient -resize "${MAX_EDGE}x${MAX_EDGE}>" -quality "$QUALITY" "$dest"
  elif command -v convert >/dev/null 2>&1; then
    convert "$src" -auto-orient -resize "${MAX_EDGE}x${MAX_EDGE}>" -quality "$QUALITY" "$dest"
  else
    echo "Error: need either macOS sips or ImageMagick (magick/convert)."
    exit 1
  fi
}

count=0
skipped=0

shopt -s nullglob nocaseglob
for src in "$RAW_DIR"/*.jpg "$RAW_DIR"/*.jpeg; do
  [ -f "$src" ] || continue
  base="$(basename "$src")"
  name="${base%.*}"
  dest="$OUT_DIR/$name.jpg"

  if [ -f "$dest" ] && [ "$dest" -nt "$src" ]; then
    skipped=$((skipped + 1))
    continue
  fi

  resize_one "$src" "$dest"
  count=$((count + 1))
  printf "  resized: %s\n" "$name.jpg"
done
shopt -u nocaseglob

echo ""
echo "Done. Resized $count file(s); skipped $skipped already up-to-date."

manifest="$OUT_DIR/manifest.json"
{
  printf '['
  first=1
  for f in "$OUT_DIR"/*.jpg; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"
    if [ $first -eq 1 ]; then
      first=0
      printf '\n  "%s"' "$name"
    else
      printf ',\n  "%s"' "$name"
    fi
  done
  printf '\n]\n'
} > "$manifest"

total=$(find "$OUT_DIR" -maxdepth 1 -type f -iname '*.jpg' | wc -l | tr -d ' ')
echo "Wrote manifest with $total photo(s) → $manifest"
