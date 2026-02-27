#!/bin/bash
set -euo pipefail

# ============================================================
# Upload PNG + HTML files for a specific YEAR and MONTH
# Usage:
#     ./upload_pngs.sh 2025 02
# ============================================================

YEAR=$1
MONTH=$2

# Convert MONTH to no-leading-zero version for local directory
#MONTH_NOZERO=$(echo $MONTH | sed 's/^0*//')

# ===== CONFIGURATION =====
REPO_SSH="git@github.com:PeitaoPeng/pngs.git"
LOCAL_DIR="$HOME/tmp/pngs"                     # local clone of pngs repo
#SOURCE_DATA_DIR="$HOME/ss_fcst/pcr/$YEAR/$MONTH_NOZERO"   # where PNGs live
SOURCE_DATA_DIR="$HOME/ss_fcst/pcr/$YEAR/$MONTH"   # where PNGs live

echo "============================================================"
echo " Uploading PNGs for YEAR=$YEAR  MONTH=$MONTH"
echo " Source directory: $SOURCE_DATA_DIR"
echo "============================================================"

# ===== CLONE OR UPDATE REPO =====
if [ ! -d "$LOCAL_DIR/.git" ]; then
    echo "Cloning pngs repository..."
    git clone "$REPO_SSH" "$LOCAL_DIR"
else
    echo "Updating existing pngs repository..."
    cd "$LOCAL_DIR"
    git pull
fi

cd "$LOCAL_DIR"

# ===== TARGET DIRECTORY =====
TARGET="$LOCAL_DIR/$YEAR/$MONTH"
echo "Creating target directory: $TARGET"
mkdir -p "$TARGET"

# ===== COPY FILES =====
echo "Copying PNG and HTML files..."
cp "$SOURCE_DATA_DIR"/*.png "$TARGET" 2>/dev/null || true

# ===== COMMIT & PUSH =====
echo "Staging changes..."
git add "$YEAR/$MONTH"

echo "Committing..."
git commit -m "Upload PNGs for $YEAR-$MONTH" || echo "No changes to commit."

echo "Pushing..."
git push

echo "============================================================"
echo " Upload complete for $YEAR-$MONTH"
echo "============================================================"
