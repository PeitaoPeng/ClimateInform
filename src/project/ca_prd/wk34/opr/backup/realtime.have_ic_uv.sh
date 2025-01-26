#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/opr
tmpdir=/cpc/home/wd52pp/tmp/opr
if [ ! -d $tmpdir ] ; then
  mkdir -p $tmpdir
fi
datadir=/cpc/home/wd52pp/data/ca_prd
outdata=/cpc/home/wd52pp/data/adam
analdir=/cpc/cfsr/rotating/rot_6hr_h/pgb.g2
bindir=/cpc/home/wd52pp/bin
#
#================================================
# have IC(u&v -> psi) from reanalysis data
#================================================
#
cd $tmpdir
#\rm pgb.*
#\rm *.g2
#
#YEAR=`date --date='8 day ago' '+%Y'`
#MONTH=`date --date='8 day ago' '+%m'`
#DAY=`date --date='8 day ago' '+%d'`
#cp $analdir/pgb.${YEAR}${MONTH}${DAY}* $tmpdir
YEAR=`date --date='8 day ago' '+%Y'`
MONTH=`date --date='8 day ago' '+%m'`
DAY=`date --date='8 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}* $tmpdir
YEAR=`date --date='7 day ago' '+%Y'`
MONTH=`date --date='7 day ago' '+%m'`
DAY=`date --date='7 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}* $tmpdir
YEAR=`date --date='6 day ago' '+%Y'`
MONTH=`date --date='6 day ago' '+%m'`
DAY=`date --date='6 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}* $tmpdir
YEAR=`date --date='5 day ago' '+%Y'`
MONTH=`date --date='5 day ago' '+%m'`
DAY=`date --date='5 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}* $tmpdir
YEAR=`date --date='4 day ago' '+%Y'`
MONTH=`date --date='4 day ago' '+%m'`
DAY=`date --date='4 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}* $tmpdir
YEAR=`date --date='3 day ago' '+%Y'`
MONTH=`date --date='3 day ago' '+%m'`
DAY=`date --date='3 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}* $tmpdir
YEAR=`date --date='2 day ago' '+%Y'`
MONTH=`date --date='2 day ago' '+%m'`
DAY=`date --date='2 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}* $tmpdir
#
cat *.g2 > pgb.g2
wgrib2 pgb.g2 -ave 6hr pgb.ave
g2ctl pgb.ave > pgb.ave.ctl

gribmap2 -0 -i pgb.ave.ctl
# read 200mb u&v from averaged grb data
cat >readuv<<EOF
run read.gs
EOF
cat >read.gs<<EOF
'reinit'
'open pgb.ave.ctl'
'set z 23'
'set x 1 720'
'set y 1 361'
'set gxout fwrite'
'set fwrite psi200.gr'
'd STRMprs'
'c'
EOF
grads -l <readuv
#
# from uv to psi
cp $lcdir/REG361_2_REG73.sh .
REG361_2_REG73.sh
# 
