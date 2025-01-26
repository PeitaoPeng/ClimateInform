#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#datadir=/cpc/home/wd52pp/data/casst
datadir=//cpc/consistency/id/ca_hcst/seasonal
#
for icss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
#for icss in jja; do
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
cat >esm<<EOF
run esmnino.gs
EOF

cat >esmnino.gs<<EOFgs
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
'open $datadir/cahcst.ersst.nino34.${icss}_ic.ctl'
'open $datadir/cahcst.hadoisst.nino34.${icss}_ic.ctl'
'set x 1 17'
'set y 1'
'set gxout fwrite'
'set fwrite $datadir/cahcst.nino34.${icss}_ic.esm.gr'
kt=1
while(kt<=$nyear)
'set t 'kt''
'd ave(0.5*(o+o.2),e=1,e=12)'
'd ave(0.5*(a+a.2),e=1,e=12)'
'd ave(0.5*(t+t.2),e=1,e=12)'
*'d ave(o,e=4,e=12)'
*'d ave(a,e=4,e=12)'
*'d ave(t,e=4,e=12)'
kt=kt+1
endwhile
EOFgs
/usr/local/bin/grads -l <esm
#
cat>$datadir/cahcst.nino34.${icss}_ic.esm.ctl<<EOF
dset ^cahcst.nino34.${icss}_ic.esm.gr
undef -9.99E+33
title EXP1
XDEF  17 LINEAR      0  1.0
YDEF   1 LINEAR  -89.5  1.0
zdef   1 linear 1 1
tdef $nyear linear $icmomidyr 1yr
vars  3
o  1 99 obs anom(avg of ersst and oisst) 
a  1 99 forecasted anom 
t  1 99 forecasted total
endvars
#
EOF
#
done  # icseason loop
