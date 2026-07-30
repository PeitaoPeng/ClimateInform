#!/bin/bash
set -euo pipefail

echo "============================================================"
echo " Cleaning ClimateInform Working Tree"
echo "============================================================"

cd /home/ppeng/ClimateInform

echo "Staging all modified and untracked files..."
git add -A

echo "Committing..."
git commit -m "Clean working tree before pipeline run" || echo "No changes to commit."

echo "Pushing..."
git push

echo "============================================================"
echo " Working tree cleaned."
echo " Current Git status:"
echo "============================================================"
git status

