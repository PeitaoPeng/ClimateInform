#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/nn/ca
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/cpc/home/wd52pp/data/casst
dataout=/cpc/home/wd52pp/data/nn/ca
#
for icss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
#for icss in jfm; do
#
if [ $icss = jfm ]; then cmon=4;  icmomid=feb; icssnmb=1; tld=12; fi #icmon_mid: mid mon of icss
if [ $icss = fma ]; then cmon=5;  icmomid=mar; icssnmb=2; tld=11; fi #icssnmb: 1st mon of icss
if [ $icss = mam ]; then cmon=6;  icmomid=apr; icssnmb=3; tld=10; fi #tld: ld# from icss to taget ss djf
if [ $icss = amj ]; then cmon=7;  icmomid=may; icssnmb=4; tld=9; fi
if [ $icss = mjj ]; then cmon=8;  icmomid=jun; icssnmb=5; tld=8; fi
if [ $icss = jja ]; then cmon=9;  icmomid=jul; icssnmb=6; tld=7; fi
if [ $icss = jas ]; then cmon=10;  icmomid=aug; icssnmb=7; tld=6; fi
if [ $icss = aso ]; then cmon=11;  icmomid=sep; icssnmb=8; tld=5; fi
if [ $icss = son ]; then cmon=12;  icmomid=oct; icssnmb=9; tld=16; fi
if [ $icss = ond ]; then cmon=1; icmomid=nov; icssnmb=10; tld=15; fi
if [ $icss = ndj ]; then cmon=2; icmomid=dec; icssnmb=11; tld=14; fi
if [ $icss = djf ]; then cmon=3; icmomid=jan; icssnmb=12; tld=13; fi
#
icmomidyr=${icmomid}1981
if [ $icss = djf ]; then icmomidyr=${icmomid}1982; fi
nyear=36  # years of forecast to be checked
#
cd $tmp
#
#===============have SST climatology
#
cat >esm<<EOF
 run esmnino.gs
EOF

cat >esmnino.gs<<EOFgs
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
'open $datadir/cahcst.nino34.${icss}_ic.esm.ctl'
'set x 1'
'set y 1'
'set gxout fwrite'
'set fwrite $dataout/cahcst.djf.nino34.${icss}_ic.esm.gr'
kt=1
while(kt<=$nyear)
'set t 'kt''
'set x $tld'
'd a'
'd o'
kt=kt+1
endwhile
EOFgs
#
/usr/local/bin/grads -bl <esm
#
cat>$dataout/cahcst.djf.nino34.${icss}_ic.esm.ctl<<EOF2
dset ^cahcst.djf.nino34.${icss}_ic.esm.gr
undef -9.99E+33
title EXP1
XDEF   1 LINEAR      0  1.0
YDEF   1 LINEAR  -89.5  1.0
zdef   1 linear 1 1
tdef $nyear linear $icmomidyr 1yr
vars  2
a  1 99 forecasted anom 
o  1 99 obs anom(avg of ersst and oisst) 
endvars
#
EOF2

done  # icseason loop
