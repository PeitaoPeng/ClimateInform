#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------
# Dry-run mode: ./climateinform_pipeline.sh --dry
# ------------------------------------------------------------
DRYRUN=0
if [[ "${1:-}" == "--dry" ]]; then
    DRYRUN=1
    echo "Running in DRY-RUN mode — no files will be modified."
fi

run() {
    if [[ $DRYRUN -eq 1 ]]; then
        echo "[DRYRUN] $*"
    else
        eval "$*"
    fi
}

# ------------------------------------------------------------
# Rollback on failure (atomic pipeline)
# ------------------------------------------------------------
rollback() {
    echo "[ROLLBACK] Restoring last clean state..."
    git reset --hard HEAD
    git clean -fd
    echo "[ROLLBACK] Completed."
}
trap rollback ERR

# ------------------------------------------------------------
# Current year/month
# ------------------------------------------------------------
curyr=$(date +%Y)
curmo=$(date +%m)
#curyr=2025
#for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#for curmo in 01 02 03 04 05 06; do
#curmo=07

case "$curmo" in
  01) cmon=1 ;;
  02) cmon=2 ;;
  03) cmon=3 ;;
  04) cmon=4 ;;
  05) cmon=5 ;;
  06) cmon=6 ;;
  07) cmon=7 ;;
  08) cmon=8 ;;
  09) cmon=9 ;;
  10) cmon=10 ;;
  11) cmon=11 ;;
  12) cmon=12 ;;
esac

YEAR=$curyr
MONTH=$cmon

REPO_ROOT="/home/ppeng/ClimateInform"
DOCS_ROOT="$REPO_ROOT/docs"

LOG_DIR="$REPO_ROOT/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/pipeline_${YEAR}_$(date +%Y%m%d_%H%M%S).log"

cd "$REPO_ROOT"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "============================================================"
echo " ClimateInform Pipeline Starting for YEAR = $YEAR, MONTH = $MONTH"
echo " Log: $LOG_FILE"
echo "============================================================"

# ------------------------------------------------------------
# 1. Detect missing PNGs
# ------------------------------------------------------------
echo "Checking for missing PNGs..."

PNG_DIR="/home/ppeng/data/ss_fcst/pcr/$YEAR/$MONTH"

if [[ -d "$PNG_DIR" ]]; then
    missing=0
    for f in "$PNG_DIR"/*.png; do
        if [[ ! -f "$f" ]]; then
            echo "WARNING: Missing PNG: $f"
            missing=1
        fi
    done

    if [[ $missing -eq 1 ]]; then
        echo "WARNING: Some PNGs are missing for $YEAR-$MONTH"
    else
        echo "All PNGs present for $YEAR-$MONTH"
    fi
else
    echo "WARNING: PNG directory not found: $PNG_DIR"
fi

# ------------------------------------------------------------
# 2. Upload PNGs
# ------------------------------------------------------------
# ------------------------------------------------------------
# Ensure /home/ppeng/pngs is a valid git repo
# ------------------------------------------------------------
PNG_REPO="/home/ppeng/pngs"

echo "Checking PNG repo at $PNG_REPO..."

if [[ ! -d "$PNG_REPO/.git" ]]; then
    echo "PNG repo missing or not a git repository. Recreating..."
    rm -rf "$PNG_REPO"
    git clone https://github.com/PeitaoPeng/pngs.git "$PNG_REPO"
    echo "PNG repo cloned successfully."
else
    echo "PNG repo exists and is a valid git repository."
fi

if [[ -f "$DOCS_ROOT/upload_pngs.sh" ]]; then
    echo "Running PNG upload script..."
    run "$DOCS_ROOT/upload_pngs.sh $YEAR $MONTH"
else
    echo "WARNING: upload_pngs.sh not found — skipping upload step."
fi

# ------------------------------------------------------------
# 3. Timestamp updates
# ------------------------------------------------------------
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

echo "Updating timestamps..."

run "sed -i \"s|<!--TIMESTAMP-->|Last updated: $timestamp|g\" $DOCS_ROOT/index.html"

for f in "$DOCS_ROOT/pages/forecasts/seasonal.html" \
         "$DOCS_ROOT/pages/forecasts/monthly.html"; do
    if [[ -f "$f" ]]; then
        run "sed -i \"s|<!--UPDATED-->|Updated: $timestamp|g\" \"$f\""
        echo "Updated timestamp in $(basename "$f")"
    else
        echo "WARNING: Missing forecast page: $f"
    fi
done

# ------------------------------------------------------------
# 4. Diff summary before commit
# ------------------------------------------------------------
echo "============================================================"
echo " Diff Summary (pre-commit)"
echo "============================================================"
git status
git diff --stat
echo "============================================================"

# ------------------------------------------------------------
# 5. Git workflow
# ------------------------------------------------------------
echo "Updating website repo..."
cd "$REPO_ROOT"

run "git pull --rebase"
run "git add -A"
run "git commit -m \"Interactive site update for YEAR=$YEAR\" || echo \"No changes to commit.\""
run "git push"

echo "============================================================"
echo " ClimateInform Pipeline Completed Successfully"
echo "============================================================"

#done # mcur loop
