#!/bin/bash
set -euo pipefail

YEAR="$1"
MONTH="$2"

SRC_DIR="/home/ppeng/data/ss_fcst/pcr/$YEAR/$MONTH"
DEST_REPO="/home/ppeng/pngs"
DEST_DIR="$DEST_REPO/$YEAR/$MONTH"

echo "============================================================"
echo " Uploading PNGs for YEAR=$YEAR  MONTH=$MONTH"
echo " Source directory: $SRC_DIR"
echo " Destination repo: $DEST_REPO"
echo "============================================================"

if [[ ! -d "$SRC_DIR" ]]; then
    echo "ERROR: Source directory does not exist: $SRC_DIR"
    exit 1
fi

mkdir -p "$DEST_DIR"

echo "Copying PNG and HTML files into pngs repo..."
cp -v "$SRC_DIR"/*.png "$DEST_DIR" 2>/dev/null || echo "No PNGs found."
cp -v "$SRC_DIR"/*.html "$DEST_DIR" 2>/dev/null || echo "No HTML files found."

echo "Staging changes in pngs repo..."
cd "$DEST_REPO"

git add "$YEAR/$MONTH"

echo "Committing..."
git commit -m "Upload PNGs for $YEAR-$MONTH" || echo "No changes to commit."

echo "Pushing..."
git push

echo "============================================================"
echo " Upload complete for $YEAR-$MONTH"
echo "============================================================"

