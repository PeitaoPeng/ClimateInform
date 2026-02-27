#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/opr
tmpdir=/cpc/home/wd52pp/tmp/opr
if [ ! -d $tmpdir ] ; then
  mkdir -p $tmpdir
fi
analdir=/cpc/cfsr/rotating/rot_6hr_h/pgb.g2
bindir=/cpc/home/wd52pp/bin
#
#================================================
# have IC(u&v -> psi) from reanalysis data
#================================================
#
cd $tmpdir
\rm pgb.*
#
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
YEAR=`date --date='1 day ago' '+%Y'`
MONTH=`date --date='1 day ago' '+%m'`
DAY=`date --date='1 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}* $tmpdir
#
cat *.g2 > pgb.g2
$bindir/wgrib2 pgb.g2 -match ":STRM:200 mb:" -ave 6hr psi.ave
$bindir/wgrib2 psi.ave -bin psi.gr
#
# from REG361 to REG73
cp $lcdir/REG361_2_REG73.sh .
REG361_2_REG73.sh
# 
