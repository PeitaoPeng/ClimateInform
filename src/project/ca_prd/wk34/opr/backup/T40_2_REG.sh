#!/bin/sh

set -eaux

#
tmpdir=/cpc/home/wd52pp/tmp/opr
lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/opr
#
 nmonth=1
 iskip=0
#
cp $lcdir/T40_2_REG.f $tmpdir/.
  /bin/rm fort.*
   ln -s psi200.T40.gr   fort.11
   ln -s psi200.gr   fort.61
#
cat > parm.h << eof
      parameter(ltime=$nmonth,iskip=$iskip)
eof
#
 gfortran  T40_2_REG.f setxy.f intp2d.f
 a.out
#
