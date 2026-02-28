set -euax
cd /export/hobbes/wd52pp/tmp
cp /export/hobbes/wd52pp/project/LF_prd/ocn_prd/read_cd.f .
#f90 -r8 -o read_cd.x read_cd.f
#
nyear=80  #once come to a new year, nyear must plus 1
cat > parm.h << eof
       parameter(nyear=$nyear)
eof
#
f77 -o read_cd.x read_cd.f
read_cd.x > read_cd.out &
exit
   

