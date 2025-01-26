#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/cpc/consistency/id/ca_hcst/seasonal
#
for icss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
#for icss in fma; do
#
if [ $icss = jfm ]; then cmon=4;  icmomid=feb; icssnmb=1; fi #icmon_mid: mid mon of icss
if [ $icss = fma ]; then cmon=5;  icmomid=mar; icssnmb=2; fi #icssnmb: 1st mon of icss
if [ $icss = mam ]; then cmon=6;  icmomid=apr; icssnmb=3 ; fi
if [ $icss = amj ]; then cmon=7;  icmomid=may; icssnmb=4 ; fi
if [ $icss = mjj ]; then cmon=8;  icmomid=jun; icssnmb=5; fi
if [ $icss = jja ]; then cmon=9;  icmomid=jul; icssnmb=6; fi
if [ $icss = jas ]; then cmon=10;  icmomid=aug; icssnmb=7; fi
if [ $icss = aso ]; then cmon=11;  icmomid=sep; icssnmb=8; fi
if [ $icss = son ]; then cmon=12;  icmomid=oct; icssnmb=9; fi
if [ $icss = ond ]; then cmon=1; icmomid=nov; icssnmb=10; fi
if [ $icss = ndj ]; then cmon=2; icmomid=dec; icssnmb=11; fi
if [ $icss = djf ]; then cmon=3; icmomid=jan; icssnmb=12; fi
#
icmomidyr=${icmomid}1981
if [ $icss = djf ]; then icmomidyr=${icmomid}1982; fi
nyear=38  # years of forecast to be checked
#
cd $tmp
#
#===============have SST climatology
#
sstdir=/cpc/home/wd52pp/data/ca_prd
nts=`expr $icssnmb`  #align clim season to fcst season
nte=`expr $nts + 16`

for sst_analysis in ersst hadoisst; do

cat >clim<<EOF
run casstc.gs
EOF

cat >casstc.gs<<EOFgs
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
'open $sstdir/clim.${sst_analysis}.3mon.1x1.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite ${sst_analysis}.clim.4ca.gr'
'set t $nts $nte'
'd sst'
EOFgs
/usr/local/bin/grads -l <clim
done
#
cp $lcdir/esm.hindcast.sst.f $tmp/esm.f
#
cat > parm.h << eof
c
      parameter(imx=360,jmx=180)
      parameter(nld=17,nesm=12)
      parameter(nyr=$nyear)
      parameter(undef=-9.99e+8)
