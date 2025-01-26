#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
cd $tmp
analdir=/cpc/analysis/cdas/rot_6hrly
bindir=/cpc/home/wd52pp/bin
#
#================================================
# have IC daily SST from R1(CDAS) data
#================================================
#
rm -f sstgr*
#
curyr=`date --date='today' '+%Y'`  # yr of making fcst
curmo=`date --date='today' '+%m'`  # mo of making fcst
curdy=`date --date='today' '+%d'`  # dy of making fcst
maxago=`expr $curdy - 2` # 1st day should be at 00 of 2nd day
totday=`expr $curdy - 4`
#
idy=3
while [ $idy -le $maxago ]; do # "le" for taking the end of a day 
echo $idy
YEAR=`date --date=''$idy' day ago' '+%Y'`
MONTH=`date --date=''$idy' day ago' '+%m'`
DAY=`date --date=''$idy' day ago' '+%d'`
cp $analdir/sstgrb${YEAR}${MONTH}${DAY}00 $tmp
let idy=idy+1
done
cat sstgrb* > sstgrball
$bindir/./grib2ctl.pl sstgrball > sstgrball.ctl
$bindir/./gribmap -0 -i sstgrball.ctl
#
cat >readsst<<EOF
run read.gs
EOF
cat >read.gs<<EOF
'reinit'
'open sstgrall.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite sst.gr'
'set t 1 $totday'
'd TMPsfc'
'c'
EOF

$bindir/grads -bl <readsst

cat >sst.ctl<<EOF
dset ^sst.gr
undef 9.999E+20
ydef 180 linear -89.5 1.0
xdef 360 linear  0.5 1.0
tdef $totday linear 01jan2017 1dy
zdef 1 linear 1 1
vars 1
TMP  0 33,100,200  daily oi sst from R1
ENDVARS
EOF
