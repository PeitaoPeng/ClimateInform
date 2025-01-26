#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#datadir=/cpc/home/wd52pp/data/casst
datadir=/cpc/consistency/id/ca_hcst/seasonal
#
for icss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
#
if [ $icss = jfm ]; then cmon=4;  icmomid=feb; icmon=mar; icssnmb=1; fi #icmon_mid: mid mon of icss
if [ $icss = fma ]; then cmon=5;  icmomid=mar; icmon=apr; icssnmb=2; fi #icssnmb: 1st mon of icss
if [ $icss = mam ]; then cmon=6;  icmomid=apr; icmon=may; icssnmb=3 ; fi
if [ $icss = amj ]; then cmon=7;  icmomid=may; icmon=jun; icssnmb=4 ; fi
if [ $icss = mjj ]; then cmon=8;  icmomid=jun; icmon=jul; icssnmb=5; fi
if [ $icss = jja ]; then cmon=9;  icmomid=jul; icmon=aug; icssnmb=6; fi
if [ $icss = jas ]; then cmon=10;  icmomid=aug; icmon=sep; icssnmb=7; fi
if [ $icss = aso ]; then cmon=11;  icmomid=sep; icmon=oct; icssnmb=8; fi
if [ $icss = son ]; then cmon=12;  icmomid=oct; icmon=nov; icssnmb=9; fi
if [ $icss = ond ]; then cmon=1; icmomid=nov; icmon=dec; icssnmb=10; fi
if [ $icss = ndj ]; then cmon=2; icmomid=dec; icmon=jan; icssnmb=11; fi
if [ $icss = djf ]; then cmon=3; icmomid=jan; icmon=feb; icssnmb=12; fi
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
cp $lcdir/hindcast.nino34.f $tmp/nino34.f
#
cat > parm.h << eof
c
      parameter(imx=360,jmx=180)
      parameter(nld=17,nesm=40)
      parameter(nyr=$nyear)
eof
#
gfortran -o nino34.x nino34.f
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
ln -s ersst.clim.4ca.gr fort.91
ln -s hadoisst.clim.4ca.gr fort.92
ln -s $datadir/cahcst.ersst.nino34.${icss}_ic.gr fort.93
ln -s $datadir/cahcst.hadoisst.nino34.${icss}_ic.gr fort.94
#
nino34.x > $datadir/cahcst.nino34.${icss}_ic.out
#
cat>$datadir/cahcst.ersst.nino34.${icss}_ic.ctl<<EOF
dset ^cahcst.ersst.nino34.${icss}_ic.gr
undef -9.99E+33
title EXP1
XDEF  17 LINEAR    0  1.0
YDEF   1 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef $nyear linear $icmomidyr 1yr
edef 40 names 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40
vars  3
o  1 99 obs anom 
a  1 99 forecasted anom 
t  1 99 forecasted total
endvars
#
EOF
cat>$datadir/cahcst.hadoisst.nino34.${icss}_ic.ctl<<EOF
dset ^cahcst.hadoisst.nino34.${icss}_ic.gr
undef -9.99E+33
title EXP1
XDEF  17 LINEAR    0  1.0
YDEF   1 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef $nyear linear $icmomidyr 1yr
edef 40 names 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40
vars  3
o  1 99 obs anom 
a  1 99 forecasted anom 
t  1 99 forecasted total
endvars
#
EOF
#
done  # icseason loop
