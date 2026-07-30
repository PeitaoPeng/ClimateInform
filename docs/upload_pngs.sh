#!/bin/bash
set -euo pipefail

# ============================================================
# ClimateInform PNG Upload Script
# Uploads PNGs for a given YEAR and MONTH into docs/pngs/
# ============================================================

YEAR="$1"
MONTH="$2"

SRC_DIR="/home/ppeng/data/ss_fcst/pcr/$YEAR/$MONTH"
DEST_DIR="/home/ppeng/ClimateInform/docs/pngs/$YEAR/$MONTH"

echo "============================================================"
echo " Uploading PNGs for YEAR=$YEAR  MONTH=$MONTH"
echo " Source directory: $SRC_DIR"
echo " Destination directory: $DEST_DIR"
echo "============================================================"

# ------------------------------------------------------------
# Validate source directory
# ------------------------------------------------------------
if [[ ! -d "$SRC_DIR" ]]; then
    echo "ERROR: Source directory does not exist: $SRC_DIR"
    exit 1
fi

# ------------------------------------------------------------
# Create destination directory
# ------------------------------------------------------------
mkdir -p "$DEST_DIR"

# ------------------------------------------------------------
# Copy PNGs + HTML (if any)
# ------------------------------------------------------------
echo "Copying PNG and HTML files..."
cp -v "$SRC_DIR"/*.png "$DEST_DIR" 2>/dev/null || echo "No PNGs found."
cp -v "$SRC_DIR"/*.html "$DEST_DIR" 2>/dev/null || echo "No HTML files found."

# ------------------------------------------------------------
# Git staging
# ------------------------------------------------------------
echo "Staging changes..."
cd /home/ppeng/ClimateInform/docs

git add "pngs/$YEAR/$MONTH"

echo "Committing..."
git commit -m "Upload PNGs for $YEAR-$MONTH" || echo "No changes to commit."

echo "Pushing..."
git push

echo "============================================================"
echo " Upload complete for $YEAR-$MONTH"
echo "============================================================"