eof
#
#gfortran -o esm.x esm.f
gfortran -mcmodel=medium -g -o esm.x esm.f
echo "done compiling"

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi
#
eof_range=tp_ml
ifile=11
for sst_analysis in ersst hadoisst; do
for msic in 1 2 3 4; do
for modemax in 15 20 25 30 35 40 45 50 55 60; do
#
ln -s $datadir/ca_hcst.${sst_analysis}.$modemax.$icss.${msic}ics.tp_ml.gr fort.$ifile
#
ifile=`expr $ifile + 1` 
#
done  # maxmode
done  # msics
done  # sst_analysis
#
#ln -s ersst.clim.4ca.gr fort.61
#ln -s hadoisst.clim.4ca.gr fort.62
ln -s $datadir/cahcst.sst.${icss}_ic.all_esm.gr fort.91
ln -s $datadir/cahcst.sst.${icss}_ic.ersst_esm.gr     fort.92
ln -s $datadir/cahcst.sst.${icss}_ic.hadoisst_esm.gr  fort.93
ln -s $datadir/cahcst.sst.${icss}_ic.1sic_esm.gr fort.94
ln -s $datadir/cahcst.sst.${icss}_ic.2sic_esm.gr fort.95
ln -s $datadir/cahcst.sst.${icss}_ic.3sic_esm.gr fort.96
ln -s $datadir/cahcst.sst.${icss}_ic.4sic_esm.gr fort.97
#
esm.x > $datadir/cahcst.esm_sst.${icss}_ic.out
#
cat>$datadir/cahcst.sst.${icss}_ic.all_esm.ctl<<EOF
dset ^cahcst.sst.${icss}_ic.all_esm.gr
undef -9.99E+8
title EXP1
XDEF  360 LINEAR    0.   1.0
YDEF  180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef $nyear linear $icmomidyr 1yr
vars  34
ic  1 99 obs ic
cic 1 99 constructed ic
o1 1 99 obs 1
p1 1 99 prd 1
o2 1 99 obs 2
p2 1 99 prd 2
o3 1 99 obs 3
p3 1 99 prd 3
o4 1 99 obs 4
p4 1 99 prd 4
o5 1 99 obs 5
p5 1 99 prd 5
o6 1 99 obs 6
p6 1 99 prd 6
o7 1 99 obs 7
p7 1 99 prd 7
o8 1 99 obs 8
p8 1 99 prd 8
o9 1 99 obs 9
p9 1 99 prd 9
o10 1 99 obs 10
p10 1 99 prd 10
o11 1 99 obs 11
p11 1 99 prd 11
o12 1 99 obs 12
p12 1 99 prd 12
o13 1 99 obs 13
p13 1 99 prd 13
o14 1 99 obs 14
p14 1 99 prd 14
o15 1 99 obs 15
p15 1 99 prd 15
o16 1 99 obs 16
p16 1 99 prd 16
endvars
EOF
#
cat>$datadir/cahcst.sst.${icss}_ic.ersst_esm.ctl<<EOF
dset ^cahcst.sst.${icss}_ic.ersst_esm.gr
undef -9.99E+8
title EXP1
XDEF  360 LINEAR    0.5  1.0
YDEF  180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef $nyear linear $icmomidyr 1yr
vars  34
ic  1 99 obs ic
cic 1 99 constructed ic
o1 1 99 obs 1
p1 1 99 prd 1
o2 1 99 obs 2
p2 1 99 prd 2
o3 1 99 obs 3
p3 1 99 prd 3
o4 1 99 obs 4
p4 1 99 prd 4
o5 1 99 obs 5
p5 1 99 prd 5
o6 1 99 obs 6
p6 1 99 prd 6
o7 1 99 obs 7
p7 1 99 prd 7
o8 1 99 obs 8
p8 1 99 prd 8
o9 1 99 obs 9
p9 1 99 prd 9
o10 1 99 obs 10
p10 1 99 prd 10
o11 1 99 obs 11
p11 1 99 prd 11
o12 1 99 obs 12
p12 1 99 prd 12
o13 1 99 obs 13
p13 1 99 prd 13
o14 1 99 obs 14
p14 1 99 prd 14
o15 1 99 obs 15
p15 1 99 prd 15
o16 1 99 obs 16
p16 1 99 prd 16
endvars
EOF
#
cat>$datadir/cahcst.sst.${icss}_ic.hadoisst_esm.ctl<<EOF
dset ^cahcst.sst.${icss}_ic.hadoisst_esm.gr
undef -9.99E+8
title EXP1
XDEF  360 LINEAR    0.5  1.0
YDEF  180 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef $nyear linear $icmomidyr 1yr
vars  34
ic  1 99 obs ic
cic 1 99 constructed ic
o1 1 99 obs 1
p1 1 99 prd 1
o2 1 99 obs 2
p2 1 99 prd 2
o3 1 99 obs 3
p3 1 99 prd 3
o4 1 99 obs 4
p4 1 99 prd 4
o5 1 99 obs 5
p5 1 99 prd 5
o6 1 99 obs 6
p6 1 99 prd 6
o7 1 99 obs 7
p7 1 99 prd 7
o8 1 99 obs 8
p8 1 99 prd 8
o9 1 99 obs 9
p9 1 99 prd 9
o10 1 99 obs 10
p10 1 99 prd 10
o11 1 99 obs 11
p11 1 99 prd 11
o12 1 99 obs 12
p12 1 99 prd 12
o13 1 99 obs 13
p13 1 99 prd 13
o14 1 99 obs 14
p14 1 99 prd 14
o15 1 99 obs 15
p15 1 99 prd 15
o16 1 99 obs 16
p16 1 99 prd 16
endvars
EOF
#
done  # icseason loop
