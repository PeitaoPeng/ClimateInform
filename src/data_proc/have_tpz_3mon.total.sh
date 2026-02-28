#!/bin/sh

set -eaux

lcdir=/home/peitao/forecast/ca_ss
tmp=/home/peitao/data/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/home/peitao/data/downloads
datadir=/home/peitao/data/tpz
#
cd $tmp
#
#======================================
# have SST IC
#======================================
curyr=`date --date='today' '+%Y'`  # yr of making fcst
curmo=`date --date='today' '+%m'`  # mo of making fcst
#
if [ $curmo = 01 ]; then cmon=1; icmon_end=dec; icmoe=12; icmon_mid=nov; icssnmb=10; fi #icmon_mid: mid mon of icss
if [ $curmo = 02 ]; then cmon=2; icmon_end=jan; icmoe=01 ; icmon_mid=dec; icssnmb=11; fi #icssnmb: 1st mon of icss
if [ $curmo = 03 ]; then cmon=3; icmon_end=feb; icmoe=02 ; icmon_mid=jan; icssnmb=12 ; fi
if [ $curmo = 04 ]; then cmon=4; icmon_end=mar; icmoe=03 ; icmon_mid=feb; icssnmb=1 ; fi
if [ $curmo = 05 ]; then cmon=5; icmon_end=apr; icmoe=04 ; icmon_mid=mar; icssnmb=2; fi
if [ $curmo = 06 ]; then cmon=6; icmon_end=may; icmoe=05 ; icmon_mid=apr; icssnmb=3; fi
if [ $curmo = 07 ]; then cmon=7; icmon_end=jun; icmoe=06 ; icmon_mid=may; icssnmb=4; fi
if [ $curmo = 08 ]; then cmon=8; icmon_end=jul; icmoe=07 ; icmon_mid=jun; icssnmb=5; fi
if [ $curmo = 09 ]; then cmon=9; icmon_end=aug; icmoe=08 ; icmon_mid=jul; icssnmb=6; fi
if [ $curmo = 10 ]; then cmon=10; icmon_end=sep; icmoe=09 ; icmon_mid=aug; icssnmb=7; fi
if [ $curmo = 11 ]; then cmon=11; icmon_end=oct; icmoe=10; icmon_mid=sep; icssnmb=8; fi
if [ $curmo = 12 ]; then cmon=12; icmon_end=nov; icmoe=11; icmon_mid=oct; icssnmb=9; fi
#
yyyy=$curyr
yyym=`expr $curyr - 1`
#
icmomidyr=$icmon_mid$yyyy
if [ $cmon -le 2 ]; then icmomidyr=$icmon_mid$yyym; fi
#
icseason=$icssnmb  # jfm=1
#
yrn=`expr $curyr - 1948` # total full years,=68 for 1948-2015
if [ $cmon = 1 ]; then yrn=`expr $yyym - 1948`; fi
mmn=`expr $yrn \* 12`
#
tmax=`expr $mmn + $icmoe` # 816=dec2015
#
nyear=`expr $curyr - 1948`  # total full year data used for CA
if [ $cmon -le 2 ]; then nyear=`expr $curyr - 1948 - 1`; fi # for having 12 3-mon avg data for past year
#
icyr=$curyr
if [ $icmoe = 12 ]; then icyr=`expr $curyr - 1`; fi
outd=/home/peitao/data/ss_fcst/ca/$icyr
outdata=${outd}/$icmoe
#
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10
kocn=15
dridge=0.01
#======================================
# define some parameters
#======================================
#
#for var in prec; do
for var in t2m prec hgt; do
#
clm_bgn=516  #dec1990
clm_end=`expr $clm_bgn + 360`
nts=2  # feb1948
nte=`expr $tmax - 1` # mid-mon of the latest season
outfile=$var.1948_cur.3mon.total
imxt=720
jmxt=360
#imxp=144
#jmxp=72
imxp=360
jmxp=180
imxz=144
jmxz=73
undef_data=-9.99E+8
#=======================================
# rewrite t2m data from grib to grads
#=======================================
cat >havedata<<EOF
run data_rewrite.gs
EOF
#
if [ $var = 't2m' ]; then
cat >data_rewrite.gs<<EOF
    'reinit'
'sdfopen $datadir0/air.mon.mean.nc'
'set x 1 $imxt'
'set y 1 $jmxt'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(air,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1948 to curr
*'define clm=ave(air,t+0, t=$tmax,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set t $nts $nte'
*'d ave(air-clm,t-1,t+1)'
'd ave(air,t-1,t+1)'
'c'
EOF
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
ydef 360 linear -89.750000 0.5
xdef 720 linear 0.250000 0.500000
tdef 9999 linear feb1948 1mo
zdef  01 levels 1
vars 1
$var  0 99 obs
ENDVARS
EOF
fi
#
#=======================================
# rewrite prec data
#=======================================
undef_data=-9.99E+8
#
if [ $var = 'prec' ]; then
cat >data_rewrite.gs<<EOF3
    'reinit'
*'sdfopen $datadir0/precip.mon.mean.2.5x2.5.nc'
'sdfopen $datadir0/precip.mon.mean.1x1.nc'
'set x 1 $imxp'
'set y 1 $jmxp'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(precip,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1948 to curr
*'define clm=ave(precip,t+0, t=$tmax,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set t $nts $nte'
*'d ave(precip-clm,t-1,t+1)'
'd ave(precip,t-1,t+1)'
'c'
EOF3
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
tdef 9999 linear feb1948 1mo
zdef  01 levels 1
vars 1
$var  0 99 obs
ENDVARS
EOF
fi
#=======================================
# rewrite hgt
#=======================================
if [ $var = 'hgt' ]; then
nts=2  # feb1948
nte=`expr $tmax - 1` # mid-mon of the latest season
cat >data_rewrite.gs<<EOF3
    'reinit'
'sdfopen $datadir0/hgt.mon.mean.nc'
'set x 1 144'
'set y 1  73'
'set z 10'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(hgt,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1949 to curr
*'define clm=ave(hgt,t+0, t=$tmax,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set t $nts $nte'
*'d ave(hgt-clm,t-1,t+1)'
'd ave(hgt,t-1,t+1)'
'c'
EOF3
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
xdef 144 linear 0 2.5
ydef  73 linear -90 2.5
tdef 9999 linear feb1948 1mo
zdef  01 levels 1
vars 1
$var  0 99 regression
ENDVARS
EOF
fi
#
/usr/bin/grads -bl <havedata
#
#=======================================
# regrid to 1x1
#=======================================
ntend=`expr $tmax - 2` # from feb1948 to the mid of latest season
cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $outfile.ctl'
'open /home/peitao/src/utility/intpl/grid.360x180.ctl'
'set gxout fwrite'
'set fwrite $datadir/$outfile.1x1.gr'
nt=1
while ( nt <= $ntend)

'set t 'nt
say 'time='nt
'set lon   0.5 359.5'
'set lat -89.5  89.5'
'd lterp($var,sst.2(time=jan1982))'

nt=nt+1
endwhile
gsEOF

/usr/bin/grads -pb <int

cat>$datadir/$outfile.1x1.ctl<<EOF
dset ^$outfile.1x1.gr
undef -9.99E+8
*
options little_endian
*
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  01 levels 1 
tdef   9999 linear feb1948 1mo
*
VARS 1
$var 1  99   3mon ave
ENDVARS
EOF
#=======================================
#
done  # for var
