#!/bin/bash
set -euo pipefail

YEAR=$1
MONTH=$2
MONTH_PAD=$(printf "%02d" $MONTH)

PNG_ROOT=${PNG_ROOT:-/home/ppeng/data/ss_fcst/pcr}
PNG_DIR="${PNG_ROOT}/${YEAR}/${MONTH}"
OUTFILE="$HOME/ClimateInform/website/pages/forecasts/${YEAR}-${MONTH_PAD}.html"
GITHUB_BASE="https://raw.githubusercontent.com/PeitaoPeng/pngs/main/$YEAR/$MONTH"

mkdir -p website/pages/forecasts

echo "Generating monthly HTML: $OUTFILE"

# ENSO phase file: warm / cold / neutral
ENSO_PHASE_FILE="${PNG_DIR}/enso_phase.txt"
ENSO_PHASE="neutral"
if [ -f "$ENSO_PHASE_FILE" ]; then
    ENSO_PHASE=$(tr '[:upper:]' '[:lower:]' < "$ENSO_PHASE_FILE")
fi

cat > $OUTFILE <<EOF
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
    <p>Forecast maps for ${YEAR}-${MONTH_PAD}, organized by variable, forecast type, and lead time. Skill maps are included for each variable.</p>
EOF

# Niño3.4 block with ENSO badge
cat >> $OUTFILE <<EOF

    <section>
        <h2>Niño3.4 Index Forecast and Skill
EOF

case "$ENSO_PHASE" in
    warm)
        cat >> $OUTFILE <<EOF
            <span class="enso-phase enso-warm">El Niño</span>
EOF
        ;;
    cold)
        cat >> $OUTFILE <<EOF
            <span class="enso-phase enso-cold">La Niña</span>
EOF
        ;;
    *)
        cat >> $OUTFILE <<EOF
            <span class="enso-phase enso-neutral">Neutral ENSO</span>
EOF
        ;;
esac

cat >> $OUTFILE <<EOF
        </h2>

        <div class="gallery-two">
            <div class="gallery-item">
                <img src="${GITHUB_BASE}/nino34_fcst.png" alt="Niño3.4 Forecast">
                <p>Niño3.4 SST Index Forecast</p>
            </div>

            <div class="gallery-item">
                <img src="${GITHUB_BASE}/skill_nino34.png" alt="Niño3.4 Skill">
                <p>Niño3.4 Forecast Skill (ACC)</p>
            </div>
        </div>
    </section>

EOF

# Detect variables
VARS=$(ls "$PNG_DIR" | sed 's/\.[0-7].png//' | sed 's/_[A-Z]*$//' | sort -u)

for VAR in $VARS; do
    echo "Processing variable: $VAR"

    cat >> $OUTFILE <<EOF

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
EOF

    TYPES=()
    if ls "$PNG_DIR"/${VAR}_det.*.png >/dev/null 2>&1; then TYPES+=("${VAR}_det"); fi
    if ls "$PNG_DIR"/${VAR}_prob.*.png >/dev/null 2>&1; then TYPES+=("${VAR}_prob"); fi
    if ls "$PNG_DIR"/${VAR}_anom.*.png >/dev/null 2>&1; then TYPES+=("${VAR}_anom"); fi

    SKILLS=()
    if ls "$PNG_DIR"/${VAR}_ACC.*.png >/dev/null 2>&1; then SKILLS+=("${VAR}_ACC"); fi
    if ls "$PNG_DIR"/${VAR}_HSS.*.png >/dev/null 2>&1; then SKILLS+=("${VAR}_HSS"); fi
    if ls "$PNG_DIR"/${VAR}_RPSS.*.png >/dev/null 2>&1; then SKILLS+=("${VAR}_RPSS"); fi

    # Forecast maps
    for TYPE in "${TYPES[@]}"; do
        LABEL=$(echo "$TYPE" | sed "s/${VAR}_//" | tr '[:lower:]' '[:upper:]')
        [ "$LABEL" = "ANOM" ] && LABEL="DETERMINISTIC"

        cat >> $OUTFILE <<EOF
        <h3>${LABEL} Forecasts</h3>
        <div class="gallery">
EOF

        for LEAD in {0..7}; do
            FILE="${TYPE}.${LEAD}.png"
            if [ -f "$PNG_DIR/$FILE" ]; then
                cat >> $OUTFILE <<EOF
            <div class="gallery-item lead-item" data-var="${VAR}" data-lead="${LEAD}">
                <img src="${GITHUB_BASE}/${FILE}" alt="${TYPE} Lead ${LEAD}">
                <p>Lead ${LEAD}</p>
            </div>
EOF
            fi
        done

        cat >> $OUTFILE <<EOF
        </div>
EOF
    done

    # Skill maps
    if [ ${#SKILLS[@]} -gt 0 ]; then
        cat >> $OUTFILE <<EOF
        <h3>Skill Maps</h3>
        <div class="skill-three">
EOF

        # ACC
        if ls "$PNG_DIR"/${VAR}_ACC.*.png >/dev/null 2>&1; then
            for LEAD in {0..7}; do
                FILE="${VAR}_ACC.${LEAD}.png"
                if [ -f "$PNG_DIR/$FILE" ]; then
                    cat >> $OUTFILE <<EOF
            <a class="lead-item" data-var="${VAR}" data-lead="${LEAD}" href="${GITHUB_BASE}/${FILE}" target="_blank" title="ACC Lead ${LEAD}">
                <img src="${GITHUB_BASE}/${FILE}" alt="ACC Lead ${LEAD}">
                <p>ACC Lead ${LEAD}</p>
            </a>
EOF
                fi
            done
        fi

        # HSS
        if ls "$PNG_DIR"/${VAR}_HSS.*.png >/dev/null 2>&1; then
            for LEAD in {0..7}; do
                FILE="${VAR}_HSS.${LEAD}.png"
                if [ -f "$PNG_DIR/$FILE" ]; then
                    cat >> $OUTFILE <<EOF
            <a class="lead-item" data-var="${VAR}" data-lead="${LEAD}" href="${GITHUB_BASE}/${FILE}" target="_blank" title="HSS Lead ${LEAD}">
                <img src="${GITHUB_BASE}/${FILE}" alt="HSS Lead ${LEAD}">
                <p>HSS Lead ${LEAD}</p>
            </a>
EOF
                fi
            done
        fi

        # RPSS
        if ls "$PNG_DIR"/${VAR}_RPSS.*.png >/dev/null 2>&1; then
            for LEAD in {0..7}; do
                FILE="${VAR}_RPSS.${LEAD}.png"
                if [ -f "$PNG_DIR/$FILE" ]; then
                    cat >> $OUTFILE <<EOF
            <a class="lead-item" data-var="${VAR}" data-lead="${LEAD}" href="${GITHUB_BASE}/${FILE}" target="_blank" title="RPSS Lead ${LEAD}">
                <img src="${GITHUB_BASE}/${FILE}" alt="RPSS Lead ${LEAD}">
                <p>RPSS Lead ${LEAD}</p>
            </a>
EOF
                fi
            done
        fi

        cat >> $OUTFILE <<EOF
        </div>
EOF
    fi

    cat >> $OUTFILE <<EOF
        </div> <!-- variable-body -->
    </section>

EOF

done

cat >> $OUTFILE <<EOF
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

echo "Done: $OUTFILE"
