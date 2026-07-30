// ---------------------------------------------------------
// ClimateInform Interactive UI (Seasonal + Monthly)
// ---------------------------------------------------------

// Back-to-Top Button Logic
const backToTopBtn = document.getElementById('back-to-top');

window.addEventListener('scroll', () => {
    const scrollTop = document.documentElement.scrollTop || document.body.scrollTop;

    // Show/hide Back-to-Top button
    if (scrollTop > 300) {
        backToTopBtn.classList.add('visible');
    } else {
        backToTopBtn.classList.remove('visible');
    }

    // Update scroll progress bar
    const scrollHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    const scrolledPercent = (scrollTop / scrollHeight) * 100;
    const bar = document.getElementById('scroll-progress');
    if (bar) bar.style.width = scrolledPercent + '%';
});

// Smooth scroll to top
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

    if (!yearSel || !monthSel) return; // Not on forecast page

    const currentYear = new Date().getFullYear();
    const startYear = 2020;

    // Populate years
    for (let y = currentYear; y >= startYear; y--) {
        const opt = document.createElement("option");
        opt.value = y;
        opt.textContent = y;
        yearSel.appendChild(opt);
    }

    // Populate months (1–12)
    for (let m = 1; m <= 12; m++) {
        const opt = document.createElement("option");
        opt.value = m;
        opt.textContent = m;
        monthSel.appendChild(opt);
    }

    // Default selections
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

    // Construct filename: variable_maptype.lead.png
    const filename = `${variable}_${maptype}.${lead}.png`;
    const path = `/pngs/${year}/${month}/${filename}`;

    // Try loading the image
    img.src = path;

    img.onerror = () => {
        img.src = "/assets/missing.png";  // You can add this file
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
});

