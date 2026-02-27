#!/bin/bash
set -euo pipefail

cyr=`date --date='today' '+%Y'`
mcur=`date --date='today' '+%m'`  # current month

#cyr=2026
#for mcur in 01 02 03 04 05 06 07 08 09 10 11 12; do
#for mcur in 01 02 03 04 05 06 07 08 09 10 11 12; do
#for mcur in 02; do
#
if [ $mcur = 01 ]; then icmon=12; icmonc=Dec; fi
if [ $mcur = 02 ]; then icmon=1;  icmonc=Jan; fi
if [ $mcur = 03 ]; then icmon=2;  icmonc=Feb; fi
if [ $mcur = 04 ]; then icmon=3;  icmonc=Mar; fi
if [ $mcur = 05 ]; then icmon=4;  icmonc=Apr; fi
if [ $mcur = 06 ]; then icmon=5;  icmonc=May; fi
if [ $mcur = 07 ]; then icmon=6;  icmonc=Jun; fi
if [ $mcur = 08 ]; then icmon=7;  icmonc=Jul; fi
if [ $mcur = 09 ]; then icmon=8;  icmonc=Aug; fi
if [ $mcur = 10 ]; then icmon=9;  icmonc=Sep; fi
if [ $mcur = 11 ]; then icmon=10; icmonc=Oct; fi
if [ $mcur = 12 ]; then icmon=11; icmonc=Nov; fi
#
icyr=$cyr
if [ $icmon = 12 ]; then icyr=`expr $cyr - 1`; fi

YEAR=$icyr
MONTH=$icmon
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/pipeline_${YEAR}_$(date +%Y%m%d_%H%M%S).log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "============================================================"
echo " ClimateInform Pipeline Starting for YEAR = $YEAR"
echo " Log: $LOG_FILE"
echo "============================================================"

trap 'echo "[ERROR] Pipeline failed. See log: $LOG_FILE" >&2' ERR

if [ -f "./upload_pngs.sh" ]; then
    echo "Running PNG upload script..."
    ./upload_pngs.sh "$YEAR" "$MONTH"
else
    echo "WARNING: upload_pngs.sh not found — skipping upload step."
fi

echo "Generating monthly HTML pages..."
for MONTH in {1..12}; do
    if [ -d "/home/ppeng/data/ss_fcst/pcr/$YEAR/$MONTH" ]; then
        echo " → Generating page for $YEAR-$MONTH"
        ./generate_month_html.sh "$YEAR" "$MONTH"
    fi
done

echo "Generating yearly overview page..."
./generate_year_html.sh "$YEAR"

echo "Rebuilding Forecast Archive in index.html..."

ARCHIVE_HTML=""
for f in $HOME/ClimateInform/website/pages/forecasts/[0-9][0-9][0-9][0-9].html; do
    YEAR=$(basename "$f" .html)
    ARCHIVE_HTML="${ARCHIVE_HTML}    <tr><td><a href=\"pages/forecasts/${YEAR}.html\">${YEAR} Forecasts</a></td></tr>\n"
done

awk -v new="$ARCHIVE_HTML" '
  /<!-- ARCHIVE-START -->/ { print; print new; skip=1; next }
  /<!-- ARCHIVE-END -->/   { skip=0 }
  skip==0 { print }
' index.html > index.tmp && mv index.tmp index.html

sed -i "s|pages/forecasts/[0-9]\{4\}.html|pages/forecasts/${YEAR}.html|" index.html

echo "Updating website repo..."
cd $HOME/ClimateInform
git add .
git commit -m "Auto-update website for $YEAR" || echo "No changes to commit."
git push

echo "Updating top-level index.html..."
cd $HOME/ClimateInform
git add website/index.html
git commit -m "Update index.html" || echo "No changes to commit."
git push

echo "============================================================"
echo " ClimateInform Pipeline Completed Successfully"
echo "============================================================"
#done
