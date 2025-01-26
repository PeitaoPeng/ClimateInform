#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/cpc/consistency/id/ca_hcst/seasonal
cd $tmp
#
nyear=38  # years of forecast to be checked

for icss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
#for icss in jfm; do
#
if [ $icss = jfm ]; then cmon=4; tmon=apr; icmomid=feb; icssnmb=1; icmon=mar; fi #icmon_mid: mid mon of icss
if [ $icss = fma ]; then cmon=5; tmon=may; icmomid=mar; icssnmb=2; icmon=apr; fi #icssnmb: 1st mon of icss
if [ $icss = mam ]; then cmon=6; tmon=jun; icmomid=apr; icssnmb=3; icmon=may; fi
if [ $icss = amj ]; then cmon=7; tmon=jul; icmomid=may; icssnmb=4; icmon=jun; fi
if [ $icss = mjj ]; then cmon=8; tmon=aug; icmomid=jun; icssnmb=5; icmon=jul; fi
if [ $icss = jja ]; then cmon=9; tmon=sep; icmomid=jul; icssnmb=6; icmon=aug; fi
if [ $icss = jas ]; then cmon=10; tmon=oct; icmomid=aug; icssnmb=7; icmon=sep; fi
if [ $icss = aso ]; then cmon=11; tmon=nov; icmomid=sep; icssnmb=8; icmon=oct; fi
if [ $icss = son ]; then cmon=12; tmon=dec; icmomid=oct; icssnmb=9; icmon=nov; fi
if [ $icss = ond ]; then cmon=1; tmon=jan; icmomid=nov; icssnmb=10; icmon=dec; fi
if [ $icss = ndj ]; then cmon=2; tmon=feb; icmomid=dec; icssnmb=11; icmon=jan; fi
if [ $icss = djf ]; then cmon=3; tmon=mar; icmomid=jan; icssnmb=12; icmon=feb; fi
#
#===============have SST climatology
#
its=2  #align clim season to fcst season
if [ $icss = ndj ]; then its=1; fi
if [ $icss = djf ]; then its=1; fi

nte=nyr

cat >select<<EOF
run pick.gs
EOF
cat >pick.gs<<EOF
'reinit'
'open $datadir/cahcst.sst.${icss}_ic.esm.ctl'
'set gxout fwrite'
'set fwrite cahcst.all_esm.sst.${icmon}_ic.ld1-14.gr'
'set x 1 360'
'set y 1 180'
it=$its
while ( it <= $nyear)
'set t 'it''
ld=3
while ( ld <= 16)
'd p'ld''
ld=ld+1
endwhile
it=it+1
endwhile
EOF
#
/usr/local/bin/grads -bl <select
#
cat>cahcst.all_esm.sst.${icmon}_ic.ld1-14.ctl<<EOF
dset ^cahcst.all_esm.sst.${icmon}_ic.ld1-14.gr
undef -9.99E+8
title EXP1
XDEF  360 LINEAR    0  1.
YDEF  180 LINEAR  -89.5  1.
zdef  1 linear 1 1
tdef $nyear linear ${tmon}1982 1yr
vars  14
p1 1 99 prd 1
p2 1 99 prd 2
p3 1 99 prd 3
p4 1 99 prd 4
p5 1 99 prd 5
p6 1 99 prd 6
p7 1 99 prd 7
p8 1 99 prd 8
p9 1 99 prd 9
p10 1 99 prd 10
p11 1 99 prd 11
p12 1 99 prd 12
p13 1 99 prd 13
p14 1 99 prd 14
endvars
#
EOF
cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open cahcst.all_esm.sst.${icmon}_ic.ld1-14.ctl'
'open /cpc/home/wd52pp/project/nn/cfsv2/data_proc/land.2.5x2.5.ctl'
'set gxout fwrite'
'set fwrite $datadir/cahcst.all_esm.sst.${icmon}_ic.ld1-14.2.5x2.5.gr'
nt=1
while ( nt <= 37)

'set t 'nt
ld=1
while ( ld <= 14)
'set lon   0. 357.5'
'set lat -90.  90.'
'd lterp(p'ld',land.2(time=feb1982))'
ld=ld+1
endwhile

nt=nt+1
endwhile
gsEOF
#
/usr/local/bin/grads -pb <int
#
cat>$datadir/cahcst.all_esm.sst.${icmon}_ic.ld1-14.2.5x2.5.ctl<<EOF
dset ^cahcst.all_esm.sst.${icmon}_ic.ld1-14.2.5x2.5.gr
undef -9.99E+8
title EXP1
XDEF  144 LINEAR    0.   2.5
YDEF   73 LINEAR  -90.   2.5
zdef  1 linear 1 1
tdef $nyear linear ${tmon}1982 1yr
vars  14
p1 1 99 prd 1
p2 1 99 prd 2
p3 1 99 prd 3
p4 1 99 prd 4
p5 1 99 prd 5
p6 1 99 prd 6
p7 1 99 prd 7
p8 1 99 prd 8
p9 1 99 prd 9
p10 1 99 prd 10
p11 1 99 prd 11
p12 1 99 prd 12
p13 1 99 prd 13
p14 1 99 prd 14
endvars
#
EOF
#
done  # icseason loop
