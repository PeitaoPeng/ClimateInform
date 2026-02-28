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
runeof=1 # 0: read in ; 1: run eof
nseason=31

#
npp=`expr $nps - 4`
#
for modemax in 30; do
cp $lcdir/sst_sat_wkly_prd.skill.ass.f $tmpdir/sat_prd.skill.f
cp $lcdir/eof_4_ca.s.f $tmpdir/eof_4_ca.s.f
cd $tmpdir

#
cat > parm.h << eof
      parameter(iseason=$iseason,nruneof=$runeof)
c
      parameter(imin=180,jmin=89)  !input sst dimension
      parameter(imt=144,jmt=73)    !input sat dimension
c
      parameter(lons=1,lone=180)   !lon range for EOFs analysis (0-360)
      parameter(eoflats=-30,lats=30,late=80)  !lat range for EOFs analysis (30S-70N)
      parameter(imp=lone-lons+1,jmp=late-lats+1)
c
      parameter(modemax=$modemax)
      parameter(nseason=$nseason)
      parameter(nps=$nps)
eof
#

gfortran -o ca.x sat_prd.skill.f eof_4_ca.s.f
echo "done compiling"

/bin/rm $tmpdir/fort.*
#
ln -s $datadir/ersst.jan1949-cur.mon.anom.gr fort.11
ln -s $datadir/wk.sata.1979-curr.detrd.gr fort.12
#
ln -s $outdata/sst_mon.$season.cnst.i3e  fort.60
ln -s $outdata/sst_mon1.$season.prd.i3e  fort.61
ln -s $outdata/sst_mon2.$season.prd.i3e  fort.62
ln -s $outdata/sst_mon3.$season.prd.i3e  fort.63
#
ln -s $outdata/sst_sat_wk.$season.cnst.i3e  fort.50
ln -s $outdata/sst_sat_wk1.$season.prd.i3e  fort.51
ln -s $outdata/sst_sat_wk2.$season.prd.i3e  fort.52
ln -s $outdata/sst_sat_wk3.$season.prd.i3e  fort.53
ln -s $outdata/sst_sat_wk4.$season.prd.i3e  fort.54
ln -s $outdata/sst_sat_wk34.$season.prd.i3e  fort.55
#
ln -s $outdata/eof.sst_mon.${season}_4_skill.i3e   fort.70
#
ln -s $outdata/ac_1d_ca_sst_monthly.$season.mm$modemax.i3e fort.71
ln -s $outdata/ac_2d_ca_sst_monthly.$season.mm$modemax.i3e fort.72
#
#ln -s $outdata/ac_1d_ca_sst_sat_wkly.$season.mm$modemax.i3e fort.81
#ln -s $outdata/ac_2d_ca_sst_sat_wkly.$season.mm$modemax.i3e fort.82
ln -s $outdata/ac_1d_ca_sst_sat_wkly.$season.mm$modemax.detrd.i3e fort.81
ln -s $outdata/ac_2d_ca_sst_sat_wkly.$season.mm$modemax.detrd.i3e fort.82
#
ca.x > $lcdir/ca_sst_sat_wkly.$season.out

cat>$outdata/eof.sst_mon.${season}_4_skill.ctl<<EOF
dset ^eof.sst_mon.${season}_4_skill.i3e
undef -9.99E+33
title EXP1
xdef  144 linear   0.  2.5
ydef   44 linear -20.  2.5
zdef     1 levels 500
tdef 999 linear     jan94     1mon
vars  1
eof   1 99 wk sst
endvars
EOF

cat>$outdata/ac_1d_ca_sst_mon.$season.mm$modemax.ctl<<EOF
dset ^ac_1d_ca_sst_mon.$season.mm$modemax.i3e
undef -9.99E+33
title EXP1
xdef  $npp linear  0  1.
ydef  1 linear 1 1
zdef  6 linear  0 1
tdef 999 linear dec82     1yr
vars  2
ac    6 99 against raw sst
rms   6 99 against raw sst
endvars
EOF

cat>$outdata/ac_2d_ca_sst_mon.$season.mm$modemax.ctl<<EOF
dset ^ac_2d_ca_sst_mon.$season.mm$modemax.i3e
undef -9.99E+33
title EXP1
xdef  144 linear   0.  2.5
ydef   44 linear -20.  2.5
zdef   1 levels 500
tdef 99 linear     jan94     1mon
vars  2
ac    1 99 against raw sst
rms   1 99 against raw sst
endvars
EOF
#

cat>$outdata/ac_1d_ca_sst_sat_wkly.$season.mm$modemax.detrd.ctl<<EOF
dset ^ac_1d_ca_sst_sat_wkly.$season.mm$modemax.detrd.i3e
undef -9.99E+33
title EXP1
xdef  $npp linear  0  1.
ydef  1 linear 1 1
zdef  6 linear  0 1
tdef 999 linear dec82     1yr
vars  2
ac    6 99 against raw sat
rms   6 99 against raw sat
endvars
EOF

cat>$outdata/ac_2d_ca_sst_sat_wkly.$season.mm$modemax.detrd.ctl<<EOF
dset ^ac_2d_ca_sst_sat_wkly.$season.mm$modemax.detrd.i3e
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

