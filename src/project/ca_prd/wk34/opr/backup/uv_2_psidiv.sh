#!/bin/sh

set -eaux

#
lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/opr
tmp=/cpc/home/wd52pp/tmp/opr
#
 cd $tmp
 nmonth=1
 iskip=0
#
 cp $lcdir/uv_2_psidiv.*  $tmp
 cp $lcdir/uv_2_psidivT40.s.f  $tmp
 cp $lcdir/lib.f  $tmp

   /bin/rm fort.*
    ln -s uv200.T40.gr fort.11
    ln -s psi200.T40.gr fort.60
#
cat > parm.h << eof
      parameter(ltime=$nmonth,iskip=$iskip)
eof
#
 gfortran  uv_2_psidiv.f uv_2_psidivT40.s.f lib.f
 a.out
#
