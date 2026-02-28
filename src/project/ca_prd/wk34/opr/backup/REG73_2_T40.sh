#!/bin/sh

set -eaux

#
tmpdir=/ptmpp1/Peitao.Peng/test
lcdir=/sss/cpc/save/Peitao.Peng/project/ca_prd/wk34
cd $tmpdir
 cp $lcdir/REG73_2_T40.f .
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
 gfortran -o intp.x REG73_2_T40.f setxy.f intp2d.f
 intp.x
#
