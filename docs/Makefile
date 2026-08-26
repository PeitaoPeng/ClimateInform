YEAR ?= 2025

# This Makefile lets you run everything with: make all YEAR=2025
 
all: upload monthly yearly update

upload:
    @if [ -f "./upload_pngs.sh" ]; then \
        echo "Uploading PNGs..."; \
        ./upload_pngs.sh; \
    else \
        echo "upload_pngs.sh not found — skipping upload step."; \
    fi

monthly:
    @echo "Generating monthly pages..."
    @for M in $$(seq 1 12); do \
        if [ -d "/home/ppeng/data/ss_fcst/pcr/$(YEAR)/$$M" ]; then \
            echo " → Generating $(YEAR)-$$M"; \
            ./generate_month_html.sh $(YEAR) $$M; \
        fi; \
    done

yearly:
    @echo "Generating yearly overview..."
    ./generate_year_html.sh $(YEAR)

update:
    @echo "Updating website repo..."
    cd website && git add . && git commit -m "Auto-update website for $(YEAR)" && git push

