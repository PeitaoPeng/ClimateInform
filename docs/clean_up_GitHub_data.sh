git clone git@github.com:PeitaoPeng/ClimateInform.git
cd ClimateInform

# Remove everything inside data/
rm -rf data/*

# Remove everything inside src/ except your active scripts
#find src/ -type f ! -name "generate_*.sh" ! -name "climateinform_pipeline.sh" -delete

git add .
git commit -m "Cleanup: remove old data and unused files"
git push

