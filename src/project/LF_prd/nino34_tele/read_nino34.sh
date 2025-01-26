set -euax
cd /export/hobbes/wd52pp/tmp
cp /export/hobbes/wd52pp/project/LF_prd/ocn_prd/read_nino34.f .
#
nyear=80  #once come to a new year, nyear must plus 1
cat > parm.h << eof
       parameter(nyear=$nyear)
eof
#
f77 -o read_nino34.x read_nino34.f
read_nino34.x > read_nino34.out &
exit
   

