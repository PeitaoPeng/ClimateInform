#!/bin/sh

set -eaux

lcdir=/home/ppeng/ClimateInform/src/develop/data_proc
tmp=/home/ppeng/data/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/home/ppeng/data/downloads
datadir=/home/ppeng/data/sst
#
cd $tmp
#
#======================================
# have SST IC
#======================================
curyr=`date --date='today' '+%Y'`  # yr of making fcst
curmo=`date --date='today' '+%m'`  # mo of making fcst
datayr=`date --date='10 day ago' '+%Y'`  # year of the latest data
datamo=`date --date='10 day ago' '+%m'`  # mo of the latest data
#
if [ $curmo = 01 ]; then cmon=1; icmoe=12; icmon_mid=nov; icssnmb=10; fi #icmon_mid: mid mon of icss
if [ $curmo = 02 ]; then cmon=2; icmoe=01 ; icmon_mid=dec; icssnmb=11; fi #icssnmb: 1st mon of icss
if [ $curmo = 03 ]; then cmon=3; icmoe=02 ; icmon_mid=jan; icssnmb=12 ; fi
if [ $curmo = 04 ]; then cmon=4; icmoe=03 ; icmon_mid=feb; icssnmb=1 ; fi
if [ $curmo = 05 ]; then cmon=5; icmoe=04 ; icmon_mid=mar; icssnmb=2; fi
if [ $curmo = 06 ]; then cmon=6; icmoe=05 ; icmon_mid=apr; icssnmb=3; fi
if [ $curmo = 07 ]; then cmon=7; icmoe=06 ; icmon_mid=may; icssnmb=4; fi
if [ $curmo = 08 ]; then cmon=8; icmoe=07 ; icmon_mid=jun; icssnmb=5; fi
if [ $curmo = 09 ]; then cmon=9; icmoe=08 ; icmon_mid=jul; icssnmb=6; fi
if [ $curmo = 10 ]; then cmon=10; icmoe=09 ; icmon_mid=aug; icssnmb=7; fi
if [ $curmo = 11 ]; then cmon=11; icmoe=10; icmon_mid=sep; icssnmb=8; fi
if [ $curmo = 12 ]; then cmon=12; icmoe=11; icmon_mid=oct; icssnmb=9; fi
#
yyyy=$curyr
yyym=`expr $curyr - 1`
#
icmomidyr=$icmon_mid$yyyy  # the mid-mon of the latest IC season
#
if [ $cmon -le 2 ]; then icmomidyr=$icmon_mid$yyym; fi
#
yrn1=`expr $curyr - 1948`
if [ $cmon = 1 ]; then yrn1=`expr $yyym - 1948`; fi
mmn1=`expr $yrn1 \* 12`
ttlong=`expr $mmn1 + $icmoe` # total mon of ersst data from jan1948 to the latest_mon;
#
yrn2=`expr $curyr - 1948` # total full years,=68 for 1948-2015
if [ $cmon = 1 ]; then yrn2=`expr $yyym - 1948`; fi
mmn2=`expr $yrn2 \* 12`
#
tmax=`expr $mmn2 + $icmoe` # 
#
nyear=`expr $curyr - 1948`  # total full year data used for CA, 68 for 1948-2015
if [ $cmon -le 2 ]; then nyear=`expr $curyr - 1948 - 1`; fi # for having 12 3-mon avg data for past year
#
icyr=$curyr
if [ $icmoe = 12 ]; then icyr=`expr $curyr - 1`; fi
outd=/home/ppeng/data/ss_fcst/ca/$icyr
outdata=${outd}/$icmoe
if [ ! -d $outd ] ; then
  mkdir -p $outd
fi
if [ ! -d $outdata ] ; then
  mkdir -p $outdata
fi
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10
kocn=15
dridge=0.01
#======================================
# define some parameters
#======================================
 sst_analysis=ersst
#
clm_bgn=144  #dec1990
clm_end=`expr $clm_bgn + 360`
nts=2  # feb1948
nte=`expr $ttlong - 1` # mid-mon of the latest season
#
inputfile=slp.mon.mean
outfile=slp.3mon.1948-curr.total
cat >sst3monavg<<EOF
run avg.gs
EOF
cat >avg.gs<<EOF
'reinit'
'sdfopen $datadir0/$inputfile.nc'
'set x 1 144'
'set y 1  73'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(slp,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1948 to curr
*'define clm=ave(slp,t+$clm_bgn, t=$ttlong,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $datadir/$outfile.gr'
'set t $nts $nte'
#'d ave(slp-clm,t-1,t+1)'
'd ave(slp,t-1,t+1)'
'c'
EOF
#
/usr/bin/grads -bl <sst3monavg
#
cat>$datadir/$outfile.ctl<<EOF
dset ^$outfile.gr
undef -999000000
*
TITLE SST
*
xdef  144 linear   0. 2.5
ydef   73 linear -90. 2.5
zdef   01 levels 1
tdef   9999 linear feb1948 1mo
vars 1
slp  1 99 3-mon mean (C)
ENDVARS
EOF
#
