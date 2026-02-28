#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/src
tmpdir=/cpc/home/wd52pp/tmp
if [ ! -d $tmpdir ] ; then
  mkdir -p $tmpdir
fi
datadir=/cpc/home/wd52pp/data/ca_prd
outdata=/cpc/home/wd52pp/data/wk34
#
nps=17   #wk number: DJF=13+4=17
iseason=4  #1: spring, 2: summer, 3: Fall, 4: Winter
season=winter
runeof=1 # 0: read in ; 1: run eof
nseason=35

#
npp=`expr $nps - 4`
#
for modemax in 15 20 25 35; do
for mwic in 1 2 3 4; do
cp $lcdir/zp_prcp_wkly_prd.skill.ass.mwic.f $tmpdir/prcp_prd.skill.f
cp $lcdir/eof_4_ca.s.f $tmpdir/eof_4_ca.s.f
cd $tmpdir

#
cat > parm.h << eof
      parameter(iseason=$iseason,nruneof=$runeof)
c
      parameter(imin=144,jmin=73)  !input psi200 dimension
      parameter(imt=144,jmt=73)    !input  prcp dimension
c
      parameter(lons=1,lone=144)   !lon range for EOFs analysis (0-360)
c     parameter(eoflats=20,lats=45,late=72)   !lat range for EOFs analysis (20N-90N)
      parameter(eoflats=-20,lats=29,late=72)  !lat range for EOFs analysis (20S-90N)
      parameter(imp=lone-lons+1,jmp=late-lats+1)
c
      parameter(modemax=$modemax)
      parameter(mwic=$mwic)
      parameter(nseason=$nseason)
      parameter(nps=$nps)
eof
#

gfortran -o ca.x prcp_prd.skill.f eof_4_ca.s.f
echo "done compiling"

/bin/rm $tmpdir/fort.*
#
ln -s $datadir/wk.psia.1979-curr.gr fort.11
ln -s $datadir/wk.prcpa_normalized.1979-curr.gr fort.12
#
ln -s $outdata/psi200_wk.$season.cnst.i3e  fort.60
ln -s $outdata/psi200_wk1.$season.prd.i3e  fort.61
ln -s $outdata/psi200_wk2.$season.prd.i3e  fort.62
ln -s $outdata/psi200_wk3.$season.prd.i3e  fort.63
ln -s $outdata/psi200_wk4.$season.prd.i3e  fort.64
ln -s $outdata/psi200_wk34.$season.prd.i3e  fort.65
ln -s $outdata/psi200_prcp_wk.$season.cnst.i3e  fort.50
ln -s $outdata/psi200_prcp_wk1.$season.prd.i3e  fort.51
ln -s $outdata/psi200_prcp_wk2.$season.prd.i3e  fort.52
ln -s $outdata/psi200_prcp_wk3.$season.prd.i3e  fort.53
ln -s $outdata/psi200_prcp_wk4.$season.prd.i3e  fort.54
ln -s $outdata/psi200_prcp_wk34.$season.${mwic}ics.mm$modemax.i3e  fort.55
ln -s $outdata/psi200_prcp_wk34.$season.obs.i3e  fort.56
#
ln -s $outdata/eof.psi200_wk.${season}_4_skill.i3e   fort.70
#
ln -s $outdata/ac_1d_ca_psi200_wkly.$season.${mwic}ics.mm$modemax.i3e fort.71
ln -s $outdata/ac_2d_ca_psi200_wkly.$season.${mwic}ics.mm$modemax.i3e fort.72
#
#ln -s $outdata/ac_1d_ca_psi200_prcp_wkly.$season.${mwic}ics.mm$modemax.i3e fort.81
#ln -s $outdata/ac_2d_ca_psi200_prcp_wkly.$season.${mwic}ics.mm$modemax.i3e fort.82
ln -s $outdata/ac_1d_ca_psi200_prcp_wkly.$season.${mwic}ics.mm$modemax.detrd.i3e fort.81
ln -s $outdata/ac_2d_ca_psi200_prcp_wkly.$season.${mwic}ics.mm$modemax.detrd.i3e fort.82
#
ca.x > $lcdir/ca_psi200_prcp_wkly.$season.out

cat>$outdata/eof.psi200_wk.${season}_4_skill.ctl<<EOF
dset ^eof.psi200_wk.${season}_4_skill.i3e
undef -9.99E+33
title EXP1
xdef  144 linear   0.  2.5
ydef   44 linear -20.  2.5
zdef     1 levels 500
tdef 999 linear     jan94     1mon
vars  1
eof   1 99 wk psi200
endvars
EOF

cat>$outdata/ac_1d_ca_psi200_wkly.$season.${mwic}ics.mm$modemax.ctl<<EOF
dset ^ac_1d_ca_psi200_wkly.$season.${mwic}ics.mm$modemax.i3e
undef -9.99E+33
title EXP1
xdef  $npp linear  0  1.
ydef  1 linear 1 1
zdef  6 linear  0 1
tdef 999 linear dec79     1yr
vars  2
ac    6 99 against raw psi200
rms   6 99 against raw psi200
endvars
EOF

cat>$outdata/ac_2d_ca_psi200_wkly.$season.${mwic}ics.mm$modemax.ctl<<EOF
dset ^ac_2d_ca_psi200_wkly.$season.${mwic}ics.mm$modemax.i3e
undef -9.99E+33
title EXP1
xdef  144 linear   0.  2.5
ydef   44 linear -20.  2.5
zdef   1 levels 500
tdef 99 linear     jan94     1mon
vars  2
ac    1 99 against raw psi200
rms   1 99 against raw psi200
endvars
EOF
#

cat>$outdata/ac_1d_ca_psi200_prcp_wkly.$season.${mwic}ics.mm$modemax.detrd.ctl<<EOF
dset ^ac_1d_ca_psi200_prcp_wkly.$season.${mwic}ics.mm$modemax.detrd.i3e
undef -9.99E+33
title EXP1
xdef  $npp linear  0  1.
ydef  1 linear 1 1
zdef  6 linear  0 1
tdef 999 linear dec79     1yr
vars  2
ac    6 99 against raw prcp
rms   6 99 against raw prcp
endvars
EOF

cat>$outdata/ac_2d_ca_psi200_prcp_wkly.$season.${mwic}ics.mm$modemax.detrd.ctl<<EOF
dset ^ac_2d_ca_psi200_prcp_wkly.$season.${mwic}ics.mm$modemax.detrd.i3e
undef -9.99E+33
title EXP1
xdef  144 linear   0 2.5
ydef  73 linear  -90 2.5
zdef   1 levels 500
tdef 99 linear     jan94     1mon
vars  2
ac    1 99 against raw prcp
rms   1 99 against raw prcp
endvars
EOF
#
done
done
#
