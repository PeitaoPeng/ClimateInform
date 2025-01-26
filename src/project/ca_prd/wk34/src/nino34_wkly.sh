#!/bin/sh

set -eaux

lcdir=/sss/cpc/save/Peitao.Peng/project/ca_prd/wk34
tmpdir=/ptmpp1/Peitao.Peng/test
if [ ! -d $tmpdir ] ; then
  mkdir -p $tmpdir
fi
datadir=/sss/cpc/shared/Peitao.Peng/wk34
outdata=/sss/cpc/shared/Peitao.Peng/wk34
#
nps=21   #wk number: NDJFM=17
iseason=4  #1: spring, 2: summer, 3: Fall, 4: Winter
season=winter
nseason=32

#
npp=`expr $nps - 4`
#
for modemax in 30; do
cp $lcdir/nino34_wkly.f $tmpdir/nino34_wkly.f
cd $tmpdir

#
cat > parm.h << eof
      parameter(iseason=$iseason)
c
      parameter(imt=144,jmt=73)  !input sst dimension
c
      parameter(nseason=$nseason)
      parameter(nps=$nps)
eof
#

gfortran -o ca.x nino34_wkly.f
echo "done compiling"

/bin/rm $tmpdir/fort.*
#
ln -s $datadir/sst.wk_anom.1982-2014.gr fort.11
#
ln -s $outdata/nino34_wkly.$season.i3e  fort.81
#
#
ca.x > $lcdir/nino34_wkly.$season.out

cat>$outdata/nino34_wkly.$season.ctl<<EOF
dset ^nino34_wkly.$season.i3e
undef -9.99E+8
title EXP1
xdef  $npp linear  0  1.
ydef  1 linear 1 1
zdef  6 linear  0 1
tdef 999 linear dec82     1yr
vars  1
t     6 99 nino34 sst
endvars
EOF
#
done
#

