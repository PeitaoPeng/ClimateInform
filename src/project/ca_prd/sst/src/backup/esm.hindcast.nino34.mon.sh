#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/cpc/home/wd52pp/data/casst
#
for icss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
#for icss in jja; do
#
if [ $icss = jfm ]; then ic_midmon=feb; icmon=mar; icssnmb=1; fi
if [ $icss = fma ]; then ic_midmon=mar; icmon=apr; icssnmb=2; fi
if [ $icss = mam ]; then ic_midmon=apr; icmon=may; icssnmb=3; fi
if [ $icss = amj ]; then ic_midmon=may; icmon=jun; icssnmb=4; fi
if [ $icss = mjj ]; then ic_midmon=jun; icmon=jul; icssnmb=5; fi
if [ $icss = jja ]; then ic_midmon=jul; icmon=aug; icssnmb=6; fi
if [ $icss = jas ]; then ic_midmon=aug; icmon=sep; icssnmb=7; fi
if [ $icss = aso ]; then ic_midmon=sep; icmon=oct; icssnmb=8; fi
if [ $icss = son ]; then ic_midmon=oct; icmon=nov; icssnmb=9; fi
if [ $icss = ond ]; then ic_midmon=nov; icmon=dec; icssnmb=10; fi
if [ $icss = ndj ]; then ic_midmon=dec; icmon=jan; icssnmb=11; fi
if [ $icss = djf ]; then ic_midmon=jan; icmon=feb; icssnmb=12; fi
#
icmidmonyr=${ic_midmon}1981
if [ $icss = djf ]; then icmidmonyr=${ic_midmon}1982; fi
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
'open $datadir/cahcst.hadoisst.nino34.${icmon}_ic.mon.ctl'
'open $datadir/cahcst.ersst.nino34.${icmon}_ic.mon.ctl'
'set x 1 17'
'set y 1'
'set gxout fwrite'
'set fwrite $datadir/cahcst.nino34.${icmon}_ic.esm.mon.gr'
kt=1
while(kt<=$nyear)
'set t 'kt''
'd ave(0.5*(o+o.2),e=1,e=12)'
'd ave(0.5*(a+a.2),e=1,e=12)'
'd ave(0.5*(t+t.2),e=1,e=12)'
kt=kt+1
endwhile
EOFgs
/usr/local/bin/grads -l <esm
#
cat>$datadir/cahcst.nino34.${icmon}_ic.esm.mon.ctl<<EOF
dset ^cahcst.nino34.${icmon}_ic.esm.mon.gr
undef -9.99E+33
title EXP1
XDEF  17 LINEAR      0  1.0
YDEF   1 LINEAR  -89.5  1.0
zdef   1 linear 1 1
tdef $nyear linear $icmidmonyr 1yr
vars  3
o  1 99 obs anom(avg of ersst and oisst) 
a  1 99 forecasted anom 
t  1 99 forecasted total
endvars
#
EOF
#
done  # icss loop
