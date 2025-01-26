#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/opr
tmpdir=/cpc/home/wd52pp/tmp/opr
if [ ! -d $tmpdir ] ; then
  mkdir -p $tmpdir
fi
bindir=/cpc/home/wd52pp/bin
#
# IC date and week#
YEAR=`date --date='2 day ago' '+%Y'`
MONTH=`date --date='2 day ago' '+%m'`
DAY=`date --date='2 day ago' '+%d'`
idate=$YEAR/$MONTH/$DAY
jday=`date -d $idate +%j`
if [ $jday -le 7 ]; then jday=7; fi
iweek=`expr $jday / 7`
#
#forecast date
fy4=`date --date='today' '+%Y'`
fm2=`date --date='today' '+%m'`
fd2=`date --date='today' '+%d'`
#
if [ $fm2 = 01 ]; then icmon=jan; fi
if [ $fm2 = 02 ]; then icmon=feb; fi
if [ $fm2 = 03 ]; then icmon=mar; fi
if [ $fm2 = 04 ]; then icmon=apr; fi
if [ $fm2 = 05 ]; then icmon=may; fi
if [ $fm2 = 06 ]; then icmon=jun; fi
if [ $fm2 = 07 ]; then icmon=jul; fi
if [ $fm2 = 08 ]; then icmon=aug; fi
if [ $fm2 = 09 ]; then icmon=sep; fi
if [ $fm2 = 10 ]; then icmon=oct; fi
if [ $fm2 = 11 ]; then icmon=nov; fi
if [ $fm2 = 12 ]; then icmon=dec; fi
#
ddmmyy=$fd2$icmon$fy4
cd $tmpdir
#
modemax=35
#
for var in z500 sat prcp; do
#
cat >ens_mean<<EOF
run esm.gs
EOF
#
cat >esm.gs<<EOF
'reinit'
'open $tmpdir/ca_${var}_wk34.1ics.35.ctl'
*'open $tmpdir/ca_${var}_wk34.2ics.35.ctl'
*'open $tmpdir/ca_${var}_wk34.3ics.35.ctl'
'open $tmpdir/ca_${var}_wk34.4ics.35.ctl'
'set gxout fwrite'
'set fwrite ca_${var}_wk34.bin2'
'set x 1 144'
'set y 1  73'
'd (w34+w34.2)/2'
'd (ocn+ocn.2)/2'
'd (wk2+wk2.2)/2'
'd (wk3+wk3.2)/2'
'd (wk4+wk4.2)/2'
'd (prd+prd.2)/2'
'd (prb+prb.2)/2'
'd (trd+trd.2)/2'
'd (hss+hss.2)/2'
'd (pic+pic.2)/2'
'd (ostd+ostd.2)/2'
'd (pstd+pstd.2)/2'
'c'
EOF

/usr/local/bin/grads -bl <ens_mean

cat>$tmpdir/ca_${var}_wk34.ctl2<<EOF
dset ^ca_${var}_wk34.bin2
undef -9.99E+8
title prcp unit=0.1mm/day
xdef  144 linear   0 2.5
ydef   73 linear  -90 2.5
zdef   1 levels 500
tdef   1 linear $ddmmyy 1dy
vars  12
w34   1 99 psi based wk34
ocn   1 99 OCN prd
wk2   1 99 psi-based + trd
wk3   1 99 psi-based + trd
wk4   1 99 psi-based + trd
prd   1 99 wk34 + trd
prb   1 99 prob format of prd
trd   1 99 trend per year
hss   1 99 HSS_2c
pic   1 99 psi ic
ostd 1 99 obs std
pstd 1 99 prd std
endvars
EOF

cp $tmpdir/ca_${var}_wk34.ctl2 /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2/$fd2
cp $tmpdir/ca_${var}_wk34.bin2 /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2/$fd2

done
