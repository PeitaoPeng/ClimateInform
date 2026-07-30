/home/ppeng/ClimateInform/README.md

# ClimateInform Operational Pipeline

This repository contains the operational workflow for maintaining the interactive forecast website **ClimateInform.com**.  
The pipeline is designed for reliability, transparency, and reproducibility, with no silent failures.

---

## Overview

The ClimateInform website displays seasonal and monthly forecast maps interactively using JavaScript (`ui.js`).  
All forecast PNGs are uploaded monthly and served directly from:
docs/pngs/<YEAR>/<MONTH>/

The pipeline performs:

1. PNG completeness checks  
2. PNG upload  
3. Timestamp updates  
4. Git commit + push  
5. Optional dry-run mode  
6. Automatic rollback on failure  
7. Diff summary before commit  

No HTML pages are generated dynamically — the site is fully interactive.

---

## Files

### **Main pipeline**
docs/climateinform_pipeline.sh

### **PNG upload script**
docs/upload_pngs.sh

### **Interactive website**
docs/index.html
docs/pages/forecasts/seasonal.html
docs/pages/forecasts/monthly.html
docs/css/style.css
docs/scripts/ui.js


### **Forecast PNGs**
docs/pngs/<YEAR>/<MONTH>/*.png


---

## Running the Pipeline

### Normal mode
bash docs/climateinform_pipeline.sh

---

## Directory Structure

ClimateInform/
├── docs/
│    ├── index.html
│    ├── pages/
│    │    └── forecasts/
│    │         ├── seasonal.html
│    │         └── monthly.html
│    ├── css/style.css
│    ├── scripts/ui.js
│    ├── pngs/
│    │    └── <YEAR>/<MONTH>/*.png
│    ├── climateinform_pipeline.sh
│    └── upload_pngs.sh
├── logs/
└── README.md

---

## Monthly Workflow

1. Generate new forecast PNGs in:
/home/ppeng/data/ss_fcst/pcr/<YEAR>/<MONTH>/

2. Run the pipeline:
bash docs/climateinform_pipeline.sh

3. The pipeline will:
- Check for missing PNGs  
- Upload PNGs  
- Update timestamps  
- Commit and push changes  

4. The interactive website automatically displays the new maps.

---

## Error Handling

- **Rollback on failure**  
If any command fails, the repository is restored to the last clean state.

- **Dry-run mode**  
Allows safe testing without modifying files.

- **Diff summary**  
Shows all changes before committing.

---

## Notes

- No HTML generation is needed — the site is fully interactive.
- PNGs must be placed in the correct directory structure.
- Timestamps are updated automatically in:
- `index.html`
- `seasonal.html`
- `monthly.html`

---

## Contact

For questions or improvements, contact:  
**Peitao Peng** — ClimateInform.com




