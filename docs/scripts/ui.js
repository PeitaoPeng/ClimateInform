// ---------------------------------------------------------
// ClimateInform Interactive UI (Seasonal + Monthly)
// ---------------------------------------------------------

// Back-to-Top Button Logic
const backToTopBtn = document.getElementById('back-to-top');

window.addEventListener('scroll', () => {
    const scrollTop = document.documentElement.scrollTop || document.body.scrollTop;

    if (scrollTop > 300) {
        backToTopBtn.classList.add('visible');
    } else {
        backToTopBtn.classList.remove('visible');
    }

    const scrollHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    const scrolledPercent = (scrollTop / scrollHeight) * 100;
    const bar = document.getElementById('scroll-progress');
    if (bar) bar.style.width = scrolledPercent + '%';
});

if (backToTopBtn) {
    backToTopBtn.addEventListener('click', () => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
}

// ---------------------------------------------------------
// Interactive Forecast Map Loader (Seasonal + Monthly)
// ---------------------------------------------------------

function populateYearMonth() {
    const yearSel = document.getElementById("year-select");
    const monthSel = document.getElementById("month-select");

    if (!yearSel || !monthSel) return;

    const currentYear = new Date().getFullYear();
    const startYear = 2020;

    for (let y = currentYear; y >= startYear; y--) {
        const opt = document.createElement("option");
        opt.value = y;
        opt.textContent = y;
        yearSel.appendChild(opt);
    }

    for (let m = 1; m <= 12; m++) {
        const opt = document.createElement("option");
        opt.value = m;
        opt.textContent = m;
        monthSel.appendChild(opt);
    }

    yearSel.value = currentYear;
    monthSel.value = new Date().getMonth() + 1;
}

function updateMap() {
    const img = document.getElementById("map-display");
    if (!img) return;

    const year = document.getElementById("year-select").value;
    const month = document.getElementById("month-select").value;
    const variable = document.getElementById("variable-select").value;
    const maptype = document.getElementById("maptype-select").value;
    const lead = document.getElementById("lead-select").value;

    const filename = `${variable}_${maptype}.${lead}.png`;
    const path = `https://raw.githubusercontent.com/PeitaoPeng/pngs/main/${year}/${month}/${filename}`;

    img.src = path;

    img.onerror = () => {
        img.src = "/assets/missing.png";
        img.alt = "Map not available";
    };
}

function attachListeners() {
    const ids = [
        "year-select",
        "month-select",
        "variable-select",
        "maptype-select",
        "lead-select"
    ];

    ids.forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener("change", updateMap);
    });
}

// ---------------------------------------------------------
// Initialize interactive forecast pages
// ---------------------------------------------------------

document.addEventListener("DOMContentLoaded", () => {
    populateYearMonth();
    attachListeners();

    // ⭐ Critical fix: ensure first map loads correctly
    setTimeout(updateMap, 100);
});

