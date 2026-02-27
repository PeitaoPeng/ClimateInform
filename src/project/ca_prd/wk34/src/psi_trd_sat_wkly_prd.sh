#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/src
tmpdir=/cpc/home/wd52pp/tmp
if [ ! -d $tmpdir ] ; then
  mkdir -p $tmpdir
fi
datadir=/cpc/home/wd52pp/data/ca_prd
outdata=/cpc/home/wd52pp/data/wk34_test
#
nps=15   #width of data window in wk#
nwextb=5  #wk number to be extended at begining of a row of the array
nwexte=`expr $nps - $nwextb - 1`  #wk number to be extended at the end of a row of the array
runeof=1 # 0: read in ; 1: run eof
nyear=36
nseason=33 #nyear-3
kocn=15

#
npp=`expr $nps - 4`
#
for modemax in 35; do
cp $lcdir/psi_trd_sat_wkly_prd.f $tmpdir/sat_prd.skill.f
cp $lcdir/eof_4_ca.s.f $tmpdir/eof_4_ca.s.f
cd $tmpdir

#
cat > parm.h << eof
      parameter(nruneof=$runeof)
c
      parameter(ims=144,jms=73)  !input psi200 dimension
      parameter(imt=144,jmt=73)    !input  sat dimension
c
      parameter(lons=1,lone=144)   !lon range for EOFs analysis (0-360)
c     parameter(eoflats=20,lats=45,late=72)   !lat range for EOFs analysis (20N-90N)
      parameter(eoflats=-20,lats=29,late=72)  !lat range for EOFs analysis (20S-90N)
      parameter(imp=lone-lons+1,jmp=late-lats+1)
c
      parameter(modemax=$modemax)
      parameter(nyear=$nyear)
      parameter(nseason=$nseason)
      parameter(nps=$nps)
      parameter(nwextb=$nwextb)
      parameter(nwexte=$nwexte)
c
      parameter(kocn=$kocn)
eof
#

gfortran -o ca.x sat_prd.skill.f eof_4_ca.s.f
echo "done compiling"

/bin/rm $tmpdir/fort.*
#
ln -s $datadir/wk.psia.1979-curr.gr fort.11
ln -s $datadir/wk.sata.1979-curr.gr fort.12
#ln -s $datadir/wk.sata.1979-curr.gr fort.12
#
ln -s $outdata/psi200_wk.cnst.hcst.i3e  fort.60
ln -s $outdata/psi200_wk1.hcst.i3e  fort.61
ln -s $outdata/psi200_wk2.hcst.i3e  fort.62
ln -s $outdata/psi200_wk3.hcst.i3e  fort.63
ln -s $outdata/psi200_wk4.hcst.i3e  fort.64
ln -s $outdata/psi200_wk34.hcst.i3e  fort.65
ln -s $outdata/psi200_sat_wk.cnst.hcst.i3e  fort.50
ln -s $outdata/psi200_sat_wk1.hcst.i3e  fort.51
ln -s $outdata/psi200_sat_wk2.hcst.i3e  fort.52
ln -s $outdata/psi200_sat_wk3.hcst.i3e  fort.53
ln -s $outdata/psi200_sat_wk4.hcst.i3e  fort.54
ln -s $outdata/psi200_sat_wk34.hcst.i3e  fort.55
#
ln -s $outdata/eof.psi200_wk.i3e   fort.70
#
ln -s $outdata/ac_1d_ca_psi200_wkly.mm$modemax.i3e fort.71
ln -s $outdata/ac_2d_ca_psi200_wkly.mm$modemax.i3e fort.72
#
#ln -s $outdata/ac_1d_ca_psi200_sat_wkly.mm$modemax.i3e fort.81
#ln -s $outdata/ac_2d_ca_psi200_sat_wkly.mm$modemax.i3e fort.82
ln -s $outdata/ac_1d_ca_psi200_sat_wkly.mm$modemax.i3e fort.81
ln -s $outdata/ac_2d_ca_psi200_sat_wkly.mm$modemax.i3e fort.82
#
ln -s $outdata/real_prd.psi200_wkly.i3e fort.85
ln -s $outdata/real_prd_psi200_sat_wkly.i3e fort.86
ln -s $outdata/real_wk34_sat_prd.i3e fort.87
#
#ca.x 
ca.x > $lcdir/ca_psi200_sat_wkly.out

cat>$outdata/eof.psi200_wk.ctl<<EOF
dset ^eof.psi200_wk.i3e
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

cat>$outdata/ac_1d_ca_psi200_wkly.mm$modemax.ctl<<EOF
dset ^ac_1d_ca_psi200_wkly.mm$modemax.i3e
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

cat>$outdata/ac_2d_ca_psi200_wkly.mm$modemax.ctl<<EOF
dset ^ac_2d_ca_psi200_wkly.mm$modemax.i3e
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

cat>$outdata/ac_1d_ca_psi200_sat_wkly.mm$modemax.ctl<<EOF
dset ^ac_1d_ca_psi200_sat_wkly.mm$modemax.i3e
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

cat>$outdata/ac_2d_ca_psi200_sat_wkly.mm$modemax.ctl<<EOF
dset ^ac_2d_ca_psi200_sat_wkly.mm$modemax.i3e
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
cat>$outdata/real_prd_psi200_sat_wkly.ctl<<EOF
dset ^real_prd_psi200_sat_wkly.i3e
undef -9.99E+33
title EXP1
xdef  144 linear   0 2.5
ydef  73 linear  -90 2.5
zdef   1 levels 500
tdef  9  linear     jan94     1mon
vars  2
obs   1 99 observed
prd   1 99 prd
endvars
EOF
#
cat>$outdata/real_prd.psi200_wkly.ctl<<EOF
dset ^real_prd.psi200_wkly.i3e
undef -9.99E+33
title EXP1
xdef  144 linear   0.  2.5
ydef   44 linear -20.  2.5
zdef   1 levels 500
tdef   6 linear     jan94     1mon
vars  2
obs   1 99 wk observed
prd   1 99 wk prd
endvars
EOF
done
#

cat>$outdata/real_wk34_sat_prd.ctl<<EOF
dset ^real_wk34_sat_prd.i3e
undef -9.99E+33
title EXP1
xdef  144 linear   0 2.5
ydef  73 linear  -90 2.5
zdef   1 levels 500
tdef  1  linear     jan94     1mon
vars  3
psi   1 99 psi based prd
ocn   1 99 OCN prd
prb   1 99 prob prd
endvars
EOF
