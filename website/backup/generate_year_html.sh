#!/bin/bash
set -euo pipefail

YEAR=$1
OUTFILE="$HOME/ClimateInform/website/pages/forecasts/${YEAR}.html"

mkdir -p pages/forecasts

MONTHS=$(ls /home/ppeng/data/ss_fcst/pcr/$YEAR | sort -n)

cat > $OUTFILE <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${YEAR} Forecast Overview | ClimateInform</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>

<body>
<div id="header"></div>

<main>
    <h1>${YEAR} Climate Forecast Overview</h1>
    <p>Select a initial month below to view detailed forecast maps.</p>

    <section>
        <h2>Monthly Forecasts</h2>
        <ul>
EOF

for M in $MONTHS; do
    MONTH_PAD=$(printf "%02d" $M)
    cat >> $OUTFILE <<EOF
            <li><a href="${YEAR}-${MONTH_PAD}.html">${YEAR}-${MONTH_PAD}</a></li>
EOF
done

cat >> $OUTFILE <<EOF
        </ul>
    </section>
</main>

<div id="footer"></div>
</body>
</html>
EOF

echo "Generated: $OUTFILE"
