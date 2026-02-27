#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/cpc/home/wd52pp/data/casst
#
for icseason in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
#for icseason in djf; do
#
if [ $icseason = jfm ]; then ic_midmon=feb; icmon=mar; icssnmb=1; fi
if [ $icseason = fma ]; then ic_midmon=mar; icmon=apr; icssnmb=2; fi
if [ $icseason = mam ]; then ic_midmon=apr; icmon=may; icssnmb=3; fi
if [ $icseason = amj ]; then ic_midmon=may; icmon=jun; icssnmb=4; fi
if [ $icseason = mjj ]; then ic_midmon=jun; icmon=jul; icssnmb=5; fi
if [ $icseason = jja ]; then ic_midmon=jul; icmon=aug; icssnmb=6; fi
if [ $icseason = jas ]; then ic_midmon=aug; icmon=sep; icssnmb=7; fi
if [ $icseason = aso ]; then ic_midmon=sep; icmon=oct; icssnmb=8; fi
if [ $icseason = son ]; then ic_midmon=oct; icmon=nov; icssnmb=9; fi
if [ $icseason = ond ]; then ic_midmon=nov; icmon=dec; icssnmb=10; fi
if [ $icseason = ndj ]; then ic_midmon=dec; icmon=jan; icssnmb=11; fi
if [ $icseason = djf ]; then ic_midmon=jan; icmon=feb; icssnmb=12; fi
#
icmidmonyr=${ic_midmon}1981
if [ $icseason = djf ]; then icmidmonyr=${ic_midmon}1982; fi
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
'open $sstdir/clim.${sst_analysis}.mon.1x1.ctl'
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
      parameter(nld=17,nesm=12)
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
for modemax in 15 25 40; do
#
ln -s $datadir/ca_hcst.${sst_analysis}.$modemax.$icmon.${msic}ics.tp_ml.mon.gr fort.$ifile
#
ifile=`expr $ifile + 1` 
#
done  # maxmode
done  # msics
done  # sst_analysis
#
ln -s ersst.clim.4ca.gr fort.61
ln -s hadoisst.clim.4ca.gr fort.62
ln -s $datadir/cahcst.ersst.nino34.${icmon}_ic.mon.gr fort.71
ln -s $datadir/cahcst.hadoisst.nino34.${icmon}_ic.mon.gr fort.72
#
nino34.x > $datadir/cahcst.nino34.${icmon}_ic.out
#
cat>$datadir/cahcst.ersst.nino34.${icmon}_ic.mon.ctl<<EOF
dset ^cahcst.ersst.nino34.${icmon}_ic.mon.gr
undef -9.99E+33
title EXP1
XDEF  17 LINEAR    0  1.0
YDEF   1 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef $nyear linear $icmidmonyr 1yr
edef 12 names 1 2 3 4 5 6 7 8 9 10 11 12
vars  3
o  1 99 obs anom 
a  1 99 forecasted anom 
t  1 99 forecasted total
endvars
#
EOF
cat>$datadir/cahcst.hadoisst.nino34.${icmon}_ic.mon.ctl<<EOF
dset ^cahcst.hadoisst.nino34.${icmon}_ic.mon.gr
undef -9.99E+33
title EXP1
XDEF  17 LINEAR    0  1.0
YDEF   1 LINEAR  -89.5  1.0
zdef  1 linear 1 1
tdef $nyear linear $icmidmonyr 1yr
edef 12 names 1 2 3 4 5 6 7 8 9 10 11 12
vars  3
o  1 99 obs anom 
a  1 99 forecasted anom 
t  1 99 forecasted total
endvars
#
EOF
#
done  # icseason loop
