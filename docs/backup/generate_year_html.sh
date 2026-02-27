#!/bin/bash
set -euo pipefail

YEAR="$1"

OUTFILE="$HOME/ClimateInform/docs/pages/forecasts/${YEAR}.html"
DATA_DIR="/home/ppeng/data/ss_fcst/pcr/${YEAR}"

# Ensure data directory exists
if [ ! -d "$DATA_DIR" ]; then
    echo "[ERROR] Data directory not found: $DATA_DIR"
    exit 1
fi

# Detect available months (numeric only)
MONTHS=$(ls "$DATA_DIR" | grep -E '^[0-9]+$' | sort -n)

echo "Generating yearly overview: $OUTFILE"

###############################################
# START HTML FILE (safe, no stdout captured)
###############################################
cat > "$OUTFILE" <<EOF
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
    <p>Select an initial month below to view detailed forecast maps.</p>

    <section>
        <h2>Monthly Forecasts</h2>
        <ul>
EOF

###############################################
# MONTH LINKS (safe, no stdout captured)
###############################################
for M in $MONTHS; do
    MONTH_PAD=$(printf "%02d" "$M")
cat >> "$OUTFILE" <<EOF
            <li><a href="${YEAR}-${MONTH_PAD}.html">${YEAR}-${MONTH_PAD}</a></li>
EOF
done

###############################################
# CLOSE HTML
###############################################
cat >> "$OUTFILE" <<EOF
        </ul>
    </section>
</main>

<div id="footer"></div>
</body>
</html>
EOF

echo "Generated: $OUTFILE"
