#!/bin/bash
set -euo pipefail

# ============================================================
# Upload html and other file to GitHub
# Usage:
#     ./upload_files.sh
# ============================================================

cd /home/ppeng/ClimateInform
git add docs/about_us.html
git commit -m "Add or update about_us.html"
git push

echo "============================================================"
echo " Upload completed"
echo "============================================================"
