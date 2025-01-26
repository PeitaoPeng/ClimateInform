#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/opr
tmpdir=/cpc/home/wd52pp/tmp/opr
if [ ! -d $tmpdir ] ; then
  mkdir -p $tmpdir
fi
analdir=/cpc/data/cdas/rot_daily
bindir=/cpc/home/wd52pp/bin
#
#================================================
# have IC PSI from R1(CDAS) data
#================================================
#
cd $tmpdir
rm -f pgb.*
rm -f psi.gr
#
YEAR=`date --date='8 day ago' '+%Y'`
MONTH=`date --date='8 day ago' '+%m'`
DAY=`date --date='8 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}.grb2 $tmpdir/pgb.1.grb2
YEAR=`date --date='7 day ago' '+%Y'`
MONTH=`date --date='7 day ago' '+%m'`
DAY=`date --date='7 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}.grb2 $tmpdir/pgb.2.grb2
YEAR=`date --date='6 day ago' '+%Y'`
MONTH=`date --date='6 day ago' '+%m'`
DAY=`date --date='6 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}.grb2 $tmpdir/pgb.3.grb2
YEAR=`date --date='5 day ago' '+%Y'`
MONTH=`date --date='5 day ago' '+%m'`
DAY=`date --date='5 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}.grb2 $tmpdir/pgb.4.grb2
YEAR=`date --date='4 day ago' '+%Y'`
MONTH=`date --date='4 day ago' '+%m'`
DAY=`date --date='4 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}.grb2 $tmpdir/pgb.5.grb2
YEAR=`date --date='3 day ago' '+%Y'`
MONTH=`date --date='3 day ago' '+%m'`
DAY=`date --date='3 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}.grb2 $tmpdir/pgb.6.grb2
YEAR=`date --date='2 day ago' '+%Y'`
MONTH=`date --date='2 day ago' '+%m'`
DAY=`date --date='2 day ago' '+%d'`
cp $analdir/pgb.${YEAR}${MONTH}${DAY}.grb2 $tmpdir/pgb.7.grb2
#
$bindir/wgrib2 pgb.1.grb2 -match ":STRM:200 mb:" -grib_out psi.1.grb2
$bindir/wgrib2 pgb.2.grb2 -match ":STRM:200 mb:" -grib_out psi.2.grb2
$bindir/wgrib2 pgb.3.grb2 -match ":STRM:200 mb:" -grib_out psi.3.grb2
$bindir/wgrib2 pgb.4.grb2 -match ":STRM:200 mb:" -grib_out psi.4.grb2
$bindir/wgrib2 pgb.5.grb2 -match ":STRM:200 mb:" -grib_out psi.5.grb2
$bindir/wgrib2 pgb.6.grb2 -match ":STRM:200 mb:" -grib_out psi.6.grb2
$bindir/wgrib2 pgb.7.grb2 -match ":STRM:200 mb:" -grib_out psi.7.grb2

cat psi.1.grb2 psi.2.grb2 psi.3.grb2 psi.4.grb2 psi.5.grb2 psi.6.grb2 psi.7.grb2 > psi.7day.grb2

$bindir/wgrib2 psi.7day.grb2 -ave 1dy psi.ave.grb2

$bindir/wgrib2 psi.ave.grb2 -bin psi.bin

cat >psi.ctl<<EOF
dset ^psi.bin
undef 9.999E+20
*options yrev
ydef 73 linear -90.000000 2.5
xdef 144 linear 0.000000 2.500000
tdef 1 linear 18Z05oct2015 1mo
zdef 1 linear 1 1
vars 1
psi  0 33,100,200  strm
ENDVARS
EOF
cat >readpsi<<EOF
run read.gs
EOF
cat >read.gs<<EOF
'reinit'
'open psi.ctl'
'set x 1 144'
'set y 1 73'
'set gxout fwrite'
'set fwrite psi200.gr'
'd psi'
'c'
EOF
$bindir/grads -bl <readpsi
# 
