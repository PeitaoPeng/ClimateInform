#!/bin/bash
set -euo 

# ============================================================
# Clean the working tree before run pipline file
# Usage:
#     ./clean_working_tree.sh
# ============================================================

cd ~/ClimateInform
git add -A
git commit -m "Add 2026 forecast HTML pages"
git pull --rebase

echo "============================================================"
echo " clean working tree completed"
echo "============================================================"

