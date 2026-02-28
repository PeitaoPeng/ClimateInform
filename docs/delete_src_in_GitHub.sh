#!/bin/sh
set -eaux
cd /home/ppeng/ClimateInform

git rm -r --cached src
git add .gitignore
git commit -m "Ignore src folder"
git push

git add .gitignore
git rm -r --cached src
git commit -m "Ignore src folder"
git push

