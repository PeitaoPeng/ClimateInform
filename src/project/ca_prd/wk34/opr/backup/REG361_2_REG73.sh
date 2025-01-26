#!/bin/sh

set -eaux

#
tmpdir=/cpc/home/wd52pp/tmp/opr
lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/opr
bindir=/cpc/home/wd52pp/bin
cd $tmpdir
 cp $lcdir/REG361_2_REG73.f .
 cp $lcdir/setxy.f .
 cp $lcdir/intp2d.f .
#
 nfld=1
#
/bin/rm fort.*
   ln -s psi.gr fort.11
   ln -s psi200.gr  fort.21
#
cat > parm.h << eof
      parameter(ltime=$nfld)
eof
#
 gfortran -o intp.x REG361_2_REG73.f setxy.f intp2d.f
 intp.x
#
