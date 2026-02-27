#!/bin/sh

#!/bin/sh

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp_opr
bindir=/home/ppeng/ClimateInform/src/bin
HOME=/home/ppeng/data

# Ensure Git identity is available even with overridden HOME
git config --global user.name "Peitao Peng"
git config --global user.email "peitao.peng@gmail.com"

for icyr in 2025; do
for icmon in 1 2 3; do

cd $tmp

# ===== CONFIGURATION =====
REPO_SSH="git@github.com:PeitaoPeng/pngs.git"
LOCAL_DIR="$HOME/tmp_opr/pngs"
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
    cp "$src"/*.html "$target" || true

    echo "Staging changes..."
    git add "$y/$m"
}

# ===== CALL FUNCTION =====
process_month "$icyr" "$icmon"

done  # icmon loop
done  # icyr loop

# ===== COMMIT & PUSH AFTER ALL MONTHS =====
echo "Committing and pushing..."
git commit -m "Add PNGs for automated upload" || true
git push

echo "Upload complete!"
