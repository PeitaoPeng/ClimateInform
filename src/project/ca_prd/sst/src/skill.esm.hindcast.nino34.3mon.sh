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
cat >esm_skill<<EOF
run skill.gs
EOF

cat >skill.gs<<EOFgs
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
'open $datadir/cahcst.nino34.${icss}_ic.esm.ctl'
'set gxout fwrite'
'set fwrite $datadir/skill.cahcst.nino34.${icss}_ic.esm.gr'
ix=1
while(ix<=17)
'set x 'ix''
'define oo=sqrt(ave(o*o,t=1,t=38))'
'define aa=sqrt(ave(a*a,t=1,t=38))'
'define ao=ave(a*o,t=1,t=38)'
'define rms=sqrt(ave((o-a)*(o-a),t=1,t=38))'
'd ao/(aa*oo)'
'd rms'
ix=ix+1
endwhile
'disable fwrite'
EOFgs
/usr/local/bin/grads -l <esm_skill
#
cat>$datadir/skill.cahcst.nino34.${icss}_ic.esm.ctl<<EOF
dset ^skill.cahcst.nino34.${icss}_ic.esm.gr
undef -9.99E+33
title EXP1
XDEF   1 LINEAR      0  1.0
YDEF   1 LINEAR  -89.5  1.0
zdef   1 linear 1 1
tdef 17 linear $icmomidyr 1mon
vars  2
ac  1 99 ac skill
rms 1 99 rmse
endvars
#
EOF
#
done  # icseason loop
