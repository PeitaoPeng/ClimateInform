#!/bin/bash
set -euo pipefail

YEAR="$1"
MONTH="$2"
MONTH_PAD=$(printf "%02d" "$MONTH")

PNG_ROOT="/home/ppeng/data/ss_fcst/pcr"
PNG_DIR="${PNG_ROOT}/${YEAR}/${MONTH}"
OUTFILE="$HOME/ClimateInform/website/pages/forecasts/${YEAR}-${MONTH_PAD}.html"
GITHUB_BASE="https://raw.githubusercontent.com/PeitaoPeng/pngs/main/${YEAR}/${MONTH}"

echo "Generating monthly HTML: $OUTFILE"

if [ ! -d "$PNG_DIR" ]; then
    echo "[ERROR] PNG directory not found: $PNG_DIR"
    exit 1
fi

# ENSO phase
ENSO_PHASE="Neutral ENSO"
ENSO_PHASE_FILE="${PNG_DIR}/enso_phase.txt"
if [ -f "$ENSO_PHASE_FILE" ]; then
    RAW=$(tr '[:upper:]' '[:lower:]' < "$ENSO_PHASE_FILE")
    case "$RAW" in
        warm) ENSO_PHASE="El Niño" ;;
        cold) ENSO_PHASE="La Niña" ;;
        *)    ENSO_PHASE="Neutral ENSO" ;;
    esac
fi

###############################################
# START HTML
###############################################
cat > "$OUTFILE" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>${YEAR}-${MONTH_PAD} Forecast | ClimateInform</title>
<link rel="stylesheet" href="../../css/style.css">
</head>

<body>
<div id="header"></div>

<main>
<h1>${YEAR}-${MONTH_PAD} Climate Forecast</h1>
<p>Forecast maps for ${YEAR}-${MONTH_PAD}, organized by variable and lead time.</p>

<section>
<h2>Niño3.4 Index Forecast and Skill — <span class="enso-phase">${ENSO_PHASE}</span></h2>

<div class="forecast-pair-grid">
    <div class="forecast-pair-row">
        <div class="forecast-cell">
            <a href="${GITHUB_BASE}/nino34_fcst.png" target="_blank">
                <img src="${GITHUB_BASE}/nino34_fcst.png" alt="Niño3.4 Forecast">
            </a>
            <p>Niño3.4 SST Index Forecast</p>
        </div>
        <div class="forecast-cell">
            <a href="${GITHUB_BASE}/skill_nino34.png" target="_blank">
                <img src="${GITHUB_BASE}/skill_nino34.png" alt="Niño3.4 Skill">
            </a>
            <p>Niño3.4 Forecast Skill (ACC)</p>
        </div>
    </div>
</div>
</section>
EOF

###############################################
# SST BLOCK (forecast + ACC only)
###############################################
cat >> "$OUTFILE" <<EOF

<section class="variable-section">
    <div class="variable-header">
        <h2>SST</h2>
        <span class="variable-toggle">Hide</span>
    </div>

    <div class="variable-body">

    <h3>SST: Forecast & ACC Skill</h3>
    <div class="forecast-pair-grid">
EOF

for LEAD in {0..7}; do
    SST_FCST="sst_anom.${LEAD}.png"
    SST_ACC="sst_ACC.${LEAD}.png"

    if [ -f "$PNG_DIR/$SST_FCST" ] || [ -f "$PNG_DIR/$SST_ACC" ]; then
cat >> "$OUTFILE" <<EOF
        <div class="forecast-pair-row">
            <div class="forecast-cell">
                $( [ -f "$PNG_DIR/$SST_FCST" ] && echo "<a href=\"${GITHUB_BASE}/${SST_FCST}\" target=\"_blank\"><img src=\"${GITHUB_BASE}/${SST_FCST}\" alt=\"SST Forecast Lead ${LEAD}\"></a><p>Forecast Lead ${LEAD}</p>" )
            </div>
            <div class="forecast-cell">
                $( [ -f "$PNG_DIR/$SST_ACC" ] && echo "<a href=\"${GITHUB_BASE}/${SST_ACC}\" target=\"_blank\"><img src=\"${GITHUB_BASE}/${SST_ACC}\" alt=\"SST ACC Lead ${LEAD}\"></a><p>ACC Lead ${LEAD}</p>" )
            </div>
        </div>
EOF
    fi
done

cat >> "$OUTFILE" <<EOF
    </div> <!-- forecast-pair-grid -->
    </div> <!-- variable-body -->
</section>
EOF

###############################################
# ONLY t2m and prec are valid variables
###############################################
VARS="t2m prec"

###############################################
# OTHER VARIABLES
###############################################
for VAR in $VARS; do

cat >> "$OUTFILE" <<EOF

