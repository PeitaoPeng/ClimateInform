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

# Ensure PNG directory exists
if [ ! -d "$PNG_DIR" ]; then
    echo "[ERROR] PNG directory not found: $PNG_DIR"
    exit 1
fi

# ENSO phase
ENSO_PHASE_FILE="${PNG_DIR}/enso_phase.txt"
ENSO_PHASE="Neutral ENSO"
if [ -f "$ENSO_PHASE_FILE" ]; then
    RAW=$(tr '[:upper:]' '[:lower:]' < "$ENSO_PHASE_FILE")
    case "$RAW" in
        warm) ENSO_PHASE="El Niño" ;;
        cold) ENSO_PHASE="La Niña" ;;
        *)    ENSO_PHASE="Neutral ENSO" ;;
    esac
fi

###############################################
# START HTML FILE
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
<p>Forecast maps for ${YEAR}-${MONTH_PAD}, organized by variable, forecast type, and lead time.</p>

<section>
<h2>Niño3.4 Index Forecast and Skill — <span class="enso-phase">${ENSO_PHASE}</span></h2>

<div class="gallery-two">
    <div class="gallery-item">
        <a href="${GITHUB_BASE}/nino34_fcst.png" target="_blank">
            <img src="${GITHUB_BASE}/nino34_fcst.png" alt="Niño3.4 Forecast">
        </a>
        <p>Niño3.4 SST Index Forecast</p>
    </div>

    <div class="gallery-item">
        <a href="${GITHUB_BASE}/skill_nino34.png" target="_blank">
            <img src="${GITHUB_BASE}/skill_nino34.png" alt="Niño3.4 Skill">
        </a>
        <p>Niño3.4 Forecast Skill (ACC)</p>
    </div>
</div>
</section>
EOF

###############################################
# DETECT VARIABLES
###############################################
VARS=$(ls "$PNG_DIR"/*.png | sed 's#.*/##' | sed 's/\.[0-7]\.png//' | sed 's/_[A-Z]*$//' | sort -u)

###############################################
# VARIABLE SECTIONS
###############################################
for VAR in $VARS; do

cat >> "$OUTFILE" <<EOF

<section class="variable-section">
    <div class="variable-header">
        <h2>${VAR}</h2>
        <span class="variable-toggle">Hide</span>
    </div>

    <div class="variable-body">

    <div class="lead-slider">
        <label>Lead time: <span class="lead-value">0</span> months</label>
        <input type="range" min="0" max="7" value="0" data-var="${VAR}">
    </div>

    <h3>${VAR}: Deterministic & Probabilistic Forecasts</h3>
    <div class="forecast-pair-grid">
EOF

    ###########################################
    # PAIRED DET + PROB FORECASTS
    ###########################################
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

    ###########################################
    # SKILL MAPS
    ###########################################
    declare -a SKILLS=()
    [ -f "$PNG_DIR/${VAR}_ACC.0.png" ]  && SKILLS+=("ACC")
    [ -f "$PNG_DIR/${VAR}_HSS.0.png" ]  && SKILLS+=("HSS")
    [ -f "$PNG_DIR/${VAR}_RPSS.0.png" ] && SKILLS+=("RPSS")

    if [ ${#SKILLS[@]} -gt 0 ]; then
cat >> "$OUTFILE" <<EOF
    <h3>Skill Maps</h3>
    <div class="skill-three">
EOF

        for METRIC in "${SKILLS[@]}"; do
            for LEAD in {0..7}; do
                FILE="${VAR}_${METRIC}.${LEAD}.png"
                if [ -f "$PNG_DIR/$FILE" ]; then
cat >> "$OUTFILE" <<EOF
        <a class="lead-item" data-var="${VAR}" data-lead="${LEAD}" href="${GITHUB_BASE}/${FILE}" target="_blank">
            <img src="${GITHUB_BASE}/${FILE}" alt="${METRIC} Lead ${LEAD}">
            <p>${METRIC} Lead ${LEAD}</p>
        </a>
EOF
                fi
            done
        done

cat >> "$OUTFILE" <<EOF
    </div> <!-- skill-three -->
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

    document.querySelectorAll('.lead-slider input[type="range"]').forEach(function (slider) {
        const varName = slider.dataset.var;
        const labelSpan = slider.parentElement.querySelector('.lead-value');

        function updateLead() {
            const lead = slider.value;
            labelSpan.textContent = lead;
            document.querySelectorAll('.lead-item[data-var="' + varName + '"]').forEach(function (el) {
                el.style.display = (el.dataset.lead === lead) ? 'block' : 'none';
            });
        }

        slider.addEventListener('input', updateLead);
        updateLead();
    });
});
</script>

<div id="footer"></div>
</body>
</html>
EOF

