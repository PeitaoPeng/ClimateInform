#!/bin/sh

#!/bin/sh

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/tmp
bindir=/home/ppeng/ClimateInform/src/bin
HOME=/home/ppeng/

# Ensure Git identity is available even with overridden HOME
git config --global user.name "Peitao Peng"
git config --global user.email "peitaopeng@icloud.com"

cd $tmp

for icyr in 2025 2026; do
for icmon in 1 2 3 4 5 6 7 8 9 10 11 12; do

# ===== CONFIGURATION =====
REPO_SSH="git@github.com:PeitaoPeng/pngs.git"
LOCAL_DIR="$HOME/tmp/pngs"
SOURCE_DATA_DIR="$HOME/ss_fcst/pcr/$icyr/$icmon"

# ===== CLONE REPO IF NEEDED =====
if [ ! -d "$LOCAL_DIR/.git" ]; then
    echo "Cloning repository..."
    git clone "$REPO_SSH" "$LOCAL_DIR"
fi

cd "$LOCAL_DIR"

# ===== CHECK IF REMOTE MAIN BRANCH EXISTS =====
if ! git ls-remote --exit-code origin main >/dev/null 2>&1; then
    echo "Remote 'main' branch does not exist. Initializing repository..."
    git add .
    git commit --allow-empty -m "Initial commit"
    git branch -M main
    git push -u origin main
fi

# ===== NOW SAFE TO PULL =====
echo "Pulling latest changes..."
git pull

# ===== FUNCTION TO PROCESS ONE MONTH =====
process_month() {
    y=$1
    m=$2
    src="$HOME/ss_fcst/pcr/$y/$m"
    target="$LOCAL_DIR/$y/$m"

    echo "----------------------------------------"
    echo "Processing $y-$m"
    echo "Creating directory: $target"
    mkdir -p "$target"

    echo "Copying PNG and HTML files from $src to $target"
    cp "$src"/*.png "$target" || true

    echo "Staging changes..."
    git add "$y/$m"
}

done  # icmon loop
done  # icyr loop

# ===== COMMIT & PUSH AFTER ALL MONTHS =====
echo "Committing and pushing..."
git commit -m "Add PNGs for automated upload" || true
git push

echo "Upload complete!"

# After uploading PNGs to GitHub
./generate_month_html.sh $YEAR $MONTH
./generate_year_html.sh $YEAR

cd website
git add .
git commit -m "Auto-update website for $YEAR-$MONTH"
git push