<section class="variable-section">
    <div class="variable-header">
        <h2>${VAR}</h2>
        <span class="variable-toggle">Hide</span>
    </div>

    <div class="variable-body">

    <h3>${VAR}: Deterministic & Probabilistic Forecasts</h3>
    <div class="forecast-pair-grid">
EOF

    for LEAD in {0..7}; do
        DET="${VAR}_det.${LEAD}.png"
        PROB="${VAR}_prob.${LEAD}.png"

        if [ -f "$PNG_DIR/$DET" ] || [ -f "$PNG_DIR/$PROB" ]; then
cat >> "$OUTFILE" <<EOF
        <div class="forecast-pair-row">
            <div class="forecast-cell">
                $( [ -f "$PNG_DIR/$DET" ] && echo "<a href=\"${GITHUB_BASE}/${DET}\" target=\"_blank\"><img src=\"${GITHUB_BASE}/${DET}\" alt=\"Det Lead ${LEAD}\"></a><p>Det Lead ${LEAD}</p>" )
            </div>
            <div class="forecast-cell">
                $( [ -f "$PNG_DIR/$PROB" ] && echo "<a href=\"${GITHUB_BASE}/${PROB}\" target=\"_blank\"><img src=\"${GITHUB_BASE}/${PROB}\" alt=\"Prob Lead ${LEAD}\"></a><p>Prob Lead ${LEAD}</p>" )
            </div>
        </div>
EOF
        fi
    done

cat >> "$OUTFILE" <<EOF
    </div> <!-- forecast-pair-grid -->
EOF

###############################################
# SKILL MATRIX (ACC | HSS | RPSS)
###############################################
    HAS_ACC=false
    HAS_HSS=false
    HAS_RPSS=false
    [ -f "$PNG_DIR/${VAR}_ACC.0.png" ]  && HAS_ACC=true
    [ -f "$PNG_DIR/${VAR}_HSS.0.png" ]  && HAS_HSS=true
    [ -f "$PNG_DIR/${VAR}_RPSS.0.png" ] && HAS_RPSS=true

    if $HAS_ACC || $HAS_HSS || $HAS_RPSS; then
cat >> "$OUTFILE" <<EOF
    <h3>Skill Maps</h3>
    <div class="skill-matrix">
        <div class="skill-matrix-header">
            <div class="skill-matrix-cell">Lead</div>
            <div class="skill-matrix-cell">ACC</div>
            <div class="skill-matrix-cell">HSS</div>
            <div class="skill-matrix-cell">RPSS</div>
        </div>
EOF

        for LEAD in {0..7}; do
            ACC="${VAR}_ACC.${LEAD}.png"
            HSS="${VAR}_HSS.${LEAD}.png"
            RPSS="${VAR}_RPSS.${LEAD}.png"

            if [ -f "$PNG_DIR/$ACC" ] || [ -f "$PNG_DIR/$HSS" ] || [ -f "$PNG_DIR/$RPSS" ]; then
cat >> "$OUTFILE" <<EOF
        <div class="skill-matrix-row">
            <div class="skill-matrix-cell">Lead ${LEAD}</div>
            <div class="skill-matrix-cell">
                $( [ -f "$PNG_DIR/$ACC" ] && echo "<a href=\"${GITHUB_BASE}/${ACC}\" target=\"_blank\"><img src=\"${GITHUB_BASE}/${ACC}\" alt=\"ACC Lead ${LEAD}\"></a>" )
            </div>
            <div class="skill-matrix-cell">
                $( [ -f "$PNG_DIR/$HSS" ] && echo "<a href=\"${GITHUB_BASE}/${HSS}\" target=\"_blank\"><img src=\"${GITHUB_BASE}/${HSS}\" alt=\"HSS Lead ${LEAD}\"></a>" )
            </div>
            <div class="skill-matrix-cell">
                $( [ -f "$PNG_DIR/$RPSS" ] && echo "<a href=\"${GITHUB_BASE}/${RPSS}\" target=\"_blank\"><img src=\"${GITHUB_BASE}/${RPSS}\" alt=\"RPSS Lead ${LEAD}\"></a>" )
            </div>
        </div>
EOF
            fi
        done

cat >> "$OUTFILE" <<EOF
    </div> <!-- skill-matrix -->
EOF
    fi

cat >> "$OUTFILE" <<EOF
    </div> <!-- variable-body -->
</section>

EOF

done

###############################################
# CLOSE HTML
###############################################
cat >> "$OUTFILE" <<EOF
</main>

<script>
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.variable-header').forEach(function (header) {
        header.addEventListener('click', function () {
            const body = header.nextElementSibling;
            const toggle = header.querySelector('.variable-toggle');
            const hidden = body.style.display === 'none';
            body.style.display = hidden ? 'block' : 'none';
            toggle.textContent = hidden ? 'Hide' : 'Show';
        });
    });
});
</script>

<div id="footer"></div>
</body>
</html>
EOF

