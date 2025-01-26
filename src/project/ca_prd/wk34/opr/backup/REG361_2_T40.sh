#!/bin/sh

set -eaux

#
tmpdir=/cpc/home/wd52pp/tmp/opr
lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/opr
cd $tmpdir
 cp $lcdir/REG361_2_T40.f .
 cp $lcdir/setxy.f .
 cp $lcdir/intp2d.f .
#
 nfld=2
 iskip=0
#
   /bin/rm fort.*
   ln -s uv200.gr fort.11
   ln -s uv200.T40.gr  fort.21
#
cat > parm.h << eof
      parameter(ltime=$nfld,iskip=$iskip)
eof
#
 gfortran -o intp.x REG361_2_T40.f setxy.f intp2d.f
 intp.x
#
