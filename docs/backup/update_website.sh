#!/bin/bash

YEAR=$1

# 1. Run your PNG upload script
./upload_pngs.sh

# 2. Generate monthly pages
for MONTH in {1..12}; do
    if [ -d "pngs/$YEAR/$MONTH" ]; then
        ./generate_month_html.sh $YEAR $MONTH
    fi
done

# 3. Generate yearly overview
./generate_year_html.sh $YEAR

# 4. Commit and push website
cd website
git add .
git commit -m "Auto-update website for $YEAR"
git push

