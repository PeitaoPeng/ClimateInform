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
nseason=34

#
npp=`expr $nps - 4`
#
for modemax in 30; do
cp $lcdir/trend_sat_wkly_prd.skill.ass.f $tmpdir/sat_prd.skill.f
cd $tmpdir

#
cat > parm.h << eof
      parameter(iseason=$iseason)
c
      parameter(imt=144,jmt=73)    !input  sat dimension
c
      parameter(nseason=$nseason)
      parameter(nps=$nps)
eof
#

gfortran -o trend.x sat_prd.skill.f
echo "done compiling"

/bin/rm $tmpdir/fort.*
#
ln -s $datadir/wk.sata.1979-curr.trend.gr   fort.11
ln -s $datadir/wk.sata.1979-curr.gr         fort.12
#
ln -s $outdata/trend_sat_wk.$season.cnst.i3e  fort.50
ln -s $outdata/trend_sat_wk1.$season.prd.i3e  fort.51
ln -s $outdata/trend_sat_wk2.$season.prd.i3e  fort.52
ln -s $outdata/trend_sat_wk3.$season.prd.i3e  fort.53
ln -s $outdata/trend_sat_wk4.$season.prd.i3e  fort.54
ln -s $outdata/trend_sat_wk34.$season.prd.i3e  fort.55
#
ln -s $outdata/ac_1d_trend_sat_wkly.$season.i3e fort.81
ln -s $outdata/ac_2d_trend_sat_wkly.$season.i3e fort.82
#
trend.x > $lcdir/trend_sat_wkly.$season.out

cat>$outdata/ac_1d_trend_sat_wkly.$season.ctl<<EOF
dset ^ac_1d_trend_sat_wkly.$season.i3e
undef -9.99E+33
title EXP1
xdef  $npp linear  0  1.
ydef  1 linear 1 1
zdef  6 linear  0 1
tdef 999 linear dec79     1yr
vars  2
ac    6 99 against raw sat
rms   6 99 against raw sat
endvars
EOF

cat>$outdata/ac_2d_trend_sat_wkly.$season.ctl<<EOF
dset ^ac_2d_trend_sat_wkly.$season.i3e
undef -9.99E+33
title EXP1
xdef  144 linear   0 2.5
ydef  73 linear  -90 2.5
zdef   1 levels 500
tdef 99 linear     jan94     1mon
vars  2
ac    1 99 against raw sat
rms   1 99 against raw sat
endvars
EOF
#
done
#

